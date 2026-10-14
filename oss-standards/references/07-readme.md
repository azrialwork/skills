<!--
  07-readme.md -- Reference for oss-standards.

  Covers: README section order, badges, the installation section, and tone.
  Read when writing or reviewing a README.
-->

# README anatomy

## Algorithm

INPUT: the README.md under review.

1. **Order the sections** exactly as follows (confirmed across ripgrep, fzf, starship, mise, eza):
   1. Title + one-line pitch (what it is, in one sentence).
   2. Badges (CI, release, license -- see step 2).
   3. Demo / screenshot.
   4. **Installation** -- package managers first, piped install documented but de-emphasized (see step 3).
   5. Quickstart (the 3 commands to first success).
   6. Usage / Features.
   7. Configuration / Options.
   8. FAQ / Troubleshooting.
   9. Uninstall (professional completeness -- fzf documents it).
   10. Contributing (link), License (SPDX identifier), Acknowledgments.
   
   IF any section is out of order THEN move it. For a small CLI repo the MANDATORY subset is: title + pitch + badges + installation + quickstart + usage + troubleshooting + license. IF a mandatory section is missing THEN add it.
2. **Badges (via shields.io).** MUST include: build status (GitHub Actions workflow), latest release version, license (SPDX identifier). SHOULD include: OpenSSF Scorecard badge + Best Practices badge (2026 trust signals). NEVER include noise badges: commit activity, code size, "made with", download counts that never update, contributor-count vanity badges. Rule: IF a badge does not answer "does it work / is it maintained / can I use it" THEN drop it. IF a workflow was deleted THEN delete its badge.
3. **Installation section.** Order the methods: native package managers first (brew/apt/dnf/pkg), then language ecosystems, then binary releases, then a piped install LAST with a security note. Frame the piped install as `curl --proto '=https' --tlsv1.2 -fsSL https://example.com/install.sh` into `sh`, PLUS the oh-my-zsh "Manual Inspection" alternative (download, inspect, run) for the cautious. State what is verified (SHA256SUMS + how, signature key location -- mise's docs do exactly this). Document version pinning (`TOOL_VERSION=1.2.3` env pin) and link full release notes.
4. **Tone.** Write direct, second person, imperative ("Install with...", "Run..."). NEVER use marketing adjectives. IF the README exceeds 100 lines THEN add a TOC; use H2 per section, `sh`/`console` code fences with `$` prompts, collapsible `<details>` for long output. EVERY command MUST be copy-pasteable; EVERY claim MUST be verifiable (badges, links).

## FLAG on sight (FAIL)

- Wall of text before the first install command.
- "Features" marketing list with no quickstart.
- No uninstall docs.
- curl|bash as the ONLY install method with no security mention.
- `curl | sudo bash` (never).
