---
name: coding-suisei
version: 3.0.0
description: "Advanced coding workflow for software development tasks. Use when: writing code, building features, debugging, refactoring, code review, implementing algorithms, creating scripts, fixing bugs, developing APIs, adding functionality, or any programming task. Triggers on requests like 'build a function', 'implement this feature', 'write a script', 'fix this code', 'create an API', 'debug this error', 'refactor this module', 'add tests'. Also triggers when user discusses architecture, design patterns, or needs help with any coding workflow. Make sure to use this skill whenever the user mentions code, programming, development, implementation, or software engineering tasks, even if they don't explicitly ask for a 'coding agent'. ☄️"
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
- Read `knowledge/conventions.md` for project-specific conventions
- Read `knowledge/error-patterns.md` for environment-specific gotchas
- Each function must have a clear single responsibility
- Each function must include error handling

### GATE 3: Verify Before Delivery

Before delivering, you MUST:
- Run `bun run lint` (or equivalent linter)
- Check for type errors
- Trace through the code mentally with sample inputs
- If tests exist, run them
- Read `workflow/review-checklist.md` for the review checklist

### GATE 4: Error Stop Protocol

If ANY error occurs during development:
- **STOP** — do not continue past errors
- Diagnose the root cause (read logs, check stack traces)
- Fix the root cause, not the symptom
- Re-verify from GATE 3

---

## Knowledge Base (LOAD WHEN NEEDED)

Read these files when the task is relevant:

| File | When to Read |
|------|-------------|
| `knowledge/architecture.md` | Starting a new feature or modifying project structure |
| `knowledge/conventions.md` | Writing any code (naming, file structure, patterns) |
| `knowledge/gotchas.md` | Working with the sandbox environment or platform APIs |
| `knowledge/error-patterns.md` | Debugging errors or unexpected behavior |

## Workflow Templates (USE FOR STRUCTURE)

| File | When to Use |
|------|-------------|
| `workflow/gates.md` | Every coding task (mandatory constraints) |
| `workflow/plan-template.md` | Complex tasks requiring step-by-step planning |
| `workflow/review-checklist.md` | Before delivering any code |

---

## Quick Reference

| Topic | File |
|-------|------|
| Memory setup | `memory-template.md` |
| Task breakdown | `workflow/plan-template.md` |
| Execution constraints | `workflow/gates.md` |
| Verification | `workflow/review-checklist.md` |
| Multi-task state | `state.md` |
| User criteria | `criteria.md` |
| Architecture | `knowledge/architecture.md` |
| Conventions | `knowledge/conventions.md` |
| Error patterns | `knowledge/error-patterns.md` |
| Platform gotchas | `knowledge/gotchas.md` |

---

## Architecture

User preferences stored in `~/code/` when user explicitly requests.

```
~/code/
  - memory.md    # User-provided preferences only
```

Create on first use: `mkdir -p ~/code`

---

## Scope

This skill ONLY:
- Provides coding workflow constraints and quality gates
- Loads project knowledge from included files
- Stores preferences user explicitly provides in `~/code/`

This skill NEVER:
- Executes code automatically
- Makes network requests
- Accesses files outside `~/code/` and the user's project
- Modifies its own SKILL.md or auxiliary files
- Takes autonomous action without user awareness

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

---

## Self-Modification

This skill NEVER modifies its own SKILL.md or auxiliary files.
User data stored only in `~/code/memory.md` after explicit request.

## External Endpoints

This skill makes NO network requests.

| Endpoint | Data Sent | Purpose |
|----------|-----------|---------|
| None | None | N/A |

## Security & Privacy

**Data that stays local:**
- Only preferences user explicitly asks to save
- Stored in `~/code/memory.md`

**Data that leaves your machine:**
- None. This skill makes no network requests.

**This skill does NOT:**
- Execute code automatically
- Access network or external services
- Access files outside `~/code/` and user's project
- Take autonomous actions without user awareness
- Delegate to sub-agents without user's explicit request
