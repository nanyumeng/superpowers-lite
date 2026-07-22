---
name: brainstorming
description: Use when starting a new feature or the scope is ambiguous - research-first design that explores context and mature solutions, recommends an approach, clarifies open decisions in one batch, and produces a spec
---

# Brainstorming Ideas Into Designs

Turn an idea into a validated design by doing the research yourself first,
then bringing the user a recommendation and the few decisions only they can
make. Spend model time on investigation; spend user time on decisions.

## When to Skip

Skip this process when the user says so, or for typo/docs/config/single-file
changes with clear success criteria — implement those directly with TDD and
verification. New features, cross-module work, and ambiguous scope get a
design first, written to the spec path below.

If the request spans multiple independent subsystems, propose a decomposition
first; each sub-project then gets its own spec → plan → implementation cycle.

## The Process

1. **Research before asking.** Explore the current project (files, docs,
   recent commits, existing patterns and constraints). For problems with
   established solutions, search for mature approaches and comparable
   products; note one or two references worth borrowing from. If the codebase
   or prior docs answer a question, use that instead of asking.

2. **Propose 2-3 approaches.** Lead with your recommendation and the
   reasoning; list trade-offs for the alternatives. Give a recommendation,
   not an exhaustive survey.

3. **Clarify in one batch.** Collect the decisions only the user can make —
   goal trade-offs, scope boundaries, preferences — and ask them together in
   a single message, as multiple-choice where possible. Do not drip one
   question per message. A short follow-up round is fine if answers open new
   decisions.

4. **Present the design.** Scale it to complexity: a few sentences for simple
   work, a structured summary (architecture, components, data flow, error
   handling, testing) for nuanced work. One approval for the whole design;
   revise where the user pushes back.

5. **Write the spec** to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
   (user preferences for location override this default), then self-review:
   fix placeholders, contradictions, ambiguous requirements, and scope creep
   inline. Commit it, then ask the user to review the file before proceeding.

6. **Hand off to writing-plans.** That is the only next skill after
   brainstorming — do not start implementation from here.

## Design Principles

- YAGNI ruthlessly: remove features nobody asked for.
- Prefer small units with one clear purpose and well-defined interfaces; you
  should be able to say what each unit does, how it's used, and what it
  depends on.
- In existing codebases, follow established patterns. Include targeted
  improvements only where existing problems affect this work; don't propose
  unrelated refactoring.
