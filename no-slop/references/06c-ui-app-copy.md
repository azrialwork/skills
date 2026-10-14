<!--
  06c-ui-app-copy.md -- Reference for no-slop.

  Covers: app/dashboard slop patterns, UI copy tells, honesty rules,
  and the UI checklist. Curated from miqdadbadjuber/anti-slop
  skills/antislop-ui (MIT) and the detector rules of
  pbakaus/impeccable (Apache-2.0) -- see SOURCES.md. Load only when
  the task builds or edits an interface.
-->

# UI slop -- app screens, UI copy, checklist

## The default dashboard shell

- **Tell:** left sidebar, top bar, four stat cards, a chart, a table --
  chosen before anyone asked what the screen is for, identical whether
  it manages invoices, patients, or servers.
- **Why:** a layout picked from memory instead of from the work the
  screen supports.
- **Fix:** name the screen's job and the one decision the user makes
  on it, then build the hierarchy around that. Cut sections that
  survive only because dashboards usually have them.
- **Rule:** Q-02.

## Invented numbers and filler content

- **Tell:** stat cards reading 12,483 / 94.2% / $48.2K with green
  "+12% this week" deltas on no data; activity feeds with invented
  people ("Sarah Chen updated a document"); charts titled "Overview"
  answering no question; form fields prefilled with "John Doe" /
  "johndoe@example.com".
- **Why:** the numbers are decoration and the deltas are worse -- a
  trend claim with no series behind it. Fabricated content disguised
  as real.
- **Fix:** show real numbers or none; a delta appears only when the
  comparison period is real and named. Empty cells stay empty or carry
  honest placeholders ("Your Name", "email@example.com"). Prototype
  values are labelled as placeholder where the user can see it.
- **Rule:** H-01.

## Broken and placeholder states

- **Tell:** `<img>` with empty or placeholder src; scripts throwing on
  load; content stuck at opacity 0 after reveals ran; text painted
  under overlapping elements; tooltips clipped by overflow hidden;
  one column stretching far past the fold while its sibling fits.
- **Why:** the visual shipped but the behavior did not -- the
  difference between a mockup and a product.
- **Fix:** real images or remove the tag; every interactive element
  has real behavior or a visible "Coming soon"; every nav item has a
  real destination.
- **Rule:** H-01.

## Empty, loading, and error states

- **Tell:** "No data available" with a stock illustration; a bare
  spinner; a skeleton mimicking a layout the data never fills.
- **Why:** technically present, telling the user nothing: no cause,
  no next action.
- **Fix:** an empty state says why it is empty and gives the one
  action that fills it ("No jobs yet. Run a sync to see results").
  A loading state says what it is loading; an error state says what
  failed and what to do next.
- **Rule:** Q-01.

## UI copy

Interface text follows the same H/P/Q rules as prose, with these
UI-specific tells:

- **Marketing buzzwords** ("streamline", "empower", "supercharge",
  "world-class", "cutting-edge") -- pick a specific verb and noun.
  (P-05)
- **Aphoristic cadence** ("Not a feature. A platform." repeated across
  sections) -- manufactured contrast, not voice. (Q-02)
- **Theater framing** ("security theater", "process theater") --
  say plainly what the thing does or does not do. (Q-01)
- **Em-dash saturation** in UI copy -- same H-02 rule as prose.

## Honesty

- **Dead navigation and non-functional controls:** every link has a
  destination; every button does something, or is removed, or carries
  a visible "Coming soon". (H-01)
- **Sections that fill a template:** every section earns its place
  from the product's content. (Q-01)
- **Sterile default:** flat white, thin grey borders, generic font, no
  identity. This is not slop, but it is not design either -- and it is
  a direction problem, not a filter problem. Add the brief or
  DESIGN.md; never fix it with more bans. (Liveliness bar)

## UI checklist

Run alongside the Delivery Gate (`references/03-self-audit.md`) when
the task is UI work. All answers must be **yes**:

- [ ] Palette from brand identity, not the default gradient set?
- [ ] Accent at the key moment only, not spread everywhere?
- [ ] Glass, glow, shadow, radius at dose caps, not page-wide?
- [ ] No decorative emoji in UI text; icons relevant or absent?
- [ ] Section compositions vary instead of repeating one template?
- [ ] No default AI shapes: bento-by-reflex, fake terminal, three
      pricing columns, meaningless left-edge stripes?
- [ ] Space above the H1 clear of pill badges restating the headline?
- [ ] Type from brand character; hierarchy real; contrast AA;
      no gradient text?
- [ ] Every nav item and control has a real destination/behavior,
      or a visible "Coming soon"?
- [ ] Motion has a written purpose and a trigger; no endless loops;
      no bounce easing?
- [ ] Dots and status lights mark real states only?
- [ ] App screens built around the user's decision, not the default
      shell?
- [ ] Every number, delta, feed entry, and table row real or labelled
      placeholder -- nothing invented?
- [ ] Empty/loading/error states name the cause and the next action?
- [ ] UI copy free of buzzwords, aphoristic cadence, theater framing?
- [ ] Holds up at every breakpoint, theme, and keyboard-only use?
