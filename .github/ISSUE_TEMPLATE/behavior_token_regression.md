---
name: Behavior / Token Regression
about: Report a matched Superpowers Lite behavior, quality, or token regression
labels: regression, evaluation
---

- [ ] I used the same task, fixture, model, effort, harness, and initial context for each compared run
- [ ] I report correctness and scope results, not token counts alone
- [ ] I sanitized all transcripts and paths

## Claim being tested

State the specific expected difference between Lite revisions or between
upstream Superpowers and Lite.

## Compared configurations

| Field | Baseline | Candidate |
|---|---|---|
| Skill project and revision | | |
| Model and version | | |
| Reasoning effort | | |
| Harness and version | | |
| Installed plugins | | |
| Fixture commit | | |

## Exact task and grader

Provide the prompt, allowed files, expected behavior, focused tests, and any
hidden or human acceptance criteria.

## Results

| Metric | Baseline | Candidate |
|---|---:|---:|
| Functional result | | |
| Scope result | | |
| Input tokens | | |
| Cached input tokens | | |
| Fresh input tokens | | |
| Output tokens | | |
| Processed tokens | | |
| Wall time | | |
| Subagents | | |
| Retries or repair turns | | |

Explain the token source and whether it represents model workload or billing.

## Repetitions and variability

State the number of independent runs, all outcomes, and whether any run was
discarded or repeated. Do not report only the best result.

## Sanitized evidence

Link a minimal public fixture or attach sanitized aggregate output. Do not post
private project transcripts.
