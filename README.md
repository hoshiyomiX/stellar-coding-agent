# coding-suisei Patch

Persistent coding workflow skill for the platform. Deploys via `setup.sh`.

## What It Does

1. **Deploys `coding-suisei` skill** — a quality-gated coding workflow with:
   - Mandatory quality gates (not suggestions)
   - Project knowledge base (architecture, conventions, gotchas, error patterns)
   - Workflow templates (plan template, review checklist)

2. **Patches `fullstack-dev`** with a routing wrapper:
   - Web dev tasks → original fullstack-dev flow
   - General coding tasks → delegates to `coding-suisei`

## Quick Install

```bash
git clone https://github.com/hoshiyomiX/coding-agent-patch.git /tmp/cap
cd /tmp/cap && bash setup.sh
```

## Trigger Marker

`☄️` — if you see this emoji, the skill loaded successfully.

## Architecture

```
skills/coding-suisei/
  SKILL.md                    # Core: quality gates + routing
  knowledge/
    architecture.md           # Project structure and constraints
    conventions.md            # Naming, imports, patterns
    gotchas.md                # Platform-specific quirks
    error-patterns.md         # Common errors → solutions
  workflow/
    gates.md                  # Mandatory coding constraints
    plan-template.md          # Structured plan format
    review-checklist.md       # Pre-delivery checklist
  memory-template.md          # User preferences template
  state.md                   # Multi-task state tracking
  criteria.md                # Acceptance criteria

skills/fullstack-dev/
  SKILL.md                    # Patched: routing wrapper → coding-suisei
  SKILL.md.original           # Platform original (backup)
```

## Version History

| Version | Changes |
|---------|---------|
| v3.0.0 | Renamed to coding-suisei, added quality gates + knowledge base, ☄️ marker |
| v2.2 | Fixed repo structure, removed bootstrap instruction |
| v2.0 | Initial fullstack-dev wrapper + coding-agent skill |

## Rollback

```bash
cp ~/my-project/skills/fullstack-dev/SKILL.md.original ~/my-project/skills/fullstack-dev/SKILL.md
rm -rf ~/my-project/skills/coding-suisei
```
