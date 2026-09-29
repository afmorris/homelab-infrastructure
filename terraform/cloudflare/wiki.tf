# The family wiki: wiki.morriscloud.com
#
# Built by Cloudflare Pages from the afmorris/morris-wiki repository and
# locked behind Cloudflare Access (email one-time PIN). The plain-English
# runbook is docs/infrastructure/wiki-hosting.md in morris-wiki; this file
# is the source of truth for the settings.

data "cloudflare_zone" "wiki" {
  filter = {
    name = var.wiki_zone
  }
}

locals {
  account_id   = data.cloudflare_zone.wiki.account.id
  pages_domain = "${var.wiki_project_name}.pages.dev"

  wiki_build_env = {
    PYTHON_VERSION = {
      type  = "plain_text"
      value = "3.12"
    }
  }
}

# --- Pages project ------------------------------------------------------------
#
# Prerequisite (one time, dashboard only): Cloudflare's GitHub app must be
# installed on the repository. See README.md, "One-time manual steps".

resource "cloudflare_pages_project" "wiki" {
  account_id        = local.account_id
  name              = var.wiki_project_name
  production_branch = "main"

  build_config = {
    build_command   = "pip install -r docs-requirements.txt && zensical build"
    destination_dir = "site"
    root_dir        = ""
  }

  source = {
    type = "github"
    config = {
      owner                          = var.wiki_repo_owner
      repo_name                      = var.wiki_repo_name
      production_branch              = "main"
      production_deployments_enabled = true
      pr_comments_enabled            = false

      # No preview deployments: every preview would get its own URL.
      preview_deployment_setting = "none"

      # Only rebuild when pages or site settings change, not README edits.
      path_includes = ["docs/*", "mkdocs.yml", "docs-requirements.txt"]
    }
  }

  # The API requires production and preview to agree on fail_open, and the
  # provider only fills in a default for production, so both are explicit.
  # Preview deployments are disabled above; its config just mirrors production.
  deployment_configs = {
    production = {
      fail_open = true
      env_vars  = local.wiki_build_env
    }
    preview = {
      fail_open = true
      env_vars  = local.wiki_build_env
    }
  }
}

resource "cloudflare_pages_domain" "wiki" {
  account_id   = local.account_id
  project_name = cloudflare_pages_project.wiki.name
  name         = var.wiki_hostname
}

# Pages does not create the DNS record for a custom domain when managed
# through the API, so it's declared here.
resource "cloudflare_dns_record" "wiki" {
  zone_id = data.cloudflare_zone.wiki.id
  name    = var.wiki_hostname
  type    = "CNAME"
  content = local.pages_domain
  proxied = true
  ttl     = 1 # automatic
  comment = "Family wiki (Cloudflare Pages). Managed by OpenTofu: terraform/cloudflare"
}

# --- Access: who can read -----------------------------------------------------
#
# One reusable policy, attached to two applications. Pages always publishes
# on <project>.pages.dev as well as the custom hostname, so both must be
# protected or the pages.dev copy is public.

resource "cloudflare_zero_trust_access_policy" "wiki_family" {
  account_id = local.account_id
  name       = "Family"
  decision   = "allow"

  include = [for email in var.wiki_readers : {
    email = {
      email = email
    }
  }]
}

resource "cloudflare_zero_trust_access_application" "wiki" {
  account_id       = local.account_id
  name             = "Morris Wiki"
  type             = "self_hosted"
  session_duration = var.wiki_session_duration

  destinations = [{
    type = "public"
    uri  = var.wiki_hostname
  }]

  policies = [{
    id         = cloudflare_zero_trust_access_policy.wiki_family.id
    precedence = 1
  }]

  app_launcher_visible = false
}

resource "cloudflare_zero_trust_access_application" "wiki_pages_dev" {
  # Access only accepts a pages.dev hostname once a Pages project owns it in
  # this account; before that it rejects it as "domain does not belong to zone".
  depends_on = [cloudflare_pages_project.wiki]

  account_id       = local.account_id
  name             = "Morris Wiki (pages.dev)"
  type             = "self_hosted"
  session_duration = var.wiki_session_duration

  destinations = [
    {
      type = "public"
      uri  = local.pages_domain
    },
    {
      # Deployment-specific URLs like <hash>.morris-wiki.pages.dev
      type = "public"
      uri  = "*.${local.pages_domain}"
    },
  ]

  policies = [{
    id         = cloudflare_zero_trust_access_policy.wiki_family.id
    precedence = 1
  }]

  app_launcher_visible = false
}

output "wiki_urls" {
  description = "Both addresses should show the Cloudflare Access sign-in page to a stranger."
  value = [
    "https://${var.wiki_hostname}",
    "https://${local.pages_domain}",
  ]
}
