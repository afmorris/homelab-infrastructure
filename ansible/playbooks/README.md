---
# README for Ansible playbooks

## Overview
This Ansible configuration manages all VMs in the homelab infrastructure.

## Directory Structure
- `playbooks/site.yml` - Master playbook that deploys entire infrastructure
- `playbooks/bootstrap.yml` - Initial server setup
- `playbooks/deploy_media.yml` - Deploy media services
- `playbooks/deploy_monitoring.yml` - Deploy monitoring stack
- `playbooks/services/` - Utility playbooks for specific operations

## Inventory
- `inventory/hosts.yml` - Host inventory grouped by function

## Group Variables
- `group_vars/all.yml` - Variables applied to all hosts
- `group_vars/media.yml` - Media services group variables
- `group_vars/databases.yml` - Database services group variables
- `group_vars/container_hosts.yml` - Docker container host variables
- `group_vars/monitoring.yml` - Monitoring stack variables
- `group_vars/storage.yml` - Storage services variables
- `group_vars/vault.yml` - Encrypted secrets (handled by Ansible Vault)

## Roles
- `common` - Base OS configuration (timezone, NTP)
- `docker` - Docker installation and configuration
- `monitoring_client` - Prometheus node exporter installation
- `plex` - Plex Media Server
- `sonarr` - TV show management
- `radarr` - Movie management
- `sabnzbd` - Usenet downloader
- `truenas` - TrueNAS configuration/verification
- `mssql` - Microsoft SQL Server

## Usage

### Run the complete site playbook
```bash
ansible-playbook playbooks/site.yml
```

### Run bootstrap only
```bash
ansible-playbook playbooks/bootstrap.yml
```

### Run specific group
```bash
ansible-playbook playbooks/site.yml --limit media
```

### Run specific host
```bash
ansible-playbook playbooks/site.yml --limit svp01plex01
```

### Dry run (check mode)
```bash
ansible-playbook playbooks/site.yml --check
```

### Deploy specific service
```bash
# Deploy only media services
ansible-playbook playbooks/deploy_media.yml

# Restart Plex
ansible-playbook playbooks/services/restart_plex.yml

# Backup MSSQL
ansible-playbook playbooks/services/backup_mssql.yml
```

## Vault Secrets
Add these to your vault.yml and encrypt with:
```bash
ansible-vault edit ansible/group_vars/vault.yml
```

Required variables:
```yaml
vault_plex_token: <your_token>
vault_sonarr_api_key: <your_key>
vault_radarr_api_key: <your_key>
vault_sabnzbd_api_key: <your_key>
vault_mssql_password: <your_password>
vault_truenas_api_token: <your_token>
vault_grafana_admin_password: <your_password>
vault_ansible_become_password: <your_sudo_password>
```

## Notes
- All services are configured to start on boot
- Host user is `tony` (configured in ansible.cfg)
- Root/sudo access is required for most tasks
- Fact caching is enabled for better performance (3600s timeout)
