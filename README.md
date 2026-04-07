# ☄️ stellar-coding-agent

**A deterministic coding workflow skill for [z.ai](https://z.ai) — GLM-5 & GLM-5-Turbo.**

Structures LLM-assisted coding as a phase state machine with mandatory artifact templates, traceability IDs, and structured verification. Replaces ad-hoc coding workflows with a repeatable process that produces consistent output across sessions.

---

## Target Platform

| Model | Role |
|-------|------|
| **GLM-5** | Primary — complex reasoning, architecture design, full coding sessions |
| **GLM-5-Turbo** | Fast tasks — quick fixes, simple scripts, shorter interactions |

### How z.ai Skills Work

z.ai web uses a hardcoded skill whitelist to match user prompts to skills. When matched, the platform loads the `SKILL.md` from `~/my-project/skills/<name>/SKILL.md` into the LLM context. Key behaviors:

1. **Trigger matching is platform-controlled** — custom descriptions do not expand trigger keywords.
2. **Post-invoke disk load** — patched `SKILL.md` content takes effect when the skill is invoked.
3. **Skills directory persists** — `~/my-project/skills/` survives between sessions.
4. **First-prompt bootstrap** — the `fullstack-dev` routing wrapper activates after matching a web dev keyword in the current session.

---

## What Changed in v4.0

The framework was redesigned from scratch based on a self-evaluation of v3.x professionalism issues.

### From "4 Gates" to Phase State Machine

v3.x used imperative gates ("follow these 4 rules"). v4.0 uses a declarative phase machine where each phase produces a mandatory artifact that the next phase consumes. This creates an artifact chain that prevents drift.

```
IDLE → SPECIFY → PLAN → IMPLEMENT → VERIFY → DELIVER
              ↑                              │
              └────── Error Recovery ◄────────┘
```

### What Was Removed

| Removed | Reason |
|---------|--------|
| "Honesty Clause" | Self-defeating — told the LLM compliance was optional |
| All-caps shouting | `MANDATORY`, `NEVER`, `FORBIDDEN` — calm firm language is equally effective |
| Informal terminology | "gotchas", "ban list", "just do it" — replaced with severity tags |
| Duplicate content | Same rules in multiple files — deduplicated to single source of truth |
| `workflow/` directory | Split into `procedure/` (process) and `constraints/` (code rules) |

### What Was Added

| Added | Purpose |
|-------|---------|
| Phase state machine | 6 phases with entry/exit criteria and transition rules |
| Traceability IDs | `IMPL-001`, `IMPL-002`... chain requirements → code → verification |
| Artifact templates | Structured templates for spec, plan, verification, and incidents |
| Error decision tree | 5-step structured process: capture → classify → recover → fix → re-verify |
| Complexity tiers | Simple (abbreviated), Standard (full), Complex (incremental) |
| Severity tags | `[CRITICAL]`, `[REQUIRED]`, `[RECOMMENDED]` on every rule |
| `CHANGELOG.md` | Version history for the skill itself |

---

## Architecture

```
stellar-coding-agent/
├── SKILL.md                              Core: phase state machine + QA attestation
├── CHANGELOG.md                          Version history
├── procedure/                            Workflow process
│   ├── phases.md                         Phase definitions with entry/exit criteria
│   ├── templates/
│   │   ├── problem-spec.md               SPECIFY artifact (7 required fields)
│   │   ├── implementation-plan.md        PLAN artifact (Traceability IDs)
│   │   ├── verification-report.md        VERIFY artifact (evidence capture)
│   │   └── incident-report.md            Error documentation (side-effect gating)
│   └── decision-trees/
│       └── error-resolution.md           5-step structured decision tree
├── constraints/                          Code quality rules
│   ├── code-standards.md                 Function, file, import, quality standards
│   └── type-safety.md                    Type system constraints with examples
├── knowledge/                            Platform-specific reference
│   ├── architecture.md                   Runtime environment, directory layout, service topology
│   ├── conventions.md                    Coding conventions, state management, import order
│   ├── platform-constraints.md           Sandbox-specific limitations (gateway, routes, SDK)
│   └── error-patterns.md                 Common errors with cause → fix mapping
└── memory-template.md                    Template for user preference storage
```

---

## Phase State Machine

### SPECIFY — Problem Specification

Produces a structured specification before any code is written.

| Required Field | Content |
|---------------|---------|
| Request | User's exact words, quoted verbatim |
| Functional Requirement | Precise technical statement of what must be built |
| Technical Constraints | Platform limits, sandbox rules, framework requirements |
| Identified Edge Cases | Each edge case with a handling strategy |
| Affected Files | Table of files to create/modify with purpose |
| Risk Level | LOW / MEDIUM / HIGH with justification |
| Dependencies | External packages, services, config changes |

### PLAN — Implementation Plan

Maps requirements to ordered steps with Traceability IDs.

| Element | Description |
|---------|-------------|
| Approach | 2-3 sentence design decision |
| Implementation Steps | Ordered steps, each with `IMPL-001`-style ID |
| Requirements Mapping | Every requirement maps to at least one step |
| Verification Strategy | What to check, how to check, expected outcome |

### IMPLEMENT — Code Writing

Each code block references its Traceability ID from the plan. Self-review using the verification checklist runs before transition to VERIFY.

### VERIFY — Structured Verification

Produces an evidence-based verification report:

- Automated checks (lint, type check, tests) with actual output
- Traceability verification (every IMPL-ID confirmed implemented)
- Edge case verification with concrete test inputs
- Review checklist (no `any`, explicit returns, no dead code, etc.)

### Error Recovery

On any error, the workflow produces an incident report, follows a 5-step decision tree, and asks the user before any recovery action with side effects (git changes, file deletions, destructive operations).

---

## QA Attestation

After delivering code, the framework outputs a structured compliance report:

```
QA Compliance
├─ G1 Specify     : PASS
├─ G2 Plan        : PASS
├─ G3 Implement   : PASS
├─ G4 Verify      : PASS
└─ G5 Error Stop  : N/A
```

Status values: `PASS` (fully completed), `FAIL` (skipped or incomplete), `N/A` (not applicable).

---

## Quick Install

```bash
git clone https://github.com/hoshiyomiX/stellar-coding-agent.git /tmp/cap
cd /tmp/cap && bash setup.sh
```

Setup is idempotent. It will:
- Deploy `stellar-coding-agent` with the full v4.0.1 framework to `~/my-project/skills/`
- Patch `fullstack-dev/SKILL.md` with routing wrapper (backs up original)
- Remove deprecated files from previous versions (`workflow/`, `gotchas.md`)
- Verify all files are present and old files are cleaned up

---

## Trigger Marker

`☄️` — when `stellar-coding-agent` loads, the LLM outputs this as its first response. If you see ☄️, the framework is active.

---

## How to Invoke

### Path 1: Direct invocation (recommended)

```
Skill(command="stellar-coding-agent")
```

### Path 2: Through fullstack-dev wrapper

Start with a web dev keyword, then the wrapper delegates general coding to stellar-coding-agent.

```
# First prompt — triggers fullstack-dev (loads wrapper)
> build a dashboard with Next.js

# Second prompt — wrapper routes to stellar-coding-agent
> Skill(command="stellar-coding-agent")
```

---

## v3.x vs v4.0 Comparison

| Aspect | v3.x | v4.0 |
|--------|------|------|
| Workflow model | "4 mandatory gates" (imperative) | Phase state machine (declarative) |
| Step completion | "Demonstrate understanding" (vague) | Mandatory artifact templates (concrete) |
| Drift prevention | None | Traceability IDs chain spec → code → verification |
| Error handling | "Diagnose and fix" (open-ended) | 5-step decision tree with forced diagnostic output |
| Verification | "Run linter" (binary) | Evidence report with actual command output |
| Consistency | Depends on LLM context | Artifact chain makes each step's output the next step's input |
| Code rules | Duplicated across SKILL.md and gates.md | Single source of truth in `constraints/` |
| Tone | Mixed shouting and slang | Calm, professional, severity-tagged |
| Reproducibility | Low variance control | Templates constrain output structure |

---

## Component: `fullstack-dev` Routing Wrapper

Patches the built-in `fullstack-dev` skill with a routing layer:

| Request Type | Action |
|---|---|
| **Web Development** (Next.js, React, UI) | Uses original fullstack-dev handler |
| **General Coding** (Python, algorithms, scripts) | Delegates to `stellar-coding-agent` |
| **Ambiguous** | Treats as general coding (safer default) |

---

## Rollback

```bash
# Restore original fullstack-dev
cp ~/my-project/skills/fullstack-dev/SKILL.md.original ~/my-project/skills/fullstack-dev/SKILL.md

# Remove stellar-coding-agent
rm -rf ~/my-project/skills/stellar-coding-agent
```

---

## Version History

| Version | Changes |
|---------|---------|
| **v4.0.1** | Fixed 3 broken internal references from v4.0 migration. Fixed banned command reference. |
| **v4.0.0** | Complete redesign: phase state machine, artifact templates, traceability IDs, error decision tree, severity tags, professional tone. Removed "Honesty Clause", duplicate content, informal language. Split `workflow/` into `procedure/` + `constraints/`. Renamed `gotchas.md` to `platform-constraints.md`. |
| v3.4.0 | QA Attestation format (structured compliance report) |
| v3.3.0 | GATE 4: User approval for destructive recovery actions |
| v3.2.0 | Token optimization, added knowledge base, error patterns, platform awareness |
| v3.1.0 | Bug fixes, multi-language linter, delivery confirmation |
| v3.0.0 | 4 mandatory quality gates, knowledge base, routing wrapper |
| v2.0 | Initial fullstack-dev routing wrapper + coding-agent patch |

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|---------|
| ☄️ does not appear | Skill not invoked | Use `Skill(command="stellar-coding-agent")` |
| setup.sh fails | Missing dependencies | Ensure `~/my-project/skills/fullstack-dev/` exists |
| fullstack-dev routing doesn't delegate | Wrapper not loaded | Invoke fullstack-dev first in the session |
| Old files still present | Upgrading from v3.x | setup.sh automatically removes deprecated files |

---

## Repository Structure

```
stellar-coding-agent/
├── README.md                            # This file
├── setup.sh                             # Idempotent install script (v4.0.1)
└── skill/
    ├── stellar-coding-agent/
    │   ├── SKILL.md                     # Core: phase state machine
    │   ├── CHANGELOG.md                 # Version history
    │   ├── procedure/                   # Workflow process
    │   │   ├── phases.md                # 6 phase definitions
    │   │   ├── templates/               # Artifact templates
    │   │   │   ├── problem-spec.md
    │   │   │   ├── implementation-plan.md
    │   │   │   ├── verification-report.md
    │   │   │   └── incident-report.md
    │   │   └── decision-trees/
    │   │       └── error-resolution.md
    │   ├── constraints/                 # Code quality rules
    │   │   ├── code-standards.md
    │   │   └── type-safety.md
    │   ├── knowledge/                   # Platform reference
    │   │   ├── architecture.md
    │   │   ├── conventions.md
    │   │   ├── platform-constraints.md
    │   │   └── error-patterns.md
    │   └── memory-template.md
    └── fullstack-dev-SKILL.md           # Routing wrapper
```
