# Implementation Plan

This template is the output of the PLAN phase. It translates the problem specification into a step-by-step implementation strategy with traceability IDs that connect requirements to code to verification.

## Why Traceability IDs Exist

Each implementation step receives a Traceability ID (IMPL-001, IMPL-002, etc.). During the IMPLEMENT phase, each code change references its Traceability ID. During the VERIFY phase, each verification item traces back to a Traceability ID. This chain is the primary mechanism that prevents drift between what was planned, what was built, and what was verified. If a verification item fails, the Traceability ID points directly to the implementation step and, through it, to the original requirement.

---

## Template

Copy and complete the following for every task:

```markdown
# Implementation Plan: [Task Name]

## Approach

[2-3 sentences describing the solution strategy. Explain the high-level design decision and why it was chosen over alternatives.]

## Implementation Steps

| Step | Action | Target File | Traceability ID |
|------|--------|-------------|-----------------|
| 1 | [Specific action — what code to write or change] | [File path] | IMPL-001 |
| 2 | [Specific action — what code to write or change] | [File path] | IMPL-002 |
| 3 | [Specific action — what code to write or change] | [File path] | IMPL-003 |

## Requirements Mapping

| Traceability ID | Maps to Requirement | Notes |
|-----------------|--------------------|----|
| IMPL-001 | [Functional requirement from problem spec] | [Any relevant context] |
| IMPL-002 | [Functional requirement from problem spec] | [Any relevant context] |
| IMPL-003 | [Edge case # from problem spec] | [Any relevant context] |

## Verification Strategy

| What to Verify | Method | Expected Outcome | Traceability ID |
|----------------|--------|------------------|-----------------|
| [Specific behavior or constraint] | [How to check: lint, manual test, type check, etc.] | [What a correct result looks like] | IMPL-001 |
| [Specific behavior or constraint] | [How to check] | [What a correct result looks like] | IMPL-002 |

## Dependencies

| Dependency | Install Command | Required By Step |
|------------|----------------|-----------------|
| [Package or service name] | [e.g., `bun add package-name`] | [IMPL-XXX] |

## Notes

[Any design decisions, trade-offs, or context the implementer should know]
```

---

## Field Guidance

| Field | Guidance |
|-------|----------|
| **Approach** | State the design decision clearly. If there are alternatives, explain why this one was chosen. Keep it to 2-3 sentences. |
| **Implementation Steps** | Each step must be specific enough that another developer could execute it without additional context. "Add a submit button" is too vague — "Add a submit button to the form in `src/app/page.tsx` that calls `handleSubmit` on click" is specific. |
| **Traceability ID** | Sequential numbering: IMPL-001, IMPL-002, etc. These IDs are referenced in code comments during IMPLEMENT and in verification items during VERIFY. |
| **Requirements Mapping** | Every functional requirement and edge case from the problem specification must appear here. This confirms nothing was dropped between specification and planning. |
| **Verification Strategy** | Define verification before writing code. This prevents the common failure mode of writing tests that pass trivially because they were designed after the code was already written. |
| **Dependencies** | If a new package is needed, specify the install command. The implementer must install it before writing code that depends on it. |

---

## Complexity Tier Abbreviation

For simple tasks, this template is combined with the problem specification template into a single output. All fields from both templates must still be present. The combined document is presented to the user as one artifact for approval.
