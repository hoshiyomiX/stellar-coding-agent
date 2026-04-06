# Error Patterns — Sandbox-Specific Errors

Common errors in the z.ai sandbox. This file focuses on platform-specific issues NOT obvious from the error message. Generic TypeScript/React errors are excluded — the LLM already knows those.

---

## Network / Gateway Errors

### `ECONNREFUSED` / `fetch failed`

| Context | Cause | Fix |
|---------|-------|-----|
| API call to own service | Using absolute URL | Change to relative: `/api/...?XTransformPort=...` |
| WebSocket connection | Direct port connection | Change to `io('/?XTransformPort=...')` |
| External API call | No internet or blocked | Use `z-ai-web-dev-sdk` server-side |

### `XTransformPort` related errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| Gateway timeout | Port number wrong or service down | Check service is running, verify port |
| 502 Bad Gateway | Service not started | Start the mini-service |
| Request hits wrong service | Port collision | Use unique port numbers |

### CORS error

| Context | Cause | Fix |
|---------|-------|-----|
| API call returns CORS block | Using absolute URL with `localhost` | Use relative path — Caddy handles CORS |
| Cross-origin fetch to mini-service | Direct port in URL | Use `?XTransformPort=` — same-origin via Caddy |

## Runtime Errors

### `Port 3000 already in use`

| Cause | Fix |
|-------|-----|
| Previous dev server still running | `lsof -ti:3000 \| xargs kill` |

### `PrismaClient not generated`

| Cause | Fix |
|-------|-----|
| Schema changed but not pushed | `bun run db:push` |
| First time setup | `bun run db:push` |

### `Module not found` (after adding dependency)

| Cause | Fix |
|-------|-----|
| Package installed but not in node_modules | `bun install` |
| Typo in package name | Check `package.json` |

### `Prisma unique constraint violation`

| Context | Cause | Fix |
|---------|-------|-----|
| `Unique constraint failed on the fields` | Duplicate insert on unique field | Use `upsert` or check existence first with `findFirst` |

### `TypeError: Cannot read properties of undefined`

| Context | Cause | Fix |
|---------|-------|-----|
| Accessing nested object property | Parent object is null/undefined | Use optional chaining `obj?.prop?.nested` or add null check |
| After `fetch` / API call | Response shape different than expected | Validate response structure before accessing |

## Build / Dev Server Errors

### `Module not found` at build time

| Context | Cause | Fix |
|---------|-------|-----|
| Import path has wrong casing | Linux is case-sensitive | Check file name casing matches import |
| Barrel export missing | New file not added to `index.ts` | Add export to barrel file or use direct import |

### `SyntaxError: Unexpected token`

| Context | Cause | Fix |
|---------|-------|-----|
| Using JSX in `.js` file | File needs `.tsx` extension | Rename to `.tsx` |
| Importing CSS in server component | CSS imports need `'use client'` | Move CSS import to client component or add directive |

## WebSocket Errors

### `socket.io` connection failed

| Cause | Fix |
|-------|-----|
| Using direct URL | Change to `io('/?XTransformPort=<port>')` |
| Service not running | Start the mini-service first |
| Wrong path | Path MUST be `/` for Caddy to forward |

### WebSocket disconnects / reconnect loop

| Cause | Fix |
|-------|-----|
| Mini-service crashed | Check mini-service logs, restart |
| Port mismatch between client and server | Verify same port in `io()` call and server `listen()` |

---

## Debug Flow

When you encounter an error, follow this order:

```
1. Read the error message carefully (don't skim)
2. Check dev.log: tail -50 /home/z/my-project/dev.log
3. Is this a sandbox-specific issue? (localhost, port, XTransformPort, Prisma)
   → YES: Match against patterns in this file
   → NO: Apply standard debugging (type check, syntax, logic)
4. If no match: isolate the error, create minimal reproduction
```
