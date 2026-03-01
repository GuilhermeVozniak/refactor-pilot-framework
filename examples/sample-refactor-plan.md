# Example: Refactor Plan Output

> This is a sample output from Phase 2 (Prepare & Create Safety Nets) showing a detailed refactoring plan for a single component. Use it as a reference for planning your own refactors.

## Refactor Plan: UserProfileCard

### Goal

Convert `UserProfileCard` from a React class component with lifecycle methods to a functional component with hooks. Extract shared validation logic into a utility module. Add TypeScript types for all props and internal state.

### Current State

- Class component with `componentDidMount`, `componentDidUpdate`, `shouldComponentUpdate`
- Inline validation logic (email regex, name length check)
- Props typed with `any`
- Direct Redux `connect()` usage
- 312 lines in a single file

### Target Structure

```
src/components/UserProfile/
├── UserProfileCard.tsx          # Functional component (≈120 lines)
├── UserProfileCard.test.tsx     # Tests from Phase 2
├── useUserProfile.ts            # Custom hook for data & state logic
├── userProfile.types.ts         # TypeScript interfaces
└── index.ts                     # Barrel export
src/utils/
└── validation.ts                # Extracted validation utilities
```

### Step-by-Step Changes

**Step 1: Extract validation utilities** (Risk: Low)
- Create `src/utils/validation.ts`
- Move email validation regex and name length check from `UserProfileCard`
- Export: `validateEmail(email: string): boolean`
- Export: `validateDisplayName(name: string): { valid: boolean; error?: string }`
- Update `UserProfileCard` to import from the new utility file
- Tests to pass: existing component tests + new validation unit tests

**Step 2: Create TypeScript interfaces** (Risk: Low)
- Create `src/components/UserProfile/userProfile.types.ts`
- Define `UserProfileProps` interface (replacing `any`)
- Define `UserProfileState` interface
- Define `User` interface (if not already in a shared types file)
- Update `UserProfileCard` to use new types
- Tests to pass: type checking (`tsc --noEmit`)

**Step 3: Create custom hook** (Risk: Medium)
- Create `src/components/UserProfile/useUserProfile.ts`
- Move state management logic from the class into the hook
- Move `componentDidMount` data fetching into `useEffect`
- Move `shouldComponentUpdate` logic into `useMemo`
- Replace Redux `connect()` with `useSelector` and `useDispatch`
- Export: `useUserProfile(userId: string): UserProfileHookReturn`
- Tests to pass: all existing component tests

**Step 4: Convert class to function component** (Risk: Medium)
- Rewrite `UserProfileCard` as a function component
- Use `useUserProfile` hook for data and state
- Use imported validation utilities
- Destructure props with TypeScript types
- Remove class syntax, `this` references, lifecycle methods
- Tests to pass: all existing component tests

**Step 5: Create barrel export and update imports** (Risk: Low)
- Create `src/components/UserProfile/index.ts`
- Update all files that import `UserProfileCard` to use the new path
- Verify no broken imports
- Tests to pass: full project build + all tests

**Step 6: Clean up** (Risk: Low)
- Remove old single-file `UserProfileCard.tsx`
- Remove any unused imports in consuming files
- Add JSDoc comments to the hook and utility functions
- Tests to pass: all tests + lint clean

### Breaking Changes

None. The component's public API (props and behavior) remains identical. Consumers import from the same path (via barrel export).

### New Dependencies

None. All changes use React built-in hooks and existing project dependencies.

### Risk Assessment

| Step | Risk | What Could Go Wrong | Detection | Rollback |
|------|------|---------------------|-----------|----------|
| 1 | Low | Validation logic subtly different | Unit tests on validation | Revert commit |
| 2 | Low | Type errors in consumers | `tsc --noEmit` | Revert commit |
| 3 | Medium | Hook lifecycle differs from class lifecycle | Component tests, manual testing | Revert commit |
| 4 | Medium | Rendering behavior changes | Component tests, visual testing | Revert commit |
| 5 | Low | Broken imports | Build step | Revert commit |
| 6 | Low | Accidentally remove needed code | Full test suite | Revert commit |
