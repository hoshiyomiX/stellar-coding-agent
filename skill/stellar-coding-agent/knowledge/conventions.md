# Code Conventions — Platform-Specific

Standard best practices (PascalCase, camelCase, basic TypeScript) are NOT repeated here — the LLM already knows them. This file covers only conventions specific to the z.ai sandbox.

## State Management Routing

| Need | Solution |
|------|----------|
| Local UI state | `useState` |
| Shared client state | Zustand store (`/stores/`) |
| Server state / data fetching | TanStack Query |
| Form state | React Hook Form + Zod validation |

## Import Order

Strict ordering within every file:

```typescript
// 1. React/Next.js
import { useState, useEffect } from 'react';

// 2. External packages
import { z } from 'zod';

// 3. Internal (@/ paths)
import { db } from '@/lib/db';
import { Button } from '@/components/ui/button';

// 4. Relative imports
import { formatDate } from './utils';

// 5. Types (always last, use `import type`)
import type { User } from '@/types';
```

## File Organization

```typescript
// Order within a component file:
// 1. Imports
// 2. Types/Interfaces
// 3. Constants
// 4. Helper functions
// 5. Main component
// 6. Sub-components
// 7. Export
```

## Platform-Specific Rules

- **Styling**: Use shadcn/ui components from `src/components/ui/` — do NOT build from scratch
- **Colors**: Avoid indigo/blue unless user explicitly requests
- **TypeScript**: Use `unknown` over `any` — narrow with type guards. Use `import type` for type-only imports
- **Server/Client split**: Hooks → `'use client'`, server-only logic → `'use server'`, no hooks → server component (default)
