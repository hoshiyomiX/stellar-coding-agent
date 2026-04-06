# Plan Template

Use this template for complex tasks (3+ steps, multiple files, or high risk).

---

## Template

```markdown
## Plan: [Task Name]

### Problem Statement
[Describe the problem in one sentence]

### Approach
[Describe the solution approach in 2-3 sentences]

### Files to Create/Modify
| File | Action | Purpose |
|------|--------|---------|
| path/to/file | Create/Modify | Why this file changes |

### Dependencies
- [ ] Package A needs to be installed: `bun add package-a`
- [ ] Service B must be running
- [ ] Config C must be updated

### Implementation Steps
1. [Step description — what to do]
2. [Step description — what to do]
3. [Step description — what to do]

### Risk Assessment
- **Level**: Low / Medium / High
- **Risk**: [What could go wrong]
- **Mitigation**: [How to prevent it]

### Verification
- [ ] Lint passes
- [ ] Types check
- [ ] Manual test: [how to test manually]
- [ ] Edge case: [edge case to verify]
```

---

## When to Use This Template

| Condition | Required? |
|-----------|-----------|
| 1-2 files, trivial change | No |
| 3+ files affected | Yes |
| Database schema change | Yes |
| New API endpoint | Yes |
| Refactoring existing code | Yes |
| User-facing UI change | Yes |
| New dependency required | Yes |

## Plan Before Code Rule

If a plan is required (see table above), you MUST present it BEFORE writing any code.
If the user says "just do it," you may skip plan presentation but still form the plan internally.
