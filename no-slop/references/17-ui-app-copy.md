<!--
  17-ui-app-copy.md -- Reference for no-slop.

  Covers: app/dashboard slop patterns, UI copy tells, accessibility
  floor, honesty rules, and the UI checklist. Load only when the task
  builds or edits an interface.
-->

# UI slop -- app screens, UI copy, checklist

## Contents

- [Detection algorithm](#detection-algorithm)
- [The default dashboard shell](#the-default-dashboard-shell)
- [Invented numbers and filler content](#invented-numbers-and-filler-content)
- [Broken and placeholder states](#broken-and-placeholder-states)
- [Empty, loading, and error states](#empty-loading-and-error-states)
- [Accessibility floor](#accessibility-floor)
- [UI copy](#ui-copy)
- [Honesty](#honesty)
- [UI checklist](#ui-checklist)

## Detection algorithm
> Why: App screens and copy are judged together because a dashboard can be structurally clean and still lie with its numbers.

INPUT: the app screens and UI copy.

1. Check screens against the patterns below; check copy against the UI-copy tells.
2. IF a pattern is observed THEN record a finding with pattern name and Rule ID, and apply the THEN line.
3. Run the accessibility floor and the UI checklist at the end. Verdict = PASS only when every check passes.

## The default dashboard shell
> Why: A layout picked from memory instead of from the user's decision builds the wrong hierarchy with great confidence.

- **Tell:** left sidebar, top bar, four stat cards, a chart, a table --
  chosen before anyone asked what the screen is for, identical whether
  it manages invoices, patients, or servers.
- **Why:** a layout picked from memory instead of from the work the screen supports.
- **THEN:** name the screen's job and the one decision the user makes on it, then build the hierarchy around that. Cut sections that survive only because dashboards usually have them.
- **Rule:** Q-02.

## Invented numbers and filler content
> Why: A trend line with no series behind it is a lie with a chart, decoration that actively misleads.

- **Tell:** stat cards reading 12,483 / 94.2% / $48.2K with green
  "+12% this week" deltas on no data; activity feeds with invented
  people ("Sarah Chen updated a document"); charts titled "Overview"
  answering no question; form fields prefilled with "John Doe" /
  "johndoe@example.com".
- **Why:** the numbers are decoration and the deltas are worse -- a trend claim with no series behind it.
- **THEN:** show real numbers or none; a delta appears only when the comparison period is real and named. Empty cells stay empty or carry honest placeholders ("Your Name", "email@example.com"). Prototype values are labelled as placeholder where the user can see it.
- **Rule:** H-01.

## Broken and placeholder states
> Why: The visual shipped but the behavior did not. The interface promises what the code cannot deliver.

- **Tell:** `<img>` with empty or placeholder src; scripts throwing on
  load; content stuck at opacity 0 after reveals ran; text painted
  under overlapping elements; tooltips clipped by overflow hidden;
  one column stretching far past the fold while its sibling fits.
- **Why:** the visual shipped but the behavior did not.
- **THEN:** real images or remove the tag; every interactive element has real behavior or a visible "Coming soon"; every nav item has a real destination.
- **Rule:** H-01.

## Empty, loading, and error states
> Why: A state that names no cause and no action abandons the user at the exact moment they need guidance.

- **Tell:** "No data available" with a stock illustration; a bare
  spinner; a skeleton mimicking a layout the data never fills.
- **Why:** technically present, telling the user nothing: no cause, no next action.
- **THEN:** an empty state says why it is empty and gives the one action that fills it ("No jobs yet. Run a sync to see results"). A loading state says what it is loading; an error state says what failed and what to do next.
- **Rule:** Q-01.

## Accessibility floor
> Why: Shipped-but-broken excludes people. Accessibility is the floor because below it the interface simply does not work for everyone.

Shipped-but-broken is slop. Check at every breakpoint; every item is PASS/FAIL:

- **Keyboard:** IF an interactive element is not reachable and operable by keyboard THEN FAIL. Every one needs a visible focus state.
- **Semantics:** IF a button, link, input, or landmark is a div with a click handler THEN FAIL. Use real elements.
- **Contrast and text:** body text MUST meet WCAG AA (4.5:1, 3:1 large); IF information is carried by color alone THEN FAIL.
- **Motion:** IF `prefers-reduced-motion` is not honored THEN FAIL: endless or large animations switch off when the user asks.
- **Touch and small screens:** touch targets MUST be at least 44px; IF horizontal scrolling occurs on phones THEN FAIL; the layout is re-thought per breakpoint, not the desktop version shrunk.
- **Rule:** Q-01 (broken), H-01 (fake controls).

## UI copy
> Why: Interface text is read in fragments under time pressure. Buzzwords there cost comprehension, not just style points.

Interface text follows the same H/P/Q rules as prose, with these UI-specific tells:

- **Marketing buzzwords** ("streamline", "empower", "supercharge", "world-class", "cutting-edge") -- **THEN:** pick a specific verb and noun. (P-05)
- **Aphoristic cadence** ("Not a feature. A platform." repeated across sections) -- **THEN:** cut it; manufactured contrast is not voice. (Q-02)
- **Theater framing** ("security theater", "process theater") -- **THEN:** say plainly what the thing does or does not do. (Q-01)
- **Em-dash saturation** in UI copy -- same H-02 rule as prose: **THEN:** remove every em dash.

## Honesty
> Why: A dead link or fake control is a small betrayal. Each one teaches the user to trust the product a little less.

- **Dead navigation and non-functional controls:** every link has a destination; every button does something, or is removed, or carries a visible "Coming soon". (H-01)
- **Sections that fill a template:** every section earns its place from the product's content. (Q-01)
- **Sterile default:** flat white, thin grey borders, generic font, no identity. This is not slop, but it is not design either -- and it is a direction problem, not a filter problem. **THEN:** add the brief or DESIGN.md; NEVER fix it with more bans. (Liveliness bar)

## UI checklist
> Why: The checklist is the last line before the user. It exists because no single pattern catches a dishonest screen.

Run alongside the Delivery Gate (`references/09-self-audit.md`) when
the task is UI work. Verdict = PASS only when every answer is **yes**:

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
