<!--
  05-code-comment-hygiene.md -- Reference for no-slop: hygiene for
  comments in AI-generated code. Adapted from miqdadbadjuber/anti-slop
  skills/antislop-code (MIT) -- see SOURCES.md. Load only when the task
  writes or edits code.
-->

# Code comment hygiene

AI-generated code ships with AI-generated comments: decorative,
obvious, stiff, loud. This module filters the comments; the code
stays exactly as it is.

## Scope guardrail

This module only modifies **comments**. Never modify executable code, identifiers, imports, formatting, indentation, whitespace, control flow, or logic. When in doubt, leave the code untouched.

## Comments that add nothing

### Decorative separators

- **Tell:** banner comments from repeated characters, ALL CAPS labels,
  box drawing: `// =======================` around `Authentication`,
  `// -------- WORKFLOW --------`, `/* ---- ROUTES ---- */`.
- **Why:** the decoration is the message. A label wrapped in `=` or `-`
  signals "AI made this" without adding information; ALL CAPS reads
  as shouting.
- **Fix:** replace with a single plain line, or remove entirely.
- **Rule:** Q-02.

### Restating the obvious

- **Tell:** a comment repeating what the next line already shows:
  `// Initialize the variable` above `let count = 0`;
  `// User class` above `class User {}`.
- **Why:** doubles the reading load without adding anything.
- **Fix:** remove and leave the line of code alone.
- **Rule:** Q-01.

### Workflow narration

- **Tell:** step-by-step narration: `// Step 1: Validate input`,
  `// Step 2: Process request`; `// First...`, `// Next...`,
  `// Finally...`.
- **Why:** the control flow is visible in the code. Numbering it reads
  as a checklist, not an explanation. If the flow is genuinely hard to
  follow, that is a structure problem, not a missing-comment problem.
- **Fix:** remove.
- **Rule:** Q-01.

### Empty labels

- **Tell:** `// Main logic`, `// Core logic`, `// Helper function`,
  `// Entry point`, `// Note: This is important.`
- **Why:** the label names a category, not a fact. "Note: retries
  happen only on 5xx" earns its place; "Note: this is important"
  does not.
- **Fix:** remove unless the label carries specific information.
- **Rule:** Q-05.

### Vague placeholders

- **Tell:** `// TODO: Improve this`, `// Future improvements`,
  `// Add more validation`.
- **Why:** a vague TODO names a feeling instead of a task. Keep a TODO
  only when it names a specific task with enough context to act on.
- **Fix:** remove or specify.
- **Rule:** Q-05.

### Signature echo

- **Tell:** docs that only restate the signature: `@param price The
  price.` for a parameter already named `price`.
- **Why:** adds length, not understanding.
- **Fix:** simplify or remove the echo. Keep docs that explain business
  rules, edge cases, assumptions, algorithms, limitations, side
  effects, or security implications.
- **Rule:** Q-01.

### Decorative emoji and end markers

- **Tell:** `// ✅ Validation`, `// 🚀 Performance`;
  `} // end if`, `# End of function`.
- **Why:** emoji is visual noise in code (and the ✅/🚀/🔒 set is the AI
  default vocabulary); the closing brace already ends the block.
- **Fix:** replace emoji with plain English or remove; remove end
  markers except where a very long file genuinely needs one.
- **Rule:** Q-04, Q-01.

## How it should read

### The over-explained comment

- **Tell:** several lines stacking reasons, context, and history
  around a fact that fits in one line.
- **Why:** a person leaves a note; a generator writes a case. Padding
  buries the one line that matters.
- **Fix:** cut to the constraint alone: one line, two at most, never
  three. Keep the platform trap, the silent failure, the protocol
  rule; drop the issue number and the reasoning chain.
- **Rule:** Q-01.

### Line-by-line narration

- **Tell:** a comment on every trivial statement: `// Initialize
  count`, `// Loop items`, `// Get item`, `// Increment`.
- **Why:** when every line is commented, none of the comments matter.
- **Fix:** one concise comment per logical block; if the block needs
  none, write none.
- **Rule:** Q-01.

### Stiff or loud wording

- **Tell:** "This function is responsible for validating whether the
  supplied credentials are valid"; `// MAIN LOGIC`.
- **Why:** formal and loud reads as generated, not as an engineer
  leaving a note.
- **Fix:** short, sentence-case, natural developer voice:
  `// Validate credentials before issuing a token.` Explain *why*,
  not *what*, and stay short.
- **Rule:** H-03.

## Not a ban -- preserve these

Never remove comments that explain: business logic and intent,
architectural decisions, security considerations, performance
trade-offs, concurrency behavior, protocol details, API contracts,
workarounds, edge cases and assumptions, licensing and legal notices.

A comment earns its place when it explains something the code does not
already show: the reason, the constraint, the non-obvious behavior.
Value is not length -- a workaround note is one line about the
workaround, not a paragraph about it.

## Code comment checklist

Run alongside the Delivery Gate (`references/03-self-audit.md`) when
the task touches comments. All answers must be **yes**:

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
