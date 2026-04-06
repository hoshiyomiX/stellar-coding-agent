# Code Review Checklist

Run through this checklist BEFORE delivering any code. Focus on items that are commonly violated or platform-specific — skip items you're already confident about.

---

## Critical Checks

- [ ] **No `any` type** — use `unknown` + type guards instead
- [ ] **Explicit return types** on all functions
- [ ] **No console.log** in delivered code
- [ ] **SDK backend only** — `z-ai-web-dev-sdk` never in client components
- [ ] **No dead code** — no unused imports, variables, or functions
- [ ] **Error paths handled** — no silent try-catch, no unhandled promises

## Structure Checks

- [ ] **Single responsibility** — each function does ONE thing
- [ ] **No function > 50 lines** — split if longer
- [ ] **Imports ordered** — React → External → Internal → Relative → Types

## Platform Checks (Web Dev Only)

- [ ] **No absolute URLs** — use `?XTransformPort=` for cross-service
- [ ] **No localhost in output** — use Preview Panel or preview link
- [ ] **All UI in `src/app/page.tsx`** — user only sees `/` route

---

## Final Gate

> "If I received this code as a PR, would I approve it without changes?"

If no, go back and fix the issues first.
