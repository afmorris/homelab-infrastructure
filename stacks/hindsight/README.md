# Hindsight

Shared memory for Claude: every computer's Claude Code saves and recalls
memories in one place instead of each keeping its own files. Lives on
svp01docker01 as a Portainer stack named `hindsight`.

- **Address:** https://memory.morriscloud.com (Home Control service `memory`
  -> `svp01docker01:8888`, http). Home network only.
- **Claude Code** connects over MCP to the shared bank `claude`:
  `https://memory.morriscloud.com/mcp/claude/` with header
  `Authorization: Bearer <API key>`.
- **Web console:** http://svp01docker01:9999 (LAN only), log in with the
  console key.
- **Secrets:** 1Password, Home vault, item "Hindsight" (fields DB password,
  API key, Console key). Set in the Portainer stack's environment
  (`.env.example` lists them).
- **Language model:** Ollama on mac-plex (192.168.3.71:11434), model
  `gemma4:e4b-it-qat`, run by the LaunchAgent
  `~/Library/LaunchAgents/com.morriscloud.ollama.plist` there (listens on the
  LAN, one model, unloads after 10 idle minutes, 16k context). Use a non-MLX
  tag: Ollama's MLX engine rejects structured output, which Hindsight needs.
  If mac-plex is off, saving new memories fails; looking them up still works.
- **Data:** the `hindsight-db` volume (PostgreSQL 18 + pgvector), backed up
  with the svp01docker01 VM in the nightly Proxmox backup to PBS.
- **Upgrade:** change the image tag, redeploy in Portainer. Database
  migrations run on start, so read the release notes first.

## Deploy

1. Make the 1Password item "Hindsight" with three fields, each from
   `openssl rand -hex 32`.
2. Portainer -> svp01docker01 -> Stacks -> Add stack -> name `hindsight`,
   Repository: this repo, compose path `stacks/hindsight/docker-compose.yml`,
   environment variables from `.env.example`.
3. Check: `curl -s -H "Authorization: Bearer <API key>" http://svp01docker01:8888/v1/default/banks`
   answers, and without the header it answers 401.
4. Home Control: create service `memory` -> `svp01docker01:8888`.
