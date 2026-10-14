<!--
  06d-ui-direction.md -- Reference for no-slop.

  Covers: direction before building -- Design Read, product truth,
  art direction, real imagery, browser self-check. Load with the
  other 06 modules when the task builds an interface. The 06 modules
  filter slop; this one supplies the direction the filter cannot
  invent.
-->

# UI direction -- before building

A filter removes what should not be there; it cannot invent what
should. Run this once before any UI build, then apply the 06a-c
filters during the build.

## Design Read

One line, written before generating anything: read the brief as a
designer would and state what only this client has. Example: "A
neighborhood bakery's site: warm, flour-dusted, morning-light --
nothing SaaS."

If you cannot write the line, the brief is missing, not the filter.
Ask for the missing direction instead of generating from defaults.

## Product truth first

Before visual work, capture the durable facts once and reuse them:
who the audience is, what the product does, its constraints, and its
voice. Write them down (a `PRODUCT.md` or a few lines in the task);
later decisions check against this instead of re-deriving it.

Do not confuse product truth with visual direction. Truth is what the
product *is*; direction is how this surface *looks*. The filter needs
both, and neither substitutes for the other.

## Art direction

Pick one visual direction and commit to it for the whole surface:
brutalist, minimalist, editorial, soft/luxury, industrial -- named,
not "modern and clean".

Then write one sentence tying the client's own material to that
direction: "The bakery's morning prep photos carry the page; type
stays quiet so the crust can be loud." If the sentence could describe
any product, the direction is not chosen yet.

## Real imagery, credited

Use real photographs or footage, not generated placeholders. Open
collections (Wikimedia Commons, Openverse, museum archives) are
acceptable sources; put the credit on the page. Replace stock with
the client's own assets when they exist.

Never ship a fake screenshot, a fake terminal, or invented people as
stand-ins for the real product (see 06c honesty rules).

## Browser self-check

Check the built page in a real browser at three widths (desktop,
tablet, phone) and fail your own work against the 06a-c patterns
before delivering:

1. Screenshot each width.
2. List the top three slop problems you see.
3. Fix them, then repeat -- up to three rounds.

A build is done when a fresh look finds nothing from the checklists,
not when the code compiles.

## What this module does not do

It does not run a heavyweight art-direction pipeline (dedicated art
direction per brief, long visual-iteration builds). It captures the
mergeable essence: direction stated up front, real imagery, honest
self-review.
