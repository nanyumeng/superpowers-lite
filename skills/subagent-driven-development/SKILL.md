---
name: subagent-driven-development
description: Use for multi-task plans needing isolation, high-risk changes, or when the user asks for independent per-task review - default plan execution is executing-plans
---

# Subagent-Driven Development

Execute a plan by dispatching a fresh implementer subagent per task, a task
review (spec compliance + code quality) after each, and a broad whole-branch
review at the end.

**Why subagents:** each gets isolated context you craft precisely — never
your session's history. They stay focused, and your own context is preserved
for coordination.

**Continuous execution:** don't pause to check in between tasks. Stop only
for a BLOCKED status you cannot resolve, ambiguity that genuinely prevents
progress, or all tasks complete. Never start implementation on main/master
without explicit user consent. Between tool calls, narrate at most one short
line — the ledger and tool results carry the record.

## The Loop

1. Read the plan; note context and Global Constraints; create todos.
2. Per task:
   a. Record the base commit, generate the task brief, dispatch the
      implementer ([implementer-prompt.md](implementer-prompt.md)). One
      implementer at a time — parallel implementers conflict.
   b. Answer any questions it raises, then let it implement, test, commit,
      self-review, and report status.
   c. Generate the review package and dispatch the task reviewer
      ([task-reviewer-prompt.md](task-reviewer-prompt.md)) — it must return
      two verdicts: spec compliance AND code quality.
   d. Critical/Important findings → dispatch a fix subagent, then
      re-review. Record Minor findings in the ledger.
   e. Both verdicts clean → mark the task complete in todos and the ledger.
3. All tasks done → dispatch the final whole-branch reviewer
   ([../requesting-code-review/code-reviewer.md](../requesting-code-review/code-reviewer.md)),
   pointing it at the Minor-findings list for triage.
4. Finish with superpowers:finishing-a-development-branch.

## Pre-Flight Plan Review

Before dispatching Task 1, scan the plan once for tasks that contradict each
other, the Global Constraints, or the review rubric. Present everything you
find as ONE batched question — each finding beside the plan text that
mandates it — before execution begins, not one interrupt per discovery. If
clean, proceed without comment.

## Model Selection

Use the least powerful model that can handle each role; always specify the
model explicitly (an omitted model inherits your expensive session model).

- Plan text contains the complete code, or single-file mechanical fix →
  cheapest tier.
- Multi-file integration, prose-spec implementation, reviews → mid tier
  floor (the cheapest models take 2-3x the turns, costing more overall).
- Design judgment, broad codebase understanding, and the final whole-branch
  review → most capable model.
- Scale reviewer capability to the diff's size and risk.

## Handling Implementer Status

- **DONE:** generate the review package (`scripts/review-package BASE HEAD`
  from this skill's directory — BASE is the commit recorded before
  dispatch, never `HEAD~1`, which silently drops all but the last commit),
  then dispatch the task reviewer with the printed path.
- **DONE_WITH_CONCERNS:** read the concerns. Correctness/scope concerns →
  address before review; observations → note and proceed.
- **NEEDS_CONTEXT:** provide the missing context and re-dispatch.
- **BLOCKED:** context problem → add context, same model. Reasoning
  problem → more capable model. Task too large → split it. Plan wrong →
  escalate to the human. Never force the same model to retry unchanged.

## Handling Reviewer ⚠️ Items

"⚠️ Cannot verify from diff" items don't block the rest of the review, but
you must resolve each yourself before marking the task complete — you hold
the plan and cross-task context the reviewer lacks. A confirmed gap is a
failed spec review: send it back to the implementer and re-review.

## Constructing Dispatch and Reviewer Prompts

- A dispatch describes one task, not the session's history. Hand the
  implementer its brief file, the interfaces it touches, and the global
  constraints — never the whole plan file, and never pasted prior-task
  summaries.
- Copy the plan's binding requirements verbatim into the reviewer's
  global-constraints block: exact values, formats, and stated relationships.
  The template already carries process rules (YAGNI, test hygiene).
- Don't pre-judge findings: no "do not flag", "treat as Minor at most", or
  open-ended extras like "check all uses" without a task-specific reason.
  If a finding conflicts with what the plan mandates, that's the human's
  decision — present both and ask which governs.
- Don't ask a reviewer to re-run tests the implementer already ran; the
  report carries the test evidence.
- Every fix dispatch carries the implementer contract: re-run the covering
  tests (named in the dispatch — a one-line fix doesn't need the whole
  suite) and report results. Confirm the fix report has tests, command, and
  output before re-dispatching the reviewer.
- If the final review returns findings, dispatch ONE fix subagent with the
  complete list — per-finding fixers each rebuild context and cost more
  than the tasks themselves.

## File Handoffs

Everything pasted into a dispatch — and everything printed back — stays in
your context forever. Hand artifacts over as files:

- **Task brief:** `scripts/task-brief PLAN_FILE N` extracts the task text to
  a uniquely named file. The dispatch contains: one line on where the task
  fits; the brief path ("read this first — it is your requirements, exact
  values verbatim"); interfaces and decisions from earlier tasks the brief
  can't know; your resolution of any ambiguity; the report-file path and
  contract. Exact values live only in the brief.
- **Report file:** named after the brief (`task-N-brief.md` →
  `task-N-report.md`). The implementer writes the full report there and
  returns only status, commits, a one-line test summary, and concerns.
- **Reviewer inputs:** the brief, the report, the review package
  (`scripts/review-package BASE HEAD`), plus the global constraints.
- Fix dispatches append to the same report file; re-reviews read the update.
- The final review gets a package too: `scripts/review-package MERGE_BASE
  HEAD` (`git merge-base main HEAD`).

## Durable Progress

Conversation memory does not survive compaction; controllers that lost
their place have re-dispatched entire completed task sequences. Track
progress in a ledger, not only in todos:

- At skill start:
  `cat "$(git rev-parse --show-toplevel)/.superpowers/sdd/progress.md"`.
  Tasks marked complete are DONE — resume at the first incomplete task.
- On each clean review, append:
  `Task N: complete (commits <base7>..<head7>, review clean)`.
- After compaction, trust the ledger and `git log` over recollection.
  (`git clean -fdx` destroys the ledger — recover from `git log`.)

## Integration

- **superpowers:using-git-worktrees** — isolated workspace
- **superpowers:writing-plans** — creates the plan this skill executes
- **superpowers:requesting-code-review** — final whole-branch review template
- **superpowers:finishing-a-development-branch** — completion
- Subagents follow superpowers:test-driven-development per task
- Alternative: **superpowers:executing-plans** (default, single-session)
