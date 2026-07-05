# Spec-Derived E2E Verification

Live end-to-end evidence for the branch: scenario cards derived from the
governing spec, run against the built code. Results land before
superpowers:finishing-a-development-branch, so "ready to merge" includes
live-scenario evidence, not just review verdicts.

## Finding the governing spec

Open the spec the plan names. If the plan names none, check the repo's spec
directory (e.g. `docs/superpowers/specs/`) for specs governing the code the
plan touches.

- Spec with an "E2E scenario cards" section: cards derive from the table's
  falsification lines verbatim.
- Spec without the section: the bootstrap path in
  superpowers:agentic-end-to-end-testing's authoring-cards-from-a-spec.md
  backports a table from the spec's requirements (flagged for human review).
- No governing spec at all: there is nothing to derive cards from. Tell your
  human partner and proceed to finishing — or they can write a spec first
  and re-run the offer.

## Procedure

Use superpowers:agentic-end-to-end-testing:

1. Dispatch a card-author subagent per its authoring-cards-from-a-spec.md.
2. Run its scripts/check-cards-against-spec yourself on the author's output
   — self-attestation is not the gate.
3. Dispatch a runner subagent per its runner-prompt.md against the built
   branch.

## Failure handling

Card FAILs are findings: dispatch ONE fix subagent with the complete list,
then re-run the failed cards. The card author never fixes. Fix-wave commits
land after the final whole-branch review, so give the fix diff its own
task-review gate before finishing — a green re-run alone does not ship
unreviewed changes.
