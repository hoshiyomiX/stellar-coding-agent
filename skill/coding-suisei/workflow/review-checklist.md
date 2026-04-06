# Code Review Checklist

Run through this checklist BEFORE delivering any code to the user.

---

## Structure Review

- [ ] **Single Responsibility**: Each function does one thing
- [ ] **No God Functions**: No function exceeds 50 lines
- [ ] **Proper Abstraction**: Shared logic extracted into utilities
- [ ] **File Organization**: Files are in the correct directory
- [ ] **Naming Clarity**: Variable/function names are self-documenting

## Type Safety Review

- [ ] **No `any`**: Zero `any` types in the codebase
- [ ] **Explicit Returns**: All functions have declared return types
- [ ] **Null Safety**: All nullable values properly handled
- [ ] **Type Narrowing**: Unknown types narrowed before use

## Error Handling Review

- [ ] **No Silent Failures**: Every error path is handled or logged
- [ ] **User-Facing Errors**: Error messages are clear and actionable
- [ ] **Boundary Errors**: API/IO boundaries have try-catch
- [ ] **Validation**: Input data is validated before processing

## Security Review

- [ ] **No Secrets**: No hardcoded API keys, tokens, or passwords
- [ ] **No SQL Injection**: Parameterized queries used (if applicable)
- [ ] **No XSS**: User input sanitized before rendering (if applicable)
- [ ] **SDK Backend Only**: `z-ai-web-dev-sdk` only in server-side code

## Performance Review

- [ ] **No Unnecessary Re-renders**: React components memoized if needed
- [ ] **No Memory Leaks**: Event listeners/effects cleaned up
- [ ] **Efficient Queries**: No N+1 queries, proper indexing
- [ ] **Bundle Size**: No importing entire libraries when partial imports work

## Code Cleanliness

- [ ] **No console.log**: All debug logging removed
- [ ] **No Dead Code**: No unused imports, variables, or functions
- [ ] **No Commented Code**: Delete it, git remembers history
- [ ] **Consistent Style**: Formatting matches project conventions

---

## Final Gate

Before delivering, ask yourself:
> "If I received this code as a PR, would I approve it without changes?"

If the answer is no, go back and fix the issues first.
