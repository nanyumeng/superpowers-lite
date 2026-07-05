# Spec-Derived Scenario Cards — Design

Date: 2026-07-04
Status: approved (design review with Jesse, 2026-07-04)
Builds on: `2026-07-04-agentic-end-to-end-testing-design.md` (the skill this
extends; same branch)

## Problem

Scenario cards authored after implementation can drift toward what was built
instead of what was requested: a model that implemented X' will happily write
cards that pass against X'. The protection that worked in practice is locking
the **falsification contract before any code exists** — the brainstorming spec
carries a scenario table whose falsification lines are later lifted into cards
**verbatim** — plus separation of roles (card author is not the implementer and
never modifies product code). That flow exists in project history and in the
new `agentic-end-to-end-testing` skill's card format, but no skill documents
how cards derive from a spec, no spec template asks for the table, and the SDD
pipeline has no hook to run any of it.

### Evidence (2026-07-04 experiment, 4 live runs)

- With only a spec pointer (no table), card authors did NOT drift in the
  current environment (n=2) — but the environment was contaminated (a
  predecessor e2e skill auto-fired in all runs; operator-level honesty norms
  ambient), so this is not evidence the protection is unnecessary in general.
- With the table + a verbatim-lift instruction, compliance was 4/4 cards
  (whitespace-normalized check; a naive fixed-string grep under-counts —
  the mechanical checker below must normalize whitespace).
- Role boundary is genuinely ambiguous today: given the same failing card, one
  author fixed the product bug (disclosed, citing ambient "fix broken things
  immediately" norms) and one flagged it and declined to fix without TDD. The
  design must state the rule explicitly; prose norms do not decide it.

## Goals

- Institutionalize the spec-side half: brainstorming specs for user-facing
  work carry an "E2E scenario cards" table.
- Document the authoring half in `agentic-end-to-end-testing`: spec → cards,
  verbatim falsification lines, coverage, role boundary, dispatch snippet.
- Give subagent-driven-development an **optional**, predicate-keyed final
  step that authors and runs the cards.
- Verification is baked into the skill: a shipped checker script plus the
  skill-development RED/GREEN discipline. **No quorum scenarios** for this
  work.

## Non-goals

- No changes to `writing-plans`.
- No quorum/eval-lab scenarios (per Jesse; the checker script and in-skill
  discipline carry repeatability).
- No new plugin dependencies. Scripts use bash + POSIX tools only.
- No retroactive backfill of tables into existing specs.

## Design

### 1. Brainstorming (core-skill edit; high bar)

`skills/brainstorming/SKILL.md` gains one conditional, keyed to an observable
predicate: **if the design includes a user-facing surface** (UI, CLI/TUI
output, rendered artifact), the spec includes an **"E2E scenario cards"**
section — a table with one row per scenario:

| Card | Covers | Falsification |

- Card: kebab-case card name (becomes `test/scenarios/<name>.md`).
- Covers: the user-visible behavior the card exercises.
- Falsification: the exact observable that makes the scenario FAIL, written
  from the *requested* behavior at spec time, before implementation. This
  line is a contract: cards must later carry it verbatim.

That is the entire brainstorming edit — no new checklist steps, no changes to
the question flow. Placement and exact wording are settled during
implementation under writing-skills discipline (RED baseline first:
brainstorm runs on a user-facing feature today do not produce such tables;
micro-test the wording; GREEN re-run).

### 2. agentic-end-to-end-testing: `authoring-cards-from-a-spec.md`

New supporting file, routed from SKILL.md §3 (one line: cards derive from the
spec when one exists) and reflected in §9's pipeline sentence. Contents:

- **With a scenario table:** one card per row. The row's Falsification line
  lands in the card's Expected section **verbatim**. The spec is
  authoritative wherever the app's behavior disagrees — flag the
  disagreement in the report; never adapt the card to observed behavior.
- **Without a table:** mine the spec's user-visible requirements into
  behaviors; write the falsification lines; backport them to the spec (so
  the contract exists for the next cycle) and say so in the report.
- **Coverage check:** every user-facing claim in the spec maps to a card or
  a stated exclusion with a reason.
- **Role boundary:** the card author never modifies product code, test code,
  or existing cards' assertions. A failing card plus root cause is the
  deliverable, not a fix. (Provisional decision — flag-only; Jesse may widen
  it to "flag, then fix via TDD" at spec review.)
- **Dispatch snippet:** a short template for dispatching a fresh card-author
  subagent (seeded from the historical card-authoring dispatch in the
  corpus), naming: the spec path (authoritative), the card format, the
  verbatim rule, the role boundary, and the report shape.
- **Mechanical check:** after authoring, run the checker script (below); a
  clean pass is part of the author's report.

### 3. subagent-driven-development: optional final step (core-skill edit)

A short subsection — "Optional: spec-derived E2E verification" — after the
final whole-branch review, plus one line in Integration:

- **Trigger (observable predicate):** the spec contains an "E2E scenario
  cards" section, or the human asked for e2e verification. Otherwise the
  step does not exist.
- **Flow:** after the final review passes, the controller uses
  superpowers:agentic-end-to-end-testing — dispatch a card-author subagent
  (per `authoring-cards-from-a-spec.md`), then a runner subagent (per
  `runner-prompt.md`) against the built branch.
- **Failure handling mirrors the final-review contract:** card FAILs are
  findings — ONE fix subagent with the complete list, then re-run the failed
  cards. The card author never fixes; the fix wave does.
- **Placement:** before superpowers:finishing-a-development-branch, so
  "ready to merge" includes live-scenario evidence.

The SDD flowchart is not modified; the step is prose, like SDD's other
conditional guidance. Same discipline: RED baseline (a controller given a
spec-with-table today does not author/run cards), micro-tested wording,
GREEN.

### 4. Checker script: `skills/agentic-end-to-end-testing/scripts/check-cards-against-spec`

Bash + POSIX tools (awk/grep/sed), no other dependencies. Usage:

```
check-cards-against-spec <spec.md> <cards-dir>
```

Checks, each reported individually, exit 0 only if all pass:

1. The spec's "E2E scenario cards" table parses (>= 1 row; every row has a
   non-empty Card and Falsification cell).
2. Every table row has a corresponding `<cards-dir>/<card>.md`.
3. Every card contains its row's Falsification line verbatim,
   **whitespace-normalized** (markdown re-wrapping must not fail the check —
   the naive-grep false negative is a proven failure mode).
4. Every card has the skill's required sections (What this covers /
   Pre-state / Steps / Expected / Cleanup). Sharp edges is not required —
   it accretes during runs, and demanding it pre-run forces padding.
5. Extra cards (in dir, not in table) are reported as a warning, not a
   failure — authors may add cards beyond the spec's minimum.

Good `--help` and per-failure diagnostics (file, expected line, what was
found). Developed TDD: the script's failing tests come first, exercised
against fixture spec/card pairs; whether those fixtures are committed
follows house precedent for skill scripts, settled in the plan.

## Decisions

- **Timing:** table early (spec time), cards late (post-implementation),
  expansion constrained by the verbatim rule. Chosen over cards-at-spec-time
  after the 2026-07-04 experiment showed the expansion step follows a locked
  table faithfully.
- **Role boundary:** flag-only (provisional; revisit at spec review).
- **Blast radius:** brainstorming + agentic-end-to-end-testing + SDD; not
  writing-plans.
- **Repeatability:** in-skill (checker script + RED/GREEN development
  discipline); no quorum scenarios.

## Testing plan (writing-skills Iron Law)

1. **Checker script:** ordinary TDD; red tests first.
2. **Brainstorming edit:** RED — baseline brainstorm run(s) on a small
   user-facing feature; confirm no scenario table is produced today. GREEN —
   with the edit, the spec contains a well-formed table (the checker's table
   parser is the objective judge). Micro-test the conditional's wording.
3. **Card-authoring file:** RED exists already (the 2026-07-04 experiment is
   the baseline; its artifacts are archived in the corpus live-runs
   directory). GREEN — re-run the experiment's Arm-A prompt with the new
   file available; cards must pass the checker and the report must flag the
   spec disagreement.
4. **SDD edit:** RED — a scaled-down SDD run (tiny plan, spec-with-table)
   without the hook: controller does not author/run cards. GREEN — with the
   hook: controller reaches for the e2e skill after final review, and card
   FAILs produce a fix wave, not a weakened card.

## Out of scope / future

- Wiring card tasks into writing-plans (revisit if the SDD option proves
  lossy in practice).
- A quorum scenario for spec-derived authoring (deliberately dropped).
- Auto-generating the runner dispatch from the checker's table parse.
