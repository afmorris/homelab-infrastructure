# Semaphore

Scheduled Ansible runs. Lives on svp01docker01 as a Portainer stack named
`semaphore` (UI: http://192.168.1.231:3000). It runs `--check --diff` only;
applying a change stays manual.

- Stack: `docker-compose.yml`. Secrets (`.env.example`) are set in the
  Portainer stack's environment variables, from the 1Password Home vault item
  "Semaphore".
- Keys inside Semaphore come from 1Password: "Semaphore SSH Key" (to the
  machines), "Semaphore Deploy Key" (read-only GitHub deploy key for this
  repo), "Ansible vault password".
- Data is in SQLite at `/var/lib/semaphore/database.sqlite` (the
  `semaphore-data` volume). BoltDB was dropped in v2.19; the move was made on
  2026-11-19 (see the wiki's Semaphore page for what to watch for).
- Home Control's API token is the 1Password item
  "Semaphore API token (Home Control)". Tokens are not carried over by the
  BoltDB-to-SQLite migrator, so a migration means making a new one.
- The container holds keys that can sudo on the machines, so it stays on its
  own stack.
- Containers can't use the host's loopback DNS stub, hence the explicit
  `dns:` setting.
