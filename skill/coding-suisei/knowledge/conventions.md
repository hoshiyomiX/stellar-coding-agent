# Code Conventions

## Naming

| Element | Convention | Example |
|---------|-----------|---------|
| Files (components) | PascalCase.tsx | `UserDashboard.tsx` |
| Files (utilities) | camelCase.ts | `formatDate.ts` |
| Files (constants) | camelCase.ts | `apiRoutes.ts` |
| React components | PascalCase | `export function UserProfile` |
| Utility functions | camelCase | `export function formatDate` |
| Constants | UPPER_SNAKE | `const MAX_RETRIES = 3` |
| Types/Interfaces | PascalCase | `interface UserProfile` |
| Boolean variables | `is`/`has`/`should` prefix | `isLoading`, `hasError` |
| Event handlers | `handle` prefix | `handleClick`, `handleSubmit` |

## File Organization

### Component Files

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

### Import Order (Strict)

```typescript
// 1. React/Next.js
import { useState, useEffect } from 'react';

// 2. External packages
import { z } from 'zod';
import { motion } from 'framer-motion';

// 3. Internal packages (@/ paths)
import { db } from '@/lib/db';
import { Button } from '@/components/ui/button';

// 4. Relative imports
import { formatDate } from './utils';

// 5. Types (always last, use `import type`)
import type { User } from '@/types';
```

## TypeScript Patterns

### Prefer interfaces for objects, types for unions

```typescript
// DO: interface for object shapes
interface User {
  id: string;
  name: string;
  email: string;
}

// DO: type for unions or intersections
type Status = 'active' | 'inactive' | 'suspended';
type ApiResponse<T> = Success<T> | Error;
```

### Prefer `unknown` over `any`

```typescript
// DON'T
function parse(data: any) { }

// DO
function parse(data: unknown) {
  if (typeof data === 'string') { }
}
```

## React Patterns

### 'use client' and 'use server'

- Components using hooks → `'use client'`
- Server-only functions → `'use server'`
- Components with no hooks → can be server components (default)

### State Management

- Local UI state → `useState`
- Shared client state → Zustand store
- Server state → TanStack Query
- Form state → React Hook Form + Zod validation

## CSS/Styling

- Use Tailwind CSS utility classes
- Use shadcn/ui components (they exist in `src/components/ui/`)
- No custom CSS files unless absolutely necessary
- Avoid indigo/blue colors unless user requests them
- Always use responsive prefixes: `sm:`, `md:`, `lg:`, `xl:`
