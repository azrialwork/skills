<!--
  16-ui-type-motion.md -- Reference for no-slop.

  Covers: UI typography, icons/decoration, and motion slop patterns.
  Load only when the task builds or edits an interface.
-->

# UI slop -- typography, icons, motion

## Detection algorithm

INPUT: the interface (screenshot or code).

1. Check type, icons, and motion against the patterns below.
2. IF a pattern is observed THEN record a finding with pattern name and Rule ID, and apply the THEN line.
3. Legibility failures (second entry) are absolute: fix regardless of aesthetic intent.

## The default type roster

- **Tell:** Inter / Geist / Space Grotesk for everything because they
  were the default; oversized italic serif hero headlines; large
  monospace headings as pure aesthetic; uppercase labels with extreme
  letter-spacing ("HOW IT WORKS").
- **Why:** each new wave of AI UIs converges on the same handful of faces.
- **THEN:** choose type from brand character with a written reason. None of these faces is banned; each is valid with a reason.
- **Rule:** P-05.

## Hierarchy and legibility failures

- **Tell:** heading and body separated by less than 1.25x at every
  step (flat hierarchy); gray text on colored backgrounds; body text
  under 14px, functional UI text under 11px; line length past ~80
  characters; line height under 1.3x; justified text with rivers;
  text touching the viewport edge; cramped padding; all-caps body
  copy; skipped heading levels (h1 then h3).
- **Why:** these are not style choices -- they are legibility and accessibility failures.
- **THEN:** add at least one stronger size step; use a darker shade of the background color or white for contrast; keep headings bound to the content they introduce (more space above than below). Text MUST meet WCAG AA contrast (4.5:1 body, 3:1 large).
- **Rule:** Q-01.

## Typography as decoration

- **Tell:** gradient text; crushed letter-spacing; wide tracking on
  body copy; tiny numbered labels as editorial scaffolding.
- **THEN:** solid colors for text; tighten display type optically, not destructively; reserve wide tracking for short uppercase labels.
- **Rule:** P-02.

## Icons and small decoration

- **Tell:** sparkle / magic-wand / lightning / robot-orb as feature
  icons; every icon from one thin-stroke library so all sites share
  the look; literal emoji in headings, bullets, buttons; `->` on
  every button; thin colored left-edge stripes with no meaning;
  "AI Powered" capsule pills with glow and dot.
- **Why:** the generic vocabulary of "AI product".
- **THEN:** icons relevant to the content, or none; arrows only where a direction cue genuinely helps; stripes and dots only marking real state; emoji out of UI text entirely.
- **Rule:** Q-04, Q-01.

## Eyebrow badges and kickers

- **Tell:** a small pill or tracked-uppercase kicker sitting directly
  above the headline, holding a label the headline already says
  ("The platform for teams"); tiny numbered section labels
  ("01", "02") riding beside headings.
- **Why:** the badge duplicates the headline -- a line of reading without a fact.
- **THEN:** cut it and let the headline do the work, or fold the label into the headline/subheadline.
- **Rule:** Q-01.

## Decorative status dots and cursors

- **Tell:** a glowing, endlessly pulsing dot beside a heading that
  marks nothing; a blinking text cursor animated into a hero where no
  input exists.
- **Why:** borrows system-status vocabulary as decoration.
- **THEN:** a dot must mark a real state (live, recording, warning): one dot, no glow, no endless pulse. Otherwise remove it.
- **Rule:** Q-01.

## Fake terminal window

- **Tell:** a styled terminal with traffic-light dots and typed-out
  commands used as the hero visual for a product that is not a CLI.
- **Why:** a placeholder for a real screenshot.
- **THEN:** show the actual product UI, or a real working screenshot.
- **Rule:** H-01.

## Illustrations with no connection

- **Tell:** generic blob characters, shape-assembled SVG scenes,
  stock illustrations unrelated to the product; raster images buried
  under near-opaque gradient washes.
- **Why:** decoration, not design.
- **THEN:** illustrations must connect to the product directly, or use real screenshots, or nothing.
- **Rule:** Q-01.

## Motion

- **Tell:** elements pulsing, bouncing, or floating forever with no
  user trigger; every element running fade-up + float + scale at once;
  bounce/elastic easing; auto-scrolling marquees.
- **Why:** perpetual motion is noise -- it competes with content and never lets the user rest.
- **THEN:** motion needs a written UX purpose and a trigger. The hero speaks; supporting elements stay calm. Prefer exponential easing (ease-out-quart and family).
- **Rule:** P-05.
