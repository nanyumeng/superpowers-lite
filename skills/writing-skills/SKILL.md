---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
---

# Writing Skills

Writing a skill is testable process documentation: establish the baseline
failure first, write the minimal skill that fixes it, verify agents comply,
and keep the wording lean. A skill nobody tested teaches you nothing; a
skill written for weaker models degrades stronger ones.

**Official guidance:** see anthropic-best-practices.md in this directory.

## What is a Skill?

A reusable reference for a proven technique, pattern, or tool — not a
narrative about how you solved a problem once.

**Create when:** the technique wasn't obvious to you, you'd reference it
across projects, and others would benefit.
**Don't create for:** one-off solutions, practices well-documented
elsewhere, project-specific conventions (instructions file), or anything
enforceable with a validator (automate it instead).

Types: **technique** (steps to follow), **pattern** (way of thinking),
**reference** (API/tool docs).

## Structure

```
skills/
  skill-name/
    SKILL.md              # Main reference (required)
    supporting-file.*     # Only for reusable tools or 100+ line references
```

Frontmatter: `name` (letters/numbers/hyphens) and `description`, max 1024
chars total. Body template — keep every section short, include only the
sections that earn their place:

```markdown
# Skill Name

Overview: what this is, core principle, 1-2 sentences.

## When to Use
Triggers, symptoms, and when NOT to use.

## Core Pattern / Process
The technique itself: decision rules, steps, or before/after comparison.

## Implementation
Inline code for simple patterns; link a file for heavy reference or tools.
```

## Write for Strong Models

Modern models follow brief instructions reliably; over-prescription
degrades their output. When writing or editing any skill:

- State the outcome, the decision rules, and the true invariants. Leave
  route choice to the model.
- Use ALWAYS/NEVER only for genuine invariants (safety, evidence,
  destructive actions) — not for judgment calls.
- One statement per rule. No rationalization tables, red-flag lists,
  spirit-vs-letter lectures, or repeated ALWAYS reminders — these add
  tokens and can backfire (see Match the Form to the Failure).
- One excellent example beats many; move long examples to reference files.
- No motivational sections ("Why This Matters", "Real-World Impact").

## Match the Form to the Failure

Classify the baseline failure before writing guidance — the form that fixes
one failure type measurably backfires on another:

| Baseline failure | Right form |
|---|---|
| Output has the wrong shape | Positive recipe: state what the output IS — its parts, in order |
| Omits a required element | Structural: a REQUIRED field or slot in the template they fill |
| Behavior should depend on a condition | Conditional keyed to an observable predicate |
| Violates a true invariant | One clear prohibition, stated once |

Head-to-head wording tests showed prohibition lists ("don't restate, never
narrate") produce MORE of the unwanted content than recipes, and can trend
worse than no guidance at all. Also: no nuance clauses ("don't X unless it
matters" reopens negotiation — express real exceptions as their own
conditional), and exemption clauses don't scope ("limit doesn't apply to
code blocks" still suppresses code blocks — restructure instead).

## Discovery (SDO)

The description decides whether future agents find and read the skill:

- Start with "Use when…" and describe ONLY triggering conditions —
  symptoms, situations, contexts. Third person.
- **Never summarize the skill's workflow in the description**: agents
  follow the summary instead of reading the skill. (A description saying
  "code review between tasks" caused agents to run one review where the
  skill required two.)
- Cover the keywords an agent would search: error messages, symptoms,
  synonyms, tool names.
- Name skills verb-first by what you do: `condition-based-waiting`, not
  `async-test-helpers`.

Cross-reference other skills by name with explicit markers
(`**REQUIRED SUB-SKILL:** superpowers:x`) — never `@`-links, which
force-load files and burn context.

## Token Efficiency

Frequently-loaded skills cost tokens in every conversation. Targets:
frequently-loaded < 200 lines, others < 500. Techniques: reference
`--help` instead of documenting flags; cross-reference instead of
repeating other skills; compress examples; delete anything that doesn't
change behavior. Flowcharts only for genuinely non-obvious decision loops
— never for linear instructions or reference material (see
`graphviz-conventions.dot`; render with `render-graphs.js`).

## Test Before Deploying

Baseline first: run the scenario WITHOUT the skill and document what agents
actually do. If the baseline doesn't exhibit the failure, stop — there is
nothing to fix. Then write the minimal skill, re-run the scenario, and
verify compliance.

- **Micro-test wording** before full scenarios: one fresh-context sample
  per call, realistic system prompt, a task that tempts the failure; always
  include a no-guidance control; 5+ reps per variant; read every flagged
  match manually; convergence across reps is the signal that wording binds.
- **Full pressure scenarios** remain the final gate for discipline skills
  (time pressure, sunk cost, authority) — see
  [testing-skills-with-subagents.md](testing-skills-with-subagents.md).
- Test by skill type: discipline skills → compliance under pressure;
  techniques → application to a new scenario; patterns → recognizing
  when (and when not) to apply; references → retrieval and correct use.

Deploy one skill at a time — test each before writing the next. Commit to
git; consider contributing upstream if broadly useful.
