# icloud-backup (TrueNAS app)

Backs up iCloud Photos for the family's five Apple IDs (Tony, Cindy, and
the three children) into the `pictures` dataset on TrueNAS, using
[icloud-backup-docker](https://github.com/michis0806/icloud-backup-docker).

## Layout

```
/mnt/storage0/pictures/            dataset storage0/pictures (snapshotted)
├── library/                       existing photo archive (moved from data/media/pictures)
└── icloud/                        this app's /backups (all Apple IDs)

/mnt/storage0/apps/icloud-backup/  dataset storage0/apps/icloud-backup (snapshotted)
├── icloud-backup.env              secrets (not in git)
├── config/                        app settings, encrypted Apple ID passwords, 2FA sessions
└── archive/                       unused with the "keep" policy
```

Off-site, the Backblaze bucket `morrisphotos` holds `pictures/` (the
library) and `icloud/` (the iCloud backups).

The datasets, snapshot schedules, Backblaze tasks, and the app itself are
all set up by hand in the TrueNAS UI, once, in the order below. This README
is the record of what should exist.

## 1. Datasets and snapshots

**Datasets** (Datasets → Add Dataset):

| Dataset | Purpose |
|---|---|
| `storage0/pictures` | Family photos: `library/` (archive) and `icloud/` (iCloud backups) |
| `storage0/apps/icloud-backup` | App settings, encrypted Apple ID passwords, 2FA sessions |

**Periodic snapshot tasks** (Data Protection → Periodic Snapshot Tasks):

| Dataset | Schedule | Keep |
|---|---|---|
| `storage0/pictures` | Daily, 03:00 | 30 days |
| `storage0/pictures` | Monthly (1st), 03:30 | 12 months |
| `storage0/apps/icloud-backup` | Daily, 03:15 | 14 days |

Photos rarely change once written, so long retention costs little space.

## 2. Move the existing photo library

Run in the TrueNAS shell (**System → Shell**) as root. The source stays
untouched until step 5.

```sh
mkdir -p /mnt/storage0/pictures/library /mnt/storage0/pictures/icloud

# Copy, preserving timestamps (Backblaze compares size + modified time,
# so this is what lets the existing off-site copy be reused)
rsync -aH --info=progress2 /mnt/storage0/data/media/pictures/ /mnt/storage0/pictures/library/

# Verify by checksum. No output means identical.
rsync -aHc --dry-run --itemize-changes /mnt/storage0/data/media/pictures/ /mnt/storage0/pictures/library/
```

## 3. Re-point the Backblaze backup (carefully)

The existing **Morris Photos** Cloud Sync task uses **SYNC** mode on five
folders, uploading each to a same-named folder in the `morrisphotos` bucket.
In SYNC mode, anything missing from the source can be deleted from
Backblaze, so every change below is checked with **Dry Run** first.
Depending on the bucket's lifecycle settings, Backblaze may keep previous
file versions as a safety net, but don't rely on it.

**a. New task for the library, which takes over `pictures/` in the bucket.**
Data Protection → Cloud Sync Tasks → Add:

| Setting | Value |
|---|---|
| Description | `Morris Photos: library` |
| Direction / Mode | PUSH / **COPY** |
| Directory | `/mnt/storage0/pictures/library` |
| Bucket / Folder | `morrisphotos` / `pictures` |
| Schedule | Daily, 00:30 |
| Transfers | Low Bandwidth (4), matching the existing task |

Click **Dry Run**. It should find **nothing (or almost nothing) to
transfer**, because the files are identical. If it wants to upload the
whole library, stop: the copy didn't preserve timestamps. Otherwise save.

**b. Remove the old path from the original task.** Edit **Morris Photos**,
remove `/mnt/storage0/data/media/pictures` from Directory/Files, then
**Dry Run** before saving. It must show **no deletions under
`pictures/`**. If it would delete there, cancel without saving and switch
that task's mode to COPY first (or ask for help).

**c. New task for the iCloud backups.**

| Setting | Value |
|---|---|
| Description | `Morris Photos: iCloud` |
| Direction / Mode | PUSH / **COPY** |
| Directory | `/mnt/storage0/pictures/icloud` |
| Bucket / Folder | `morrisphotos` / `icloud` |
| Schedule | Daily, 04:00 (after the nightly iCloud backup) |

COPY never deletes from Backblaze, so a photo deleted from iCloud (and
therefore not in future iCloud backups) stays off-site.

## 4. Install the app

1. Create the secrets file:
   ```sh
   mkdir -p /mnt/storage0/apps/icloud-backup/config /mnt/storage0/apps/icloud-backup/archive
   install -m 600 /dev/null /mnt/storage0/apps/icloud-backup/icloud-backup.env
   ```
   Fill it in from `.env.example`, generating each value with
   `openssl rand -base64 32`. Save all three in the password manager as
   **iCloud backup (TrueNAS)**.
2. **Apps → Discover Apps → ⋮ → Install via YAML**, name it
   `icloud-backup`, and paste `docker-compose.yml` unchanged.
3. Check it's up: `curl -s http://truenas:30880/health` should report the
   build version and no storage errors.

## 5. Add the Apple IDs

Open **http://truenas:30880** and sign in with `AUTH_PASSWORD`. Parts of
the UI are in German: *Account hinzufügen* = Add account, *Einstellungen*
= Settings.

For each of the five Apple IDs:

1. Add the account with its Apple ID and password. The owner approves the
   2FA prompt on their iPhone, or you can request an SMS code.
2. Enable **Photos** backup with sync policy **keep** (the default for
   photos). Leave Drive, Contacts and Calendars off unless wanted.
3. If the family uses an **iCloud Shared Photo Library**, turn on
   *include family library* for **one** account only, so shared photos
   aren't downloaded five times.

The first backup of each library can take a long time. After everything
has run once, check that the Backblaze **iCloud** task has uploaded, then
remove the old copy:

```sh
rm -rf /mnt/storage0/data/media/pictures   # still in the data dataset's snapshots for a while
```

## Ongoing care

- **Every ~30 days, each Apple ID's 2FA session expires.** Open the web
  UI, re-authenticate that account, and have its owner approve the code.
  With five accounts, expect about one of these a week. Setting up
  **Pushover** notifications under *Einstellungen* gives a heads-up before
  a session expires and when a backup fails.
- **Advanced Data Protection:** if an Apple ID has it on, that account
  needs *Settings → [name] → iCloud → Access iCloud Data on the Web*
  turned on, or the app can't see its photos.
- **Upgrades:** bump the image tag in `docker-compose.yml`, then in
  TrueNAS edit the app's YAML to match.
- **Health:** `http://truenas:30880/health` returns HTTP 503 and names the
  path if a volume isn't readable.
