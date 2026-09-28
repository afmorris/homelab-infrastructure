# Glossary

Plain-English explanations of the technical words used in this wiki,
in alphabetical order.

**Backblaze B2**
:   A company that stores copies of our files in their data centers, far away
    from our house. It's our "off-site" backup: if something happened to the
    house or the NAS, our photos would still be safe there.

**Backup**
:   A second (or third) copy of something, kept separately, so that losing
    one copy doesn't mean losing the thing.

**Cloudflare**
:   A company that runs a large part of the internet's plumbing. We use it for
    three things: keeping track of our web addresses (like
    `wiki.morriscloud.com`), hosting this wiki, and checking who's allowed
    to see it.

**Cloudflare Access**
:   The "front desk" for this wiki. Before anyone can see a page, Access asks
    for their email address, checks it against the approved list, and emails
    them a one-time code to prove the address is really theirs.

**Cloudflare Pages**
:   The Cloudflare service that actually holds the wiki's pages and shows them
    to your browser.

**Dashboard**
:   The website you sign into to manage an online service. For example, the
    "Cloudflare dashboard" is where Cloudflare settings can be viewed, and
    changed in an emergency.

**DNS**
:   The internet's address book. It turns a name like `wiki.morriscloud.com`
    into the location of the computer that answers for that name.

**Domain**
:   A web address we own, like `morriscloud.com`. We can create sub-addresses
    under it, like `wiki.morriscloud.com`.

**Git / GitHub**
:   Git is a system that keeps every version of a set of files, so any change
    can be seen and undone. GitHub is a website that stores those files
    online. The text of this wiki lives on GitHub; when it changes there, the
    website updates itself.

**iCloud Photos**
:   Apple's service that keeps the photos from our iPhones and iPads. It's
    the "main" copy of our photos.

**NAS (Network Attached Storage)**
:   A computer at home whose job is to store files. Ours runs software called
    TrueNAS. It keeps a full copy of our iCloud photos.

**One-time PIN / code**
:   A short code emailed to you that works once, for a few minutes. It proves
    you have access to that email account, so we don't need separate
    passwords for the wiki.

**OpenTofu**
:   A tool that sets up online services from a written description (code)
    instead of by clicking through websites. The wiki's hosting settings are
    written down this way, so they can be recreated exactly.

**Password manager**
:   The secure app where the family's passwords are kept. This wiki never
    contains passwords; it only names the entry to look up.

**pages.dev**
:   Cloudflare's own backup address for the wiki (`morris-wiki.pages.dev`).
    It shows the same pages as `wiki.morriscloud.com` and is protected the
    same way.

**Runbook**
:   Step-by-step instructions for a specific task, especially fixing
    something. Most pages in this wiki are runbooks.

**Snapshot**
:   A "freeze-frame" of files at a moment in time. If files are later
    deleted or damaged, they can be brought back from a snapshot.
