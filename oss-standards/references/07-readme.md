<!--
  07-readme.md -- Reference for oss-standards.

  Covers: README section order, badges, the installation section, and tone.
  Read when writing or reviewing a README.
-->

# README anatomy

## Section order (confirmed across ripgrep, fzf, starship, mise, eza)

1. Title + one-line pitch (what it is, in one sentence).
2. Badges (CI, release, license -- see below).
3. Demo / screenshot.
4. **Installation** -- package managers first, piped install documented but
   de-emphasized (see below).
5. Quickstart (the 3 commands to first success).
6. Usage / Features.
7. Configuration / Options.
8. FAQ / Troubleshooting.
9. Uninstall (professional completeness -- fzf documents it).
10. Contributing (link), License (SPDX identifier), Acknowledgments.

**Mandatory for a small CLI repo:** title + pitch + badges + installation
+ quickstart + usage + troubleshooting + license.

## Badges (via shields.io)

- Build status (GitHub Actions workflow), latest release version,
  license (SPDX identifier).
- OpenSSF Scorecard badge + Best Practices badge -- 2026 trust signals.
- **Noise badges** (never): commit activity, code size, "made with",
  download counts that never update, contributor-count vanity badges.
- Rule: if a badge does not answer "does it work / is it maintained /
  can I use it", drop it. Delete badges for deleted workflows.

## Installation section

- **Order:** native package managers first (brew/apt/dnf/pkg), then
  language ecosystems, then binary releases, then a piped install **last**
  with a security note.
- **Piped-install framing:**
  `curl --proto '=https' --tlsv1.2 -fsSL https://example.com/install.sh`
  piped into `sh`, plus the oh-my-zsh "Manual Inspection" alternative
  (download, inspect, run) for the cautious.
- **Security framing:** state what is verified (SHA256SUMS + how,
  signature key location) -- mise's docs do exactly this.
- **Version pinning:** document `TOOL_VERSION=1.2.3` env pin and link
  full release notes.

## Tone

- Direct, second person, imperative ("Install with...", "Run...").
  No marketing adjectives.
- TOC for READMEs over 100 lines; H2 per section; `sh`/`console` code
  fences with `$` prompts; collapsible `<details>` for long output.
- Every command copy-pasteable; every claim verifiable (badges, links).

## Anti-patterns

- Wall of text before the first install command.
- "Features" marketing list with no quickstart.
- No uninstall docs.
- curl|bash as the ONLY install method with no security mention.
- `curl | sudo bash` (never).
