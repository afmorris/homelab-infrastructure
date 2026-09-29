# Cloudflare (OpenTofu)

Manages the Cloudflare side of the homelab as code:

- **DNS records** for every zone in the account except those listed in
  `EXCLUDE_ZONES` in `bootstrap.sh` (`dns_<zone>.tf`, generated
  from the live zones by `cf-terraforming`, then maintained here)
- **The family wiki** (`wiki.tf`): the Cloudflare Pages project that builds
  the [`morris-wiki`](https://github.com/afmorris/morris-wiki) repository, the `wiki.morriscloud.com` custom domain and DNS record, and the
  Cloudflare Access applications and **Family** policy that restrict who can
  read it

Uses **OpenTofu**, not Terraform, because state is encrypted at rest with
OpenTofu's built-in state encryption. Terraform can't read this state.

## First run

```sh
brew install opentofu cloudflare/cloudflare/cf-terraforming
cd terraform/cloudflare
./bootstrap.sh
```

`bootstrap.sh` asks for the API token once (see below), generates a state
passphrase, pulls every existing DNS record into config, adopts any wiki
pieces that were already created in the dashboard, and ends with a
`tofu plan`. It never changes anything in Cloudflare. Re-running it is safe.

Then read the plan:

- **DNS records** should show only *import*, with **0 to change**. A change
  means the generated config doesn't exactly match a live record. Fix the
  config, not the record, and plan again.
- **Wiki resources** show *add* for whatever doesn't exist yet.

Apply when it looks right:

```sh
tofu apply tfplan
```

After the first successful apply, the `imports_*.tf` files have done their
job and can be deleted.

## One-time manual steps

These can't be done through the API.

### 1. Create the API token

Cloudflare dashboard → **My Profile → API Tokens → Create Token → Create
Custom Token**. Name it `opentofu-homelab` and grant:

| Scope | Permission | Access |
|---|---|---|
| Account | Cloudflare Pages | Edit |
| Account | Access: Apps and Policies | Edit |
| Account | Access: Organizations, Identity Providers, and Groups | Read |
| Zone | Zone | Read |
| Zone | DNS | Edit |

Account resources: your account. Zone resources: **All zones**. Store it in
the password manager as *Cloudflare OpenTofu API token*; `bootstrap.sh` saves
a copy in `.env` (git-ignored).

### 2. Turn on Zero Trust

Dashboard → **Zero Trust** → pick a team name → **Free** plan. Confirm
**Settings → Authentication → Login methods** includes **One-time PIN**.
`bootstrap.sh` warns if this hasn't been done.

### 3. Let Cloudflare Pages read the GitHub repo

Pages builds straight from GitHub, which needs Cloudflare's GitHub app
installed on `afmorris/morris-wiki`. The API can't do this part.

Dashboard → **Workers & Pages → Create → Pages → Connect to Git** → install
the app with access to **only** `morris-wiki` → then **cancel** out of the
project wizard. OpenTofu creates the project itself.

## Everyday use

```sh
cd terraform/cloudflare
set -a; source .env; set +a
tofu plan -out=tfplan
tofu apply tfplan
```

**Add or remove a wiki reader:** edit `wiki_readers` in `variables.tf`,
plan, apply.

**Add or change a DNS record:** edit `dns_<zone>.tf`, plan, apply. A change
made in the dashboard will show up as drift on the next plan. Either copy it
into the config or let the plan revert it.

**Pull in records added elsewhere:** `./bootstrap.sh --regenerate-dns`
rewrites the `dns_*.tf` files from the live zones. Review the diff with
`git diff` before committing.

**Upgrade the provider:** bump the pinned version in `versions.tf`, run
`tofu init -upgrade`, and read the plan carefully. The v5 provider has
renamed resources between minor releases.

## Files

| File | What it is |
|---|---|
| `versions.tf` | OpenTofu and provider versions, state encryption |
| `variables.tf` | Wiki settings, reader list, state passphrase |
| `wiki.tf` | Pages project, custom domain, wiki DNS record, Access apps and policy |
| `dns_<zone>.tf` | DNS records per zone (generated once, then edited by hand) |
| `imports_*.tf` | One-time import blocks; delete after the first apply |
| `bootstrap.sh` | First-run / re-sync script |
| `scripts/tidy_dns.py` | Renames and tidies cf-terraforming output |
| `.env` | **Not committed.** API token and state passphrase |

## State

State is local (`terraform.tfstate`, git-ignored) and encrypted with the
passphrase in `.env`. Keep that passphrase in the password manager as
*Cloudflare OpenTofu state passphrase*.

If the state or passphrase is ever lost, nothing in Cloudflare is harmed:
move the old state aside, generate a new passphrase, and run
`./bootstrap.sh --regenerate-dns` to adopt everything again.

Planned: move state to an S3-compatible bucket (B2 or R2) so GitHub Actions
can run plan on pull requests and apply on merge.
