---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing - run the verification and read the output before making any success claim
---

# Verification Before Completion

**Invariant: no completion claim without fresh verification evidence.**

Before reporting progress or completion, audit each claim against a tool
result from this session. Only report work you can point to evidence for; if
something is not yet verified, say so explicitly.

## The Gate

Before claiming any status:

1. Identify the command that proves the claim.
2. Run it fresh and in full.
3. Read the output — exit code, failure counts, warnings.
4. Claim only what the output supports, citing it. If it doesn't support the
   claim, state the actual status instead.

## What counts as evidence

| Claim | Requires |
|-------|----------|
| Tests pass | Test run in this session: 0 failures |
| Build succeeds | Build command: exit 0 (linter passing is not a build) |
| Bug fixed | The original symptom re-tested and passing |
| Regression test works | Seen failing without the fix, passing with it |
| Subagent completed | VCS diff inspected, not just the agent's report |
| Requirements met | Checked line-by-line against the plan or spec |

"Should work", "probably passes", and satisfaction phrases before running
verification are all the same failure: a claim without evidence.

Report outcomes faithfully: if tests fail, say so with the output; if a step
was skipped, say that; when something is done and verified, state it plainly.
If validation cannot be run, explain why and describe the next best check.
