# Wiki hosting

This page explains how this wiki website works, who can see it, and what to
do if you can't reach it. The first half is for everyone. The second half,
[Setting it up](#setting-it-up-technical), is technical and only needed if
the wiki ever has to be rebuilt from scratch.

## The short version

Think of this wiki as a **binder of instructions kept at a friend's house**
rather than in our own. If something goes wrong at home (a power outage, a
broken computer, a flood), the instructions are still safe and reachable
from any phone or laptop.

- **Where it lives:** on Cloudflare, a large internet company. Not on any
  computer in our house.
- **Who can read it:** only people whose email addresses are on our approved
  list. Everyone else sees a sign-in page and nothing more.
- **How you prove who you are:** Cloudflare emails you a one-time code. There
  is no separate wiki password to remember.
- **What it costs:** nothing. We use Cloudflare's free plans.

## How to open the wiki

1. Go to **wiki.morriscloud.com** on any phone, tablet, or computer.
2. On the Cloudflare sign-in page, enter your email address.
3. Open the email from Cloudflare and type the code into the page.
4. You'll stay signed in on that device for about a month, then it will ask
   again.

## If you can't get in

Work through these in order.

**No code arrives in your email**
:   Check your spam or junk folder first. If it isn't there, your email
    address is probably not on the approved list. Someone with access to the
    Cloudflare account can add it (see [Adding or removing a
    reader](#adding-or-removing-a-reader)).

**The page won't load at all, or shows an error**
:   Cloudflare itself may be having problems, which is rare and usually
    fixed within hours. Try the backup address
    **morris-wiki.pages.dev**. If that fails too, use one of the
    options below.

**The website is down and you need the instructions now**
:   Every page of this wiki is also kept as plain text on GitHub, in the
    project called `afmorris/homelab-infrastructure`, inside the `docs`
    folder. Sign in to GitHub (password manager entry: *GitHub*) and read
    the pages there. They look a little plainer but say exactly the same
    thing.

**Nothing online is working**
:   Printed copies of the most important recovery pages are kept with the
    family's important papers.

## How it works

You don't need this to use the wiki, but it helps to know what the pieces
are if you ever have to explain a problem to someone.

```
 Tony edits a page ──▶ saved on GitHub ──▶ Cloudflare rebuilds the website
                                                     │
                                                     ▼
 You visit wiki.morriscloud.com ──▶ Cloudflare checks your email ──▶ page appears
```

| Piece | What it does | Where to manage it |
|---|---|---|
| **GitHub** | Stores the text of every page, with a history of every change | github.com, project `afmorris/homelab-infrastructure` |
| **Cloudflare Pages** | Turns that text into a website and serves it | Cloudflare dashboard → Workers & Pages → `morris-wiki` |
| **Cloudflare Access** | Checks your email address before letting you in | Cloudflare dashboard → Zero Trust → Access |
| **Domain** | The address `wiki.morriscloud.com` | Cloudflare dashboard → morriscloud.com → DNS |

**Accounts you may need** (look these up in the password manager; they are
never written here):

- *Cloudflare*: to add or remove readers, or fix settings. It uses
  two-step verification, so you'll also need the device or app that
  provides the second code.
- *GitHub*: to read or edit the wiki's text directly.

### Why it's kept private

These pages describe how our home network and backups are set up. That's
useful to us and could also be useful to someone trying to break in. So
the wiki is private, and it **never contains passwords**. Pages only say
*which* password-manager entry to use.

## Adding or removing a reader

The approved list lives in the same place as the rest of the wiki's
settings: a file on GitHub. The usual way to change it is to ask Tony, or
anyone comfortable with the steps in [Setting it up](#setting-it-up-technical).
It's a one-line change.

**In an emergency** (for example, someone must be locked out right now and
Tony isn't available), it can also be changed in the Cloudflare dashboard:

1. Sign in at **dash.cloudflare.com** (password manager: *Cloudflare*).
2. Open **Zero Trust**, then **Access**, then **Policies**.
3. Open the policy named **Family** and add or remove the email address.
   Save. This one policy covers both wiki addresses.

The change takes effect right away. To sign someone out immediately rather
than when their sign-in expires, also open each wiki application under
**Access → Applications** and choose **Revoke existing tokens**.

!!! warning "Tell Tony about dashboard changes"
    The settings file on GitHub is the official list. A change made only in
    the dashboard will be undone the next time the settings are applied,
    unless the file is updated to match.

## Editing the wiki

**The easy way (no tools needed):** every page has a small pencil icon near
its title. Clicking it opens that page on GitHub, where you can edit the
text in your browser and choose **Commit changes** to save. The website
updates itself about a minute later.

**Tony's way:** edit the files on a computer, preview them locally, and push
the change to GitHub:

```
pip install -r docs-requirements.txt
zensical serve        # preview at http://localhost:8000
```

---

## Setting it up (technical)

!!! info "Who this section is for"
    You don't need this section to read or use the wiki. It records how the
    wiki is set up, so it can be rebuilt if the Cloudflare account or
    project is ever lost. A tech-comfortable person can follow it in about
    20 minutes.

Everything about the wiki's hosting (the Pages project, the web address,
the DNS record, the sign-in protection, and the list of approved readers)
is written down as code, using a tool called **OpenTofu**, in the GitHub
project `afmorris/homelab-infrastructure` under `terraform/cloudflare/`.
Nobody should need to click through the Cloudflare dashboard to rebuild it;
the code recreates it.

### Settings at a glance

| Setting | Value |
|---|---|
| Source | GitHub `afmorris/homelab-infrastructure`: `docs/`, `mkdocs.yml`, `docs-requirements.txt` |
| Site generator | Zensical (successor to Material for MkDocs; reads `mkdocs.yml`) |
| Hosting settings | `terraform/cloudflare/wiki.tf` (OpenTofu) |
| Approved readers | `wiki_readers` in `terraform/cloudflare/variables.tf` |
| Pages project | `morris-wiki`, connected to GitHub, production branch `main`, no preview deployments |
| Hostnames | `wiki.morriscloud.com` (main), `morris-wiki.pages.dev` (Cloudflare's default) |
| Access | Applications **Morris Wiki** and **Morris Wiki (pages.dev)**, sharing the reusable policy **Family** |
| Login method | One-time PIN (emailed code) |
| Plans | Pages Free; Zero Trust Free (up to 50 users) |
| Secrets needed | *Cloudflare* (dashboard login), *Cloudflare OpenTofu API token*, *Cloudflare OpenTofu state passphrase* |

### Rebuilding it

Follow `terraform/cloudflare/README.md`. In short:

1. On a Mac: `brew install opentofu cloudflare/cloudflare/cf-terraforming`
   and clone the repository.
2. Do the three one-time dashboard steps in the README: create the API
   token, turn on Zero Trust, and let Cloudflare Pages read the GitHub
   repository.
3. In `terraform/cloudflare/`, run `./bootstrap.sh`. It changes nothing; it
   prepares everything and shows a plan.
4. If the plan looks right, run `tofu apply tfplan`.
5. Run every check below.

!!! danger "The pages.dev address must be protected too"
    Cloudflare publishes the wiki at `morris-wiki.pages.dev` as well as at
    `wiki.morriscloud.com`. The code protects both, but if the site is ever
    rebuilt by hand, protecting only the main address leaves a public copy.
    That's why the checks below test both addresses, and why only
    non-sensitive pages should be published until the checks pass.

### Check that everything is locked down

**Every item must pass before adding real runbooks.**

- [ ] In a private/incognito browser window, `https://wiki.morriscloud.com`
      shows the Cloudflare sign-in page, not the wiki.
- [ ] Same for `https://morris-wiki.pages.dev`.
- [ ] From a terminal, both addresses redirect to the sign-in page:
      ```
      curl -sI https://wiki.morriscloud.com | grep -i location
      curl -sI https://morris-wiki.pages.dev | grep -i location
      ```
      Each should print a `location:` line pointing to
      `<team>.cloudflareaccess.com`.
- [ ] Signing in with an approved email delivers a code and opens the wiki.
- [ ] An email address *not* on the list never receives a code.
