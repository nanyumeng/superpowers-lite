# Superpowers Lite

> A lightweight, drop-in skills overlay for
> [Superpowers](https://github.com/obra/superpowers), designed for stronger
> coding models such as GPT-5.6 and Claude Fable 5.

[简体中文](README.zh-CN.md)

**Why use it:**

- **Lighter for modern models.** Simplified in the direction of the official
  [GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
  and [Claude Fable 5 prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5):
  less repetition and legacy over-prescription.
- **Same workflow and file structure.** Skill names, the main development
  process, `docs/superpowers/specs/`, and `docs/superpowers/plans/` stay
  compatible with existing Superpowers projects.
- **30%+ fewer tokens in maintainer field use.** Ongoing real-project work has
  been faster and produced better-focused first-pass results with less
  unnecessary development. This is an observation, not a universal guarantee.
- **Reviewable skill instructions, safe and reversible.** Core behavior is
  defined in Markdown alongside the small helper scripts used by the skills.
  Installation backs up and replaces only the local `skills/` directory. It
  runs no installer and changes no application code or project configuration;
  Rollback uses the Backup created before replacement.

Install Superpowers normally, then let your coding agent replace its complete
`skills/` directory with this repository's `skills/`. Existing projects do not
need to rename skills, specs, plans, or project instructions.

This is an unofficial, independently maintained derivative. It is not endorsed
by Superpowers, OpenAI, or Anthropic.

## Why Lite?

Superpowers established a dependable path from an idea to verified code. Some
of its strongest rules were written for earlier or less reliable models. On
newer models, applying the heaviest workflow to every task can add repeated
planning, delegation, review loops, and context without improving the result.

Superpowers Lite makes the process proportional to the task:

- small, explicit changes can go directly to implementation and verification;
- new features or ambiguous work still begin with brainstorming and a spec;
- multi-step implementations still use written plans;
- production behavior changes still use test-driven development;
- completion claims still require fresh verification;
- subagents and systematic debugging are used when complexity or risk justifies
  them, rather than by default.

The result is less orchestration around the model and more attention available
for the actual project.

## Built for modern model guidance

The simplification follows the direction of current official prompting advice:

- [OpenAI's GPT-5.6 prompting guidance](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
  recommends lean prompts, avoiding repeated instructions and unnecessary
  examples, and validating changes on representative tasks.
- [Anthropic's Claude Fable 5 prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5)
  recommends revisiting prompts and skills written for older models because
  overly prescriptive legacy instructions can reduce newer-model performance.

Those documents do not endorse this project, and “shorter” is not automatically
“better.” Lite preserves the rules that protect correctness, safety, user
control, TDD, and verification.

## What stays compatible

Lite preserves the parts existing Superpowers projects depend on:

| Area | Preserved behavior |
|---|---|
| Skill names | Existing `superpowers:*` references continue to work |
| Main workflow | Brainstorm → spec → plan → execute → verify → finish |
| Specification path | `docs/superpowers/specs/` |
| Plan path | `docs/superpowers/plans/` |
| Engineering discipline | TDD, debugging, review, verification, and safe branch completion |
| Project instructions | Existing `AGENTS.md` and `CLAUDE.md` references do not need migration |

Only the behavior-shaping skill instructions are lighter. Your project's
source code and Superpowers documents are not changed by installation.

## Observed results

In the maintainer's real-project use after switching from upstream Superpowers
to Lite, comparable ongoing work used **30%+ fewer tokens**, completed faster,
and produced more focused first-pass results with less unnecessary development.
The shipped core skill text is also substantially smaller than the upstream
baseline.

The 30%+ figure is a field observation from real work, not a guarantee for every
repository or task. Savings depend on task complexity, model, harness, existing
project instructions, and how often the original workflow would have triggered
extra planning, delegation, or review.

## Installation

Superpowers Lite is a skills overlay, not a standalone harness plugin. Keep one
working Superpowers installation so its native adapter can discover skills and
load `using-superpowers`. Do not enable a second copy of the same skills.

The easiest installation is to paste the prompt below into Codex, Claude Code,
Cursor, or another coding agent that can inspect its own environment.

### Copy this prompt into your coding agent

```text
Install or update Superpowers Lite on this machine. Complete the installation;
do not only explain the steps.

Source: https://github.com/nanyumeng/superpowers-lite

1. Find the one active Superpowers installation and its exact `skills/` path
   using this harness's plugin metadata or manager. If Superpowers is absent,
   install upstream Superpowers through the harness's native method first. If
   paths are ambiguous, stop and ask me.
2. Download https://github.com/nanyumeng/superpowers-lite to a temporary
   directory and validate `skills/using-superpowers/SKILL.md`. If its complete
   `skills/` tree already matches the active one, report that no update is needed.
3. Show the active path and a unique timestamped Backup path, then move the
   complete active `skills/` directory to that Backup. Do not delete, merge, or
   overwrite anything.
4. Copy the complete superpowers-lite `skills/` directory into the original
   location. Preserve every file outside `skills/`, then verify the installed
   and downloaded trees match recursively and the Backup is intact.
5. Report the original version, installed path, Backup path, source commit,
   verification result, restart/new-session requirement, and an exact Rollback
   command. Do not execute Rollback.

Change no application project, project configuration, AGENTS.md, CLAUDE.md, or
`docs/superpowers/` content. Do not claim success without fresh verification.
```

After installation, restart the harness or open a new session. The UI may still
display “Superpowers” because Lite intentionally reuses the installed adapter.
If that plugin is updated later, rerun the prompt: an upstream update may
replace the overlaid skills.

### Quick verification

In a disposable test repository, start a clean session and try:

```text
Let's make a React todo list.
```

The agent should select `brainstorming` before writing code. For a small,
explicit documentation correction, Lite should instead work directly and
verify the result without forcing a full design and plan.

### Rollback

Keep the Backup path reported during installation. To restore it, paste:

```text
Rollback Superpowers Lite using this exact Backup path:
<PASTE_BACKUP_PATH>

Find the currently active Superpowers `skills/` directory, verify that the
Backup contains `using-superpowers/SKILL.md`, show both exact paths, and restore
the Backup using recoverable move operations. Do not delete either tree or
modify project files. Verify the restored skills and tell me whether to restart
the harness or open a new session.
```

## Repository scope

The distributable product is the [`skills/`](skills/) directory. Platform
manifests, loaders, hooks, package metadata, and test infrastructure are not
shipped here because the user's existing Superpowers installation already
provides the harness integration.

Issues and pull requests are welcome at
[`nanyumeng/superpowers-lite`](https://github.com/nanyumeng/superpowers-lite).

## License and attribution

MIT licensed. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

Superpowers was created by Jesse Vincent and its contributors. Superpowers Lite
preserves that foundation while independently maintaining the lighter skills.
