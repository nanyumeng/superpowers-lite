---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
---

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The
reviewer gets precisely crafted context — never your session's history —
which keeps it focused on the work product and preserves your own context.

## When to Request

- After each task in subagent-driven development
- After completing a major feature; before merging to main
- Optionally: when stuck, before a risky refactor, after a complex bug fix

## How to Request

1. Get the range:

```bash
BASE_SHA=$(git rev-parse HEAD~1)   # or origin/main / the task's recorded base
HEAD_SHA=$(git rev-parse HEAD)
```

2. Dispatch a general-purpose subagent using the template at
   [code-reviewer.md](code-reviewer.md), filling `{DESCRIPTION}` (what you
   built), `{PLAN_OR_REQUIREMENTS}` (what it should do), `{BASE_SHA}`,
   `{HEAD_SHA}`.

3. Act on feedback:
   - Critical issues: fix immediately.
   - Important issues: fix before proceeding.
   - Minor issues: note for later.
   - Reviewer wrong? Push back with technical reasoning and evidence
     (code, passing tests); request clarification if ambiguous.
