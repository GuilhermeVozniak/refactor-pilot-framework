# Model Selection Strategy

AI-assisted refactoring isn't one-size-fits-all when it comes to model choice. Different phases and tasks have different requirements for context window size, reasoning depth, and cost. This guide helps you pick the right model for each step.

## The Core Tradeoff

**Expensive models** (Claude Opus, GPT-4, GPT-5) give you better reasoning, fewer errors, and larger context windows. Use them where quality matters most and the task runs once.

**Cheaper models** (Claude Haiku, GPT-3.5, local models) are faster, cheaper, and good enough for repetitive or well-constrained tasks. Use them where you're iterating many times.

**Local models** (Ollama + Qwen, LLaMA, CodeLlama, DeepSeek) keep your code on your machine. Use them when code is sensitive or when you need to process many files at low cost.

## Model Selection by Phase

### Phase 1: Gather Insights

| Task | Recommended Model | Why |
|------|-------------------|-----|
| Per-file analysis (small files) | Local model (Ollama) | Runs hundreds of times; cost adds up with cloud models. Context needs are small (single file). |
| Per-file analysis (large files) | Mid-tier cloud model | Files over 500 lines may exceed local model context. |
| File structure mapping | Script (no model needed) | Pure file system traversal. |
| Project metadata extraction | Script (no model needed) | JSON/TOML parsing. |
| Full codebase summary | Top-tier cloud model | Needs large context window to synthesize metadata + file structure + all summaries at once. |

### Phase 2: Prepare & Create Safety Nets

| Task | Recommended Model | Why |
|------|-------------------|-----|
| Test plan generation | Top-tier cloud model | Planning requires deep reasoning. Run once. Worth the cost. |
| Test code generation | Mid-tier cloud model | More mechanical; mid-tier models generate competent test code. |
| Refactor plan creation | Top-tier cloud model | Critical planning step. One mistake here cascades through Phase 3. |

### Phase 3: Transform

| Task | Recommended Model | Why |
|------|-------------------|-----|
| Utility extraction | Mid-tier cloud model | Well-constrained task with clear inputs/outputs. |
| Pattern conversion | Mid-tier cloud model | Pattern conversions are well-documented; models handle them reliably. |
| Complex refactoring | Top-tier cloud model | If the refactor involves architectural changes or subtle logic, use the best model. |
| Import path updates | Cheaper model or script | Mechanical find-and-replace. |

### Phase 4: Verify & Deploy

| Task | Recommended Model | Why |
|------|-------------------|-----|
| Verification checklist | Mid-tier cloud model | Generating checklists is straightforward. |
| Diff review assistance | Top-tier cloud model | Catching subtle bugs in diffs requires strong reasoning. |

## Planning vs. Execution Pattern

A cost-effective strategy used by experienced practitioners:

1. **Plan with the best model available.** Use Claude Opus, GPT-4, or GPT-5 for Phase 1 summary, Phase 2 planning, and Phase 3 complex decisions. These run once and set the direction.

2. **Execute with cheaper models.** Use Claude Haiku, GPT-3.5, or local models for repetitive tasks: per-file analysis, test generation, mechanical pattern conversion. These run many times and cost adds up.

3. **Review with the best model.** After execution, use a top-tier model to review the diffs and catch issues the cheaper model might have introduced.

**Example cost comparison for a 50-file refactor:**

```
Strategy A: Use GPT-4 for everything
  50 file analyses × $0.10 = $5.00
  Planning + transforms  = $3.00
  Total: ~$8.00

Strategy B: Local for analysis, GPT-4 for planning, Haiku for execution
  50 file analyses (local) = $0.00
  Planning (GPT-4)         = $1.00
  Transforms (Haiku)       = $0.50
  Review (GPT-4)           = $0.50
  Total: ~$2.00
```

## Using Local Models

Local models keep sensitive code on your machine. Setup with Ollama:

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a code-focused model
ollama pull qwen2.5-coder:7b    # Good for per-file analysis
ollama pull deepseek-coder:6.7b # Alternative
ollama pull codellama:13b        # Larger, more capable

# Use in scripts via the Ollama API
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen2.5-coder:7b", "prompt": "Analyze this file..."}'
```

**When to use local models:**
- Per-file analysis (small context, many calls)
- Code contains proprietary logic, secrets, or PII
- You're on a metered internet connection
- You want reproducible results (same model version)

**When NOT to use local models:**
- Full codebase summary (context window too small)
- Complex refactoring plans (reasoning quality matters)
- You need the latest model capabilities

## Context Window Considerations

Different tasks require different context sizes:

| Task | Typical Context Needed | Minimum Model Context |
|------|------------------------|----------------------|
| Single file analysis | 2-8K tokens | 4K (any model) |
| Multi-file analysis | 10-30K tokens | 32K |
| Full project summary | 30-100K tokens | 128K |
| Refactor plan + source + tests | 20-50K tokens | 64K |
| Transform with full context | 30-80K tokens | 128K |

If your project summary exceeds the model's context window, split it into sections and summarize incrementally (summarize groups of files, then summarize the summaries).
