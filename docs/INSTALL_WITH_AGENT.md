# Install Superpowers Lite with a coding agent

[简体中文](INSTALL_WITH_AGENT.zh-CN.md)

The easiest migration is to give the prompt below to the coding agent you
already use. The agent will detect its harness, preserve a recoverable copy of
an existing upstream Superpowers installation, and install the pinned Lite
release.

This guide is designed for Codex, Claude Code, Cursor, and other coding
harnesses that can inspect their own local plugin installation. It also covers
fresh installation when the harness has a documented native source-install
mechanism.

## Copy-paste installation prompt

Copy the complete prompt below into a new coding-agent session:

```text
Install Superpowers Lite on this machine and complete the installation rather
than only explaining the steps.

Source repository: https://github.com/nanyumeng/superpowers-lite
Pinned release: v6.1.1-lite.1

Safety and scope:

1. Detect the current harness, operating system, and exact Superpowers install
   location. Inspect native plugin/package metadata and the usual harness-owned
   directories first; do not run an unbounded search of my home directory.
2. Never leave upstream Superpowers and Superpowers Lite enabled at the same
   time. They intentionally expose the same `superpowers:*` skill namespace.
3. Do not change any application project, project skills, AGENTS.md, CLAUDE.md,
   or docs/superpowers files. This task changes only the harness-owned
   Superpowers installation.
4. Do not use `rm`, destructive cleanup, or overwrite an existing backup. Use
   a temporary checkout and recoverable move/copy operations.
5. This prompt authorizes creating one timestamped backup and replacing only
   the single, exact `skills/` directory that you resolve with confidence. If
   more than one active installation is found, the installed upstream version
   is not compatible with v6.1.1, or the target path is uncertain, stop and ask
   me before changing anything.

If upstream Superpowers is already installed:

1. Confirm its version and active install path. The Lite release is based on
   upstream v6.1.1; do not silently overlay a different upstream version.
2. Clone or download only the pinned Lite release into a temporary directory.
   Validate that it contains `skills/using-superpowers/SKILL.md` and the other
   top-level skill directories before touching the installation.
3. Show the resolved install path, detected version, and planned Backup path in
   your progress report.
4. Move the existing complete `skills/` directory to a unique sibling Backup
   directory whose name includes `upstream-v6.1.1` and a UTC timestamp. Do not
   merge the old and new directories.
5. Copy the pinned release's complete `skills/` directory into the original
   location. Preserve the existing harness manifest, loader, extension, and
   session-start hook; they are the compatibility adapter.
6. Verify recursively that the installed `skills/` matches the pinned Lite
   checkout, that the renamed Backup still contains
   `using-superpowers/SKILL.md`, and that no second active skill source remains.
7. Report the exact installed path, Backup path, release, verification result,
   and a Rollback command that restores the backup. Do not execute Rollback.
8. Tell me whether I must restart the harness or open a new session. Warn me
   that an upstream plugin update may overwrite an in-place Lite migration.

If upstream Superpowers is not installed:

1. Prefer the harness's native plugin or source-package installation mechanism.
   Read this repository's harness-specific documentation and inspect the
   pinned release manifests instead of inventing commands.
2. For OpenCode, follow `docs/README.opencode.md`. For Kimi Code, follow
   `docs/README.kimi.md`.
3. For Codex, Claude Code, Cursor, or another harness, use a documented native
   local/source plugin install only if the installed harness supports it. The
   installation must deliver all three integration pieces: the complete
   `skills/` directory, the harness tool mapping, and automatic loading of
   `using-superpowers` at session start or through native skill discovery.
4. Do not simulate installation by editing my global AGENTS.md, CLAUDE.md,
   GEMINI.md, shell profile, or unrelated personal configuration. If this
   harness has no verified source-install mechanism, stop and explain that
   limitation without making a partial installation.
5. Verify the installed source and report how to uninstall or Rollback it.

After either path, provide a concise final report. Do not claim success unless
fresh verification passed.
```

The prompt intentionally replaces the complete `skills/` directory instead of
copying selected `SKILL.md` files. Lite changes 14 workflow skill files, and a
partial overlay can leave contradictory upstream rules or stale supporting
files.

## What the agent should change

For an existing upstream v6.1.1 installation, the migration is deliberately
small:

1. Keep the harness's existing plugin manifest, loader, hooks, and tool mapping.
2. Rename the active upstream `skills/` directory to a timestamped backup.
3. Put the pinned Lite `skills/` directory in its place.
4. Restart the harness or start a new session.

The backup makes the operation reversible and avoids maintaining a mixed tree.
An in-place migration may still appear as “Superpowers” in the harness UI
because it reuses the upstream adapter. Its loaded skill behavior is Lite.

## Verify the installation

Start a clean session and try both checks:

1. `Let's make a React todo list.` A working bootstrap should select
   `brainstorming` before writing code.
2. `Correct one spelling mistake in README and verify it.` Lite should treat
   this as a small, explicit change rather than forcing a full spec and plan.

The second prompt changes whichever repository the agent is currently using,
so run it only in a disposable test repository.

## Rollback prompt

Keep the reported Backup path. To restore upstream Superpowers later, give the
agent this prompt:

```text
Restore my previous upstream Superpowers skills from this exact backup:
<PASTE_BACKUP_PATH>

Resolve the currently active Superpowers `skills/` directory, confirm the
backup contains `using-superpowers/SKILL.md`, show both exact paths, and replace
the active Lite directory with the backup using recoverable move operations.
Do not delete either directory and do not modify project files. Verify the
restored tree, then tell me to restart the harness or open a new session.
```

## Native installation guides

- [OpenCode](README.opencode.md)
- [Kimi Code](README.kimi.md)
- [Main project README](../README.md)
