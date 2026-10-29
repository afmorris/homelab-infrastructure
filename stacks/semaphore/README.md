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
- The container holds keys that can sudo on the machines, so it stays on its
  own stack.
- Containers can't use the host's loopback DNS stub, hence the explicit
  `dns:` setting.
