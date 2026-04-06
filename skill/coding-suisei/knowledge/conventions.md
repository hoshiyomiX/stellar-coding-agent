# Code Conventions — Platform-Specific

This file covers conventions specific to the z.ai sandbox environment. Standard best practices (naming, basic TypeScript) are not repeated here.

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

## Import Order

Strict import ordering within every file:

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

## CSS/Styling

- Use Tailwind CSS utility classes
- Use shadcn/ui components (they exist in `src/components/ui/`)
- No custom CSS files unless absolutely necessary
- Avoid indigo/blue colors unless user requests them
- Always use responsive prefixes: `sm:`, `md:`, `lg:`, `xl:`

## TypeScript

- Prefer `unknown` over `any` — narrow with type guards
- Prefer interfaces for object shapes, types for unions
- Use `import type` for type-only imports
