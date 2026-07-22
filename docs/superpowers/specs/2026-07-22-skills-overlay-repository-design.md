# Superpowers Lite Skills-Overlay Repository Design

**Date:** 2026-07-22
**Status:** Approved through maintainer direction

## Objective

Turn the public repository from a multi-harness standalone plugin into a small
skills-overlay distribution. The product name is always **Superpowers Lite** or
`superpowers-lite`; it is not presented as a version-suffixed edition.

Users keep their existing Superpowers harness adapter and replace its complete
`skills/` directory with the one from this repository. A coding agent performs
path discovery, backup, replacement, verification, and rollback reporting.

## Final repository surface

The default branch retains only:

- `skills/`
- `README.md`
- `README.zh-CN.md`
- `LICENSE`
- `NOTICE`
- `.gitattributes`
- `.gitignore`

All harness manifests, loaders, hooks, root package metadata, tests, scripts,
assets, governance documents, and `docs/` are removed from the final tree.
Project history and the existing release remain intact; this is not a history
rewrite or release deletion.

## Installation model

The README embeds a standalone copy-paste prompt for Codex, Claude Code,
Cursor, and similar coding agents. The prompt requires the agent to:

1. Detect the active Superpowers installation through harness-owned metadata
   and paths.
2. If Superpowers is not installed, use the harness's supported native method
   to install upstream Superpowers first, because this repository no longer
   ships a standalone adapter.
3. Resolve exactly one active `skills/` directory.
4. Download the current `superpowers-lite` repository into a temporary path.
5. Move the complete active `skills/` directory to a unique timestamped backup.
6. Copy the complete Lite `skills/` directory into the original location.
7. Verify the installed tree against the checkout and report an exact rollback
   operation without executing it.

The prompt must not use irreversible deletion, change application projects, or
leave two active Superpowers skill sources. If discovery is ambiguous, it stops
before mutation.

## Positioning

The README leads with these points:

- Superpowers Lite is a lightweight skill set for stronger modern coding
  models.
- Its simplification follows the direction of official GPT-5.6 and Claude
  Fable 5 prompting guidance: remove repeated, legacy, and unnecessarily
  prescriptive instructions, then validate against representative work.
- It preserves the familiar Superpowers workflow, skill names,
  `docs/superpowers/specs/`, and `docs/superpowers/plans/` project structure.
- Small explicit tasks may proceed directly; ambiguous features still use
  brainstorming, specifications, planning, TDD, and fresh verification.
- Maintainer field observation is stated as **30%+ token savings**, faster
  completion, and better-focused first-pass results. It is identified as a
  real-project observation rather than a universal guarantee.

The README does not contain unverified Pi or Antigravity compatibility status.
It does not claim marketplace or standalone-plugin installation.

## Compatibility consequences

- The harness UI may continue to display the upstream plugin name because the
  upstream adapter remains installed.
- Upstream plugin updates can overwrite the overlay; users keep the backup and
  rerun the installation prompt after updates.
- Existing projects keep their `superpowers:*` references and specs/plans
  layout without migration.
- The repository is no longer directly installable through the removed Kimi,
  OpenCode, Claude, Cursor, Codex, Pi, Gemini, or Antigravity manifests.

## Verification

Before completion:

1. Prove the old repository fails a strict final-tree allowlist check.
2. Confirm every relative file reference inside `skills/` resolves within
   `skills/` or is clearly an output path in the user's project.
3. Confirm both READMEs contain the repository URL, agent installation prompt,
   Backup and Rollback behavior, official guidance links, preserved structure,
   and the qualified 30%+ observation.
4. Confirm both READMEs omit version-suffixed Lite naming and Pi/Antigravity
   compatibility claims.
5. Confirm the final Git status contains only the intended deletion/rewrite
   change and the final tree matches the allowlist exactly.
