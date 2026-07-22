# Superpowers Lite Skills-Overlay Repository Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (default) to implement this plan task-by-task; use superpowers:subagent-driven-development only for multi-task isolation, high-risk changes, or explicit user request. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce the public default branch to a self-contained `superpowers-lite` skills overlay with concise bilingual positioning and a safe agent-driven backup/replacement workflow.

**Architecture:** `skills/` is the only product payload. The existing Superpowers installation continues to supply each harness adapter; bilingual root READMEs teach an agent to detect that installation, back up its complete active skills directory, replace it with this repository's skills, verify the result, and report rollback. A temporary acceptance gate validates the final tree without leaving a tests module in the repository.

**Tech Stack:** Markdown, Bash, Git, existing zero-dependency skill assets

## Global Constraints

- The product name is always **Superpowers Lite** or `superpowers-lite`; do not present a version-suffixed Lite name.
- Preserve `skills/`, `README.md`, `README.zh-CN.md`, `LICENSE`, `NOTICE`, `.gitattributes`, and `.gitignore`; remove every other path from the final default-branch tree.
- Preserve existing Git history and the current GitHub Release; do not rewrite history or delete releases.
- Do not claim standalone plugin or marketplace installation.
- Do not include unverified Pi or Antigravity compatibility status in either README.
- State 30%+ token savings, faster completion, and better-focused results as a maintainer field observation, not a universal guarantee.
- The installation prompt must use a recoverable Backup and provide Rollback without irreversible deletion.

---

### Task 1: Define the final-surface acceptance gate

**Files:**
- Create temporarily: `/tmp/superpowers-lite-skills-overlay-gate.py`
- Test: current repository tree and final repository tree

**Interfaces:**
- Consumes: Git tracked-file list, both root READMEs, every file under `skills/`
- Produces: exit status `0` only when the repository matches the approved minimal surface and documentation contract

- [ ] **Step 1: Create the temporary failing gate**

Use `apply_patch` to create `/tmp/superpowers-lite-skills-overlay-gate.py`. The validator must:

1. Run `git ls-files` and reject every path outside the seven-path allowlist.
2. Require all seven retained paths and every current top-level skill directory.
3. Require both READMEs to contain the Lite repository URL, the official GPT-5.6 and Claude Fable 5 guidance URLs, `30%`, `Backup`, `Rollback`, `docs/superpowers/specs/`, and `docs/superpowers/plans/`.
4. Reject `v6.1.1-lite.1`, `Pi`, and `Antigravity` in both READMEs.
5. Reject README claims that this repository is a standalone marketplace plugin.
6. Resolve relative Markdown links inside `skills/` and fail on a missing target.

- [ ] **Step 2: Run the gate and verify RED**

Run:

```bash
python3 /tmp/superpowers-lite-skills-overlay-gate.py /Users/geekvape/develop/superpowers-lite/.worktrees/open-source-release
```

Expected: non-zero exit because the current repository still tracks manifests,
hooks, tests, docs, scripts, and other files outside the allowlist.

### Task 2: Rewrite the bilingual product and installation documentation

**Files:**
- Modify: `README.md`
- Modify: `README.zh-CN.md`
- Modify: `.gitignore`
- Modify: `.gitattributes`

**Interfaces:**
- Consumes: approved design and the current `skills/` payload
- Produces: self-contained English and Chinese explanations plus an agent-executable overlay prompt

- [ ] **Step 1: Rewrite both READMEs**

Each README must contain:

1. A short definition of Superpowers Lite as a lightweight skills overlay for stronger modern models.
2. Official GPT-5.6 and Claude Fable 5 guidance links and a careful explanation that the project follows their lean-prompt direction without vendor endorsement.
3. A preserved-structure section covering skill names, the main workflow,
   `docs/superpowers/specs/`, and `docs/superpowers/plans/`.
4. A field-results section stating 30%+ observed token reduction, faster delivery,
   and better-focused first-pass results, with an explicit non-guarantee qualifier.
5. A copy-paste installation prompt that detects the active Superpowers installation,
   installs upstream through the harness's native method only when absent, creates a
   unique timestamped Backup of the complete active `skills/`, copies the complete
   Lite `skills/`, verifies recursive equality, and reports Rollback.
6. A warning that the harness may still display the upstream plugin name and that
   upstream updates can overwrite the overlay.
7. License, attribution, issues, and pull-request links in compact form.

- [ ] **Step 2: Simplify Git attributes and ignores**

Keep LF rules for Markdown, JavaScript, TypeScript, shell scripts, and other text
assets present under `skills/`. Reduce `.gitignore` to local macOS/editor artifacts,
worktrees, private notes, and temporary dependency directories; remove comments
that reference deleted root modules.

- [ ] **Step 3: Run documentation-focused portions of the temporary gate**

Run the full gate. Expected: it still fails on extra tracked paths, but no longer
reports README naming, claims, prompt, or guidance failures.

- [ ] **Step 4: Commit the documentation rewrite**

```bash
git add README.md README.zh-CN.md .gitattributes .gitignore
git commit -m "docs: position Lite as a skills overlay"
```

### Task 3: Remove non-skill modules and verify the minimal distribution

**Files:**
- Delete: every tracked path except `skills/**`, `README.md`, `README.zh-CN.md`, `LICENSE`, `NOTICE`, `.gitattributes`, and `.gitignore`
- Preserve: all 48 currently tracked files under `skills/` unless a validation step proves one is unsafe or externally dependent

**Interfaces:**
- Consumes: the final allowlist and rewritten READMEs
- Produces: a repository whose current tree is only the skills overlay and minimum public documentation

- [ ] **Step 1: Build and review an explicit deletion manifest**

Generate `/tmp/superpowers-lite-delete-paths.txt` from `git ls-files`, excluding
only the approved allowlist. Print the complete manifest, confirm it contains no
`skills/`, README, license, notice, attributes, or ignore path, and record its
file count before deletion.

- [ ] **Step 2: Run relevant existing tests before removing the test harness**

Run:

```bash
bash tests/release/test-release-surface.sh
bash tests/release/test-release-metadata.sh
bash tests/shell-lint/test-lint-shell.sh
```

Expected: all current release and shell-lint tests pass before their requested removal.

- [ ] **Step 3: Delete the reviewed manifest paths**

Use Git's tracked-file removal with the reviewed explicit manifest. Do not delete
untracked user files and do not modify the retained `skills/` tree.

- [ ] **Step 4: Run the final acceptance gate and syntax checks**

Run:

```bash
python3 /tmp/superpowers-lite-skills-overlay-gate.py /Users/geekvape/develop/superpowers-lite/.worktrees/open-source-release
find skills -type f -name '*.sh' -exec bash -n {} \;
find skills -type f \( -name '*.js' -o -name '*.cjs' \) -exec node --check {} \;
git diff --check
```

Expected: every command exits `0`.

- [ ] **Step 5: Inspect and commit the removal**

Confirm `git status --short` lists only the intended deletions, with no modified
or deleted `skills/` files beyond the already-reviewed README changes. Then run:

```bash
git add -u
git commit -m "refactor: publish Lite as a skills-only overlay"
```

- [ ] **Step 6: Verify the committed tree**

Run the temporary gate against `HEAD`, confirm `git status --short --branch` is
clean, and print `git ls-tree -r --name-only HEAD`. Do not push until the
maintainer authorizes the external write.
