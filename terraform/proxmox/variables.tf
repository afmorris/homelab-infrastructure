variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
  default     = "https://metal:8006"
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: terraform@pve!terraform=<secret>)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key content to inject into VMs via cloud-init"
  type        = string
}
