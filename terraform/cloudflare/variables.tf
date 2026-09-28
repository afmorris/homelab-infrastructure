variable "state_passphrase" {
  description = "Passphrase for OpenTofu state encryption (min 16 chars). Set via TF_VAR_state_passphrase."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.state_passphrase) >= 16
    error_message = "state_passphrase must be at least 16 characters."
  }
}

variable "wiki_zone" {
  description = "Zone that hosts the wiki's custom hostname."
  type        = string
  default     = "morriscloud.com"
}

variable "wiki_hostname" {
  description = "Custom hostname for the family wiki."
  type        = string
  default     = "wiki.morriscloud.com"
}

variable "wiki_project_name" {
  description = "Cloudflare Pages project name. Also determines <name>.pages.dev."
  type        = string
  default     = "morris-wiki"
}

variable "wiki_repo_owner" {
  description = "GitHub owner of the repository the wiki is built from."
  type        = string
  default     = "afmorris"
}

variable "wiki_repo_name" {
  description = "GitHub repository the wiki is built from."
  type        = string
  default     = "homelab-infrastructure"
}

variable "wiki_readers" {
  description = <<-EOT
    Email addresses allowed to read the wiki. Adding or removing a reader is
    a one-line change here, then `tofu apply`.
  EOT
  type        = list(string)
  default = [
    "tony@morriscloud.com",
    # Add family members here, one per line.
  ]
}

variable "wiki_session_duration" {
  description = "How long a wiki sign-in lasts before a new email code is needed."
  type        = string
  default     = "730h" # about one month
}
