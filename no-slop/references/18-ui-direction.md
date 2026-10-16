<!--
  18-ui-direction.md -- Reference for no-slop.

  Covers: direction before building -- Design Read, product truth,
  art direction, real imagery, browser self-check. Load with the
  other UI modules (15-17) when the task builds an interface. The UI
  modules (15-17) filter slop; this one supplies the direction the
  filter cannot invent.
-->

# UI direction -- before building

A filter removes what should not be there; it cannot invent what
should. Run this once before any UI build, then apply the 15-17
filters during the build.

## Direction algorithm
> Why: Direction must come before building because a filter can only remove. It cannot invent what was never decided.

INPUT: the brief (and DESIGN.md if it exists).

1. Write the Design Read line (below). IF you cannot write it THEN the brief is missing direction: STOP and ask for it instead of generating from defaults.
2. Capture product truth once; write it down. Later decisions check against it instead of re-deriving it.
3. Pick one art direction and commit for the whole surface.
4. Use real, credited imagery only.
5. After building, run the browser self-check below. Verdict = done only when a fresh look finds nothing from the 15-17 checklists.

## Design Read
> Why: One line of direction, written first, is the cheapest decision in the whole build. Everything after it gets easier.

Write one line before generating anything: read the brief as a
designer would and state what only this client has. Example: "A
neighborhood bakery's site: warm, flour-dusted, morning-light --
nothing SaaS."

## Product truth first
> Why: Truth and direction are different jobs. Confusing them produces a beautiful surface for a product that does not exist.

Capture the durable facts once and reuse them: who the audience is,
what the product does, its constraints, and its voice. Write them
down (a `PRODUCT.md` or a few lines in the task).

NEVER confuse product truth with visual direction. Truth is what the
product *is*; direction is how this surface *looks*. The filter needs
both, and neither substitutes for the other.

## Art direction
> Why: Committing to one direction is what makes choices cohere. 'modern and clean' commits to nothing and coheres with everything.

Pick one visual direction and commit to it for the whole surface:
brutalist, minimalist, editorial, soft/luxury, industrial -- named,
not "modern and clean".

THEN write one sentence tying the client's own material to that
direction: "The bakery's morning prep photos carry the page; type
stays quiet so the crust can be loud." IF the sentence could describe
any product THEN the direction is not chosen yet: pick again.

## Real imagery, credited
> Why: Real, credited imagery is respect, for the subject, the source, and the user who can tell the difference.

Use real photographs or footage, not generated placeholders. Open
collections (Wikimedia Commons, Openverse, museum archives) are
acceptable sources; put the credit on the page. Replace stock with
the client's own assets when they exist.

NEVER ship a fake screenshot, a fake terminal, or invented people as
stand-ins for the real product (see 17 honesty rules).

## Browser self-check
> Why: A fresh look in a real browser is the only honest test. The builder's eye is compromised by having built it.

Check the built page in a real browser at three widths (desktop,
tablet, phone) and fail your own work against the 15-17 patterns
before delivering:

1. Screenshot each width.
2. List the top three slop problems you see.
3. Fix them, then repeat -- up to three rounds.

A build is done when a fresh look finds nothing from the checklists,
not when the code compiles.

## What this module does not do
> Why: Stating the boundary keeps the module honest. It does direction, not a pipeline, and pretending otherwise would be its own kind of slop.

It does not run a heavyweight art-direction pipeline (dedicated art
direction per brief, long visual-iteration builds). It captures the
mergeable essence: direction stated up front, real imagery, honest
self-review.
