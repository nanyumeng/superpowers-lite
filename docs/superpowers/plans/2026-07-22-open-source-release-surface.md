# Superpowers Lite Open-Source Release Surface Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (default) to implement this plan task-by-task; use superpowers:subagent-driven-development only for multi-task isolation, high-risk changes, or explicit user request. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace inherited upstream release identity and telemetry with a privacy-clean Superpowers Lite release surface, then add the governance files required to accept outside issues and pull requests.

**Architecture:** Keep `superpowers:*` skill names, skill directories, runtime entry-point filenames, and upstream MIT attribution for compatibility. Rename public packages and plugin manifests to `superpowers-lite`, point current-project URLs and authorship to `nanyumeng/superpowers-lite`, remove the visual companion's external image request, and document the fork/upstream boundary. Automated contract tests guard release metadata, offline branding, links, privacy, and adapter behavior.

**Tech Stack:** JSON manifests, Markdown, YAML, CommonJS/Node.js, shell tests, Git.

## Global Constraints

- Public project identity is `Superpowers Lite`, package/plugin slug `superpowers-lite`, repository `https://github.com/nanyumeng/superpowers-lite`, and first release `6.1.1-lite.1`.
- Preserve the upstream MIT license and Jesse Vincent attribution; upstream identity may remain only in license, acknowledgement, historical release notes, issue references, or explicit upstream-sync documentation.
- Preserve `superpowers:*` skill names, the `skills/` layout, and existing runtime entry-point filenames where renaming would break installed projects.
- Do not include maintainer email addresses, local paths, task IDs, credentials, private transcripts, or invented contact channels.
- Runtime visual companion pages must not make a request to `primeradiant.com` or another analytics/branding endpoint.
- Do not push, create the GitHub repository, enable remote settings, or open an upstream issue/PR in this plan.
- A private Code of Conduct contact remains a release blocker until the owner supplies one; remove the inherited upstream email and state the temporary boundary without fabricating an address.

---

### Task 1: Lock the Lite release identity in tests and manifests

**Files:**
- Create: `tests/release/test-release-metadata.sh`
- Modify: `package.json`
- Modify: `gemini-extension.json`
- Modify: `.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`
- Modify: `.codex-plugin/plugin.json`
- Modify: `.cursor-plugin/plugin.json`
- Modify: `.kimi-plugin/plugin.json`
- Modify: `.agents/plugins/marketplace.json`
- Modify: `tests/codex/test-marketplace-manifest.sh`
- Modify: `tests/kimi/test-plugin-manifest.sh`

**Interfaces:**
- Consumes: the compatibility contract from the approved release design.
- Produces: consistent `superpowers-lite` identity, `6.1.1-lite.1` version, `nanyumeng` author, and personal-repository URLs across every published manifest.

- [x] **Step 1: Add a failing metadata contract**

Create a shell test that loads all JSON manifests with Python and asserts the public slug, display name, version, author, homepage/repository, privacy/license URLs, preserved `skills` paths, and absence of `jesse@`, `primeradiant`, and current-project `obra/superpowers` URLs.

- [x] **Step 2: Run the metadata tests and confirm RED**

Run:

```bash
bash tests/release/test-release-metadata.sh
bash tests/codex/test-marketplace-manifest.sh
bash tests/kimi/test-plugin-manifest.sh
```

Expected: failures show inherited `superpowers`, `superpowers-dev`, v6.1.1, upstream author, or upstream repository values.

- [x] **Step 3: Apply the minimal manifest rewrite**

Use `superpowers-lite`, `Superpowers Lite`, `superpowers-lite-dev`, `6.1.1-lite.1`, author `nanyumeng`, and `https://github.com/nanyumeng/superpowers-lite`. Point the Codex privacy policy to `PRIVACY.md` and terms to `LICENSE` in the personal repository. Preserve runtime skill and hook paths.

- [x] **Step 4: Update adapter test expectations and verify GREEN**

Run the three tests from Step 2 plus:

```bash
./scripts/bump-version.sh --check
```

Expected: all pass and all declared manifests report `6.1.1-lite.1`.

### Task 2: Remove remote branding and inherited visual assets with TDD

**Files:**
- Modify: `tests/brainstorm-server/branding.test.js`
- Modify: `skills/brainstorming/scripts/server.cjs`
- Modify: `skills/brainstorming/scripts/frame-template.html`
- Modify: `assets/superpowers-small.svg`
- Delete: `assets/app-icon.png`
- Modify: `.codex-plugin/plugin.json`
- Modify: `tests/codex/test-package-codex-plugin.sh`

**Interfaces:**
- Consumes: `brandMarkup()` and the visual companion HTTP test harness.
- Produces: local text branding `Superpowers Lite v<version>`, link to the Lite repository, no remote image or telemetry environment branch, and one neutral local SVG used by the Codex interface.

- [x] **Step 1: Rewrite one branding behavior test and confirm RED**

Assert that framed and waiting pages contain `Superpowers Lite v<version>`, link to the Lite repository, contain no `primeradiant.com`, no remote `<img>`, and no `Prime Radiant` text regardless of legacy telemetry environment variables.

Run:

```bash
node tests/brainstorm-server/branding.test.js
```

Expected: FAIL because the current server injects the upstream remote image and brand.

- [x] **Step 2: Implement the offline visual companion branding**

Remove `SUPERPOWERS_BRAND_IMAGE_URL`, telemetry opt-out branching, remote `<img>`, and unused logo CSS. Render one local text link to the Lite repository. Replace the plugin SVG with a neutral `SL` mark, point both Codex icon fields at it, and remove the inherited PNG.

- [x] **Step 3: Verify GREEN and package behavior**

Run:

```bash
node tests/brainstorm-server/branding.test.js
bash tests/codex/test-package-codex-plugin.sh
```

Expected: branding tests pass with no network image, and packaged assets match the new manifest.

### Task 3: Add release governance and fork documentation

**Files:**
- Create: `NOTICE`
- Create: `CONTRIBUTING.md`
- Create: `SECURITY.md`
- Create: `SUPPORT.md`
- Create: `PRIVACY.md`
- Create: `UPSTREAM.md`
- Create: `CHANGELOG.md`
- Modify: `CODE_OF_CONDUCT.md`

**Interfaces:**
- Consumes: the upstream MIT license, approved fork policy, and GitHub Private Vulnerability Reporting URL.
- Produces: attribution, contribution/evaluation rules, security intake, support routing, runtime privacy disclosure, upstream-sync policy, and initial Lite changelog.

- [x] **Step 1: Write focused governance files**

Document one-issue-per-PR, real problem evidence, AI assistance disclosure, skill before/after evals, target branch policy, GitHub private vulnerability reports, Lite-versus-upstream support routing, no intentional usage telemetry, upstream baseline `d884ae0`, and `v6.1.1-lite.1` as unreleased.

- [x] **Step 2: Remove inherited conduct contact safely**

Remove `jesse@primeradiant.com`. State that confidential conduct intake is not yet configured and public reports must not include sensitive information. Record a dedicated private contact as a release blocker rather than inventing one.

- [x] **Step 3: Verify local links and required statements**

Run a local Markdown link check plus searches for `nanyumeng`, `d884ae0`, private vulnerability reporting, AI disclosure, and upstream attribution.

Expected: every local link resolves and no unresolved placeholder text or invented email remains.

### Task 4: Open the issue/PR surface and correct source-install docs

**Files:**
- Modify: `.github/ISSUE_TEMPLATE/bug_report.md`
- Create: `.github/ISSUE_TEMPLATE/behavior_token_regression.md`
- Modify: `.github/ISSUE_TEMPLATE/feature_request.md`
- Modify: `.github/ISSUE_TEMPLATE/platform_support.md`
- Modify: `.github/ISSUE_TEMPLATE/config.yml`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`
- Delete: `.github/FUNDING.yml`
- Modify: `.opencode/INSTALL.md`
- Modify: `docs/README.opencode.md`
- Modify: `docs/README.kimi.md`

**Interfaces:**
- Consumes: governance rules from Task 3 and manifest identity from Task 1.
- Produces: external issue/PR forms with Lite-specific reproduction and token methodology, plus install docs that never install upstream by mistake.

- [x] **Step 1: Rewrite community templates**

Replace upstream marketing and rejection-rate copy with concise Lite requirements. Add a behavior/token regression template requiring matched task, model, effort, harness, revisions, cache-aware counts, correctness outcome, and transcript sanitization. Point help to `SUPPORT.md`.

- [x] **Step 2: Remove inherited sponsorship**

Delete `.github/FUNDING.yml`; Lite must not direct sponsors to the upstream maintainer through fork-owned repository chrome.

- [x] **Step 3: Correct installation URLs**

Change OpenCode and Kimi source installation examples, update examples, issue links, and documentation links to `nanyumeng/superpowers-lite` and the Lite release tag. Preserve uninstall and troubleshooting behavior.

- [x] **Step 4: Verify template and install identity**

Search active manifests, templates, and install docs for inherited upstream promotion or install commands. Explicit upstream links are allowed only in `README*`, `NOTICE`, `UPSTREAM.md`, `LICENSE`, and historical release notes.

### Task 5: Full release-surface verification and commit

**Files:**
- Verify all files modified by Tasks 1–4.

**Interfaces:**
- Consumes: the complete release-surface diff.
- Produces: a clean local commit suitable for owner review; no remote write.

- [x] **Step 1: Run adapter and runtime suites**

Run:

```bash
bash tests/release/test-release-metadata.sh
node tests/brainstorm-server/branding.test.js
bash tests/codex/test-marketplace-manifest.sh
bash tests/codex/test-package-codex-plugin.sh
bash tests/kimi/test-plugin-manifest.sh
bash tests/opencode/run-tests.sh
bash tests/hooks/test-session-start.sh
bash tests/shell-lint/test-lint-shell.sh
./scripts/bump-version.sh --check
```

Expected: all relevant release tests pass. If the linked-worktree-only package check rejects `.git` as a file, run it from the normal checkout at the same commit and document the test-harness limitation.

- [x] **Step 2: Run privacy, brand, and repository checks**

Run `git diff --check`, validate all changed JSON with `python3 -m json.tool`, resolve all changed Markdown links, and scan public files for local home paths, task IDs, credentials, upstream emails, Prime Radiant marketing, and remote visual-companion image URLs.

- [x] **Step 3: Commit the release surface**

```bash
git add --all
git diff --cached --check
git commit -m "chore: prepare Lite open-source release surface"
```

Expected: a clean worktree and no remote push.
