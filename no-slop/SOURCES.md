<!--
  SOURCES.md -- Attribution for third-party material adapted into no-slop.

  All sources below are permissively licensed (MIT or Apache-2.0) and
  permit adaptation with attribution. Versions are pinned to the commit
  reviewed on 2026-10-14. This file, not the pattern text, is where
  provenance lives: pattern entries cite it instead of repeating URLs.
-->

# Sources

Pattern taxonomies and mechanisms in this skill adapt the following
third-party agent skills. Nothing is copied verbatim at length; each
entry was curated, rewritten in no-slop's voice, and mapped onto the
H/P/Q tier system.

| Source | Pinned version | License | What was adapted |
|---|---|---|---|
| [blader/humanizer](https://github.com/blader/humanizer) | `225a6f3` (2026-10-14) | MIT | 26-pattern taxonomy (staging, rhythm-by-rule, inflation, formatting, leftovers, wrong-reader); strength ordering; voice-sample matching; show-its-work workflow; "when not to act" carve-outs. Into 01a/01b and SKILL.md editing principles. |
| [conorbronsdon/avoid-ai-writing](https://github.com/conorbronsdon/avoid-ai-writing) | `2dc826f` (2026-10-14) | MIT | Tiered vocabulary system (Tier 1A frequency markers, 1B clarity edits, Tier 2 cluster rule, Tier 3 density); structural patterns (hedge-stacking, -ing riders, placeholders, AI-tool fingerprints, scenario openers). Into `assets/slop-phrases.txt`, `scripts/slop-scan.sh` (@cluster mode, new density groups), 01a/01b. |
| [petergyang/no-ai-slop](https://github.com/petergyang/no-ai-slop) | `000650b` (2026-10-14) | MIT | Minimum-effective-edit philosophy; voice preservation; portability test; detect-vs-edit modes. Into 01b and SKILL.md editing principles. |
| [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | `8da1f03` (2026-10-14) | MIT | Structural patterns (false agency, narrator-from-a-distance, Wh- openers, lazy extremes, negative listing). Into 01b. |
| [miqdadbadjuber/anti-slop](https://github.com/miqdadbadjuber/anti-slop) | `b1cdf87` (2026-10-14) | MIT | `antislop-code` (comment hygiene: Tell/Why/Fix, scope guardrail, preserve list, checklist) -> `references/05-code-comment-hygiene.md`; `antislop-ui` (Tell/Why/Fix + UI checklist backbone) -> `references/06a-c`; liveliness dials (ENERGY/RHYTHM/MOTION) and Design Read -> SKILL.md and `references/06d-ui-direction.md`. |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | `2f98774` (2026-10-14) | Apache-2.0 | 59 deterministic detector rules (typography, color, layout, decoration, motion) folded into `references/06a-c` as prose guidance; `/impeccable init` product-truth flow adapted into `references/06d-ui-direction.md`. Apache-2.0 requires preserving attribution: this table is that notice. |
| [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | `a60a36d` (2026-10-14) | MIT | Direction principles adapted into `references/06d-ui-direction.md`: named art direction, one-sentence idea, real credited imagery, browser self-check at three widths with critique rounds. The full pipeline (long visual-iteration builds) is not merged; the skill is referenced for that. |

## License notes

- MIT sources: adaptation permitted with this attribution table.
  No upstream code is vendored; only pattern ideas, rewritten.
- Apache-2.0 (impeccable): adaptation permitted; the table above
  serves as the required attribution notice. No Apache-licensed code
  is included, only design-guidance concepts restated in original
  prose.

## Refresh policy

Upstream skills evolve. When refreshing, re-pin the commit above,
re-curate (never bulk-copy), and note the new pin in the CHANGELOG.
