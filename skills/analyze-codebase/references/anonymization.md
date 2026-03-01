# Code Anonymization for Sensitive Codebases

When analyzing proprietary or regulated code, use these strategies to get AI assistance
without exposing sensitive information.

## Strategy 1: Send Structure, Not Code

Describe what your code does in plain language:
- "This module handles user authentication via OAuth2 with Google and GitHub providers"
- "This utility formats currency values for 12 different locales"

AI can generate analysis, refactoring plans, and test strategies from descriptions alone.

## Strategy 2: Find-and-Replace Sanitization

Before sending code to AI:
1. Replace company-specific names: `AcmeAuth` → `AuthService`
2. Replace proprietary algorithm names: `QuantumSort` → `customSort`
3. Strip API keys, tokens, and secrets
4. Replace real endpoint URLs with placeholders
5. Keep a local mapping file to reverse substitutions

## Strategy 3: Use Local Models

Run analysis locally with Ollama:
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a code-capable model
ollama pull qwen2.5-coder:7b

# Use for analysis (via API or CLI)
ollama run qwen2.5-coder:7b "Analyze this code for refactoring opportunities: ..."
```

Good local models for code analysis: Qwen 2.5 Coder (7B/14B), DeepSeek Coder V2,
CodeLlama (13B/34B).

## Hybrid Approach

1. Run Phase 1 analysis locally (code stays on your machine)
2. Send only the generated summaries to cloud AI for planning
3. Use cloud AI to generate the refactor plan (no code needed)
4. Execute Phase 3 transformations locally

This gives you the best of both worlds: powerful cloud models for high-level planning,
local models for anything that touches actual code.
