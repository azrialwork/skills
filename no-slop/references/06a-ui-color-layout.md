<!--
  06a-ui-color-layout.md -- Reference for no-slop.

  Covers: UI color/decoration and layout/component slop patterns.
  Load only when the task builds or edits an interface. A filter,
  not a style guide: direction comes from the brief or DESIGN.md.
-->

# UI slop -- color, decoration, layout

## The default gradient family

- **Tell:** blue-to-purple / purple-to-pink gradients, cyan-on-dark,
  glowing colored shadows, radial halo washes, gradient text on
  headings -- especially as the primary color treatment.
- **Why:** the most over-represented treatments in training data. They
  signal "no brand identity" and mark the design as AI-generated at a
  glance. The warm cream/beige page is the same tell in "tasteful"
  clothes.
- **Fix:** pull the palette from the product's own identity. Keep a
  gradient only as a hierarchy function with the reason written down.
  Text stays solid -- never gradient.
- **Rule:** P-05.

## Background texture defaults

- **Tell:** dot grids, blueprint lines, hairline grid overlays,
  repeating-gradient stripes used as page background.
- **Why:** a default way to make a flat page feel "technical" without
  doing any work. Texture without intent.
- **Fix:** texture only when it genuinely supports the product's
  identity, with the reason written down.
- **Rule:** P-05.

## Dose-cap violations (glass, glow, shadow, radius)

- **Tell:** blur/backdrop-filter on navbar + cards + modals at once;
  glow on every button and badge; large shadows on everything;
  every element pill-shaped.
- **Why:** when every surface is glass / glowing / floating, none is.
  Elevation, glow, and radius are hierarchy tools -- applied everywhere
  they communicate nothing.
- **Fix:** caps: glass on 1-2 elements, glow on 1-2 focus accents,
  shadow as elevation marker only, one deliberate radius scale.
- **Rule:** P-02.

## Dark mode default for no reason

- **Tell:** the whole page dark because it looks "tech", with no brand
  reason.
- **Why:** dark is a decision, not a default.
- **Fix:** choose the theme from brand, product type, and audience. If
  there is no strong reason for a fixed theme, build a working
  light/dark toggle.
- **Rule:** P-05.

## Palette discipline

- **Tell:** 5-7 colors with no system; one accent smeared across
  buttons, icons, badges, links, and glows at once.
- **Why:** a scattered palette has no hierarchy; an accent everywhere
  stops being an accent.
- **Fix:** cap at 2-3 core colors + 1 accent, the accent at the key
  moment only.
- **Rule:** P-02.

## The template landing page

- **Tell:** hero, subtitle, 2 CTAs, screenshot, feature grid,
  testimonials, FAQ, CTA, footer -- in that order, every time.
- **Why:** the order is the training-data default, not the product's
  narrative. Sections exist because the template has them.
- **Fix:** build structure around actual content needs. If the product
  has no testimonials, there is no testimonials section. Vary section
  composition deliberately.
- **Rule:** Q-02.

## Card uniformity and nesting

- **Tell:** identical feature cards (same size, icon tile, padding);
  cards nested inside cards; a thick colored side-tab stripe on cards.
- **Why:** uniform cards flatten content hierarchy; nesting adds
  visual noise; the side stripe is the single most recognizable
  AI-UI tell.
- **Fix:** vary card treatment by content weight -- the flagship
  feature may deserve full width, supporting ones a list. Flatten
  nesting into spacing and typography. A stripe must mark real state
  (active, warning) or go.
- **Rule:** Q-02.

## Bento grid by reflex

- **Tell:** a mosaic of differently-sized cards filling a section like
  a tiled dashboard, when the content has no real size variation.
- **Why:** the default "app-like" landing layout of recent years --
  a template, not a decision.
- **Fix:** use it only when the content genuinely has elements of
  different sizes to show. Otherwise a simple grid or list is more
  honest.
- **Rule:** Q-02.

## Uniform spacing and rhythm

- **Tell:** identical padding/margin/gap across every section; every
  section centered title + subtitle + identical card grid.
- **Why:** a single spacing value removes rhythm; identical
  composition makes sections blur together.
- **Fix:** establish a spacing scale and use different levels to
  separate and connect. Alternate text-heavy and visual sections.
- **Rule:** Q-02.

## The "How it works" 3-step and friends

- **Tell:** round icon + number 1-2-3 + short text, always three steps;
  "Trusted by" logo bar with generic logos; pricing as three columns
  with the middle one highlighted; 4-column template footer.
- **Why:** each is the default shape, which means none is a decision.
  The logo bar is a trust claim with no evidence; the pricing shape
  ignores the product's real tier structure.
- **Fix:** present the process as it actually is (two steps or five
  allowed); show only real, verifiable logos; use as many pricing
  tiers as the product really has and highlight the one that serves
  it; structure the footer around actual links.
- **Rule:** Q-02, H-01 (fake logos, invented tiers).
