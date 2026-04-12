# Changelog

## [4.5.0] — 2026-04-12

### Added
- Coexistence Mode — new "Coexistence with fullstack-dev" section defining how this framework layers with the platform-provided fullstack-dev skill
- IMPLEMENT phase defers technology-specific decisions to fullstack-dev when it is active; falls back to own `constraints/` and `knowledge/` files when standalone
- Implementation Rules now conditional: tech-specific rules apply only in standalone mode

### Changed
- Version bumped to v4.5.0

### Why
fullstack-dev persists across sessions (system prompt level) and provides deep Next.js technical expertise. This framework provides orthogonal process governance (phase state machine, traceability, verification). Rather than duplicating fullstack-dev's technical rules and risking conflicting instructions, the framework now natively recognizes fullstack-dev's presence and defers to it for IMPLEMENT-phase technology decisions. SPECIFY, PLAN, VERIFY, and DELIVER remain fully under this framework's control in both modes. This allows users to load both skills and get the best of both: disciplined process AND expert technical knowledge, with no rule conflicts.

## [4.4.2] — 2026-04-11

### Changed
- Removed non-coding task exemption from Activation section — QA Attestation is now required after every task, not just coding tasks
- Non-coding tasks (conversation, questions, feedback) mark phases as N/A but still output the attestation block
- QA Attestation header changed from "After delivering code" to "After completing any task (coding or non-coding)"

### Why
The Activation section had an escape hatch: "If the user's request is not a coding task, the phase machine does not apply." This allowed the agent to skip the QA Attestation entirely on non-coding tasks — the exact failure mode the user wanted to detect. The QA Attestation is the framework's proof-of-life signal. If it's optional, the user has no way to confirm the agent is following the framework. Making it mandatory for all tasks means the user can always check: no attestation block = framework was not followed.

## [4.4.1] — 2026-04-11

### Changed
- Activation section now includes explicit compliance binding after the banner — defines "ACTIVE" as a mandatory behavioral requirement, not just a status label
- Phase State Machine section changed from informational description to imperative instruction ("Every phase is mandatory")

### Why
In rare cases, the agent printed the activation banner correctly but then ignored the entire framework — no specification, no plan, no verification, no QA Attestation. Root cause: the Activation section contained only one instruction ("output the banner") and described the framework using informational language. The LLM complied with the explicit command and treated everything else as optional context. The fix adds a direct imperative after the banner stating that every coding task MUST follow the phase machine, and converts the Phase State Machine section from "this is how it works" to "you must do this."

### Honest limitation
This fix improves compliance but cannot guarantee it. No amount of text in a skill file can force an LLM to follow a procedure in every session — attention varies, context windows degrade, and different model runs have different behavior. The compliance instruction is placed in the Activation section (highest attention) and uses direct imperatives, which gives it the best chance of being followed, but it remains best-effort.

## [4.4.0] — 2026-04-08

### Added
- Git / Version Control error classification in `error-resolution.md` — new category with diagnostic path for git push rejection, merge conflicts, force push, and infrastructure-blocked git commands
- Git / Version Control option in `incident-report.md` Error Classification field

### Changed
- Error Recovery section in `SKILL.md` — added mandatory git operation rules as override to general error recovery

### Why
An agent in another session encountered a fatal cascading failure: `git push` was rejected (remote diverged), then the agent automatically escalated through `git pull --rebase` → `git rebase --abort` → `git reset --hard` → `rm -rf .git`, each command blocked by infrastructure, leaving the agent completely paralyzed. The root cause was twofold: (1) the error classification table had no "Git / Version Control" category, so the agent had no decision path for git errors; (2) the general "ask before side effects" rule was too vague for git operations — `git pull` doesn't read as "destructive" even though it can trigger merge conflicts that lead to cascading failures. The fix adds a dedicated git error category with an explicit "fetch first, then ask" policy, and elevates git rules to a mandatory override in the main SKILL.md so they cannot be missed.

## [4.3.1] — 2026-04-08

### Fixed
- Bare `dev.log` path in error-resolution.md — now uses absolute `/home/z/my-project/dev.log`
- Dead `~/code/memory.md` reference in phases.md — now points to `skills/stellar-coding-agent/memory.md`
- Banner template count corrected from 5 to 4 (problem-spec, implementation-plan, verification-report, incident-report)

### Added
- Version sync comment in SKILL.md frontmatter — reminds maintainers to update 3 locations on bump
- Honesty note in QA Attestation section — acknowledges attestation is self-graded, sets correct expectations

### Why
The bare `dev.log` path could resolve incorrectly if the working directory changed mid-session. The `~/code/memory.md` path was a stale reference from before the framework moved to `skills/`. The template count was cosmetically wrong. The version sync comment prevents the recurring issue of mismatched version numbers across frontmatter, banner, and setup.sh. The honesty note documents the inherent limitation that the LLM grades its own work.

## [4.3.0] — 2026-04-08

### Changed
- QA Attestation replaced `ERROR STOP` row with `OUTCOME` row — a separate gate for code correctness
- Added mandatory `Evidence` line requiring concrete counts (e.g. `lint 0 errors, 4/4 traceability verified`)
- Added mandatory `Defects found and fixed` counter
- Added delivery gate rule: OUTCOME FAIL blocks delivery regardless of process phase status
- Verification report template: added `Defects found/fixed` metrics to Summary, added `Outcome Statement` section
- Verification report guidance: added rules for defect count consistency and outcome vs process distinction
- setup.sh version bumped to v4.3.0
- SKILL.md version bumped to v4.3.0

### Why
The old attestation measured process compliance ("did I write a spec?") not outcome quality ("does the code work?"). The LLM would stamp all phases PASS even when code had real bugs, because it followed the process — just followed it badly. The OUTCOME row decouples correctness from process, and the evidence requirement makes false claims harder to fabricate.

## [4.2.1] — 2026-04-08

### Changed
- Activation banner: removed `{version}` placeholder, hardcoded actual version to prevent hallucination
- setup.sh rewritten: clean wipe-and-mirror deploy instead of incremental copy
- Old PART 2 (hardcoded deprecated file list) removed — no longer needed since `rm -rf` guarantees clean state
- Reduced from 5 parts to 4 parts (PART 1+2 merged into single clean deploy)
- `SOURCE_DIR` now points directly at `skill/stellar-coding-agent/` (one level deeper)

### Why
Incremental `cp` left orphan files when future versions removed files from the repo. The clean `rm -rf` + `cp -R` approach guarantees the installed directory is always a 1:1 mirror of the source, with no stale artifacts from previous versions. The `{version}` placeholder in the activation banner caused rare hallucinated version numbers (e.g. "v1.0") — hardcoding the version eliminates this.

## [4.2.0] — 2026-04-08

### Changed
- Activation trigger redesigned from bare `☄️` to a styled banner with version, phase count, and status
- QA Attestation header now includes `☄️` prefix for visual consistency with activation
- Phase labels in QA Attestation changed from `G1`/`G2` notation to plain names (`SPECIFY`, `PLAN`, etc.)
- setup.sh version bumped to v4.2.0

### Why
The bare `☄️` emoji as the only activation output looked plain and lacked informational value. The new banner provides instant visibility of framework version, loaded component count, and ready state — making it functionally useful while remaining compact.

## [4.1.0] — 2026-04-08

### Changed
- Removed fullstack-dev routing wrapper (no longer needed — stellar-coding-agent can be invoked directly via `Skill(command="stellar-coding-agent")`)
- setup.sh no longer patches fullstack-dev; instead restores it to original if a wrapper from a previous version exists
- setup.sh version bumped to v4.1.0
- Removed `fullstack-dev-SKILL.md` from repository

### Why
The platform recognizes `stellar-coding-agent` as a valid skill in `<available_skills>`, making direct invocation reliable. The wrapper caused problems because the platform overwrites `fullstack-dev/SKILL.md` on invoke, silently destroying the routing bridge.

## [4.0.1] — 2026-04-08

### Fixed
- 3 broken references in `procedure/phases.md` pointing to deleted `workflow/` files — now point to correct v4.0 locations
- Old "GATE 2 section" terminology in phases.md replaced with "Phase References table"
- Banned `tail` command reference in error-resolution.md replaced with direct file read instruction
- Inconsistent relative path in problem-spec.md corrected to full path

## [4.0.0] — 2026-04-07

### Breaking Changes
- Complete framework redesign from "4 gates" to phase state machine
- Templates moved from `workflow/` to `procedure/templates/`
- Code constraints moved from `workflow/gates.md` to `constraints/`
- Knowledge files rewritten with professional tone and severity tags

### Added
- Phase state machine (IDLE → SPECIFY → PLAN → IMPLEMENT → VERIFY → DELIVER)
- Artifact chain with Traceability IDs for drift prevention
- Structured decision tree for error resolution
- Complexity tiers (Simple / Standard / Complex)
- Severity classification system ([CRITICAL], [REQUIRED], [RECOMMENDED])
- Incident report template for error documentation
- Verification report template with evidence capture
- CHANGELOG.md for version tracking
- Purpose sections in all documents

### Removed
- "Honesty Clause" (self-defeating — replaced by QA attestation integrity statement)
- All-caps emphasis repetition throughout documents
- Informal language ("gotchas", "ban list", "just do it")
- Duplicate content between SKILL.md and gates.md
- `workflow/gates.md`, `workflow/plan-template.md`, `workflow/review-checklist.md`

### Changed
- "Delivery Confirmation" → "QA Attestation" with structured format
- GATE 4 enhanced: user approval required before destructive recovery actions
- `knowledge/gotchas.md` → `knowledge/platform-constraints.md`
- All documents use calm, professional tone with severity tags

## [3.4.0] — 2026-04-07
- QA Attestation format (structured compliance report replacing informal delivery confirmation)

## [3.3.0] — 2026-04-07
- GATE 4: Added user approval requirement for destructive recovery actions

## [3.2.0] — 2026-04-07
- Initial deployment from setup.sh
