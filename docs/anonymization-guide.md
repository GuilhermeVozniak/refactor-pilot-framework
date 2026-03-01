# Anonymizing Code for External AI Services

When you need to use cloud AI services but your code contains sensitive information, anonymize it first. This guide covers what to sanitize, how to do it, and when to use local models instead.

## What Needs Anonymization

**Always remove before sending to external AI:**
- API keys, tokens, secrets (even in comments or test fixtures)
- Database connection strings
- Internal domain names and URLs
- Customer data, PII, or HIPAA-protected information
- Proprietary algorithm names that reveal business strategy

**Consider anonymizing:**
- Internal service names (replace `payment-gateway-v3` with `service-A`)
- Company-specific naming conventions that could identify the organization
- Internal employee names in comments or git blame
- Business-specific constants (pricing tiers, feature flags)

**Usually safe to keep:**
- Code structure and patterns (these are what AI needs to understand)
- Standard library and framework usage
- Generic variable names and logic
- Open source dependency names

## Anonymization Techniques

### Technique 1: Send Structure, Not Code

Instead of sending actual source code, describe what the code does:

```
Instead of: [actual 200 lines of payment processing code]

Send: "I have a function that:
- Takes a user ID and amount as parameters
- Validates the amount is positive and under a configurable limit
- Calls an external payment API with retry logic (3 attempts)
- Returns a result object with status, transaction ID, and error message
- Has 4 edge cases: expired card, insufficient funds, network timeout, duplicate transaction

How would you refactor this to use async/await and extract the retry logic into a utility?"
```

This gives AI enough context to produce a useful refactoring plan without exposing any proprietary code.

### Technique 2: Find-and-Replace Sanitization

Replace sensitive identifiers systematically:

```bash
# Create a sanitization mapping file
cat > sanitize-map.txt << 'EOF'
AcmeCorp=CompanyX
payment-gateway-v3=service-alpha
STRIPE_SECRET_KEY=API_KEY_PLACEHOLDER
internal.acme.com=api.example.com
calculateMRR=calculateMetricA
EOF

# Apply to a file before sending
cp src/billing.ts src/billing.sanitized.ts
while IFS='=' read -r original replacement; do
  sed -i "s|$original|$replacement|g" src/billing.sanitized.ts
done < sanitize-map.txt
```

Keep the mapping file so you can de-anonymize the AI's output.

### Technique 3: Use the Analysis Outputs

The Phase 1 analysis prompts produce summaries that are already somewhat anonymized — they describe what code does without reproducing it verbatim. Feed AI the summaries instead of the source:

```
Instead of sending: [full source of UserProfileCard.tsx]
Send: [output from prompts/03-file-summary.md for that file]
```

The AI can generate test plans, refactoring strategies, and structural advice from summaries alone.

## When to Just Use Local Models

If anonymization feels like too much overhead, use a local model instead. Good options:

- **Ollama** + Qwen, DeepSeek Coder, or CodeLlama (free, runs on your machine)
- **LM Studio** (GUI-based, easy setup)
- **Enterprise AI services** with contractual data protection (Azure OpenAI, AWS Bedrock)

See [Model Selection Strategy](model-selection-strategy.md) for details on which tasks work well with local models.

## The Hybrid Approach

Use both local and cloud models in the same workflow:

1. **Phase 1 analysis:** Run locally (sensitive code stays on your machine)
2. **Phase 2 planning:** Send anonymized summaries to cloud model for better reasoning
3. **Phase 3 transform:** Run locally (actual code transformation)
4. **Phase 4 verification:** Send anonymized diffs to cloud model for review

This gives you the best reasoning for planning while keeping sensitive code local.
