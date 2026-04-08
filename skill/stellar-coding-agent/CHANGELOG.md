# Changelog

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
