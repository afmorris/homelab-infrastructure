#!/usr/bin/env python3
"""Find morris-wiki pages whose `sources` front matter covers changed files.

Usage:
  find_wiki_pages.py <wiki repo dir> <file with one changed path per line>
  git diff --name-only origin/main...HEAD | find_wiki_pages.py <wiki repo dir> -

Prints the pages to update and the changed paths that no page covers.
Globs in `sources` follow fnmatch rules, with `**` matching across
directories. A source that names a directory covers everything under it.
No third-party dependencies.
"""

from __future__ import annotations

import fnmatch
import pathlib
import sys


def read_sources(page: pathlib.Path) -> list[str]:
    """Parse the `sources:` list from a page's YAML front matter."""
    lines = page.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        return []
    sources: list[str] = []
    in_sources = False
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if line.startswith("sources:"):
            in_sources = True
            inline = line.split(":", 1)[1].strip()
            if inline.startswith("[") and inline.endswith("]"):
                sources += [s.strip().strip("'\"") for s in inline[1:-1].split(",") if s.strip()]
                in_sources = False
            continue
        if in_sources:
            stripped = line.strip()
            if stripped.startswith("- "):
                sources.append(stripped[2:].strip().strip("'\""))
            elif stripped and not line.startswith((" ", "\t")):
                in_sources = False
    return sources


def covers(source: str, path: str) -> bool:
    source = source.rstrip("/")
    if path == source or path.startswith(source + "/"):
        return True
    pattern = source.replace("**/", "*").replace("**", "*")
    return fnmatch.fnmatch(path, pattern) or fnmatch.fnmatch(path, source)


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    wiki = pathlib.Path(sys.argv[1])
    stream = sys.stdin if sys.argv[2] == "-" else open(sys.argv[2], encoding="utf-8")
    changed = [l.strip() for l in stream if l.strip()]

    pages = {p: read_sources(p) for p in sorted((wiki / "docs").rglob("*.md"))}
    hits: dict[pathlib.Path, list[str]] = {}
    covered: set[str] = set()
    for page, sources in pages.items():
        for path in changed:
            if any(covers(s, path) for s in sources):
                hits.setdefault(page, []).append(path)
                covered.add(path)

    if hits:
        print("Pages to review and update:")
        for page, paths in hits.items():
            print(f"  {page.relative_to(wiki)}")
            for path in paths:
                print(f"      <- {path}")
    else:
        print("No wiki page lists any of the changed paths in `sources`.")

    uncovered = [p for p in changed if p not in covered]
    if uncovered:
        print("\nChanged paths no page covers (decide: new page, new section, or internal-only):")
        for path in uncovered:
            print(f"  {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
