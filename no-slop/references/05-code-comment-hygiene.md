<!--
  05-code-comment-hygiene.md -- Reference for no-slop: hygiene for
  comments in AI-generated code. Load only when the task writes or
  edits code.
-->

# Code comment hygiene

AI-generated code ships with AI-generated comments: decorative,
obvious, stiff, loud. This module filters the comments; the code
stays exactly as it is.

## Scope guardrail

NEVER modify executable code, identifiers, imports, formatting,
indentation, whitespace, control flow, or logic -- comments only.
IF in doubt THEN leave the code untouched.

## Detection algorithm

INPUT: the code's comments.

1. Check each comment against the patterns below, in order.
2. IF a pattern matches THEN apply its THEN line; record the Rule ID.
3. IF the comment explains business logic, intent, architecture,
   security, performance trade-offs, concurrency, protocols, API
   contracts, workarounds, edge cases, assumptions, or licensing
   THEN NEVER remove it (see "Preserve these").
4. Re-run the checklist at the end.

## Comments that add nothing

### Decorative separators

- **Tell:** banner comments from repeated characters, ALL CAPS labels,
  box drawing: `// =======================` around `Authentication`,
  `// -------- WORKFLOW --------`, `/* ---- ROUTES ---- */`.
- **THEN:** replace with a single plain line, or remove entirely.
- **Rule:** Q-02.

### Restating the obvious

- **Tell:** a comment repeating what the next line already shows:
  `// Initialize the variable` above `let count = 0`;
  `// User class` above `class User {}`.
- **THEN:** remove the comment; leave the line of code alone.
- **Rule:** Q-01.

### Workflow narration

- **Tell:** step-by-step narration: `// Step 1: Validate input`,
  `// Step 2: Process request`; `// First...`, `// Next...`,
  `// Finally...`.
- **THEN:** remove. IF the flow is genuinely hard to follow THEN that is a structure problem, not a missing-comment problem.
- **Rule:** Q-01.

### Empty labels

- **Tell:** `// Main logic`, `// Core logic`, `// Helper function`,
  `// Entry point`, `// Note: This is important.`
- **THEN:** IF the label carries specific information ("Note: retries happen only on 5xx") THEN keep it; ELSE remove it.
- **Rule:** Q-05.

### Vague placeholders

- **Tell:** `// TODO: Improve this`, `// Future improvements`,
  `// Add more validation`.
- **THEN:** IF the TODO names a specific task with enough context to act on THEN keep it; ELSE remove or specify it.
- **Rule:** Q-05.

### Signature echo

- **Tell:** docs that only restate the signature: `@param price The
  price.` for a parameter already named `price`.
- **THEN:** simplify or remove the echo. Keep docs that explain business rules, edge cases, assumptions, algorithms, limitations, side effects, or security implications.
- **Rule:** Q-01.

### Decorative emoji and end markers

- **Tell:** `// ✅ Validation`, `// 🚀 Performance`;
  `} // end if`, `# End of function`.
- **THEN:** replace emoji with plain English or remove; remove end markers except where a very long file genuinely needs one.
- **Rule:** Q-04, Q-01.

## How it should read

### The over-explained comment

- **Tell:** several lines stacking reasons, context, and history
  around a fact that fits in one line.
- **THEN:** cut to the constraint alone: one line, two at most, never three. Keep the platform trap, the silent failure, the protocol rule; drop the issue number and the reasoning chain.
- **Rule:** Q-01.

### Line-by-line narration

- **Tell:** a comment on every trivial statement: `// Initialize
  count`, `// Loop items`, `// Get item`, `// Increment`.
- **THEN:** one concise comment per logical block; IF the block needs none THEN write none.
- **Rule:** Q-01.

### Stiff or loud wording

- **Tell:** "This function is responsible for validating whether the
  supplied credentials are valid"; `// MAIN LOGIC`.
- **THEN:** short, sentence-case, natural developer voice: `// Validate credentials before issuing a token.` Explain *why*, not *what*, and stay short.
- **Rule:** H-03.

## Preserve these -- never remove

A comment earns its place when it explains something the code does not
already show: the reason, the constraint, the non-obvious behavior.
Value is not length -- a workaround note is one line about the
workaround, not a paragraph about it.

## Code comment checklist

Run alongside the Delivery Gate (`references/03-self-audit.md`) when
the task touches comments. Verdict = PASS only when every answer is
**yes**:

- [ ] Does every comment add information the code does not show?
- [ ] No decorative separators, ALL CAPS banners, box-drawn headers?
- [ ] No restating the obvious line, declaration, or signature?
- [ ] No step-by-step workflow narration?
- [ ] No empty labels or vague TODOs that name no task?
- [ ] No decorative emoji or end markers?
- [ ] Comment density is one per logical block, not one per line?
- [ ] Every comment one line (two only when the second adds a fact)?
- [ ] Remaining comments read short, natural, sentence case?
- [ ] Scope guardrail held: only comments changed, code untouched?
