# GymCoach AI — AI Design

## Principles

1. AI has **no** unrestricted DB access and **never** writes DB directly.
2. AI receives **summarized training context** from `TrainingContextBuilder` / `CoachService` only.
3. Machine-consumed output is **structured** and schema-validated.
4. Recommendations pass **TrainingPolicyValidator** before final decision.
5. Nutrition questions are refused.
6. Runtime AI is optional; `TrainingEngineOnlyAiProvider` / `FakeAiCoachClient` used when disabled or on failure.

## Pipeline

```text
Database
  → Training metrics / Training Engine
  → TrainingContextBuilder (+ CoachService enrichment)
  → ITrainingAiProvider (OpenAI or Training Engine)
  → StructuredRecommendationDto
  → TrainingPolicyValidator
  → ProgramDecision audit (+ optional apply)
```

Deterministic engines remain authoritative for e1RM, PRs, progressive overload, and simple next-load math. OpenAI is **not** called after every set or weight change.

## Provider selection

| Condition | Provider |
|-----------|----------|
| `OpenAI.Enabled`/`Ai.Enabled` + API key + model | `OpenAiTrainingProvider` |
| Otherwise or request failure | `TrainingEngineOnlyAiProvider` / fake client |

## Structured recommendation schema

```json
{
  "decision": "CONTINUE",
  "scope": "PROGRAM",
  "confidence": 0.91,
  "reason": "Overall strength progression remains positive.",
  "evidence": ["Bench e1RM increased 4.3% over 6 exposures"],
  "exerciseId": null,
  "replacementExerciseId": null,
  "changes": []
}
```

Allowed decisions: `CONTINUE`, `PROGRESS_LOAD`, `PROGRESS_REPS`, `REDUCE_LOAD`, `REDUCE_VOLUME`, `INCREASE_VOLUME`, `CHANGE_REP_RANGE`, `REPLACE_EXERCISE`, `DELOAD`, `PROGRAM_ADJUSTMENT`, `NEW_PROGRAM`.

Allowed scopes for analysis: `EXERCISE`, `WORKOUT`, `PROGRAM` (`SET` rejected).

## Coach Q&A

- Endpoint: `POST /api/coach/ask`
- Context is question-relevant (e.g. Bench history for Bench questions — not full leg history).
- Response includes `answer`, `source` (`OPENAI` | `TRAINING_ENGINE`), `confidence`.
- System prompts are versioned in `CoachSystemPrompts` (`coach-v1`).

## Invocation triggers

1. User asks Coach a question.
2. Explicit `POST /api/coach/evaluate`.
3. After workout completion **only if** deterministic signals show plateau, multi-lift decline, fatigue, or adjustment need.

## Cost controls

- Max recent exposures window (default 6)
- Trimmed key-lift summaries
- Short system prompts + max tokens
- No AI for PR / e1RM / simple overload math
- Bounded retries for transient failures only

## Audit / observability

Persisted: `AIAnalysis`, `AIRecommendation`, `ProgramDecision` with provider, model, prompt version, fingerprint, structured response, policy result.

Logged: request id, operation, model, duration, token usage, fallback — **never** API keys.

## Configuration

See [openai-setup.md](openai-setup.md).
