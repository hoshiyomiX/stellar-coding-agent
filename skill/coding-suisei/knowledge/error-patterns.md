# Error Patterns — Sandbox-Specific Errors

Common errors in the z.ai sandbox environment. This file focuses on platform-specific issues that are NOT obvious from the error message alone. Generic TypeScript/React errors are excluded — the LLM already knows those.

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

## Runtime Errors

### `Port 3000 already in use`

| Cause | Fix |
|-------|-----|
| Previous dev server still running | Kill process: `lsof -ti:3000 \| xargs kill` |

### `PrismaClient not generated`

| Cause | Fix |
|-------|-----|
| Schema changed but not pushed | `bun run db:push` |
| First time setup | `bun run db:push` |

### `Module not found` (after adding dependency)

| Cause | Fix |
|-------|-----|
| Package installed but not in node_modules | `bun install` |

## WebSocket Errors

### `socket.io` connection failed

| Cause | Fix |
|-------|-----|
| Using direct URL | Change to `io('/?XTransformPort=<port>')` |
| Service not running | Start the mini-service first |
| Wrong path | Path MUST be `/` for Caddy to forward |

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
