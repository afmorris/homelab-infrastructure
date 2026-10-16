# CloverleafTrack publishing scripts

These three scripts run on **svp01docker01**, in `/home/tony/`. They are not
managed by Ansible: this folder is the version-controlled copy, and the host
copy is installed by hand (see "Installing a change" below).

The public site (`cloverleaftrack.com`) is a static export, not a running
application. The app container (`stacks/cloverleaftrack/docker-compose.yml`,
reachable internally as `ctf.morriscloud.com`) is crawled and the result is
copied to the S3 bucket `cloverleaftrack.com`, which CloudFront serves.

| Script | What it does | When it runs |
|---|---|---|
| `deploy-cloverleaftrack` | Pulls `ghcr.io/afmorris/cloverleaftrack:latest`; if the image changed, recreates the container, checks it answers HTTP 200 on `localhost:8081`, and rolls back to the previous image if not. | Cron, 02:30 daily |
| `ctf` | Crawls `https://ctf.morriscloud.com` with `wget`, adds the files wget cannot discover by following links (`/img/hero-home.jpg`, a `sitemap.xml` built from the exported pages), then runs `aws s3 sync --delete` to `s3://cloverleaftrack.com`. | Cron, 03:00 daily |
| `publish-cloverleaftrack` | Runs `deploy-cloverleaftrack`, then `ctf`. Skips the export if the deploy failed or rolled back. | By hand, for a same-day publish |

## Why the deploy script exists

The Portainer stack pins `image: …:latest`. Portainer's GitOps polling only
redeploys when this repository changes, and merging to the application repo
never changes it, so new images were never pulled. `deploy-cloverleaftrack`
does the pull and recreate itself. Changing the Portainer stack to re-pull
automatically (a webhook from CI) would make it unnecessary, but GitHub's
hosted runners cannot reach Portainer on the home network.

## Things that are easy to get wrong

- **Pull as `tony`, not with `sudo`.** `tony`'s Docker config holds the GitHub
  Container Registry login; root has none and the pull is denied.
- **Recreating the container needs `sudo`.** The compose file lives in
  Portainer's data folder (`/mnt/k8s/portainer/compose/5/stacks/cloverleaftrack/`),
  which only root can read. `tony` has passwordless `sudo`, and the script uses
  `sudo -n docker compose -p cloverleaftrack -f <that file> up -d`.
- **`ctf` deletes from S3.** `aws s3 sync --delete` removes anything the crawl
  did not produce. That is why the deploy script rolls back an unhealthy
  container *before* the export runs.
- **The crawl only finds linked pages.** Anything nothing links to (the share
  image, `sitemap.xml`) has to be added to `ctf` explicitly.
- **The AWS credentials are in `/home/tony/.aws/`** (not in this repository).

## AWS / S3 access

`ctf` is the only thing that writes to AWS. It uses the AWS CLI's `default`
profile on svp01docker01, read from `/home/tony/.aws/` (`config`, `credentials`).
No keys are stored in this repository.

| Item | Value |
|---|---|
| Identity | IAM user `@photos` (the CLI's `default` profile; confirm with `aws sts get-caller-identity`). TODO (Tony): confirm whether this user is shared with other sites (MorrisPhotos). |
| Permissions | The policy `S3FullAccess` (all S3 actions on all buckets in the account). Far more than `ctf` needs; it only needs `s3:ListBucket` on the bucket and `s3:PutObject`/`s3:DeleteObject` on its objects. |
| Region | `us-east-2` |
| Bucket | `cloverleaftrack.com`, static website hosting on (index and error document `index.html`, plus a handful of redirect rules for old URLs) |
| Bucket policy | Public read: anyone may `s3:GetObject` any object. The website endpoint is the CloudFront origin. |
| Versioning | **Off.** `aws s3 sync --delete` is permanent; the only way back is to re-run `publish-cloverleaftrack`. |
| CloudFront | Distribution `E1TSP2TC4FETRI` (`d1agn4g5pghhiu.cloudfront.net`), origin `cloverleaftrack.com.s3-website.us-east-2.amazonaws.com`. DNS for `cloverleaftrack.com` points here (`terraform/cloudflare/dns_cloverleaftrack_com.tf`). |
| Password manager | TODO (Tony): name the entry for the AWS account / the `@photos` access key. |

Check access from the host:

```sh
aws sts get-caller-identity
aws s3 ls s3://cloverleaftrack.com/ | head
```

To rotate the key: create a new access key for the IAM user in the AWS console,
put it in `/home/tony/.aws/credentials` (`[default]`), run the two commands
above, then delete the old key in the console. There is also an old
`/home/tony/.aws/credentials.save` (dated 2023) that is not used; once nothing
needs it, delete it and deactivate the key it holds.

If cached pages look stale after an export, CloudFront may still be serving its
copy; create an invalidation for `/*` on the distribution above.

## Logs

| File on the host | Written by |
|---|---|
| `~/logs/deploy-cloverleaftrack.log` | `deploy-cloverleaftrack` |
| `~/logs/cloverleaf-generation.log` | `ctf` (its own progress lines) |
| `~/logs/ctf.log` | `ctf` (cron output, including wget and S3 transfer lines) |

## Crontab for `tony` on svp01docker01

```cron
30 2 * * * /home/tony/deploy-cloverleaftrack >> /home/tony/logs/deploy-cloverleaftrack.cron.log 2>&1
0 3 * * * /home/tony/ctf >> /home/tony/logs/ctf.log 2>&1
```

## Rolling back by hand

`deploy-cloverleaftrack` keeps the previous image on the host (it becomes
untagged). To go back, find its id with `docker image ls -a ghcr.io/afmorris/cloverleaftrack`,
then `docker tag <id> ghcr.io/afmorris/cloverleaftrack:latest` and re-run the
`docker compose … up -d` command above.

## Installing a change

```sh
scp stacks/cloverleaftrack/scripts/<script> tony@svp01docker01:/home/tony/<script>
ssh tony@svp01docker01 'chmod +x ~/<script>'
```
