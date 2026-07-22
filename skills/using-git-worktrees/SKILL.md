---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback
---

# Using Git Worktrees

Ensure work happens in an isolated workspace. Detect existing isolation
first, prefer the platform's native worktree tools, and fall back to manual
git worktrees only when no native tool exists. Never fight the harness.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## Step 0: Detect Existing Isolation

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
git rev-parse --show-superproject-working-tree 2>/dev/null  # non-empty = submodule
```

- `GIT_DIR != GIT_COMMON` **and not a submodule**: you are already in a
  linked worktree — do NOT create another; skip to Step 2. Report the path
  and branch (note detached HEAD as externally managed if applicable).
- `GIT_DIR == GIT_COMMON` (or submodule): normal checkout. If the user has
  a declared worktree preference, honor it; otherwise ask once:
  "Would you like me to set up an isolated worktree? It protects your
  current branch from changes." If declined, work in place (Step 2).

## Step 1: Create the Workspace

**1a. Native tools first.** If the platform provides a worktree mechanism
(a tool like `EnterWorktree`, a `/worktree` command, a `--worktree` flag),
use it and skip to Step 2. Native tools handle placement, branching, and
cleanup; using `git worktree add` alongside them creates phantom state the
harness can't manage.

**1b. Git fallback** (only when no native tool exists):

Directory priority: explicit user preference > existing `.worktrees/` >
existing `worktrees/` > default `.worktrees/` at the project root.

For project-local directories, verify the directory is git-ignored before
creating anything — otherwise worktree contents pollute the repo:

```bash
git check-ignore -q .worktrees 2>/dev/null || { echo ".worktrees/" >> .gitignore && git add .gitignore && git commit -m "chore: ignore worktrees dir"; }
git worktree add "$LOCATION/$BRANCH_NAME" -b "$BRANCH_NAME"
cd "$LOCATION/$BRANCH_NAME"
```

If `git worktree add` fails with a sandbox/permission error, say so and
work in the current directory instead.

## Step 2: Project Setup

Auto-detect and run the project's setup: `npm install` (package.json),
`cargo build` (Cargo.toml), `pip install -r requirements.txt` /
`poetry install` (Python), `go mod download` (go.mod).

## Step 3: Verify Clean Baseline

Run the test suite. Tests pass → report ready ("Worktree ready at <path>,
N tests passing"). Tests fail → report the failures and ask whether to
proceed or investigate first; a dirty baseline makes new bugs
indistinguishable from pre-existing ones.
