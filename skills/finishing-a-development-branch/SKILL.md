---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

Verify tests → detect environment → present options → execute choice → clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## Step 1: Verify Tests

Run the project's test suite. If tests fail, show the failures and stop —
no merge or PR until they pass.

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
```

- `GIT_DIR == GIT_COMMON`: normal repo — standard 4 options, no worktree cleanup.
- `GIT_DIR != GIT_COMMON`, named branch: worktree — standard 4 options, provenance-based cleanup (Step 6).
- `GIT_DIR != GIT_COMMON`, detached HEAD: externally managed — reduced 3 options (no local merge), no cleanup.

## Step 3: Determine Base Branch

`git merge-base HEAD main` (or `master`), or ask: "This branch split from main — correct?"

## Step 4: Present Options

Normal repo / named-branch worktree — present exactly these, without extra explanation:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

Detached HEAD: offer only Push-as-new-branch + PR / Keep / Discard.

## Step 5: Execute Choice

**1. Merge locally:**

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base-branch> && git pull && git merge <feature-branch>
<test command>   # verify tests on the merged result
```

Only after the merge succeeds: clean up the worktree (Step 6), then
`git branch -d <feature-branch>`. Order matters — branch deletion fails
while a worktree still references the branch.

**2. Push and create PR:** `git push -u origin <feature-branch>`. Keep the
worktree — it's needed to iterate on PR feedback.

**3. Keep as-is:** report branch name and worktree path; touch nothing.

**4. Discard** — destructive, requires typed confirmation first:

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for the exact word. If confirmed: `cd` to the main repo root, clean up
the worktree (Step 6), then `git branch -D <feature-branch>`.

## Step 6: Cleanup Workspace (Options 1 and 4 only)

```bash
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

- Normal repo: nothing to clean up.
- Worktree path under `.worktrees/` or `worktrees/`: Superpowers created it —
  `cd` to the main repo root (never run removal from inside the worktree),
  then `git worktree remove "$WORKTREE_PATH" && git worktree prune`.
- Any other path: the harness owns this workspace — do NOT remove it. Use a
  workspace-exit tool if the platform provides one, otherwise leave it.

## Invariants

- No merge/PR with failing tests.
- Typed confirmation before discarding work; never force-push without an
  explicit request.
- Only clean up worktrees you created (provenance check above).
