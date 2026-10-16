<!--
  15-ui-color-layout.md -- Reference for no-slop.

  Covers: UI color/decoration and layout/component slop patterns.
  Load only when the task builds or edits an interface. A filter,
  not a style guide: direction comes from the brief or DESIGN.md.
-->

# UI slop -- color, decoration, layout

## Contents

- [Detection algorithm](#detection-algorithm)
- [The default gradient family](#the-default-gradient-family)
- [Background texture defaults](#background-texture-defaults)
- [Dose-cap violations (glass, glow, shadow, radius)](#dose-cap-violations-glass-glow-shadow-radius)
- [Dark mode default for no reason](#dark-mode-default-for-no-reason)
- [Palette discipline](#palette-discipline)
- [The template landing page](#the-template-landing-page)
- [Card uniformity and nesting](#card-uniformity-and-nesting)
- [Bento grid by reflex](#bento-grid-by-reflex)
- [Uniform spacing and rhythm](#uniform-spacing-and-rhythm)
- [The "How it works" 3-step and friends](#the-how-it-works-3-step-and-friends)

## Detection algorithm
> Why: UI slop is recognized by repetition across thousands of generated interfaces. The detector checks for defaults, not for ugliness.

INPUT: the interface (screenshot or code).

1. Check each element against the patterns below.
2. IF a pattern is observed THEN record a finding with pattern name and Rule ID, and apply the THEN line.
3. IF the element serves a documented hierarchy or brand function with the reason written down THEN keep it; ELSE apply the THEN line.

## The default gradient family
> Why: The most overused treatments are a confession. The interface announces it was generated before the user reads a single word.

- **Tell:** blue-to-purple / purple-to-pink gradients, cyan-on-dark,
  glowing colored shadows, radial halo washes, gradient text on
  headings -- especially as the primary color treatment.
- **Why:** the most over-represented treatments in training data. The warm cream/beige page is the same tell in "tasteful" clothes.
- **THEN:** pull the palette from the product's own identity. Keep a gradient only as a hierarchy function with the reason written down. Text stays solid -- never gradient.
- **Rule:** P-05.

## Background texture defaults
> Why: Texture without intent is set dressing. It makes a flat page feel technical while doing no work.

- **Tell:** dot grids, blueprint lines, hairline grid overlays,
  repeating-gradient stripes used as page background.
- **Why:** a default way to make a flat page feel "technical" without doing any work. Texture without intent.
- **THEN:** texture only when it genuinely supports the product's identity, with the reason written down.
- **Rule:** P-05.

## Dose-cap violations (glass, glow, shadow, radius)
> Why: When every surface glows, none does. Decoration applied everywhere communicates nothing.

- **Tell:** blur/backdrop-filter on navbar + cards + modals at once;
  glow on every button and badge; large shadows on everything;
  every element pill-shaped.
- **Why:** when every surface is glass / glowing / floating, none is. Applied everywhere they communicate nothing.
- **THEN:** enforce the caps: glass on 1-2 elements, glow on 1-2 focus accents, shadow as elevation marker only, one deliberate radius scale.
- **Rule:** P-02.

## Dark mode default for no reason
> Why: A theme chosen for looks instead of brand is a decision made by fashion. It will age like fashion too.

- **Tell:** the whole page dark because it looks "tech", with no brand
  reason.
- **THEN:** choose the theme from brand, product type, and audience. IF there is no strong reason for a fixed theme THEN build a working light/dark toggle.
- **Rule:** P-05.

## Palette discipline
> Why: An accent smeared everywhere stops being an accent. Hierarchy dies by dilution.

- **Tell:** 5-7 colors with no system; one accent smeared across
  buttons, icons, badges, links, and glows at once.
- **Why:** a scattered palette has no hierarchy; an accent everywhere stops being an accent.
- **THEN:** cap at 2-3 core colors + 1 accent, the accent at the key moment only.
- **Rule:** P-02.

## The template landing page
> Why: A structure copied from memory instead of content needs is a narrative the product never told.

- **Tell:** hero, subtitle, 2 CTAs, screenshot, feature grid,
  testimonials, FAQ, CTA, footer -- in that order, every time.
- **Why:** the order is the training-data default, not the product's narrative.
- **THEN:** build structure around actual content needs. IF the product has no testimonials THEN there is no testimonials section. Vary section composition deliberately.
- **Rule:** Q-02.

## Card uniformity and nesting
> Why: Uniform cards flatten content hierarchy. When everything has equal weight, nothing does.

- **Tell:** identical feature cards (same size, icon tile, padding);
  cards nested inside cards; a thick colored side-tab stripe on cards.
- **Why:** uniform cards flatten content hierarchy; nesting adds visual noise.
- **THEN:** vary card treatment by content weight -- the flagship feature may deserve full width, supporting ones a list. Flatten nesting into spacing and typography. A stripe must mark real state (active, warning) or go.
- **Rule:** Q-02.

## Bento grid by reflex
> Why: A mosaic for content with no size variation is complexity performing as design.

- **Tell:** a mosaic of differently-sized cards filling a section like
  a tiled dashboard, when the content has no real size variation.
- **THEN:** use it only when the content genuinely has elements of different sizes to show; otherwise a simple grid or list is more honest.
- **Rule:** Q-02.

## Uniform spacing and rhythm
> Why: One spacing value everywhere removes rhythm. Sections blur together and the page becomes a corridor.

- **Tell:** identical padding/margin/gap across every section; every
  section centered title + subtitle + identical card grid.
- **Why:** a single spacing value removes rhythm; identical composition makes sections blur together.
- **THEN:** establish a spacing scale and use different levels to separate and connect. Alternate text-heavy and visual sections.
- **Rule:** Q-02.

## The "How it works" 3-step and friends
> Why: Default shapes are decisions never made. Each one is a place where the product's actual story was skipped.

- **Tell:** round icon + number 1-2-3 + short text, always three steps;
  "Trusted by" logo bar with generic logos; pricing as three columns
  with the middle one highlighted; 4-column template footer.
- **Why:** each is the default shape, which means none is a decision. The logo bar is a trust claim with no evidence.
- **THEN:** present the process as it actually is (two steps or five allowed); show only real, verifiable logos; use as many pricing tiers as the product really has and highlight the one that serves it; structure the footer around actual links.
- **Rule:** Q-02, H-01 (fake logos, invented tiers).
