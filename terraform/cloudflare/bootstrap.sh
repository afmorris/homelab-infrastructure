#!/usr/bin/env bash
# Bootstrap OpenTofu management of Cloudflare for this account.
#
#   ./bootstrap.sh                  first run, or re-run safely any time
#   ./bootstrap.sh --regenerate-dns re-pull DNS records from the live zones
#
# What it does:
#   1. Checks tools, loads or creates .env (API token + state passphrase)
#   2. Verifies the token and discovers every zone in the account
#   3. `tofu init`
#   4. Runs cf-terraforming per zone -> dns_<zone>.tf + imports_dns_<zone>.tf
#   5. Detects wiki resources that already exist (made in the dashboard)
#      and writes imports_wiki.tf so they're adopted rather than duplicated
#   6. `tofu validate` and `tofu plan` (never applies)
#
# It makes no changes to Cloudflare. Only `tofu apply` does that.

set -euo pipefail
cd "$(dirname "$0")"

# Keep these in sync with the defaults in variables.tf
WIKI_ZONE="morriscloud.com"
WIKI_HOSTNAME="wiki.morriscloud.com"
WIKI_PROJECT="morris-wiki"
WIKI_PAGES_DOMAIN="${WIKI_PROJECT}.pages.dev"

# Zones in the account that are deliberately NOT managed here.
#   wildeyed.cloud: retired, left to lapse (see removed_wildeyed_cloud.tf)
EXCLUDE_ZONES=(wildeyed.cloud)

REGENERATE_DNS=0
for arg in "$@"; do
  case "$arg" in
    --regenerate-dns) REGENERATE_DNS=1 ;;
    -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

API="https://api.cloudflare.com/client/v4"
WORK=".bootstrap"
mkdir -p "$WORK"
WARNINGS=()

bold()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
warn()  { printf '\033[33m! %s\033[0m\n' "$*"; WARNINGS+=("$*"); }
die()   { printf '\033[31mx %s\033[0m\n' "$*" >&2; exit 1; }

# --- 1. Tools and secrets -----------------------------------------------------

bold "Checking tools"
missing=()
for cmd in tofu cf-terraforming python3 curl openssl; do
  command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if ((${#missing[@]})); then
  echo "Missing: ${missing[*]}"
  echo "Install with:"
  echo "  brew install opentofu cloudflare/cloudflare/cf-terraforming"
  die "Install the missing tools and re-run."
fi
echo "ok: $(tofu version | head -1), cf-terraforming $(cf-terraforming version 2>/dev/null | head -1 || echo '?')"

bold "Loading secrets from .env"
touch .env
chmod 600 .env
set -a
# shellcheck disable=SC1091
source ./.env
set +a

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "No CLOUDFLARE_API_TOKEN yet. Create one as described in README.md,"
  echo "then paste it here (input is hidden):"
  read -rs CLOUDFLARE_API_TOKEN
  echo
  [[ -n "$CLOUDFLARE_API_TOKEN" ]] || die "No token entered."
  printf 'CLOUDFLARE_API_TOKEN=%q\n' "$CLOUDFLARE_API_TOKEN" >> .env
  export CLOUDFLARE_API_TOKEN
  echo "Saved to .env (git-ignored, mode 600)."
fi

if [[ -z "${TF_VAR_state_passphrase:-}" ]]; then
  if ls terraform.tfstate >/dev/null 2>&1; then
    die "State exists but TF_VAR_state_passphrase is missing. Restore it from your password manager into .env."
  fi
  TF_VAR_state_passphrase="$(openssl rand -base64 32 | tr -d '\n')"
  printf 'TF_VAR_state_passphrase=%q\n' "$TF_VAR_state_passphrase" >> .env
  export TF_VAR_state_passphrase
  warn "Generated a new state passphrase in .env. Copy it into your password manager now (entry: 'Cloudflare OpenTofu state passphrase')."
fi

# --- 2. Token and zones -------------------------------------------------------

cf() { curl -sS --fail-with-body -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" "$API$1"; }
# json <python expression over `d`> : reads JSON on stdin
json() { python3 -c "import json,sys; d=json.load(sys.stdin); print($1)"; }

bold "Verifying API token"
status="$(cf /user/tokens/verify | json "d['result']['status']")" \
  || die "Token verification failed. Check CLOUDFLARE_API_TOKEN in .env."
[[ "$status" == "active" ]] || die "Token status is '$status', expected 'active'."
echo "ok: token is active"

bold "Discovering zones"
cf "/zones?per_page=50" > "$WORK/zones.json" || die "Could not list zones. Token needs Zone:Read on all zones."
ZONES=()
while IFS= read -r line; do ZONES+=("$line"); done < <(
  json "'\n'.join(f\"{z['name']} {z['id']} {z['account']['id']}\" for z in d['result'] if z['status']=='active')" < "$WORK/zones.json"
)
((${#ZONES[@]})) || die "No active zones visible to this token."
ACCOUNT_ID=""
WIKI_ZONE_ID=""
for z in "${ZONES[@]}"; do
  read -r name id acct <<< "$z"
  echo "  $name ($id)"
  ACCOUNT_ID="$acct"
  [[ "$name" == "$WIKI_ZONE" ]] && WIKI_ZONE_ID="$id"
done
[[ -n "$WIKI_ZONE_ID" ]] || die "Zone $WIKI_ZONE not found. The wiki needs it."

bold "Checking Zero Trust is enabled"
if cf "/accounts/$ACCOUNT_ID/access/organizations" > "$WORK/org.json" 2>/dev/null; then
  echo "ok: team domain $(json "d['result']['auth_domain']" < "$WORK/org.json")"
else
  warn "Zero Trust isn't enabled (or the token lacks Access read). Do the one-time Zero Trust step in README.md before 'tofu apply'."
fi

# --- 3. Init ------------------------------------------------------------------

bold "tofu init"
tofu init -input=false >/dev/null
echo "ok"

# --- 4. DNS via cf-terraforming ----------------------------------------------

# Find the wiki CNAME if it already exists; it's managed in wiki.tf, so it
# must be left out of the generated DNS file.
WIKI_RECORD_ID="$(cf "/zones/$WIKI_ZONE_ID/dns_records?name=$WIKI_HOSTNAME" \
  | json "d['result'][0]['id'] if d['result'] else ''")"

bold "Generating DNS config with cf-terraforming"
TOFU_BIN="$(command -v tofu)"

# cf-terraforming reads the provider schema by running `tofu providers schema`
# in a directory. Give it a clean one containing only the provider pin, so
# half-generated or broken dns_*.tf files here can't break later zones.
PROVIDER_VERSION="$(sed -nE 's/^[[:space:]]+version[[:space:]]*=[[:space:]]*"([0-9][0-9.]*)".*/\1/p' versions.tf | head -1)"
[[ -n "$PROVIDER_VERSION" ]] || die "Couldn't read the Cloudflare provider version from versions.tf"
SCHEMA_DIR="$WORK/schema"
mkdir -p "$SCHEMA_DIR"
cat > "$SCHEMA_DIR/main.tf" << EOF
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "$PROVIDER_VERSION"
    }
  }
}
EOF
(cd "$SCHEMA_DIR" && tofu init -input=false >/dev/null) || die "tofu init failed in $SCHEMA_DIR"
for z in "${ZONES[@]}"; do
  read -r name id _ <<< "$z"
  if [[ " ${EXCLUDE_ZONES[*]} " == *" $name "* ]]; then
    echo "  $name: excluded, not managed here"
    continue
  fi
  slug="$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')"
  out="dns_${slug}.tf"
  imp="imports_dns_${slug}.tf"

  if [[ -f "$out" && $REGENERATE_DNS -eq 0 ]]; then
    echo "  $name: $out exists, skipping (use --regenerate-dns to refresh)"
    continue
  fi

  common=(--resource-type cloudflare_dns_record --zone "$id"
          --terraform-binary-path "$TOFU_BIN" --terraform-install-path "$SCHEMA_DIR")
  cf-terraforming generate "${common[@]}" > "$WORK/$slug.resources.tf" \
    || die "cf-terraforming generate failed for $name"
  cf-terraforming import --modern-import-block "${common[@]}" > "$WORK/$slug.imports.tf" \
    || die "cf-terraforming import failed for $name"

  exclude=()
  if [[ "$name" == "$WIKI_ZONE" ]]; then
    exclude+=(--exclude-name "$WIKI_HOSTNAME")
    [[ -n "$WIKI_RECORD_ID" ]] && exclude+=(--exclude-record-id "$WIKI_RECORD_ID")
  fi

  python3 scripts/tidy_dns.py --zone "$name" --zone-id "$id" \
    --resources "$WORK/$slug.resources.tf" --imports "$WORK/$slug.imports.tf" \
    --out-resources "$out" --out-imports "$imp" "${exclude[@]+"${exclude[@]}"}" \
    || warn "$name: some records had no import id; check $imp against $out."
done

# --- 5. Adopt wiki resources that already exist ------------------------------

bold "Looking for existing wiki resources"
{
  echo "# Adopts wiki resources that already existed (created in the dashboard)."
  echo "# Written by ./bootstrap.sh. Safe to delete once 'tofu apply' has succeeded."
} > imports_wiki.tf
adopted=0

add_import() { # address id description
  printf '\nimport {\n  to = %s\n  id = "%s"\n}\n' "$1" "$2" >> imports_wiki.tf
  echo "  adopting $3"
  adopted=$((adopted + 1))
}

if cf "/accounts/$ACCOUNT_ID/pages/projects/$WIKI_PROJECT" >/dev/null 2>&1; then
  add_import cloudflare_pages_project.wiki "$ACCOUNT_ID/$WIKI_PROJECT" "Pages project $WIKI_PROJECT"
  if cf "/accounts/$ACCOUNT_ID/pages/projects/$WIKI_PROJECT/domains/$WIKI_HOSTNAME" >/dev/null 2>&1; then
    add_import cloudflare_pages_domain.wiki "$ACCOUNT_ID/$WIKI_PROJECT/$WIKI_HOSTNAME" "custom domain $WIKI_HOSTNAME"
  fi
fi

if [[ -n "$WIKI_RECORD_ID" ]]; then
  add_import cloudflare_dns_record.wiki "$WIKI_ZONE_ID/$WIKI_RECORD_ID" "DNS record $WIKI_HOSTNAME"
fi

if cf "/accounts/$ACCOUNT_ID/access/apps?per_page=100" > "$WORK/apps.json" 2>/dev/null; then
  app_id() { # match by exact name, or by a destination/domain containing $2
    python3 - "$1" "$2" "$WORK/apps.json" << 'PY'
import json, sys
name, host, path = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path) as f:
    apps = json.load(f)["result"]
def hosts(a):
    hs = [a.get("domain") or ""] + (a.get("self_hosted_domains") or [])
    hs += [d.get("uri", "") for d in (a.get("destinations") or [])]
    return [h.lower() for h in hs if h]
hit = next((a for a in apps if a.get("name") == name), None)
if hit is None and host:
    hit = next((a for a in apps if any(h.rstrip("/").lstrip("*.") == host for h in hosts(a))), None)
print(hit["id"] if hit else "")
PY
  }
  id="$(app_id "Morris Wiki" "$WIKI_HOSTNAME")"
  [[ -n "$id" ]] && add_import cloudflare_zero_trust_access_application.wiki "accounts/$ACCOUNT_ID/$id" "Access app for $WIKI_HOSTNAME"
  id="$(app_id "Morris Wiki (pages.dev)" "$WIKI_PAGES_DOMAIN")"
  [[ -n "$id" ]] && add_import cloudflare_zero_trust_access_application.wiki_pages_dev "accounts/$ACCOUNT_ID/$id" "Access app for $WIKI_PAGES_DOMAIN"
fi

if cf "/accounts/$ACCOUNT_ID/access/policies?per_page=100" > "$WORK/policies.json" 2>/dev/null; then
  id="$(json "next((p['id'] for p in d['result'] if p.get('name')=='Family'), '')" < "$WORK/policies.json")"
  [[ -n "$id" ]] && add_import cloudflare_zero_trust_access_policy.wiki_family "$ACCOUNT_ID/$id" "reusable Access policy 'Family'"
fi

if ((adopted == 0)); then
  rm -f imports_wiki.tf
  echo "  none found; the wiki will be created fresh"
fi

# --- 6. Validate and plan ------------------------------------------------------

bold "tofu fmt / validate"
tofu fmt >/dev/null
tofu validate

bold "tofu plan"
set +e
tofu plan -input=false -out=tfplan
plan_rc=$?
set -e

bold "Summary"
for w in "${WARNINGS[@]+"${WARNINGS[@]}"}"; do printf '\033[33m! %s\033[0m\n' "$w"; done
if ((plan_rc != 0)); then
  die "Plan failed. Paste the error to Claude (or read it above); nothing was changed."
fi
cat << EOF
Nothing has been changed in Cloudflare yet.

Read the plan above. What to expect:
  - DNS records:      "import" only, 0 to change. Any change means the
                      generated config differs from the live record.
  - Wiki resources:   "add" for anything that doesn't exist yet.

When it looks right:   tofu apply tfplan
EOF
