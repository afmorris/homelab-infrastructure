---
name: infra-change
description: Make a change in the homelab-infrastructure repo (Ansible, OpenTofu, compose stacks) and update the morris-wiki with a plain-English description of how things work afterward. Use for any homelab or Cloudflare change the family should know about.
---

# Infrastructure change + wiki update

Every change to `afmorris/homelab-infrastructure` that affects how something
works gets a matching update in `afmorris/morris-wiki`, so the wiki always
describes the **current state** in words a non-technical family member can
follow. This skill does both halves, and ships them as two linked branches.

It never touches live systems. No `tofu apply`, no playbook runs against
hosts, no dashboard changes. Those are Tony's call after review.

## 0. Get both repos

Both must be available as git working copies:

- `afmorris/homelab-infrastructure`: where the change is made
- `afmorris/morris-wiki`: where the description lives

Attach or clone whichever is missing. If `morris-wiki` can't be reached,
make the infra change anyway, then stop before step 5 and tell the user the
wiki update is still owed.

Read `morris-wiki/STYLE.md` before writing any wiki text. It is the
authority on tone and structure; this skill summarizes it, it doesn't
replace it.

## 1. Understand the change

- Restate the request in one sentence. If it's ambiguous in a way that
  changes what gets built (which host, which zone, replace vs. add), ask
  before editing. Otherwise proceed.
- Read the files you'll touch and their neighbors, and follow the existing
  conventions (layout below).
- Find the wiki pages that already describe this area (step 4's script
  with the paths you expect to touch) and read them. They tell you what
  the family currently believes is true.

### Repo layout and conventions

| Area | Where | Notes |
|---|---|---|
| Proxmox VMs | `terraform/proxmox/` | Terraform, local state |
| Cloudflare DNS, Pages, Access | `terraform/cloudflare/` | **OpenTofu** (state encryption), provider pinned exactly, see its README |
| Host configuration | `ansible/` roles + `playbooks/` | Secrets only in `ansible/inventory/group_vars/all/vault.yml` (Ansible Vault) |
| Docker stacks | `stacks/<name>/docker-compose.yml` | Real values in `.env` (ignored), placeholders in `.env.example` |

Rules that always apply:

- **No secrets in commits.** Tokens, passwords, and keys go in `.env`
  files (git-ignored), `TF_VAR_*` environment variables, or Ansible Vault.
  Variables holding them are marked `sensitive = true`.
- Pin versions (providers, images, roles). Don't float to `latest`.
- Keep changes minimal and scoped to the request.

## 2. Branch

Use the same branch name in both repos: `infra/<short-kebab-summary>`
(e.g. `infra/add-cindy-to-wiki`). Branch the infra repo from an up-to-date
`main`.

## 3. Make and check the infra change

Edit, then run every check that applies and that the environment supports:

| Changed | Check |
|---|---|
| `terraform/*` | `tofu fmt -check` (or `terraform fmt -check` for proxmox); `tofu init -backend=false && tofu validate` when the provider can be downloaded |
| `ansible/*` | `ansible-playbook --syntax-check` on affected playbooks; `ansible-lint` if installed |
| `stacks/*` | `docker compose -f … config -q` |
| `*.sh` | `shellcheck` |
| `*.py` | `python3 -m py_compile` |

If a check can't run here (tool missing, no network to the provider
registry), say so plainly in the final report. Don't claim it passed.

Never run `tofu apply`, `terraform apply`, playbooks against real hosts, or
anything that changes a live system, even if it seems harmless. Put the
exact commands Tony should run in the PR description instead.

## 4. Find the wiki pages to update

System pages in `morris-wiki/docs/` declare what they describe:

```yaml
---
sources:
  - terraform/cloudflare/wiki.tf
last_reviewed: 2026-09-28
---
```

List changed files, then match them against every page's `sources`:

```sh
cd <infra repo>
git diff --name-only origin/main...HEAD > /tmp/changed.txt
python3 .claude/skills/infra-change/scripts/find_wiki_pages.py <wiki repo> /tmp/changed.txt
```

The script prints matching pages and any changed paths no page covers.

Also search the wiki for concrete facts the change makes stale, like old
hostnames, service names, email addresses, schedules, and retention periods:

```sh
grep -rn "<old value>" <wiki repo>/docs
```

Decide per unmatched path:

- **Behavior the family could notice** (a new service, backup, access
  rule, address, schedule, cost, or recovery step): create a page from
  `templates/system-page.md`, or add a section to the closest existing
  page. Add it to `nav` in `mkdocs.yml`, and put the path in `sources`.
- **Purely internal** (formatting, refactors, version bumps with no
  visible effect): no wiki change is needed. Still bump `last_reviewed` on
  matched pages you checked, and say in the report that no wording changed.

## 5. Write the wiki update

Write from the **resulting configuration**, not from the diff. Open the
changed files as they will be after merge and describe what they now do.

Follow `STYLE.md`. The essentials:

- **Current state, present tense.** "Backups run every night at 2 a.m.",
  never "backups were changed to run at 2 a.m." Git is the changelog.
- **The top half is for someone non-technical.** Say what it's for, what it
  means for the family, and exactly what to click or do, using an everyday
  comparison where it helps. Explain any unavoidable term inline and add it
  to `docs/glossary.md` (alphabetical).
- **Technical detail goes below the line**, under
  `## Setting it up (technical)`. Point to the source of truth
  (`afmorris/homelab-infrastructure` → `path/to/file`) rather than pasting
  configuration.
- **No secrets, ever.** Name the password-manager entry instead.
- **Don't invent facts.** Where something isn't known (which password
  entry, who to call, where a printout lives), write a visible
  `TODO (Tony): …` rather than guessing.
- Update `sources` if files were added, renamed, or removed, and set
  `last_reviewed` to today.

## 6. Verify the wiki

```sh
cd <wiki repo>
pip install -r docs-requirements.txt   # once
zensical build                         # must report no issues
```

Then scan the wiki diff for anything secret-shaped and fix any hit:

```sh
git diff | grep -nEi '(password|passwd|secret|token|api[_-]?key)\s*[:=]\s*\S{6,}|[A-Za-z0-9_\-]{32,}|-----BEGIN' || echo "clean"
```

(Long hex IDs such as Cloudflare zone IDs don't belong in the wiki
either. Refer to them by name.)

Read the changed pages once more as Cindy would. If the top half needs any
technical knowledge to follow, rewrite it.

## 7. Commit, push, and link

- Commit each repo separately with a message that says what changed and
  why. In the wiki commit, reference the infra branch or PR.
- Push both branches. If a pull-request tool is available, open both PRs:
  - **Infra PR:** summary, checks run (and any not run), and the exact
    commands to apply (e.g. `cd terraform/cloudflare && tofu plan -out=tfplan && tofu apply tfplan`).
  - **Wiki PR:** which pages changed and why, linking the infra PR, plus
    a note: **merge after the infra change is applied**, because the
    wiki describes what's live.
- Without a PR tool, give the compare URLs:
  `https://github.com/afmorris/<repo>/compare/<branch>`.

## 8. Report

Keep it short:

1. What changed in infrastructure (one or two sentences)
2. Checks run, and any that couldn't run
3. Wiki pages created or updated, or "no wiki wording change needed" and why
4. What Tony needs to do, in order: review, apply, verify, then merge
   the wiki PR
5. Any `TODO (Tony)` items left in the wiki
