---
name: coding-suisei
version: 3.1.0
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

## What Is This (Honest Description)

This is a **coding workflow standard** — a set of quality constraints injected into the LLM context when invoked. It is not an autonomous agent. It cannot execute code, make independent decisions, or persist memory on its own.

What it DOES: forces the LLM to follow structured quality gates, load project knowledge, and avoid common mistakes.
What it does NOT: execute code autonomously, access external services, modify its own files.

---

## QUALITY GATES (MANDATORY — READ BEFORE EVERY TASK)

You MUST follow these gates in order. Do NOT skip any gate.

### GATE 1: Understand Before Coding

Before writing ANY code, you must demonstrate understanding:
- Restate the problem in your own words
- Identify edge cases and constraints
- List files that will be created or modified
- If the task is complex, create a plan (see `workflow/plan-template.md`)

### GATE 2: Write with Constraints

While writing code, you MUST follow:
- Read `workflow/gates.md` for mandatory coding constraints
- Read `knowledge/conventions.md` for platform-specific conventions (state management, styling, component patterns)
- Read `knowledge/gotchas.md` for sandbox-specific quirks (localhost, XTransformPort, single route)
- Read `knowledge/error-patterns.md` for debugging known errors
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
- Read `workflow/review-checklist.md` for the full review checklist

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

## Reference Files

### Knowledge Base

| File | When to Read |
|------|-------------|
| `knowledge/architecture.md` | Starting a new feature or modifying project structure |
| `knowledge/conventions.md` | Writing code — state management, styling, component patterns |
| `knowledge/gotchas.md` | Working with sandbox environment or platform APIs |
| `knowledge/error-patterns.md` | Debugging errors or unexpected behavior |

### Workflow Templates

| File | When to Use |
|------|-------------|
| `workflow/gates.md` | Every coding task (mandatory constraints) |
| `workflow/plan-template.md` | Complex tasks requiring step-by-step planning |
| `workflow/review-checklist.md` | Before delivering any code |

### Support Files

| File | Purpose |
|------|---------|
| `memory-template.md` | Template for `~/code/memory.md` |
| `state.md` | Multi-task request tracking |
| `criteria.md` | When to save/never save user preferences |

---

## Architecture

User preferences stored in `~/code/` when user explicitly requests.

```
~/code/
  - memory.md    # User-provided preferences only
```

Create on first use: `mkdir -p ~/code`

---

## Core Rules

### 1. Check Memory First
Read `~/code/memory.md` for user's stated preferences if it exists.

### 2. User Controls Execution
- This skill provides GUIDANCE and CONSTRAINTS, not autonomous execution
- User decides when to proceed to next step
- Sub-agent delegation requires user's explicit request

### 3. Follow the Gates (GATE 1 → 2 → 3 → 4)
Never skip a gate. Never rush to code without understanding.

### 4. Store Preferences on Request
| User says | Action |
|-----------|--------|
| "Remember I prefer X" | Add to memory.md |
| "Never do Y again" | Add to memory.md Never section |

Only store what user explicitly asks to save.

### 5. Scope Boundaries
This skill NEVER:
- Executes code automatically
- Makes network requests
- Accesses files outside `~/code/` and the user's project
- Modifies its own SKILL.md or auxiliary files
- Takes autonomous action without user awareness
- Delegates to sub-agents without user's explicit request
