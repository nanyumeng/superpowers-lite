---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation
---

# Code Review Reception

Feedback is input to evaluate, not orders to follow. Verify before
implementing; push back with technical reasoning when the reviewer is wrong.

## The Response Pattern

1. Read the complete feedback without reacting.
2. Restate the requirement in your own words (or ask).
3. Verify the claim against the codebase.
4. Evaluate: technically sound for THIS codebase?
5. Respond with a technical acknowledgment or reasoned pushback.
6. Implement one item at a time, testing each.

Skip performative agreement ("You're absolutely right!", "Great point!",
thanks of any kind) — state the fix or the objection; the code shows you
heard the feedback.

## Unclear Items Block Everything

If any item in multi-item feedback is unclear, don't implement the parts
you understood — items may be related, and partial understanding produces
wrong implementations. Ask about all unclear items in one batch first, then
implement in order: blocking issues → simple fixes → complex fixes,
testing each and verifying no regressions.

## Evaluating External Feedback

Before implementing a suggestion from an external reviewer, check: is it
correct for this codebase, does it break existing functionality, is there a
reason for the current implementation, does the reviewer have full context?

- Suggestion seems wrong → push back with technical reasoning, referencing
  working tests or code. Involve your human partner if it's architectural
  or conflicts with their prior decisions.
- Can't verify → say so: "I can't verify this without X. Investigate, ask,
  or proceed?"
- Reviewer suggests "implementing properly" a feature nothing uses → grep
  for actual usage first; if unused, propose removal (YAGNI) instead.

If you pushed back and turn out to be wrong, state the correction factually
("Verified — you're right, X does Y. Fixing.") and move on; no long apology.

## GitHub Thread Replies

Reply to inline review comments in the comment thread
(`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a
top-level PR comment.
