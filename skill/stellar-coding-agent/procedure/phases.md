# Phase State Machine

This framework uses a phase state machine to govern every coding task. Each phase produces a concrete artifact that the next phase consumes, forming an artifact chain that enforces consistency. Skipping a phase means the next phase has no input to work from, which makes the gap visible and correctable.

## State Diagram

```
IDLE → SPECIFY → PLAN → IMPLEMENT → VERIFY → DELIVER
              ↑                              │
              └────── (on error) ────────────┘
```

The diagram shows one error-return path: any phase that encounters an error documents it and returns to SPECIFY. In practice, the return target depends on severity — see the error resolution decision tree at `decision-trees/error-resolution.md`.

---

## Phase 1: IDLE

**Purpose**: Receive the user's request and determine whether it warrants a full workflow execution.

**Entry criteria**: No active task. The agent is waiting for input.

**Required actions**:
1. Receive and acknowledge the user's request.
2. Classify the task complexity:
   - **Simple**: Single file, no schema change, no new dependencies, no architectural impact.
   - **Standard**: Multiple files or a schema change, but within existing patterns.
   - **Complex**: New endpoints, architectural changes, multi-service coordination, or high risk.
3. Read `~/code/memory.md` for user preferences, if the file exists.
4. Transition to SPECIFY.

**Required artifacts**: None. IDLE is a routing phase.

**Exit criteria**: Task complexity is classified and relevant context (user preferences) is loaded.

**Transition rules**:
- Always transitions to SPECIFY.

**Complexity tier note**: Simple tasks may abbreviate SPECIFY and PLAN into a single combined output (see SPECIFY phase), but must still produce all artifact fields. The classification here determines which abbreviation is allowed.

---

## Phase 2: SPECIFY

**Purpose**: Produce a precise problem specification that removes ambiguity and establishes shared understanding of what needs to be built.

**Entry criteria**:
- Task complexity is classified (from IDLE).
- User preferences are loaded, if available.

**Required actions**:
1. Restate the user's request in precise technical terms.
2. Identify all functional requirements — what the code must accomplish.
3. Identify technical constraints — platform limits, sandbox rules, framework requirements. Reference `knowledge/architecture.md` for sandbox-specific constraints.
4. Enumerate edge cases with handling strategies for each.
5. List all files that will be created or modified, with the action type (create/modify) and purpose for each.
6. Assess risk level (LOW / MEDIUM / HIGH) with justification.
7. Identify dependencies — external packages, services, configuration changes.
8. Fill out the problem specification template and present it to the user.

**Required artifacts**:
- `procedure/templates/problem-spec.md` — the completed Problem Specification.

**Exit criteria**:
- All fields in the problem specification template are filled.
- The user has reviewed and confirmed the specification (or the task is simple enough that confirmation is implied).

**Transition rules**:
- On acceptance → transition to PLAN.
- On user revision → update the specification and re-present.

**Complexity tier note**:
- **Simple tasks**: SPECIFY and PLAN may be combined into a single output. The agent produces both the problem specification and the implementation plan together, but every field from both templates must still be present. This abbreviation exists because the overhead of two separate phases is disproportionate for a small change.
- **Standard and complex tasks**: SPECIFY and PLAN are separate phases. Present the specification, get confirmation, then proceed to PLAN.

---

## Phase 3: PLAN

**Purpose**: Design the implementation strategy and define traceable steps that map requirements to code changes.

**Entry criteria**:
- Problem specification is approved (from SPECIFY).
- For simple tasks, the combined SPECIFY+PLAN output is approved.

**Required actions**:
1. Review the problem specification and confirm all requirements are accounted for.
2. Choose a solution approach (2-3 sentences describing the strategy).
3. Break the implementation into discrete, ordered steps. Each step gets a Traceability ID (IMPL-001, IMPL-002, etc.).
4. Define the verification strategy — what to check, how to check it, and what the expected outcome is.
5. Read relevant knowledge files based on task type (see the Phase References table in SKILL.md).
6. Fill out the implementation plan template and present it.

**Required artifacts**:
- `procedure/templates/implementation-plan.md` — the completed Implementation Plan.

**Exit criteria**:
- Every functional requirement from the problem specification maps to at least one implementation step.
- Every implementation step has a Traceability ID.
- The verification strategy covers all edge cases identified in the specification.

**Transition rules**:
- On acceptance → transition to IMPLEMENT.
- On user revision → update the plan and re-present.

**Complexity tier note**: For simple tasks, this phase is combined with SPECIFY (see above). The implementation plan section is included in the combined output.

---

## Phase 4: IMPLEMENT

**Purpose**: Write the code, following the plan step by step and maintaining traceability.

**Entry criteria**:
- Implementation plan is approved (from PLAN).
- Relevant knowledge files have been read.

**Required actions**:
1. For each implementation step in the plan:
   a. Reference the step's Traceability ID in a comment or context note.
   b. Write the code for that step.
   c. Ensure the code follows the constraints in `constraints/code-standards.md` and `constraints/type-safety.md`.
   d. If the step introduces a new dependency, install it before writing code that uses it.
2. After writing all code, do a self-review using the Review Checklist in `procedure/templates/verification-report.md`.
3. Fix any issues found during self-review before transitioning to VERIFY.

**Required artifacts**:
- The code itself (modified or created files as listed in the plan).
- Inline traceability references (each code block annotated with its Traceability ID).

**Exit criteria**:
- All implementation steps from the plan are completed.
- Self-review passes with no unresolved issues.

**Transition rules**:
- On completion → transition to VERIFY.
- On error → document the error using the incident report template at `procedure/templates/incident-report.md`, then follow `procedure/decision-trees/error-resolution.md` to determine the correct recovery path.

---

## Phase 5: VERIFY

**Purpose**: Confirm that the implementation satisfies all requirements through systematic testing and traceability checks.

**Entry criteria**:
- All implementation steps are complete (from IMPLEMENT).
- Self-review has been performed.

**Required actions**:
1. Run automated checks:
   a. Lint the project (`bun run lint` for TypeScript/Next.js, or the appropriate linter for the language).
   b. Check for type errors.
   c. Run existing tests, if any.
2. Perform traceability verification — confirm that every Traceability ID from the plan has a corresponding implementation that can be verified.
3. Verify each edge case identified in the problem specification:
   a. Provide the test input.
   b. State the expected behavior.
   c. Confirm the actual behavior matches.
4. Fill out the verification report template.

**Required artifacts**:
- `procedure/templates/verification-report.md` — the completed Verification Report.

**Exit criteria**:
- All automated checks pass (or failures are documented with explanations).
- Every Traceability ID has a verified status.
- Every edge case from the specification has been tested and confirmed.

**Transition rules**:
- All checks pass → transition to DELIVER.
- Any check fails → document the failure in the incident report, return to IMPLEMENT (or SPECIFY if the failure reveals a specification gap).

---

## Phase 6: DELIVER

**Purpose**: Present the completed work to the user with a clear summary of what was done and how it was verified.

**Entry criteria**:
- Verification report shows all checks passing (from VERIFY).

**Required actions**:
1. Summarize what was implemented, referencing the Traceability IDs.
2. List all files created or modified.
3. Note any dependencies that were added.
4. Present the verification report summary to the user.
5. If any caveats or follow-up items exist, state them clearly.

**Required artifacts**: None new. DELIVER consumes the verification report and presents it to the user.

**Exit criteria**:
- The user has received the summary and verification results.
- No unresolved issues remain.

**Transition rules**:
- On acceptance → transition to IDLE (task complete).
- On user revision → determine the appropriate phase to return to (typically SPECIFY if requirements changed, or IMPLEMENT if a fix is needed).

---

## Error Handling Across Phases

When an error occurs during any phase:

1. Stop work on the current phase.
2. Complete the incident report template (`procedure/templates/incident-report.md`).
3. Follow the error resolution decision tree (`procedure/decision-trees/error-resolution.md`).
4. The decision tree determines which phase to return to. The default return target is VERIFY (re-verify after a fix), but specification gaps require returning to SPECIFY.

This approach ensures errors are documented, diagnosed, and resolved systematically rather than patched ad hoc.
