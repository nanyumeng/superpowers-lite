# Superpowers Lite

> A lightweight, drop-in skills overlay for
> [Superpowers](https://github.com/obra/superpowers), designed for stronger
> coding models such as GPT-5.6 and Claude Fable 5.

[简体中文](README.zh-CN.md)

Superpowers Lite keeps the familiar Superpowers workflow, skill names, and
project file structure while removing repeated and overly prescriptive legacy
instructions. Existing projects do not need to rename their skills, specs, or
plans. Install Superpowers normally, then let your coding agent back up and
replace its complete `skills/` directory with this repository's `skills/`.

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

Goal: keep the harness adapter from my active Superpowers installation, create
a recoverable Backup of its complete `skills/` directory, and replace that
directory with the repository's complete `skills/` directory.

Rules:

1. Detect the current harness and operating system. Use the harness's plugin
   metadata, plugin manager, and harness-owned directories to locate the one
   active Superpowers installation. Do not perform an unbounded search of my
   home directory.
2. If Superpowers is not installed, use this harness's supported native method
   to install upstream Superpowers from https://github.com/obra/superpowers
   first. Do not imitate installation by editing global AGENTS.md, CLAUDE.md,
   shell profiles, or unrelated personal configuration.
3. Resolve the exact active `skills/` directory and the installed Superpowers
   version when available. If multiple active installations or ambiguous paths
   exist, stop and ask me before changing anything.
4. Clone or download https://github.com/nanyumeng/superpowers-lite into a
   temporary directory. Validate that
   `skills/using-superpowers/SKILL.md` and all top-level skill directories are
   present.
5. Compare the source and active skills. If they already match recursively,
   report that Superpowers Lite is current and make no changes.
6. Before replacement, show the exact active path and planned Backup path. This
   prompt authorizes you to replace only that uniquely resolved `skills/`
   directory.
7. Move the complete active `skills/` directory to a unique sibling Backup
   whose name includes the detected version or `unknown`, plus a UTC timestamp.
   Never overwrite an existing Backup. Do not merge old and new skill trees and
   do not use irreversible deletion.
8. Copy the complete Superpowers Lite `skills/` directory into the original
   active location. Preserve the existing plugin manifest, hooks, loader,
   extension, permissions, and every file outside `skills/`.
9. Verify recursively that the installed skills match the downloaded
   superpowers-lite skills, that the Backup still contains
   `using-superpowers/SKILL.md`, and that only one skill source is active.
10. Report the installed path, detected original version, Backup path, source
    commit, verification result, whether a restart/new session is required, and
    an exact Rollback command. Do not execute Rollback.

Do not claim success without fresh verification. Do not modify any application
project or its `docs/superpowers/specs/` and `docs/superpowers/plans/` files.
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
