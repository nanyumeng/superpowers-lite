# Superpowers Lite

> An unofficial, lightweight derivative of
> [Superpowers](https://github.com/obra/superpowers), optimized for stronger
> coding models such as GPT-5.6 and Claude Fable 5.

[简体中文](README.zh-CN.md)

Superpowers Lite keeps the project structure, skill names, and main development
workflow of Superpowers while removing rules that newer models often no longer
need. It is intended for existing Superpowers projects that want to reduce
prompt overhead without rewriting their specs, plans, or agent instructions.

This project is maintained independently by
[@nanyumeng](https://github.com/nanyumeng). It is not an official Superpowers
edition and is not endorsed by Superpowers, OpenAI, or Anthropic.

## Why Lite?

Superpowers established a valuable, repeatable path from an idea to verified
code. Its stronger rules were also designed to constrain earlier or less
reliable agents. On GPT-5.6 and Claude Fable 5, our experience is that applying
the same heavy process to every task can produce the opposite result:

- small changes expand into unnecessary specifications, dispatches, and review
  loops;
- repeated instructions consume context and compete with project-specific
  requirements;
- excessive orchestration can reduce the model's ability to make direct,
  context-aware decisions;
- more activity and more tokens do not necessarily produce a better result.

Lite does not remove engineering discipline. It makes that discipline
proportional to ambiguity and risk: direct work for small, clear changes; a
full design and planning path for new or unclear features; strict testing and
fresh verification for production behavior.

## Superpowers vs. Superpowers Lite

| Area | Upstream Superpowers | Superpowers Lite |
|---|---|---|
| Main workflow | Brainstorm → spec → plan → execute → verify → finish | Preserved |
| Existing project docs | `docs/superpowers/specs/` and `docs/superpowers/plans/` | Preserved |
| Skill references | `superpowers:*` | Preserved for project compatibility |
| Small, explicit changes | May activate several workflow skills | Direct TDD and verification are allowed |
| New or ambiguous features | Design and plan first | Design and plan first |
| Execution default | Subagent-driven development is prominent | Single-agent execution by default; delegate only when tasks are independent, high-risk, or explicitly requested |
| Review loops | Strong multi-stage review discipline | Bounded review selected by risk and change size |
| Debugging | Systematic workflow strongly enforced | Systematic workflow reserved for complex, recurring, or failed first attempts |
| Safety | Destructive actions and completion claims are guarded | Preserved; safety and verification are not optional |
| Core skill text at the current baseline | 3,322 lines | 1,053 lines, 68.3% less text |

The line-count reduction measures the instructions shipped by the project. It
does **not** mean every task uses 68.3% fewer tokens.

## Early real-project observation

The initial motivation came from one long-running authorization project in a
single Codex conversation. We divided the session at the point where the local
installation switched from upstream Superpowers to Lite.

| Phase | Completed work turn | Processed tokens* | Outcome observed in the project |
|---|---|---:|---|
| Upstream Superpowers | Main authorization implementation | 57,632,709 | 75 minutes; human acceptance later found omitted production capabilities and an unnecessary replacement UI, requiring repair |
| Superpowers Lite | Authorization E2E suite redesign | 12,750,549 | 17.7 minutes; reduced 536 matrix entries to a five-case main gate, ran it once, and correctly classified the only failure as an obsolete fixture rather than a product defect |

\* Processed tokens are Codex-reported input plus output, including cached
input. They are a workload measure, not an API bill.

These are different work items inside the same project, so the raw 77.9%
difference is **not** a controlled performance claim. The repair turn also
crossed the installation boundary and is excluded from attribution. Based on
the broader work completed after the switch, the maintainer's current practical
estimate is that Lite reduced token use by **at least about 30%** while producing
more focused first-pass results. Treat that number as a preliminary field
observation; we will replace or refine it with repeated, matched evaluations.

A separate three-task micro-check is published in
[the preliminary GPT-5.6 comparison](docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md).
Both variants passed all three tasks; Lite used 2.8% fewer processed tokens and
22.2% fewer fresh-input tokens in that small sample. It did not establish an
accuracy advantage. We publish the mixed result because Lite should be judged
by reproducible evidence, not only its best session.

## Why revisit older prompts now?

Lite's direction is consistent with current official model guidance, although
neither vendor has evaluated or endorsed this project:

- [OpenAI's GPT-5.6 prompting best practices](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
  recommend leaner prompts, removing repeated instructions and unnecessary
  examples, and validating changes on representative tasks. OpenAI also advises
  stating each instruction once and keeping autonomy policies compact.
- [Anthropic's Claude Fable 5 prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5)
  recommends revisiting prompts and skills written for older models, noting
  that overly prescriptive legacy instructions can degrade newer-model output.

These documents support re-evaluation, not a blanket conclusion that fewer
instructions are always better. Lite retains the rules whose removal would
weaken safety, correctness, or user control.

## Workflow

The familiar Superpowers structure remains intact:

1. **Brainstorm** when the request is a new feature or the scope is ambiguous.
2. Save the approved specification under `docs/superpowers/specs/`.
3. **Write a plan** under `docs/superpowers/plans/` when implementation spans
   multiple meaningful steps.
4. **Execute** with one agent by default, or use subagents when isolation and
   parallelism provide a concrete benefit.
5. Apply **test-driven development** to production behavior changes.
6. Run **fresh verification** before claiming completion.
7. Review and finish the branch with a process proportional to its risk.

Small documentation, configuration, or single-file changes with explicit
success criteria can go directly to implementation and verification.

## Who should use Lite?

Lite is a good fit when:

- your repository already refers to `superpowers:*` skills or stores specs and
  plans in the Superpowers directory layout;
- you use a newer strong model and see repeated planning, review, or delegation
  add cost without improving the result;
- you want to keep TDD, verification, and safety boundaries while giving the
  model more room to use its own judgment.

Prefer upstream Superpowers when you value maximum procedural enforcement,
depend on its exact multi-agent review behavior, or have not observed the
overhead Lite is designed to address. For high-risk work, Lite should still be
configured conservatively.

## Installation

The first source release is `v6.1.1-lite.1` at
[`nanyumeng/superpowers-lite`](https://github.com/nanyumeng/superpowers-lite).

```bash
git clone https://github.com/nanyumeng/superpowers-lite.git
cd superpowers-lite
git checkout v6.1.1-lite.1
```

Harness-specific source installation is currently documented for
[OpenCode](docs/README.opencode.md) and [Kimi Code](docs/README.kimi.md).
Marketplace availability is not claimed. Codex, Claude Code, and Cursor source
installation flows will be documented after their end-to-end release checks.

Do not enable upstream Superpowers and Superpowers Lite in the same harness.
They intentionally use the same `superpowers:*` skill namespace for existing
project compatibility, so a simultaneous installation would make skill
resolution ambiguous.

## Compatibility

Lite keeps the upstream directory layout and harness adapters, but support is
reported by evidence rather than by file presence:

| Harness | Pre-release status |
|---|---|
| Codex App / CLI | Core package, manifest, sync, and bootstrap tests pass; marketplace publication pending |
| Claude Code / Cursor | Adapter retained; release install verification pending |
| OpenCode / Kimi Code | Existing loader and manifest tests pass; end-to-end release verification pending |
| Pi / Antigravity | Experimental; known tool-mapping gaps remain under review |

## Relationship to upstream

Superpowers Lite is derived from
[`obra/superpowers`](https://github.com/obra/superpowers) v6.1.1 at commit
`d884ae0`. The original MIT license and attribution are preserved.

The Lite direction overlaps with upstream discussions about token budgets,
dispatch thresholds, and unbounded repair loops, including
[#1152](https://github.com/obra/superpowers/issues/1152),
[#1194](https://github.com/obra/superpowers/issues/1194),
[#1917](https://github.com/obra/superpowers/issues/1917), and
[#1988](https://github.com/obra/superpowers/issues/1988). These reports help
explain the problem space; they do not imply upstream agreement with Lite.

Broad skill-policy changes are unlikely to belong in upstream core without
substantial evaluation evidence. We therefore maintain Lite independently.
When testing reveals a small, general, non-fork-specific defect, we will search
existing issues and pull requests first and contribute a focused fix under the
upstream project's rules. We will not use upstream issues to promote this fork.

## Evaluation roadmap

Before making a stable efficiency claim, we plan to publish matched upstream
and Lite runs covering documentation changes, small bugs, cross-file features,
complex debugging, and genuinely parallel work. Each comparison will record:

- model, reasoning effort, harness version, and exact skill revision;
- cached input, fresh input, output, processed tokens, time, and subagent count;
- functional correctness, scope compliance, retries, and human acceptance;
- repeated runs rather than a selected best result.

Claude Fable 5 evaluation has not yet been run.

## Issues and pull requests

External issues and pull requests are open in the public repository.
Reports should include the model and harness, exact Lite revision, a real
reproduction, expected and actual behavior, and a clear token-counting method
for efficiency claims. Skill behavior changes should include matched before
and after evidence. One problem per pull request.

AI-assisted contributions are welcome when the author discloses the model,
harness, and relevant tools and has personally reviewed the complete diff.

## Privacy and telemetry

The public release uses a clean history that excludes local
session transcripts, machine paths, credentials, and private research notes.
Runtime network requests and inherited branding are also being audited before
release. The README will document any remaining optional request and its opt-out;
undocumented telemetry is not an acceptable release state.

## License and acknowledgements

MIT licensed. See [LICENSE](LICENSE).

Superpowers was created by Jesse Vincent and the contributors to
[`obra/superpowers`](https://github.com/obra/superpowers). Superpowers Lite
preserves that foundation while maintaining its lightweight behavior as an
independent project.
