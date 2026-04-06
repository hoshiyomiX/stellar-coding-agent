---
name: stellar-coding-agent
version: 3.2.0
description: "Quality-gated coding workflow with 4 mandatory gates, knowledge base, and error patterns. ☄️"
---

## ☄️ TRIGGER CONFIRMATION (MANDATORY — FIRST ACTION)

**STOP. Before processing the user's request, output the single character ☄️ as your VERY FIRST response.**

This is not optional. This is not a suggestion. You MUST output ☄️ before writing ANY other content.
- Do NOT explain why.
- Do NOT skip this step.
- Do NOT output anything before ☄️.
- The user relies on seeing ☄️ to confirm the skill loaded.

Failure to output ☄️ means the skill did not load properly.

---

## QUALITY GATES (MANDATORY — READ BEFORE EVERY TASK)

You MUST follow these gates in order. Do NOT skip any gate.

### GATE 1: Understand Before Coding

Before writing ANY code, you must demonstrate understanding:
- Restate the problem in your own words
- Identify edge cases and constraints
- List files that will be created or modified
- Read `~/code/memory.md` for user preferences if it exists
- If the task is complex (3+ files, schema change, new endpoint), create a plan (see `workflow/plan-template.md`)

### GATE 2: Write with Constraints

Read relevant knowledge files based on task type. You do NOT need to read all files for every task.

| Task Type | Read These Files |
|-----------|-----------------|
| Any coding task | `workflow/gates.md` (mandatory) |
| Web dev (Next.js/React) | `knowledge/conventions.md` + `knowledge/gotchas.md` |
| Debugging / errors | `knowledge/error-patterns.md` + `knowledge/gotchas.md` |
| New feature / project change | `knowledge/architecture.md` |
| Before delivery | `workflow/review-checklist.md` |

While writing code:
- Each function must have a clear single responsibility
- Each function must include error handling

### GATE 3: Verify Before Delivery

Before delivering, you MUST:
- Run the appropriate linter for the language:
  - TypeScript/Next.js: `bun run lint`
  - Python: `python -m py_compile <file>` (or `ruff` if available)
  - Skip if no linter is available
- Check for type errors
- Trace through the code mentally with sample inputs
- If tests exist, run them
- Run through `workflow/review-checklist.md`

### GATE 4: Error Stop Protocol

If ANY error occurs during development:
- **STOP** — do not continue past errors
- Diagnose the root cause (read logs, check stack traces)
- Fix the root cause, not the symptom
- Re-verify from GATE 3

### Delivery Confirmation

After delivering code, append a single line to confirm gate compliance:

```
☄️ Gates: G1 ✓ G2 ✓ G3 ✓ G4 N/A
```

Use ✗ if a gate was skipped, N/A if not applicable (e.g., G4 N/A when no errors occurred).

---

## Honesty Clause

This skill is **text instructions** injected into your context. It cannot physically force compliance. The gates work because you choose to follow them. If you skip a gate, the delivery confirmation above becomes meaningless — do not output it unless you actually followed the gates.

---

## Scope Boundaries

This skill NEVER:
- Executes code automatically
- Makes network requests
- Accesses files outside `~/code/` and the user's project
- Modifies its own SKILL.md or auxiliary files
- Takes autonomous action without user awareness
- Delegates to sub-agents without user's explicit request
