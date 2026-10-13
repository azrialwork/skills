#!/usr/bin/env python3
"""
validate.py -- Validate and score an Agent Skill directory (SKILL.md + layout).

Usage:
    python3 validate.py <skill-dir>
    python3 validate.py --score <skill-dir> [--rubric rubric.json]

Checks (stdlib only, no dependencies):
  - SKILL.md exists; YAML frontmatter block is at byte 0 and parses
  - name: present, matches ^[a-z0-9]+(-[a-z0-9]+)*$, 1-64 chars, equals dir name
  - description: present, 1-1024 chars, third-person heuristic
  - metadata: values should be strings (cross-client portability)
  - warns on unknown top-level fields (incl. disable-model-invocation, which is
    in neither the Agent Skills spec nor OpenCode's official docs)
  - body under ~500 lines; references/*.md links resolve; scripts sane

--score runs the full 0-100 quality algorithm from
references/11-quality-scoring.md: B1-B10 (binary, 55 pts, automated) plus
G1-G9 (graded, 45 pts). G-items take explicit human scores from --rubric
(a JSON object {"G1": 8, ...}); without it, documented heuristics are used
and flagged as auto. Failing the hard gate (B1-B4) scores 0.

Exit code: 0 = clean (or scored without hard-gate failure),
           1 = errors found / hard gate failed, 2 = usage error.
"""

import json
import os
import re
import sys

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
KNOWN_FIELDS = {
    "name", "description", "license", "compatibility",
    "metadata", "allowed-tools",
}
TRIGGER_RE = re.compile(r"\buse when\b|\bwhen the user\b|\bwhen you need\b", re.I)
NEG_TRIGGER_RE = re.compile(
    r"\bnot for\b|do not use (it|this )?when\b|instead of\b|not to be confused with\b", re.I)
ARTIFACT_RE = re.compile(
    r"`[^`]+`|\b[\w][\w.\-]*\.(md|py|sh|js|json|yaml|yml|toml|txt|csv)\b"
    r"|\bscripts/|\breferences/|\bassets/", re.I)
QUOTED_RE = re.compile(r'"([^"]+)"')
CURL_PIPE_RE = re.compile(r"curl\b[^\n|]*\|\s*(ba)?sh\b")
# lines that merely document the anti-pattern ("never curl | bash") are not violations
DOC_NEGATION_RE = re.compile(r"\b(never|no|not|without|avoid|warn(?:ing)?s?|forbidden)\b", re.I)
EXFIL_RE = re.compile(
    r"(send|upload|post|transmit|exfiltrat)[^.]{0,60}"
    r"(http|url|webhook|endpoint|api[_ \-]?key|secret|credential|token|password)", re.I)
PROC_RE = re.compile(
    r"\bvalidat\w*|\bpars\w*|\bconvert\w*|\btransform\w*|\bgenerat\w*|\blint\w*|\bcomput\w*", re.I)

G_MAX = {"G1": 8, "G2": 6, "G3": 5, "G4": 3, "G5": 3,
         "G6": 8, "G7": 4, "G8": 4, "G9": 4}


def unquote(v):
    v = v.strip()
    if len(v) >= 2 and v[0] == v[-1] and v[0] in ("'", '"'):
        return v[1:-1]
    return v


def parse_frontmatter(block):
    """Minimal YAML-subset parser: top-level scalars + one-level nested maps."""
    data = {}
    cur_key = None
    for raw in block.split("\n"):
        if not raw.strip() or raw.strip().startswith("#"):
            continue
        m = re.match(r"^(\s*)([^:\s][^:]*):\s*(.*)$", raw)
        indent = len(m.group(1)) if m else None
        if m and indent == 0:
            cur_key = m.group(2).strip()
            val = unquote(m.group(3))
            data[cur_key] = {} if val == "" else val
        elif m and cur_key is not None and indent > 0 and isinstance(data.get(cur_key), dict):
            data[cur_key][m.group(2).strip()] = unquote(m.group(3))
        elif cur_key is not None and isinstance(data.get(cur_key), str):
            # continuation line: fold into previous scalar
            data[cur_key] += " " + raw.strip()
        # else: unparseable line inside a nested map -- ignore
    return data


def load_skill(skill_dir):
    """Return dict with text, fm, body, body_lines, want_name, ref_files, scripts."""
    want_name = os.path.basename(skill_dir)
    if want_name in (".", ""):
        want_name = os.path.basename(os.path.abspath(skill_dir))
    md_path = os.path.join(skill_dir, "SKILL.md")
    text = open(md_path, encoding="utf-8").read()
    fm_ok = text.startswith("---\n")
    m = re.match(r"^---\n(.*?)\n---\n?", text, re.S) if fm_ok else None
    if m:
        try:
            fm = parse_frontmatter(m.group(1))
        except Exception:
            fm = {}
        body = text[m.end():]
    else:
        fm, body = {}, text
    body_lines = body.count("\n") + (0 if body.endswith("\n") or not body else 1)
    ref_dir = os.path.join(skill_dir, "references")
    ref_files = []
    ref_subdirs = False
    if os.path.isdir(ref_dir):
        for root, dirs, files in os.walk(ref_dir):
            if root != ref_dir:
                ref_subdirs = True
            for f in files:
                ref_files.append(os.path.join(root, f))
    ref_lines = 0
    for fp in ref_files:
        try:
            with open(fp, encoding="utf-8", errors="replace") as fh:
                ref_lines += sum(1 for _ in fh)
        except OSError:
            pass
    sdir = os.path.join(skill_dir, "scripts")
    scripts = []
    if os.path.isdir(sdir):
        for fn in sorted(os.listdir(sdir)):
            fp = os.path.join(sdir, fn)
            if os.path.isfile(fp):
                with open(fp, "rb") as fh:
                    head = fh.read(2)
                scripts.append({"name": fn, "path": fp,
                                "shebang": head == b"#!",
                                "exec": os.access(fp, os.X_OK)})
    return {"want_name": want_name, "text": text, "fm": fm, "fm_ok": fm_ok,
            "fm_terminated": bool(m), "body": body, "body_lines": body_lines,
            "ref_files": ref_files, "ref_subdirs": ref_subdirs,
            "ref_lines": ref_lines, "scripts": scripts}


def run_binary(s):
    """B1-B10. Returns list of (id, label, passed, pts, max)."""
    fm, body = s["fm"], s["body"]
    name = fm.get("name")
    desc = fm.get("description")
    meta = fm.get("metadata")
    out = []

    def add(i, label, passed, pts, mx):
        out.append({"id": i, "label": label, "passed": passed,
                    "pts": pts if passed else 0, "max": mx})

    add("B1", "frontmatter at byte 0", s["fm_ok"] and s["fm_terminated"], 5, 5)
    add("B2", "name matches ^[a-z0-9]+(-[a-z0-9]+)*$, 1-64 chars",
        isinstance(name, str) and bool(NAME_RE.match(name)) and 1 <= len(name) <= 64, 8, 8)
    add("B3", "name == directory name",
        isinstance(name, str) and name == s["want_name"], 8, 8)
    add("B4", "description present", isinstance(desc, str) and bool(desc.strip()), 8, 8)
    add("B5", "description 1-1024 chars",
        isinstance(desc, str) and 1 <= len(desc) <= 1024, 6, 6)
    add("B6", "description third-person",
        isinstance(desc, str) and not re.match(r"^(I|We|You)\b", desc.strip()), 5, 5)
    add("B7", "body <= 500 lines", s["body_lines"] <= 500, 5, 5)
    refs = set(r.rstrip(".") for r in
              re.findall(r"references/([A-Za-z0-9_.\-]+)", body))
    missing = [r for r in sorted(refs)
               if r not in (".", "..", "")
               and not os.path.isfile(os.path.join(s["dir"], "references", r))]
    add("B8", "references/* links resolve", not missing, 5, 5)
    add("B9", "scripts have shebang or +x",
        all(x["shebang"] or x["exec"] for x in s["scripts"]), 3, 3)
    add("B10", "metadata values are strings",
        not isinstance(meta, dict) or all(isinstance(v, str) for v in meta.values()), 2, 2)
    return out, missing


def heuristic_g(s, gid):
    """Automated first pass for G-items. Returns (pts, note)."""
    desc = s["fm"].get("description") or ""
    body = s["body"]
    if gid == "G1":
        m = TRIGGER_RE.search(desc)
        cap = desc[:m.start()] if m else desc
        words = len(cap.split())
        if m and words >= 8:
            return 8, "trigger + capability clause"
        if m or words >= 8:
            return 4, "only one clause detected"
        return 0, "no trigger/capability clause"
    if gid == "G2":
        toks = set()
        for mm in ARTIFACT_RE.finditer(desc):
            toks.add(mm.group(0).lower())
        n = len(toks)
        return (6 if n >= 3 else 3 if n >= 1 else 0), "%d artifact token(s)" % n
    if gid == "G3":
        quoted = set(QUOTED_RE.findall(desc))
        m = TRIGGER_RE.search(desc)
        clause = desc[m.start():] if m else desc
        terms = [t.strip(" .") for t in re.split(r"[,;]", clause) if t.strip(" .")]
        n_q, n_t = len(quoted), len(terms)
        note = "%d quoted, %d trigger terms" % (n_q, n_t)
        if n_q >= 2 or n_t >= 4:
            return 5, note
        if n_q >= 1 or n_t >= 2:
            return 2, note
        return 0, note
    if gid == "G4":
        return (3, "negative trigger present") if NEG_TRIGGER_RE.search(desc) \
            else (0, "no negative trigger")
    if gid == "G5":
        # split on sentence-ending punctuation followed by whitespace/end,
        # so periods inside tokens like "validate.py" don't split sentences
        n = len([x for x in re.split(r"[.!?]+(?:\s+|$)", desc.strip()) if x.strip()])
        return (3 if 1 <= n <= 3 else 1 if n <= 5 else 0), "%d sentence(s)" % n
    if gid == "G6":
        if not s["ref_files"]:
            return (8, "no references/; nothing further to disclose") \
                if s["body_lines"] <= 500 else (0, "body over budget, no references")
        ratio = s["body_lines"] / float(s["body_lines"] + s["ref_lines"])
        return (8 if ratio <= 0.60 else 4 if ratio <= 0.80 else 0), \
            "body share %.0f%%" % (ratio * 100)
    if gid == "G7":
        pts, notes = 0, []
        if not s["ref_subdirs"]:
            pts += 2
            notes.append("flat")
        else:
            notes.append("nested subdirs!")
        if s["ref_files"]:
            long = [os.path.basename(f) for f in s["ref_files"]
                    if sum(1 for _ in open(f, encoding="utf-8", errors="replace")) > 150]
            if not long:
                pts += 2
                notes.append("all <=150 lines")
            else:
                notes.append("long files: %s" % ", ".join(long))
        else:
            pts += 2
            notes.append("no references/")
        return pts, "; ".join(notes)
    if gid == "G8":
        procs = len(PROC_RE.findall(body))
        if procs >= 2:
            return (4, "%d procedural markers, scripts/ present" % procs) \
                if s["scripts"] else (0, "%d procedural markers but no scripts/" % procs)
        return 4, "no substantial deterministic procedures in prose"
    if gid == "G9":
        pts, notes = 0, []
        hay = body + "\n".join(
            open(x["path"], encoding="utf-8", errors="replace").read() for x in s["scripts"])
        curl_pipe = any(CURL_PIPE_RE.search(line) and not DOC_NEGATION_RE.search(line)
                        for line in hay.split("\n"))
        if not curl_pipe:
            pts += 2
            notes.append("no curl|sh pipe")
        else:
            notes.append("CURL|SH PIPE FOUND")
        if not EXFIL_RE.search(hay):
            pts += 2
            notes.append("no exfiltration pattern")
        else:
            notes.append("EXFILTRATION PATTERN FOUND")
        notes.append("human: confirm sensitive-skill posture if applicable")
        return pts, "; ".join(notes)
    return 0, "unknown item"


BANDS = [(90, "Exemplary"), (70, "Mature"), (40, "Developing"), (0, "Critical")]


def band_for(score):
    for lo, name in BANDS:
        if score >= lo:
            return name
    return "Critical"


def do_score(skill_dir, rubric):
    s = load_skill(skill_dir)
    s["dir"] = os.path.normpath(skill_dir)
    b_checks, missing = run_binary(s)
    b_by_id = {c["id"]: c for c in b_checks}
    hard_ok = all(b_by_id[i]["passed"] for i in ("B1", "B2", "B3", "B4"))

    rows = []
    total = 0
    for c in b_checks:
        rows.append((c["id"], c["label"], "%d/%d" % (c["pts"], c["max"]), "auto"))
        total += c["pts"]
    if not hard_ok:
        return rows, 0, "HARD GATE FAIL", False

    for i in range(1, 10):
        gid = "G%d" % i
        mx = G_MAX[gid]
        if gid in rubric:
            v = rubric[gid]
            if not isinstance(v, (int, float)) or not (0 <= v <= mx):
                print("WARNING: rubric %s=%r out of range 0..%d; using heuristic"
                      % (gid, v, mx), file=sys.stderr)
                pts, note, src = heuristic_g(s, gid) + ("auto",)
            else:
                pts, note, src = v, rubric.get("_notes", {}).get(gid, ""), "human"
        else:
            h = heuristic_g(s, gid)
            pts, note, src = h[0], h[1], "auto"
        rows.append((gid, note, "%d/%d" % (pts, mx), src))
        total += pts
    return rows, total, band_for(total), True


def main():
    args = sys.argv[1:]
    score_mode = False
    rubric_path = None
    rest = []
    i = 0
    while i < len(args):
        if args[i] == "--score":
            score_mode = True
        elif args[i] == "--rubric":
            i += 1
            if i >= len(args):
                print("usage: validate.py [--score] [--rubric FILE] <skill-dir>",
                      file=sys.stderr)
                return 2
            rubric_path = args[i]
        else:
            rest.append(args[i])
        i += 1
    if len(rest) != 1:
        print("usage: validate.py [--score] [--rubric FILE] <skill-dir>", file=sys.stderr)
        return 2
    skill_dir = os.path.normpath(rest[0])

    if not os.path.isdir(skill_dir):
        print("ERROR: not a directory: %s" % skill_dir)
        return 1
    md_path = os.path.join(skill_dir, "SKILL.md")
    if not os.path.isfile(md_path):
        print("ERROR: missing SKILL.md in %s" % skill_dir)
        return 1

    rubric = {}
    if rubric_path:
        try:
            rubric = json.load(open(rubric_path, encoding="utf-8"))
        except Exception as e:
            print("ERROR: cannot read rubric %s: %s" % (rubric_path, e), file=sys.stderr)
            return 2

    if score_mode:
        rows, total, band, ok = do_score(skill_dir, rubric)
        w = max(len(r[1]) for r in rows)
        for gid, label, pts, src in rows:
            print("%-3s %-*s  %6s  [%s]" % (gid, w, label, pts, src))
        print("-" * (w + 22))
        print("TOTAL: %d/100  band: %s" % (total, band))
        if not ok:
            print("verdict: HARD GATE FAIL (B1-B4) -- score forced to 0")
            return 1
        return 0

    # ---- classic validate mode (unchanged behavior) ----
    errors, warnings = [], []
    s = load_skill(skill_dir)
    s["dir"] = skill_dir
    b_checks, missing = run_binary(s)
    b_by_id = {c["id"]: c for c in b_checks}
    if not b_by_id["B1"]["passed"]:
        if not s["fm_ok"]:
            errors.append("frontmatter must start at byte 0 (file must begin with '---')")
        else:
            errors.append("unterminated frontmatter block")
    if not b_by_id["B2"]["passed"]:
        name = s["fm"].get("name")
        if not isinstance(name, str) or not name:
            errors.append("frontmatter: 'name' is required and must be a string")
        else:
            if not NAME_RE.match(name):
                errors.append("frontmatter: name %r violates ^[a-z0-9]+(-[a-z0-9]+)*$" % name)
            if not (1 <= len(name) <= 64):
                errors.append("frontmatter: name must be 1-64 chars (got %d)" % len(name))
    if not b_by_id["B3"]["passed"] and isinstance(s["fm"].get("name"), str):
        errors.append("frontmatter: name %r != directory name %r"
                      % (s["fm"]["name"], s["want_name"]))
    if not b_by_id["B4"]["passed"]:
        errors.append("frontmatter: 'description' is required (skill is invisible without it)")
    if not b_by_id["B5"]["passed"] and isinstance(s["fm"].get("description"), str):
        errors.append("frontmatter: description must be 1-1024 chars (got %d)"
                      % len(s["fm"]["description"]))
    if not b_by_id["B6"]["passed"]:
        warnings.append("description should be third-person, not start with %r"
                        % s["fm"]["description"].strip().split()[0])
    if not b_by_id["B10"]["passed"]:
        warnings.append("metadata should be a string-to-string map")
    for k in s["fm"]:
        if k not in KNOWN_FIELDS:
            if k == "disable-model-invocation":
                warnings.append(
                    "disable-model-invocation is in neither the Agent Skills spec "
                    "nor OpenCode's official docs; use "
                    'metadata: {"opencode/autoinvoke": "false"} instead')
            else:
                warnings.append("unknown top-level field %r (tolerated, but move client "
                                "keys to metadata)" % k)
    if "allowed-tools" in s["fm"]:
        warnings.append("allowed-tools is spec-experimental and unsupported by OpenCode")
    if not b_by_id["B7"]["passed"]:
        warnings.append("SKILL.md body is %d lines (>~500); move detail to references/"
                        % s["body_lines"])
    for r in missing:
        errors.append("references/%s mentioned but file does not exist" % r)
    for x in s["scripts"]:
        if not (x["shebang"] or x["exec"]):
            warnings.append("scripts/%s has no shebang and is not executable" % x["name"])

    for w in warnings:
        print("WARNING: %s" % w, file=sys.stderr)
    for e in errors:
        print("ERROR: %s" % e)
    if not errors and not warnings:
        print("OK: %s is a valid skill" % s["want_name"])
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
