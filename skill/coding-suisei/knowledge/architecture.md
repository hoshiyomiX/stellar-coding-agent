# Project Architecture

## Environment Overview

This project runs in a **restricted cloud sandbox** with specific constraints. Understanding these constraints is critical for writing code that actually works.

### Key Facts

- **OS**: Linux container with limited package availability
- **Runtime**: Bun (not Node.js) — use `bun` commands, not `npm` or `npx`
- **Framework**: Next.js 16 with App Router (when building web apps)
- **Language**: TypeScript 5 (strict mode)
- **Single Port Exposure**: Only one port accessible externally (gateway via Caddy)

### Directory Layout

```
/home/z/my-project/          # Project root
├── src/                     # Application source
│   ├── app/                 # Next.js App Router pages
│   │   └── page.tsx         # Main page (only user-visible route)
│   ├── components/          # React components
│   │   └── ui/              # shadcn/ui components (pre-installed)
│   ├── lib/                 # Utility functions and configurations
│   └── hooks/               # Custom React hooks
├── prisma/                  # Database schema
│   └── schema.prisma        # Prisma schema (SQLite)
├── mini-services/           # Standalone services (websocket, etc.)
├── public/                  # Static assets
├── package.json             # Dependencies
└── dev.log                  # Development server log
```

### Important Constraints

| Constraint | Details |
|-----------|---------|
| User sees only `/` route | All UI must be in `src/app/page.tsx` |
| No `bun run build` | Only dev server on port 3000 |
| Relative API paths only | Use `?XTransformPort=` for cross-service |
| SDK backend only | `z-ai-web-dev-sdk` never in client code |
| No localhost in output | Use Preview Panel or preview link |

### Service Communication

```
User Browser
    │
    ▼
Caddy Gateway (port 80/443 — only exposed port)
    │
    ├── / ──────────→ Next.js (port 3000)
    └── /?XTransformPort=3003 → Mini Service (port 3003)
```
