#!/usr/bin/env python3
"""Turn raw cf-terraforming output for one zone into readable OpenTofu files.

cf-terraforming emits resources named like
`terraform_managed_resource_<record id>_0` with the zone ID pasted in as a
literal. This script:

  * renames each record to something readable (`morriscloud_com_mx_apex`, ...)
  * replaces the literal zone ID with a `data "cloudflare_zone"` lookup
  * drops records that are managed elsewhere (e.g. the wiki CNAME in wiki.tf)
  * writes matching `import` blocks so the first plan adopts, not recreates

Usage:
  tidy_dns.py --zone morriscloud.com --zone-id <id> \
      --resources raw_resources.tf --imports raw_imports.tf \
      --out-resources dns_morriscloud_com.tf --out-imports imports_dns_morriscloud_com.tf \
      [--exclude-record-id <id> ...]
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field

HEREDOC_RE = re.compile(r"<<-?\s*([A-Za-z_][A-Za-z0-9_]*)\s*$")


@dataclass
class Block:
    kind: str  # "resource", "import", or other top-level keyword
    lines: list[str] = field(default_factory=list)

    @property
    def text(self) -> str:
        return "\n".join(self.lines)


def split_top_level_blocks(src: str) -> list[Block]:
    """Split HCL into top-level blocks, respecting strings and heredocs."""
    blocks: list[Block] = []
    current: Block | None = None
    depth = 0
    heredoc_end: str | None = None

    for line in src.splitlines():
        if heredoc_end is not None:
            current.lines.append(line)  # type: ignore[union-attr]
            if line.strip() == heredoc_end:
                heredoc_end = None
            continue

        if current is None:
            stripped = line.strip()
            if not stripped or stripped.startswith(("#", "//")):
                continue
            current = Block(kind=stripped.split()[0])
            depth = 0

        current.lines.append(line)

        in_string = False
        escaped = False
        for ch in line:
            if in_string:
                if escaped:
                    escaped = False
                elif ch == "\\":
                    escaped = True
                elif ch == '"':
                    in_string = False
                continue
            if ch == '"':
                in_string = True
            elif ch == "#":
                break
            elif ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1

        m = HEREDOC_RE.search(line)
        if m and not in_string:
            heredoc_end = m.group(1)
            continue

        if depth == 0 and "{" in "".join(current.lines):
            blocks.append(current)
            current = None

    if current is not None:
        raise ValueError("unterminated block in cf-terraforming output")
    return blocks


def attr(block: Block, name: str) -> str | None:
    """Return a top-level string attribute value, or None."""
    for line in block.lines[1:]:
        m = re.match(rf'^\s*{name}\s*=\s*"((?:[^"\\]|\\.)*)"\s*$', line)
        if m:
            return m.group(1)
    return None


def resource_label(block: Block) -> str | None:
    m = re.match(r'^\s*resource\s+"([^"]+)"\s+"([^"]+)"', block.lines[0])
    return m.group(2) if m else None


def slugify(text: str) -> str:
    s = re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")
    if not s:
        s = "record"
    if s[0].isdigit():
        s = "r_" + s
    return s


def friendly_name(record_type: str, record_name: str, zone: str) -> str:
    """e.g. cloverleaftrack_com_cname_www.

    Prefixed with the zone because resource names must be unique across the
    whole directory, and most zones have an apex and a www record.
    """
    name = record_name.rstrip(".").lower()
    if name in (zone, "@"):
        short = "apex"
    elif name.endswith("." + zone):
        short = name[: -(len(zone) + 1)]
    else:
        short = name
    short = short.replace("*", "wildcard")
    return slugify(f"{zone}_{record_type}_{short}")


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--zone", required=True)
    p.add_argument("--zone-id", required=True)
    p.add_argument("--resources", required=True)
    p.add_argument("--imports", required=True)
    p.add_argument("--out-resources", required=True)
    p.add_argument("--out-imports", required=True)
    p.add_argument("--exclude-record-id", action="append", default=[])
    p.add_argument("--exclude-name", action="append", default=[],
                   help="Also drop records with this FQDN (fallback matcher)")
    args = p.parse_args()

    zone = args.zone.lower()
    zone_slug = slugify(zone)
    zone_ref = f"data.cloudflare_zone.{zone_slug}.id"

    with open(args.resources) as f:
        resources = [b for b in split_top_level_blocks(f.read()) if b.kind == "resource"]
    with open(args.imports) as f:
        imports = [b for b in split_top_level_blocks(f.read()) if b.kind == "import"]

    # label -> record id, from the import blocks
    label_to_id: dict[str, str] = {}
    for imp in imports:
        to_line = next((l for l in imp.lines if re.match(r"^\s*to\s*=", l)), "")
        m = re.search(r"cloudflare_dns_record\.([A-Za-z0-9_\-]+)", to_line)
        imp_id = attr(imp, "id")
        if m and imp_id and "/" in imp_id:
            label_to_id[m.group(1)] = imp_id.split("/", 1)[1]

    excluded_ids = set(args.exclude_record_id)
    excluded_names = {n.lower().rstrip(".") for n in args.exclude_name}

    used: dict[str, int] = {}
    out_resources: list[str] = []
    out_imports: list[str] = []
    dropped = 0
    unmatched = 0

    for block in resources:
        old_label = resource_label(block)
        if old_label is None:
            continue
        rtype = attr(block, "type") or "record"
        rname = attr(block, "name") or ""
        rec_id = label_to_id.get(old_label)
        # cf-terraforming usually embeds the record id in the label
        if rec_id is None:
            m = re.search(r"([0-9a-f]{32})", old_label)
            rec_id = m.group(1) if m else None

        if (rec_id and rec_id in excluded_ids) or rname.lower().rstrip(".") in excluded_names:
            dropped += 1
            continue

        base = friendly_name(rtype, rname, zone)
        used[base] = used.get(base, 0) + 1
        label = base if used[base] == 1 else f"{base}_{used[base]}"

        text = block.text
        text = text.replace(f'"{old_label}"', f'"{label}"', 1)
        text = re.sub(
            rf'^(\s*zone_id\s*=\s*)"{re.escape(args.zone_id)}"',
            rf"\g<1>{zone_ref}",
            text,
            flags=re.M,
        )
        out_resources.append(text)

        if rec_id:
            out_imports.append(
                "import {\n"
                f"  to = cloudflare_dns_record.{label}\n"
                f'  id = "{args.zone_id}/{rec_id}"\n'
                "}"
            )
        else:
            unmatched += 1

    header = (
        f"# DNS records for {zone}.\n"
        "# Generated from the live zone by ./bootstrap.sh (cf-terraforming), then\n"
        "# hand-maintained. Edit records here, not in the Cloudflare dashboard.\n"
    )
    zone_block = (
        f'data "cloudflare_zone" "{zone_slug}" {{\n'
        "  filter = {\n"
        f'    name = "{zone}"\n'
        "  }\n"
        "}\n"
    )
    with open(args.out_resources, "w") as f:
        f.write(header + "\n" + zone_block + "\n" + "\n\n".join(out_resources) + "\n")

    imports_header = (
        f"# Adopts the existing {zone} records into state on the first apply.\n"
        "# Safe to delete once `tofu apply` has succeeded.\n"
    )
    with open(args.out_imports, "w") as f:
        f.write(imports_header + "\n" + "\n\n".join(out_imports) + "\n")

    print(
        f"{zone}: {len(out_resources)} records, {len(out_imports)} imports, "
        f"{dropped} excluded, {unmatched} without an import id"
    )
    return 1 if unmatched else 0


if __name__ == "__main__":
    sys.exit(main())
