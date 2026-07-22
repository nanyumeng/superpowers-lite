---
name: systematic-debugging
description: Use for complex or recurring bugs - a first fix attempt failed, the cause spans components, or the same symptom keeps returning; for simple failures with an obvious cause, fix and verify directly
---

# Systematic Debugging

Find the root cause before proposing fixes. Symptom patches waste time and
create new bugs. Work through the four phases in order; return to Phase 1
whenever a fix fails.

## Phase 1: Root Cause Investigation

- Read the error output completely — messages, stack traces, line numbers.
  They often contain the answer.
- Reproduce consistently. If you can't, gather more data before guessing.
- Check what changed: recent commits, dependencies, config, environment.
- In multi-component systems (CI → build → sign; API → service → DB), add
  instrumentation at each boundary and run once to see which layer breaks,
  then investigate that layer — don't guess across layers.
- For errors deep in a call stack, trace the bad value backward to its
  origin and fix at the source (see `root-cause-tracing.md`).

## Phase 2: Pattern Analysis

- Find similar working code in the same codebase and list every difference
  from the broken path — don't assume "that can't matter."
- When implementing a known pattern, read the reference implementation
  fully before adapting it.

## Phase 3: Hypothesis and Test

- State one specific hypothesis: "X is the root cause because Y."
- Test it with the smallest possible change, one variable at a time.
- Confirmed → Phase 4. Refuted → new hypothesis; don't stack more changes
  on top. If you don't understand something, say so and investigate or ask.

## Phase 4: Fix

- Write a failing test reproducing the bug first
  (superpowers:test-driven-development), then fix the root cause — one
  change, no bundled refactoring.
- Verify: the new test passes, the rest of the suite still passes, the
  original symptom is gone (superpowers:verification-before-completion).

## Stop Rule: 3 Failed Fixes = Architecture Problem

If three or more fixes have failed — each revealing new coupling or new
symptoms elsewhere — stop fixing. The pattern itself is likely wrong.
Present the evidence to your human partner and discuss whether to refactor
the architecture rather than attempt fix #4.

## When Investigation Finds No Root Cause

If the issue is genuinely environmental or timing-dependent: document what
you investigated, implement appropriate handling (retry, timeout, clear
error), and add logging for the future. Most "no root cause" conclusions
are incomplete investigation — check Phase 1 again before settling.

## Supporting References (this directory)

- `root-cause-tracing.md` — trace bugs backward through the call stack
- `defense-in-depth.md` — layered validation after the root cause is found
- `condition-based-waiting.md` — replace arbitrary timeouts with condition polling
