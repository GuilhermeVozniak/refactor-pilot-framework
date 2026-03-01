# Best Practices for AI-Assisted Refactoring

This guide covers the principles and guardrails that make AI-assisted refactoring safe, effective, and repeatable.

## You Are the Reviewer, AI Is the Author

AI can generate code faster than any human and has been exposed to more patterns than any single developer will encounter in a career. But it has no understanding of your business logic, your team's unwritten conventions, or why that one function has a seemingly redundant null check that actually prevents a race condition in production.

Think of AI as a highly productive colleague who is new to your project. It will produce solid work quickly, but every output needs review from someone who knows the codebase, the users, and the constraints that don't exist in documentation.

## The Context Window Is Everything

The quality of AI's output is directly proportional to the quality of context you provide. This is why Phase 1 (Gather Insights) exists — every minute spent building context saves ten minutes of correcting bad output.

**Good context includes:**
- The original source code
- Type definitions and interfaces
- Related utility files
- Test files showing expected behavior
- The refactor plan with explicit goals
- Project conventions and coding standards

**Bad context includes:**
- Entire repository dumps (too much noise)
- Vague instructions ("make this better")
- Conflicting requirements in the same prompt

## Start Small, Build Confidence

Don't start with your most critical production service. Begin with:

1. **Personal projects** — zero risk, maximum learning
2. **Internal tools** — low stakes, real complexity
3. **Non-critical features** — production exposure, manageable blast radius
4. **Core systems** — only after you've built confidence with the process

## Security and Sensitivity

**Code you should NOT send to external AI services:**
- Authentication and authorization logic
- Cryptographic implementations
- Code containing API keys, tokens, or secrets (even in comments)
- Proprietary algorithms that are competitive advantages
- Code covered by NDA or regulatory requirements (HIPAA, SOX, PCI)

**Alternatives for sensitive code:**
- Use local models (Ollama + CodeLlama, LM Studio)
- Use enterprise AI services with data protection agreements
- Anonymize sensitive parts before sending (replace real API names, strip secrets)
- Use the analysis prompts locally and only send sanitized summaries to external AI

## Inspect Every Diff

Before committing AI-generated code, review it with the same rigor you'd apply to any pull request from a new team member.

**Things to watch for:**
- New dependencies added without discussion
- Changed public API signatures
- Removed error handling
- Altered business logic (especially edge cases)
- Performance regressions (e.g., N+1 queries, unnecessary re-renders)
- Security issues (unsanitized inputs, SQL injection vectors)
- Hallucinated imports (packages that don't exist)
- Over-engineering (AI sometimes produces unnecessarily complex solutions)

## Validate Inputs and Outputs

For every module you refactor, verify the contract:

**Input validation:**
- Does the refactored function accept the same parameter types?
- Does it handle null, undefined, empty, and boundary values the same way?
- Does it throw the same errors for invalid inputs?

**Output validation:**
- Does it return the same data structure?
- Does it produce the same results for known inputs?
- Does it maintain the same side effects (API calls, state mutations, events)?

Property-based testing and snapshot testing are valuable tools here.

## Incremental Over Big-Bang

Big-bang refactors (rewriting an entire module at once) are high-risk. Incremental refactoring (one small change at a time, each tested and committed) is safer and easier to review.

**Incremental approach:**
1. Extract one utility function → test → commit
2. Convert one pattern → test → commit
3. Reorganize one file → test → commit
4. Repeat until done

**Benefits:**
- Each commit is small and reviewable
- If something breaks, you know exactly which change caused it
- You can stop at any point and the code is still functional
- Team members can review in parallel

## Branch-Per-Solution Strategy

When a refactoring task has multiple viable approaches, don't debate in a document — prototype each approach in its own branch and compare results.

**The workflow:**

1. Create a branch for each approach: `solution/extract-hooks`, `solution/hoc-pattern`, `solution/render-props`
2. Implement the refactor in each branch (this is where AI speed shines — trying three approaches takes minutes instead of days)
3. Run the test suite and benchmarks on each branch
4. Compare results: code quality, performance, readability, maintainability
5. Merge the winner into your main refactoring branch
6. Keep the other branches around for reference until the refactor ships

**Why this works:** AI makes each attempt cheap. Instead of committing to an approach upfront and discovering problems late, you test multiple approaches early and pick the best one with real data. This is especially valuable for cross-language migrations, where the first approach might compile but produce non-idiomatic code, while a second approach might be cleaner overall.

**Git workflow:**
```bash
# Start from your main refactoring branch
git checkout refactor/user-profile

# Create solution branches
git checkout -b solution/approach-a
# ... implement approach A, run tests, benchmark ...

git checkout refactor/user-profile
git checkout -b solution/approach-b
# ... implement approach B, run tests, benchmark ...

# Compare and merge the winner
git checkout refactor/user-profile
git merge solution/approach-a
```

## Prompt Engineering for Refactoring

**Be specific about what you want:**
```
# Bad
Refactor this code to be better.

# Good
Convert this React class component to a functional component using hooks.
Extract the form validation logic into a separate utility function.
Preserve the existing error handling behavior.
Use the project's existing patterns from utils/validation.ts as a reference.
```

**Provide the "why" alongside the "what":**
```
# Bad
Remove the global variable.

# Good
Remove the global variable `currentUser` because it causes race conditions
when multiple components read and write to it simultaneously. Replace it
with a React Context that provides the user object to the component tree.
```

**Specify output format:**
```
Provide the refactored code with:
- Inline comments explaining non-obvious changes
- A summary of what changed and why
- A list of any new dependencies or types needed
- Notes on any behavior differences from the original
```

## Security as a Refactoring Goal

Refactoring is one of the best opportunities to improve code security — you're already reading and restructuring the code, so fixing security issues along the way costs almost nothing extra.

**Make it part of the workflow, not an afterthought.** Phase 1 should include a security-aware analysis step (see [Phase 1, Step 9](phase-1-gather-insights.md#step-9-security-aware-analysis)). The output feeds into the refactor plan in Phase 2, so security fixes become explicit plan steps with their own tests.

**AI is good at spotting deprecated APIs.** AI models have broad knowledge of API deprecation timelines across languages and frameworks. When you ask AI to explain potential problems with a codebase, it will often surface deprecated functions, unsafe patterns, and known vulnerability classes that a human might miss — especially in languages or frameworks the developer doesn't use daily.

**Common security improvements during refactoring:**
- Replacing deprecated crypto functions with current alternatives
- Adding input validation to functions that accept user data
- Replacing string concatenation with parameterized queries
- Moving hardcoded secrets to environment variables
- Wrapping unsafe operations with proper error handling and bounds checking
- Replacing permissive CORS or access control configurations with restrictive defaults

**Don't try to fix everything at once.** Classify security issues by severity (critical, high, medium, low) and address critical and high issues in the current refactor cycle. Medium and low issues go into the backlog for future work.

## When NOT to Use AI for Refactoring

AI-assisted refactoring isn't always the right tool:

- **Performance-critical hot paths** — AI might produce correct but slower code. Benchmark carefully.
- **Complex algorithmic code** — If the original algorithm is intricate, AI might simplify it incorrectly.
- **Code with undocumented edge cases** — If behavior depends on subtle bugs that users rely on, AI will "fix" them.
- **Cross-system refactors** — If the refactor spans multiple services, databases, and APIs, AI can't see the full picture.
- **Regulatory compliance code** — Code governed by audit requirements needs human review at every step.

In these cases, use AI for analysis and planning (Phases 1-2) but do the transformation (Phase 3) manually.

## Measuring Success

Track these metrics to quantify the impact of your refactoring efforts:

**Code quality:**
- Cyclomatic complexity (before vs. after)
- Duplication percentage
- Test coverage percentage
- Linting warnings count

**Team productivity:**
- Time to understand a module (new developer onboarding)
- Bug fix turnaround time
- Feature development velocity in the refactored area

**Reliability:**
- Production incident rate
- Mean time to recovery (MTTR)
- Error rates in refactored areas

## Code Anonymization for Sensitive Codebases

When working with proprietary or regulated code, you don't have to choose between AI assistance and security. Use these techniques to get AI help without exposing sensitive code.

**Technique 1: Send Structure, Not Code.** Describe what your code does in plain language rather than pasting the source. AI can generate refactoring plans, test strategies, and architecture recommendations from descriptions alone.

**Technique 2: Find-and-Replace Sanitization.** Before sending code to AI, replace proprietary names with generic equivalents — `CompanyAuth` becomes `AuthService`, `SpecialAlgorithm` becomes `processData`. Keep a mapping file locally to reverse the substitution.

**Technique 3: Use Analysis Outputs.** Run Phase 1 analysis locally (with local models or scripts), then send only the generated summaries and metadata to cloud AI for planning. The summaries contain structure and patterns without revealing implementation details.

**Hybrid Local + Cloud Approach.** Use local models (Ollama with Qwen, DeepSeek, or CodeLlama) for code-touching tasks (analysis, transformation) and cloud models for planning tasks that work from summaries. See [Anonymization Guide](anonymization-guide.md) for the complete playbook.

## Model Selection and Cost Optimization

Not every task needs the most powerful (and expensive) model. Match model capability to task complexity.

**Planning tasks** (requirements, refactor plans, architecture decisions) benefit from the strongest models available — Claude Opus, GPT-4, or equivalent. These tasks are high-leverage: a good plan saves hours of rework. The cost of one premium API call is trivial compared to the time saved.

**Execution tasks** (generating test code, applying straightforward pattern conversions, formatting) can use faster and cheaper models — Claude Haiku, GPT-4o-mini, or local models. These are repetitive tasks with clear instructions where speed and cost matter more than nuance.

**Analysis tasks** fall in between. File-by-file analysis can use mid-tier models, but the final project summary synthesis benefits from a stronger model.

See [Model Selection Strategy](model-selection-strategy.md) for token estimates per task and specific model recommendations.

## Creating Domain-Expert Skills

The most effective AI refactoring skills encode domain-specific knowledge. A generic "refactor this React code" prompt produces decent results, but a skill that knows your team's conventions, preferred patterns, and common pitfalls produces great results.

**Who should create skills?** The senior engineers and domain experts on your team. They know the patterns that work, the mistakes that keep happening, and the standards that matter. A skill captures that knowledge in a reusable format.

**Quick decision trees** at the top of a skill help AI make the right choices fast — "If the component uses class state, convert to useState. If it uses lifecycle methods, convert to useEffect. If it manages form state, consider useReducer."

**Progressive disclosure** keeps skills readable. Put the core workflow (under 200 lines) in `SKILL.md` and supporting detail in a `references/` folder. See [Creating Domain Skills](creating-domain-skills.md) for the full guide.

## The Refactoring Mindset

Refactoring is not a one-time project. It's an ongoing practice. Every sprint, every feature, every bug fix is an opportunity to leave the code a little better than you found it.

AI makes this practice dramatically faster. Use it.
