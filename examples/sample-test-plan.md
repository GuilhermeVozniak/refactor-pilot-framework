# Example: Test Plan Output

> This is a sample output from Phase 2 (Prepare & Create Safety Nets) showing a test plan for a single component. Use it as a reference for the level of detail to aim for.

## Test Plan: UserProfileCard Component

**File:** `src/components/UserProfileCard.tsx`
**Priority:** High (this component is used on 4 pages and will be converted from class to function)

### Behavior Tests (Critical)

```
UserProfileCard
├── Rendering
│   ├── Given: valid user object with all fields
│   │   When: component renders
│   │   Then: displays user name, email, and avatar image
│   │
│   ├── Given: user object with role "admin"
│   │   When: component renders
│   │   Then: displays "Admin" badge next to name
│   │
│   └── Given: user object with role "member"
│       When: component renders
│       Then: does NOT display any role badge
│
├── Interactions
│   ├── Given: component is in edit mode (isEditable=true)
│   │   When: user clicks "Edit Profile" button
│   │   Then: calls onEdit callback with user.id
│   │
│   ├── Given: component is in read-only mode (isEditable=false)
│   │   When: component renders
│   │   Then: "Edit Profile" button is not present
│   │
│   └── Given: component is in edit mode
│       When: user clicks "Delete Account" button
│       Then: shows confirmation dialog before calling onDelete
│
└── Data Loading
    ├── Given: user data is loading (isLoading=true)
    │   When: component renders
    │   Then: displays skeleton placeholder, not user data
    │
    └── Given: user data has loaded (isLoading=false)
        When: component renders
        Then: displays actual user data, no skeleton
```

### Edge Cases (Important)

```
UserProfileCard — Edge Cases
├── Given: user object is null
│   When: component renders
│   Then: displays "User not found" message, does not crash
│
├── Given: user.name is an empty string
│   When: component renders
│   Then: displays "Anonymous User" as fallback
│
├── Given: user.name is 200 characters long
│   When: component renders
│   Then: truncates to 50 characters with ellipsis
│
├── Given: user.avatarUrl is null
│   When: component renders
│   Then: displays default avatar placeholder image
│
├── Given: user.avatarUrl points to a broken image
│   When: image fails to load
│   Then: displays default avatar placeholder (onError handler)
│
└── Given: user.email contains special characters (e.g., "user+tag@domain.com")
    When: component renders
    Then: displays email correctly without encoding issues
```

### Integration Tests (Important)

```
UserProfileCard — Integration
├── Given: component is wrapped in ThemeProvider
│   When: theme changes from light to dark
│   Then: component re-renders with dark theme styles
│
├── Given: component receives updated user prop
│   When: user.name changes
│   Then: component re-renders with new name (no stale data)
│
└── Given: onEdit callback triggers a Redux action
    When: user clicks "Edit Profile"
    Then: Redux store is updated with edit mode for that user
```

### Side Effects (Nice to Have)

```
UserProfileCard — Side Effects
├── Given: component mounts
│   When: user data is available
│   Then: sends analytics event "profile_card_viewed" with user.id
│
└── Given: user clicks "Edit Profile"
    When: onEdit is called
    Then: sends analytics event "profile_edit_started" with user.id
```
