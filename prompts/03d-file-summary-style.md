# Prompt: Analyze Style File

> **Phase:** 1 — Gather Insights
> **Purpose:** Specialized analysis for CSS, SCSS, and style files.
> **Input:** Source code of a stylesheet

## The Prompt

```
Analyze this stylesheet and produce a structured summary:

1. **File Purpose** (one sentence)
   What does this stylesheet target? Which component(s) or page(s)?

2. **Styling Approach**
   - Plain CSS, SCSS/Sass, Less, CSS Modules, CSS-in-JS?
   - Scoped to a component or global?
   - Uses CSS custom properties (variables)?
   - Uses a utility framework (Tailwind) or custom classes?

3. **Selector Analysis**
   - Total number of selectors (approximate)
   - Deepest nesting level
   - Any ID selectors (specificity issues)?
   - Any !important declarations (count them)
   - Any overly broad selectors (*, div, p without scoping)

4. **Layout Patterns**
   - Uses Flexbox, Grid, or older float/position patterns?
   - Responsive breakpoints present?
   - Any fixed pixel values that should be relative?

5. **Specificity Issues**
   - !important count and which properties they override
   - High-specificity selectors that could cause cascade conflicts
   - Styles that depend on DOM order or parent context

6. **Maintainability Concerns**
   - Duplicated property groups (same margin/padding/color in multiple places)
   - Magic numbers (arbitrary pixel values without explanation)
   - Colors defined inline instead of using variables/tokens
   - Media queries scattered vs. organized
   - Dead selectors (targeting elements that no longer exist)

7. **Refactoring Opportunities**
   Suggest 1-3 specific actions (e.g., extract design tokens, convert to CSS modules,
   replace !important with proper specificity, add responsive breakpoints).

---

FILE: [[FILE_PATH]]

```css
[[FILE_CONTENT]]
```
```
