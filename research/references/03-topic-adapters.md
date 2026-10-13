<!--
  03-topic-adapters.md -- Reference for research.

  Covers: what a topic adapter declares, how to build one, the default
  adapter for technical standards and tools, a blank template, and a
  worked sketch for product comparisons.
-->

# Topic adapters

The method is fixed; the topic is flexible. A topic adapter declares,
*in writing, before collection starts*, three things for the task's
domain:

1. **Source hierarchy** -- ordered tiers, strongest first, plus what is
   excluded outright.
2. **Verification rules** -- what counts as "verified" for this domain's
   typical claims (versions, dates, prices, legal status...).
3. **Deliverable tweaks** -- anything the default template
   (`07-deliverable-template.md`) needs for this domain.

## How to build one

1. Name the domain in one phrase.
2. List where authoritative answers live for this domain. Order them by
   how directly they speak for the subject.
3. Name what is excluded: sources you will not cite alone for an
   important claim.
4. Write the verification rule for the domain's most common
   time-sensitive claim (usually "what is the current version/status?").
5. Keep it short -- an adapter is a page, not a thesis.

## Default adapter: technical standards and tools

Use for: specs, protocols, libraries, frameworks, dev tools, platforms.

**Hierarchy (strongest first):**

- Tier 1 -- the official documentation and specification repositories.
  These are the source of truth for their own subject.
- Tier 2 -- vendor engineering blogs, official changelogs, primary
  data (benchmarks you can reproduce, source code you can read).
- Tier 3 -- reputable secondary sources: established analyst firms,
  long-running technical press, well-maintained community references
  *used as pointers, not as truth*.
- Excluded as sole sources: community mirrors and wikis, undated
  pages (for any currency claim), AI-generated content farms,
  marketing pages for factual claims about competitors.

**Verification rule:** version numbers, spec revisions, and "current"
status are re-checked against Tier 1 on the date anchor and stamped
"verified as of <date>". Training-data memory is never a verification.

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

Domain: "team chat tools for a 20-person remote team".

1. Tier 1 -- the vendors' own pricing and feature pages (authoritative
   for their own offering) plus primary testing (trial accounts).
2. Tier 2 -- independent reviews with disclosed methodology, dated
   within 12 months.
3. Tier 3 -- user forums and social threads, labeled as anecdote.
   Excluded as sole sources: vendor marketing claims about
   competitors, undated "best of" listicles.
4. Verification rule: prices and plan limits re-checked on vendor
   pages at the date anchor; stamped per finding.
5. Deliverable tweak: comparison table up front, then per-tool notes.

Adapt, do not adopt blindly: if the domain's reality differs, rewrite
the adapter and note why.
