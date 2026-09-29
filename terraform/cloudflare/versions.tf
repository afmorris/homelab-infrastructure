terraform {
  # OpenTofu, not Terraform: the encryption block below is OpenTofu-only.
  # Variables inside the encryption block need OpenTofu >= 1.8.
  required_version = ">= 1.8.0"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # v5 renamed many resources between minor releases. Pin exactly and
      # upgrade on purpose: bump this, run `tofu init -upgrade`, read the plan.
      version = "5.26.0"
    }
  }

  # State and plan files are encrypted at rest. The passphrase comes from
  # TF_VAR_state_passphrase (see .env). Lose it and the state is unreadable,
  # though every resource here can be re-imported with ./bootstrap.sh.
  encryption {
    key_provider "pbkdf2" "main" {
      passphrase = var.state_passphrase
    }

    method "aes_gcm" "main" {
      keys = key_provider.pbkdf2.main
    }

    state {
      method   = method.aes_gcm.main
      enforced = true
    }

    plan {
      method   = method.aes_gcm.main
      enforced = true
    }
  }
}

# Authenticates with the CLOUDFLARE_API_TOKEN environment variable.
provider "cloudflare" {}
