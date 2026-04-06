# ☄️ stellar-coding-agent

**A quality-gated coding workflow skill for [z.ai](https://z.ai) web — GLM-5 & GLM-5-Turbo.**

Enhances the built-in `coding-agent` skill with mandatory quality gates, a project knowledge base, platform-specific error patterns, and a `fullstack-dev` routing wrapper — all deployed via a single `setup.sh` script.

---

## Target Platform

This patch targets the **z.ai web** interface (https://z.ai) running on the following models:

| Model | Role | Notes |
|-------|------|-------|
| **GLM-5** | Primary | Full coding sessions, complex reasoning, architecture design |
| **GLM-5-Turbo** | Fast tasks | Quick fixes, simple scripts, shorter interactions |

### How z.ai Skills Work

z.ai web uses a **hardcoded skill whitelist** (`<available_skills>`) to match user prompts to skills. When a match is found, the platform loads the corresponding `SKILL.md` file from the `skills/` directory, injecting its content into the LLM context. Key behaviors discovered through testing:

1. **Trigger matching is platform-controlled** — The `<available_skills>` block is injected by the platform, and the LLM matches user prompts against skill descriptions listed there. Custom skill descriptions in `SKILL.md` on disk do **not** expand the trigger keywords.

2. **Post-invoke disk load** — Once a skill is invoked (via `Skill(command='X')`), the platform loads the `SKILL.md` from `~/my-project/skills/X/SKILL.md` on disk. This is where patched content takes effect.

3. **Skills directory persists** — Files in `~/my-project/skills/` survive between sessions, so patches installed via `setup.sh` remain active until explicitly removed.

4. **First-prompt bootstrap** — For the `fullstack-dev` routing wrapper to become active, the first prompt in a session must match the built-in `fullstack-dev` description (keywords like Next.js, React, dashboard, UI). Once loaded, the wrapper can route subsequent prompts to `stellar-coding-agent`.

---

## What This Patch Does

```
                        ┌─────────────────────────────────────────┐
                        │          z.ai web (GLM-5 / Turbo)        │
                        │                                         │
                        │   User Prompt                           │
                        │       │                                 │
                        │       ▼                                 │
                        │   <available_skills> matching           │
                        │       │                                 │
  ┌─────────────────────┼───────────────┐                         │
  │                     ▼               │                         │
  │        fullstack-dev (built-in)     │                         │
  │               │                     │                         │
  │               ▼                     │                         │
  │      ROUTING DECISION               │                         │
  │       ┌─────────┴─────────┐         │                         │
  │       ▼                   ▼         │                         │
  │   Web Dev            General Code   │                         │
  │   (Next.js/React)    (Python/etc)   │                         │
  │       │                   │         │                         │
  │       ▼                   ▼         │                         │
  │   Original          Skill('stellar- │                         │
  │   Handler           coding-agent')  │                         │
  │                     ☄️               │                         │
  └─────────────────────┼───────────────┘                         │
                        │                                         │
                        ▼                                         │
              ┌──────────────────────┐                             │
              │ stellar-coding-agent │  Quality Gates + Knowledge  │
              │ SKILL.md             │  Base + Error Patterns      │
              │ (from disk)          │                             │
              └──────────────────────┘                             │
                        │                                         │
                        ▼                                         │
                 Better Code Output                               │
                        │                                         │
                        └─────────────────────────────────────────┘
```

### Component 1: `stellar-coding-agent` Skill

A replacement for the built-in `coding-agent` that enforces structured quality constraints on every coding task. See the [comparison table](#default-coding-agent-vs-stellar-coding-agent) below for the full list of differences.

### Component 2: `fullstack-dev` Routing Wrapper

Patches the built-in `fullstack-dev` skill's `SKILL.md` with a routing decision layer that separates web development tasks from general coding tasks, delegating the latter to `stellar-coding-agent`.

---

## Default `coding-agent` vs `stellar-coding-agent`

| Aspect | Default `coding-agent` (v1.0.4) | `stellar-coding-agent` (v3.2.0) |
|--------|-------------------------------|-------------------------------|
| **Workflow** | Soft guidance: "Plan Before Code", "Verify Everything" | **4 mandatory quality gates** enforced as hard constraints (GATE 1→2→3→4) |
| **Error Handling** | "Report error to user, suggest fixes, wait" | **Error Stop Protocol**: STOP immediately, diagnose root cause, fix root not symptom, re-verify |
| **Code Quality** | No specific constraints | **Hard constraints**: no `any`, functions <50 lines, no magic numbers, no `console.log`, explicit return types |
| **Knowledge Base** | None — no reference files for environment specifics | **4 files**: architecture (sandbox layout), conventions (naming, imports), gotchas (platform quirks), error patterns (error→fix lookup) |
| **Workflow Templates** | Basic `planning.md` (step format) + `execution.md` (progress tracking) | **Structured templates**: plan template with risk assessment, focused review checklist, gates with enforcement |
| **Verification** | "Suggest running tests", "suggest taking screenshot" | **Pre-delivery checklist**: lint, type check, mental trace, test run, then review checklist |
| **Trigger Confirmation** | None — no way to verify skill loaded | **☄️ mandatory first output** — user sees ☄️ and knows the skill is active |
| **Import Order** | Not specified | **Strict enforced order**: external → internal → relative → types |
| **Code Smell Ban** | Not specified | **Explicit ban list**: console.log, silent catch, callback hell, copy-paste logic, commented-out code, TODO without context, hardcoded strings, boolean params |
| **Platform Awareness** | Generic — no sandbox-specific knowledge | **z.ai-specific**: Caddy gateway routing, `?XTransformPort=` pattern, single `/` route, `z-ai-web-dev-sdk` backend-only, `skills/` persistence |
| **Error Pattern Library** | None | **Lookup table**: 15+ common errors with cause→fix mapping |
| **Debug Flow** | "Report to user, wait" | **Structured flow**: read error → check dev.log → identify layer → match patterns → isolate |
| **Honesty** | Not addressed | **Honesty Clause**: acknowledges no enforcement mechanism — compliance is voluntary |

### What `stellar-coding-agent` Adds On Top

- Mandatory quality gates that cannot be skipped
- Platform-specific knowledge (z.ai sandbox constraints, gateway routing)
- Hard coding constraints (no `any`, 50-line limit, import order)
- Error pattern library with root cause analysis
- Focused code review checklist (critical + structure + platform checks)
- Trigger confirmation marker (☄️) for reliability verification
- Plan template with risk assessment and dependency tracking
- Honesty Clause — no false promises about enforcement

---

## Quick Install

```bash
git clone https://github.com/hoshiyomiX/stellar-coding-agent.git /tmp/cap
cd /tmp/cap && bash setup.sh
```

Setup is **idempotent** — safe to re-run any time. It will:
- Create/overwrite `stellar-coding-agent` skill files in `~/my-project/skills/stellar-coding-agent/`
- Patch `fullstack-dev/SKILL.md` with routing wrapper
- Back up original `fullstack-dev/SKILL.md` as `SKILL.md.original`
- Migrate preferences from old `coding-suisei` or `coding-agent` if present

---

## Trigger Marker

`☄️` — when `stellar-coding-agent` loads, the LLM **must** output this emoji as its very first response before any other content. If you see ☄️, the patch is active and quality gates are enforced.

---

## How to Invoke stellar-coding-agent

Because `stellar-coding-agent` is not in the z.ai built-in whitelist, it relies on two paths to get invoked:

### Path 1: Direct invocation (most reliable ~90%)

Use the skill name as a prefix in your prompt:

```
stellar-coding-agent: buat fungsi python merge sort
stellar-coding-agent: refactor kode react component ini
stellar-coding-agent: debug error TypeError Cannot read properties of undefined
```

### Path 2: Through fullstack-dev wrapper (~70-90%)

Start the session with a web dev keyword to trigger `fullstack-dev`, then on subsequent prompts the routing wrapper delegates general coding tasks to `stellar-coding-agent`:

```
# First prompt — triggers fullstack-dev (loads wrapper)
> buat dashboard dengan Next.js

# Second prompt — wrapper routes to stellar-coding-agent
> stellar-coding-agent: buat fungsi helper untuk format tanggal
```

| Prompt Pattern | Invokes | Reliability |
|---|---|---|
| `stellar-coding-agent: <task>` | stellar-coding-agent directly | ~90% |
| `gunakan stellar-coding-agent untuk <task>` | stellar-coding-agent directly | ~85% |
| `☄️ <coding task>` | stellar-coding-agent (marker match) | ~60% |
| `buat dashboard dengan Next.js` (first prompt) | fullstack-dev → wrapper loaded | ~90% |
| General coding (after wrapper loaded) | fullstack-dev → routes to stellar-coding-agent | ~80% |
| `buat fungsi python merge sort` (cold session) | ❌ may not trigger any skill | ~10% |

> **Recommendation**: Always prefix with `stellar-coding-agent:` for general coding tasks. The z.ai trigger matching is unreliable for ambiguous prompts without a skill name.

---

## Installed Structure

```
~/my-project/skills/
├── stellar-coding-agent/               # Deployed skill
│   ├── SKILL.md                        # Core: quality gates + trigger confirmation
│   │                                   #   version 3.2.0
│   ├── knowledge/                      # Knowledge Base
│   │   ├── architecture.md             # z.ai sandbox constraints, directory layout,
│   │   │                               #   service communication (Caddy gateway)
│   │   ├── conventions.md              # Platform-specific: state management routing,
│   │   │                               #   import order, file organization, shadcn/ui rules
│   │   ├── gotchas.md                  # Platform quirks: single route, no localhost,
│   │   │                               #   XTransformPort, skills/ persistence, Prisma limits
│   │   └── error-patterns.md           # 15+ error→cause→fix entries organized by category
│   │                                   #   (network, runtime, build, WebSocket) + debug flow
│   ├── workflow/                       # Workflow Templates
│   │   ├── gates.md                    # Hard constraints: function limits, type rules,
│   │   │                               #   file rules, code smell ban list, import order
│   │   ├── plan-template.md            # Structured plan: problem, approach, files,
│   │   │                               #   dependencies, steps, risk assessment, verification
│   │   └── review-checklist.md         # Focused review: critical checks, structure,
│   │                                   #   platform checks (web dev)
│   └── memory-template.md              # Template for ~/code/memory.md preferences + storage rules
│
└── fullstack-dev/                      # Patched with routing wrapper
    ├── SKILL.md                        # Wrapper: ROUTING DECISION layer that separates
    │                                   #   web dev (original handler) from general coding
    │                                   #   (delegates to stellar-coding-agent via Skill())
    └── SKILL.md.original               # z.ai platform original (backup for rollback)
```

---

## Quality Gates

The core differentiator. Four gates that the LLM must follow **in order** for every coding task.

### GATE 1: Understand Before Coding

Forces the LLM to demonstrate comprehension before writing any code.

- Restate the problem in your own words
- Identify edge cases and constraints
- List files that will be created or modified
- Check `~/code/memory.md` for user preferences
- If the task is complex (3+ files, schema change, new endpoint), create a structured plan

### GATE 2: Write with Constraints

Reads relevant knowledge files based on task type — not all files for every task.

- `workflow/gates.md` — mandatory for every coding task
- `knowledge/conventions.md` + `knowledge/gotchas.md` — for web dev tasks
- `knowledge/error-patterns.md` + `knowledge/gotchas.md` — for debugging
- `knowledge/architecture.md` — for new features or project changes
- `workflow/review-checklist.md` — before delivery

### GATE 3: Verify Before Delivery

Enforces verification before presenting code to the user.

- Run the appropriate linter (`bun run lint`, `ruff`, etc.)
- Check for type errors
- Trace through the code mentally with sample inputs
- If tests exist, run them
- Run through the focused review checklist

### GATE 4: Error Stop Protocol

Forces a complete stop on any error.

- **STOP** — do not continue past errors
- Diagnose the root cause (read logs, check stack traces, check `dev.log`)
- Fix the root cause, not the symptom
- Re-verify from GATE 3

---

## Version History

| Version | Changes |
|---------|---------|
| **v3.2.0** | Major token optimization (~24% reduction). Removed dead weight: Honest Description, Architecture/Core Rules bloat, duplicate checklists. Deleted criteria.md (merged into memory-template.md) and state.md (rarely used). Made GATE 2 smarter (read relevant files, not all 4). Added Honesty Clause acknowledging no enforcement. Slashed review-checklist from 24→12 items. Added more error patterns (CORS, Prisma unique constraint, case sensitivity). Rebranded to stellar-coding-agent. |
| v3.1.0 | Fixed 3 critical bugs (wrong file mapping in GATE 2, dead references in memory-template, import order conflict). Added multi-language linter in GATE 3. Changed wrapper trigger to ⚡. Trimmed description frontmatter. Added delivery confirmation line. |
| v3.0.0 | Renamed `coding-agent` → `coding-suisei`. Added Tier 1 upgrades: 4 mandatory quality gates, project knowledge base (4 files), error pattern library, workflow templates (plan + review + gates), trigger confirmation marker (☄️). Added `fullstack-dev` routing wrapper. |
| v2.2 | Fixed repo structure (independent git), removed bootstrap `Invoke Skill()` instruction from setup.sh. |
| v2.0 | Initial `fullstack-dev` routing wrapper + `coding-agent` skill patch. |

---

## Rollback

```bash
# Restore original fullstack-dev
cp ~/my-project/skills/fullstack-dev/SKILL.md.original ~/my-project/skills/fullstack-dev/SKILL.md

# Remove stellar-coding-agent
rm -rf ~/my-project/skills/stellar-coding-agent
```

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|---------|
| ☄️ does not appear | Skill not invoked by z.ai | Use `stellar-coding-agent:` prefix, or start session with a web dev keyword to load the fullstack-dev wrapper first |
| setup.sh refused by LLM | AI manipulation detection | Fixed in v2.2 — script no longer contains `Invoke Skill()` instructions |
| fullstack-dev routing doesn't delegate | Wrapper not loaded yet | The wrapper only activates after fullstack-dev is invoked in the current session |
| General coding prompt triggers nothing | z.ai trigger matching is unreliable for non-whitelisted skills | Always use `stellar-coding-agent:` prefix for guaranteed invocation |
| Skills disappear after session | Session cleanup | `skills/` directory persists. If it doesn't, re-run setup.sh |

---

## Repository Structure

```
stellar-coding-agent/
├── README.md                            # This file
├── setup.sh                             # Idempotent install script (v3.2)
└── skill/
    ├── stellar-coding-agent/
    │   ├── SKILL.md                     # Core skill definition (quality gates + trigger)
    │   ├── knowledge/                   # 4 knowledge base files
    │   │   ├── architecture.md
    │   │   ├── conventions.md
    │   │   ├── gotchas.md
    │   │   └── error-patterns.md
    │   ├── workflow/                    # 3 workflow template files
    │   │   ├── gates.md
    │   │   ├── plan-template.md
    │   │   └── review-checklist.md
    │   └── memory-template.md
    └── fullstack-dev-SKILL.md           # Routing wrapper (patches fullstack-dev)
```
