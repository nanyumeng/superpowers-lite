---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
---

# Dispatching Parallel Agents

Dispatch one agent per independent problem domain and let them work
concurrently. Each agent gets isolated, precisely crafted context — never
your session's history — which keeps it focused and preserves your own
context for coordination.

## When

Use when problems are truly independent: different test files, different
subsystems, no shared state, each understandable without the others.

Don't parallelize when failures are related (fixing one may fix others),
when understanding requires whole-system state, when you don't yet know
what's broken (explore first), or when agents would touch the same files.

## The Pattern

1. **Group by domain.** e.g. tool-approval tests / batch-completion tests /
   abort tests — each independently fixable.
2. **Write one focused prompt per domain.** Each prompt is self-contained:
   the specific scope (one file or subsystem), the goal, the relevant error
   messages or test names pasted in, constraints ("fix tests only, don't
   change production code", "don't just increase timeouts — find the real
   issue"), and the expected output ("return a summary of root cause and
   changes").
3. **Dispatch all in one message.** Multiple subagent calls in the same
   response run in parallel; one per response runs sequentially.
4. **Integrate.** Read each summary, check the changes don't conflict, run
   the full suite, and spot-check — agents can make systematic errors.
