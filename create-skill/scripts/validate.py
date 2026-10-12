#!/usr/bin/env python3
"""
validate.py -- Validate an Agent Skill directory (SKILL.md + layout).

Usage:
    python3 validate.py <skill-dir>

Checks (stdlib only, no dependencies):
  - SKILL.md exists; YAML frontmatter block is at byte 0 and parses
  - name: present, matches ^[a-z0-9]+(-[a-z0-9]+)*$, 1-64 chars, equals dir name
  - description: present, 1-1024 chars, third-person heuristic
  - metadata: values should be strings (cross-client portability)
  - warns on unknown top-level fields and on V1-ignored fields
  - body under ~500 lines; references/*.md links resolve; scripts sane

Exit code: 0 = clean, 1 = errors found. Warnings go to stderr, do not fail.
"""

import os
import re
import sys

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
KNOWN_FIELDS = {
    "name", "description", "license", "compatibility",
    "metadata", "disable-model-invocation", "allowed-tools",
}
V1_IGNORED = {"license", "compatibility", "metadata", "disable-model-invocation"}


def unquote(v):
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] and v[0] in ("'", '"'):
        return v[1:-1]
    return v


def parse_frontmatter(block):
    """Minimal YAML-subset parser: top-level scalars + one-level nested maps."""
    data = {}
    cur_key = None
    cur_indent = None
    for raw in block.split("\n"):
        if not raw.strip() or raw.strip().startswith("#"):
            continue
        m = re.match(r"^(\s*)([^:\s][^:]*):\s*(.*)$", raw)
        indent = len(m.group(1)) if m else None
        if m and (cur_indent is None or indent == 0):
            cur_key = m.group(2).strip()
            cur_indent = 0
            val = unquote(m.group(3))
            data[cur_key] = {} if val == "" else val
        elif m and cur_key is not None and indent > 0 and isinstance(data.get(cur_key), dict):
            data[cur_key][m.group(2).strip()] = unquote(m.group(3))
        elif cur_key is not None and isinstance(data.get(cur_key), str):
            # continuation line: fold into previous scalar
            data[cur_key] += " " + raw.strip()
        # else: unparseable line inside a nested map -- ignore
    return data


def main():
    errors, warnings = [], []
    if len(sys.argv) != 2:
        print("usage: python3 validate.py <skill-dir>", file=sys.stderr)
        return 2
    skill_dir = os.path.normpath(sys.argv[1])
    want_name = os.path.basename(skill_dir)
    if want_name in (".", ""):
        want_name = os.path.basename(os.path.abspath(skill_dir))

    if not os.path.isdir(skill_dir):
        print("ERROR: not a directory: %s" % skill_dir)
        return 1
    md_path = os.path.join(skill_dir, "SKILL.md")
    if not os.path.isfile(md_path):
        print("ERROR: missing SKILL.md in %s" % skill_dir)
        return 1

    text = open(md_path, encoding="utf-8").read()
    if not text.startswith("---\n"):
        errors.append("frontmatter must start at byte 0 (file must begin with '---')")
        fm, body = {}, text
    else:
        m = re.match(r"^---\n(.*?)\n---\n?", text, re.S)
        if not m:
            errors.append("unterminated frontmatter block")
            fm, body = {}, text
        else:
            try:
                fm = parse_frontmatter(m.group(1))
            except Exception as e:  # noqa: BLE001 -- report, don't crash
                errors.append("frontmatter parse failed: %s" % e)
                fm = {}
            body = text[m.end():]

    # --- name ---
    name = fm.get("name")
    if not isinstance(name, str) or not name:
        errors.append("frontmatter: 'name' is required and must be a string")
    else:
        if not NAME_RE.match(name):
            errors.append("frontmatter: name %r violates ^[a-z0-9]+(-[a-z0-9]+)*$" % name)
        if not (1 <= len(name) <= 64):
            errors.append("frontmatter: name must be 1-64 chars (got %d)" % len(name))
        if name != want_name:
            errors.append("frontmatter: name %r != directory name %r" % (name, want_name))

    # --- description ---
    desc = fm.get("description")
    if not isinstance(desc, str) or not desc.strip():
        errors.append("frontmatter: 'description' is required (skill is invisible without it)")
    else:
        if not (1 <= len(desc) <= 1024):
            errors.append("frontmatter: description must be 1-1024 chars (got %d)" % len(desc))
        if re.match(r"^(I|We|You)\b", desc.strip()):
            warnings.append("description should be third-person, not start with %r"
                            % desc.strip().split()[0])

    # --- metadata portability ---
    meta = fm.get("metadata")
    if meta is not None:
        if not isinstance(meta, dict):
            warnings.append("metadata should be a string-to-string map")
        else:
            for k, v in meta.items():
                if not isinstance(v, str):
                    warnings.append("metadata[%r] is not a string -- quote it for portability" % k)

    # --- unknown / ignored fields ---
    for k in fm:
        if k not in KNOWN_FIELDS:
            warnings.append("unknown top-level field %r (tolerated, but move client keys to metadata)" % k)
    ignored = sorted(set(fm) & V1_IGNORED)
    if ignored:
        warnings.append("fields have no effect in OpenCode V1 (docs/V2 only): %s" % ", ".join(ignored))
    if "allowed-tools" in fm:
        warnings.append("allowed-tools is spec-experimental and unsupported by OpenCode")

    # --- body budget ---
    body_lines = body.count("\n") + (0 if body.endswith("\n") else 1)
    if body_lines > 500:
        warnings.append("SKILL.md body is %d lines (>~500); move detail to references/" % body_lines)

    # --- references links resolve ---
    for ref in sorted(set(re.findall(r"references/([A-Za-z0-9_.\-]+)", body))):
        if ref in (".", ".."):
            continue  # prose like "lives in references/." is not a file link
        if not os.path.isfile(os.path.join(skill_dir, "references", ref)):
            errors.append("references/%s mentioned but file does not exist" % ref)

    # --- scripts sanity ---
    sdir = os.path.join(skill_dir, "scripts")
    if os.path.isdir(sdir):
        for fn in sorted(os.listdir(sdir)):
            fp = os.path.join(sdir, fn)
            if not os.path.isfile(fp):
                continue
            head = open(fp, "rb").read(2)
            if head != b"#!" and not os.access(fp, os.X_OK):
                warnings.append("scripts/%s has no shebang and is not executable" % fn)

    for w in warnings:
        print("WARNING: %s" % w, file=sys.stderr)
    for e in errors:
        print("ERROR: %s" % e)
    if not errors and not warnings:
        print("OK: %s is a valid skill" % want_name)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
