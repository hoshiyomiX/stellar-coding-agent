# Quality Gates — Mandatory Coding Constraints

These are NOT suggestions. These are hard constraints that MUST be followed for every coding task.

---

## Function Constraints

- **Single Responsibility**: Each function does exactly ONE thing. If a function does two things, split it.
- **Maximum Length**: Functions should be under 50 lines. If longer, refactor into smaller functions.
- **No Magic Numbers**: Use named constants. `if (retries < 3)` → `if (retries < MAX_RETRIES)`
- **Error Handling**: Every function that can fail MUST handle errors. No silent failures.

## Type Constraints

- **No `any`**: Never use `any` type in TypeScript. Use `unknown` if truly unknown, then narrow.
- **Explicit Returns**: All functions must have explicit return types declared.
- **Null Safety**: Always handle null/undefined cases. Use optional chaining (`?.`) and nullish coalescing (`??`).

## File Constraints

- **One Export Pattern**: Use named exports. Default exports only for page components.
- **Co-located Types**: Types used by one file stay in that file. Shared types go in a `types.ts` file.
- **No Circular Imports**: If A imports B, B must not import A.

## Code Smell Ban List

These patterns are FORBIDDEN:

```
❌ console.log in production code
❌ try-catch that swallows errors silently
❌ Callback hell (nesting > 3 levels — use async/await)
❌ Copy-pasted logic (extract to shared function)
❌ Commented-out code blocks (delete it, git remembers)
❌ TODO comments without a ticket/context reference
❌ Hardcoded strings that should be constants
❌ Boolean parameters (use options object or enum instead)
```

## Import Order

Strict import ordering within every file:

```
1. External packages (react, zod, etc.)
2. Internal packages (@/lib, @/components)
3. Relative imports (./sibling, ../parent)
4. Types (import type)
```

---

## Gate Enforcement

Before delivering any code, verify against this checklist:

- [ ] No function exceeds 50 lines
- [ ] No `any` type used
- [ ] All functions have explicit return types
- [ ] All error paths handled
- [ ] No console.log statements
- [ ] No circular imports
- [ ] Imports ordered correctly
- [ ] No magic numbers
