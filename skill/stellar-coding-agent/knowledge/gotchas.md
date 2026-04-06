# Platform Gotchas

Things that look normal but behave differently in this environment. Read this before debugging.

---

## Sandbox Environment

| Issue | What You Expect | What Actually Happens |
|-------|----------------|----------------------|
| `localhost:3000` | User can access it | User CANNOT access it — only Preview Panel works |
| `bun run build` | Production build | NOT supported — only dev server |
| Multiple ports | Expose each service | Only ONE port exposed via Caddy gateway |
| Absolute API URLs | `fetch('http://localhost:3001/api')` | FORBIDDEN — must use relative + `?XTransformPort=3001` |
| WebSocket direct connect | `io('ws://localhost:3003')` | FORBIDDEN — must use `io('/?XTransformPort=3003')` |

## Gateway Routing

### Caddy is the ONLY external entry point

All requests go through Caddy. This means:
- External users only see ports 80/443
- Internal services must be accessed via Caddy's routing
- Cross-service requests use `?XTransformPort=` query parameter

### Correct API Request Pattern

```typescript
// CORRECT
fetch('/api/users?XTransformPort=3001')

// WRONG — will fail in sandbox
fetch('http://localhost:3001/api/users')
```

### Correct WebSocket Pattern

```typescript
// CORRECT
const socket = io('/?XTransformPort=3003');

// WRONG — will fail in sandbox
const socket = io('http://localhost:3003');
```

## Next.js Specifics

| Quirk | Detail |
|-------|--------|
| Single route | User only sees `/` — put ALL UI in `src/app/page.tsx` |
| No route files | Do NOT create `src/app/about/page.tsx` — user can't see it |
| Auto dev server | `bun run dev` runs automatically — do NOT run it manually |
| Dev log | Check `/home/z/my-project/dev.log` for errors |
| z-ai-web-dev-sdk | MUST be in backend/server code only — NEVER in client components |

## Filesystem

| Quirk | Detail |
|-------|--------|
| `/home/z/my-project/` | Project root — always use absolute paths |
| `skills/` persists | Files in `skills/` survive between sessions |
| `download/` may persist | But not guaranteed — use `skills/` for persistence |
| `/tmp/` | Session-scoped — cleaned up between sessions |

## Prisma

| Quirk | Detail |
|-------|--------|
| SQLite only | No MySQL/PostgreSQL — only SQLite client |
| Schema push | Use `bun run db:push` (not `migrate`) |
| DB client import | `import { db } from '@/lib/db'` |
| List types | Prisma scalar types CANNOT be lists |

## Common Pitfalls

1. **Forgetting `?XTransformPort=`** — causes "network error" that looks like a code bug
2. **Using `npm` instead of `bun`** — packages install but scripts may behave differently
3. **Creating new route files** — user can't access them, wastes effort
4. **SDK in client code** — causes build/runtime errors
5. **Assuming filesystem persists** — only `skills/` directory persists between sessions
