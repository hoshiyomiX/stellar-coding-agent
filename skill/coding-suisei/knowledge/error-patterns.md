# Error Patterns — Common Errors and Solutions

## Runtime Errors

### `Module not found`
| Context | Cause | Fix |
|---------|-------|-----|
| After new feature | Package not installed | `bun add <package>` |
| After clone | Dependencies not installed | `bun install` |
| Import path typo | Wrong path | Check import matches file location |

### `Port 3000 already in use`
| Cause | Fix |
|-------|-----|
| Previous dev server still running | Kill process: `lsof -ti:3000 \| xargs kill` |
| Another service占用 | Use different port or kill conflicting process |

### `ECONNREFUSED` / `fetch failed`
| Context | Cause | Fix |
|---------|-------|-----|
| API call to own service | Using absolute URL | Change to relative: `/api/...?XTransformPort=...` |
| WebSocket connection | Direct port connection | Change to `io('/?XTransformPort=...')` |
| External API call | No internet or blocked | Use `z-ai-web-dev-sdk` server-side |

### `PrismaClient not generated`
| Cause | Fix |
|-------|-----|
| Schema changed but not pushed | `bun run db:push` |
| First time setup | `bun run db:push` |

### `XTransformPort` related errors
| Symptom | Cause | Fix |
|---------|-------|-----|
| Gateway timeout | Port number wrong or service down | Check service is running, verify port |
| 502 Bad Gateway | Service not started | Start the mini-service |
| Request hits wrong service | Port collision | Use unique port numbers |

## Build/Lint Errors

### `Type 'X' is not assignable to type 'Y'`
| Common Cause | Fix |
|-------------|-----|
| Missing type annotation | Add explicit return type |
| API response shape mismatch | Define interface for response, validate with Zod |
| `any` propagation | Replace `any` with proper type |

### `'X' is defined but never used`
| Fix |
|-----|
| Remove unused import/variable |
| If needed for side effects: `import 'side-effects-package'` |

### `Unexpected token` / Syntax error
| Cause | Fix |
|-------|-----|
| Mixing ESM/CJS | Ensure consistent `import/export` syntax |
| Missing configuration | Check `tsconfig.json` includes the file |

## React Errors

### `Too many re-renders`
| Cause | Fix |
|-------|-----|
| setState in render body | Move to useEffect or event handler |
| Infinite useEffect loop | Fix dependency array |

### `Hydration mismatch`
| Cause | Fix |
|-------|-----|
| Server/client render difference | Move dynamic content to `'use client'` component |
| Date/time rendering | Use `suppressHydrationWarning` or client-only render |

### `Objects are not valid as React child`
| Cause | Fix |
|-------|-----|
| Rendering object directly | Use `JSON.stringify()` or access specific properties |

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
3. Identify the layer: syntax → type → runtime → network
4. Match against patterns in this file
5. If no match: isolate the error, create minimal reproduction
```
