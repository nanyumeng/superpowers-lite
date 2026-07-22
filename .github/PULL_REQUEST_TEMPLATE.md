<!--
Thank you for contributing. Keep this pull request focused on one experienced
problem, remove private data, and complete every applicable section.
-->

## Problem

<!-- Describe the concrete task, failure, or user experience that motivated the change. -->

Related issue:

## Change

<!-- Explain the smallest behavior or documentation change included here. -->

## Scope

- [ ] This pull request solves one problem
- [ ] The change is general-purpose rather than project-specific
- [ ] I searched open and closed issues and pull requests for prior work
- [ ] I removed unrelated formatting, generated files, logs, and private data

Prior work or alternatives considered:

## Environment and authorship

| Field | Value |
|---|---|
| Model and version | |
| Harness and version | |
| Installed plugins or skills | |
| Human who reviewed the complete diff | |

<!-- If written without AI assistance, state that plainly in the table. -->

## Verification

| Check | Command or evidence | Result |
|---|---|---|
| Focused failing test before the fix | | |
| Focused passing test after the fix | | |
| Relevant adapter or behavior suite | | |
| `git diff --check` | | |

## Skill behavior evaluation

<!-- Complete this section when SKILL.md or behavior-shaping support content changes. -->

- Baseline failure:
- Matched prompt, fixture, model, effort, and harness:
- Number of independent before/after runs:
- Functional and scope outcomes:
- Cached input, fresh input, output, and processed tokens, if relevant:
- Safety and compatibility invariants preserved:

## New harness support

<!-- Complete this section only when adding an IDE, CLI, or agent runner. -->

- [ ] A clean session loads `using-superpowers` automatically at startup
- [ ] The exact prompt `Let's make a react todo list` triggers `brainstorming` before code
- [ ] A sanitized complete acceptance transcript is attached

## Final review

- [ ] I personally reviewed the complete proposed diff
- [ ] The documentation and public claims match the actual test evidence
- [ ] This pull request targets the repository's `main` branch
