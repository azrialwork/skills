<!--
  03-topic-adapters.md -- Reference for research.

  Covers: what a topic adapter declares, how to build one, the default
  adapter for technical standards and tools, a blank template, and a
  worked sketch for product comparisons.
-->

# Topic adapters

The method is fixed; the topic is flexible. A topic adapter is a written declaration, made BEFORE collection starts, of three things for the task's domain:

1. **Source hierarchy** -- ordered tiers, strongest first, plus what is excluded outright.
2. **Verification rules** -- what counts as "verified" for this domain's typical claims (versions, dates, prices, legal status).
3. **Deliverable tweaks** -- what the default template (`07-deliverable-template.md`) needs for this domain.

## Build algorithm
> Why: An undeclared hierarchy lets the researcher cherry-pick whichever source agrees with the answer they already want.

INPUT: the domain phrase from the brief. OUTPUT: a one-page adapter.

1. Name the domain in one phrase.
2. List where authoritative answers live for this domain, ordered by how directly they speak for the subject. Tier 1 = speaks for its own subject; Tier 2 = primary data and official records; Tier 3 = reputable secondary sources, pointers only.
3. Name the exclusions: sources you will NEVER cite alone for an important claim.
4. Write the verification rule for the domain's most common time-sensitive claim (usually "what is the current version/status?").
5. Keep it to one page. An adapter is a page, not a thesis.

## Default adapter: technical standards and tools
> Why: A shared default stops each task from quietly redefining "authoritative" to fit the conclusion at hand.

USE WHEN the domain is specs, protocols, libraries, frameworks, dev tools, or platforms.

Hierarchy (strongest first):

- Tier 1 -- official documentation and specification repositories. Source of truth for their own subject.
- Tier 2 -- vendor engineering blogs, official changelogs, primary data (reproducible benchmarks, readable source code).
- Tier 3 -- reputable secondary sources: established analyst firms, long-running technical press, well-maintained community references. Pointers only, never truth.

NEVER use as sole sources: community mirrors and wikis; undated pages (for any currency claim); AI-generated content farms; marketing pages for factual claims about competitors.

Verification rule: IF a claim names a version, spec revision, or "current" status THEN re-check it against Tier 1 on the date anchor and stamp "verified as of <date>". Training-data memory is NEVER a verification.

## Blank adapter template

```markdown
## Adapter: <domain>

Hierarchy:
1. <tier 1 -- authoritative for this domain>
2. <tier 2>
3. <tier 3 -- pointers only>

Excluded as sole sources: <...>

Verification rule for time-sensitive claims: <...>

Deliverable tweaks: <...>
```

## Worked sketch: product comparison
> Why: A sketch copied blindly becomes a conclusion in search of evidence — the adapter must describe this domain, not the last one.

Domain: "team chat tools for a 20-person remote team".

1. Tier 1 -- the vendors' own pricing and feature pages (authoritative for their own offering) plus primary testing (trial accounts).
2. Tier 2 -- independent reviews with disclosed methodology, dated within 12 months.
3. Tier 3 -- user forums and social threads, labeled as anecdote.
   Excluded as sole sources: vendor marketing claims about competitors, undated "best of" listicles.
4. Verification rule: prices and plan limits re-checked on vendor pages at the date anchor; stamped per finding.
5. Deliverable tweak: comparison table up front, then per-tool notes.

IF the domain's reality differs from this sketch THEN rewrite the adapter and note why. Adapt; never adopt blindly.
