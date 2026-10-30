# Actual Budget

Budgeting app. Lives on svp01docker01 as a Portainer stack named
`actual-budget` (https://budget.morriscloud.com, made with Home Control:
service `budget` -> `svp01docker01:5006`, http).

- Stack: `docker-compose.yml`. No secrets in the file. The server password is
  set in the browser on first visit.
- Data is the `actual-data` volume (`/data`). Back it up with the
  svp01docker01 VM in the nightly Proxmox backup to PBS.
- Upgrade: change the image tag, redeploy the stack in Portainer.
