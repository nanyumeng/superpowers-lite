# Superpowers Lite README and GPT-5.6 Comparison Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (default) to implement this plan task-by-task; use superpowers:subagent-driven-development only for multi-task isolation, high-risk changes, or explicit user request. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish an evidence-based English and Chinese project introduction that explains Superpowers Lite, compares it with upstream Superpowers, and reports a reproducible preliminary GPT-5.6 token/quality comparison without exposing private session data.

**Architecture:** Build the public work on a clean branch rooted before the private research commit. Run paired Codex CLI fixtures against upstream `v6.1.1` and Lite `447a754` with the same model, effort, prompt, repository and grader; publish only sanitized aggregate results. Rewrite the upstream-derived README around Lite's compatibility contract, official prompting guidance, measured results and honest limitations.

**Tech Stack:** Markdown, Git, shell, Codex CLI `0.145.0-alpha.30`, GPT-5.6 Sol, Node.js fixture tests.

## Global Constraints

- The public branch starts from `447a754`; commit `c663772` and its internal research files must not enter public refs.
- The intended repository is `nanyumeng/superpowers-lite`; no remote repository creation or push occurs in this plan.
- Preserve the upstream MIT license and clearly identify Lite as an unofficial derivative of `obra/superpowers` v6.1.1.
- Preserve `superpowers:*` skill names and `docs/superpowers/specs/` / `docs/superpowers/plans/` compatibility.
- Do not claim that prompt-line reduction equals token reduction.
- Do not publish private task identifiers, local usernames, absolute home paths, credentials, raw session transcripts or business-project details.
- Cite the exact OpenAI GPT-5.6 prompt-guidance URL requested by the project owner and Anthropic's official Claude Fable 5 prompting guide.
- Treat OpenAI's reported 10–15% score gain and 41–66% token reduction as OpenAI's internal directional result, not as a Lite benchmark.
- Publish a Lite accuracy or token advantage only if the paired runs produce it; otherwise report the actual neutral or negative result.

---

### Task 1: Create the clean public development line

**Files:**
- Preserve: `docs/superpowers/specs/2026-07-22-superpowers-lite-open-source-release-design.md`
- Preserve: `docs/superpowers/plans/2026-07-22-readme-and-gpt56-comparison.md`
- Exclude: `docs/research/`

**Interfaces:**
- Consumes: Lite behavior commit `447a754`, design commit `191c8f3`, and this plan commit.
- Produces: branch `codex/open-source-release` with no ancestry through `c663772`.

- [ ] **Step 1: Record this plan on the private working branch**

Run:

```bash
git add docs/superpowers/plans/2026-07-22-readme-and-gpt56-comparison.md
git diff --cached --check
git commit -m "docs: plan README and GPT-5.6 comparison"
```

Expected: one documentation commit and a clean working tree.

- [ ] **Step 2: Create the release branch and carry only public documentation forward**

Run:

```bash
git switch -c codex/open-source-release 447a754
git cherry-pick 191c8f3
git cherry-pick lite
```

The `lite` branch still points to the plan commit after the new branch is created. Expected: `git merge-base --is-ancestor c663772 HEAD` exits `1`, while both design and plan files exist.

- [ ] **Step 3: Verify the public line excludes private research**

Run:

```bash
git log --oneline --decorate -10
git ls-tree -r --name-only HEAD docs/research
git grep -n -E '/Users/[^/]+|\.codex/sessions|019f[0-9a-f-]{20,}' HEAD -- . ':!docs/superpowers/specs/2026-07-22-superpowers-lite-open-source-release-design.md'
```

Expected: `docs/research` is absent and the privacy grep returns no matches.

### Task 2: Run the paired GPT-5.6 comparison

**Files:**
- Create: `docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md`
- Use temporarily: isolated repositories under a directory created by `mktemp -d`

**Interfaces:**
- Consumes: upstream skills at `d884ae0`, Lite skills at `447a754`, Codex CLI `/Applications/ChatGPT.app/Contents/Resources/codex`, model `gpt-5.6-sol`, reasoning effort `high`.
- Produces: per-run functional pass, scope pass, elapsed time, input tokens, cached input tokens, output tokens and total processed tokens; plus aggregate upstream/Lite comparison.

- [ ] **Step 1: Prepare three identical, deterministic fixtures per variant**

Create a temporary Git repository for each run. Each repository has a project-local `.agents/skills/superpowers` directory populated from exactly one Git revision and one of these fixtures:

1. `docs-typo`: change only `teh` to `the` in one README sentence.
2. `normalize-tags`: fix a JavaScript function so it trims, lowercases and de-duplicates tags while preserving order; hidden grading checks empty strings and duplicate ordering.
3. `timeout-default`: change a CLI default from 30 to 45 and update its focused test, with an explicit prohibition on redesign or new documentation.

Each fixture is committed before the agent runs. The grader passes only when focused tests succeed and the diff contains only the allowed files and behavior.

Use these exact initial fixture contents and prompts:

```text
docs-typo/README.md
Superpowers Lite is teh smallest compatible workflow layer.

Prompt:
Fix the typo "teh" to "the" in README.md. This is a small documentation-only change. Change nothing else, do not add planning documents, and verify the final diff.

Allowed diff: README.md only.
Expected final content: Superpowers Lite is the smallest compatible workflow layer.
```

```javascript
// normalize-tags/src/tags.js
export function normalizeTags(tags) {
  return tags.map((tag) => tag.toLowerCase());
}

// normalize-tags/test/tags.test.js
import test from 'node:test';
import assert from 'node:assert/strict';
import { normalizeTags } from '../src/tags.js';

test('normalizes tags', () => {
  assert.deepEqual(normalizeTags(['Alpha', 'BETA']), ['alpha', 'beta']);
});
```

```text
normalize-tags/package.json
{"type":"module","scripts":{"test":"node --test"}}

Prompt:
Fix normalizeTags so it trims whitespace, lowercases tags, removes empty tags, and de-duplicates while preserving first-seen order. Add focused tests, make the smallest production change, run them, and do not add planning documents or dependencies.

Allowed diff: src/tags.js and test/tags.test.js only.
Hidden check: normalizeTags([' Alpha ', 'alpha', '', ' BETA ', 'beta']) returns ['alpha', 'beta'].
```

```javascript
// timeout-default/src/config.js
export const DEFAULT_TIMEOUT_SECONDS = 30;

// timeout-default/test/config.test.js
import test from 'node:test';
import assert from 'node:assert/strict';
import { DEFAULT_TIMEOUT_SECONDS } from '../src/config.js';

test('uses the default timeout', () => {
  assert.equal(DEFAULT_TIMEOUT_SECONDS, 30);
});
```

```text
timeout-default/package.json
{"type":"module","scripts":{"test":"node --test"}}

Prompt:
Change the CLI default timeout from 30 seconds to 45 seconds and update the focused test. Do not redesign configuration, add compatibility layers, create documentation, or change unrelated files. Run the focused test and verify the final diff.

Allowed diff: src/config.js and test/config.test.js only.
Hidden check: DEFAULT_TIMEOUT_SECONDS is exactly 45.
```

- [ ] **Step 2: Run upstream and Lite with identical settings**

Create the temporary root with `LITE_BENCH_ROOT=$(mktemp -d /private/tmp/superpowers-lite-bench.XXXXXX)`. For each fixture and each variant, run these exact prompts with the same CLI options:

```bash
/Applications/ChatGPT.app/Contents/Resources/codex exec \
  --ephemeral --json --ignore-user-config --ignore-rules \
  --model gpt-5.6-sol -c 'model_reasoning_effort="high"' \
  --sandbox workspace-write -c 'approval_policy="never"' \
  --cd "$LITE_BENCH_ROOT/upstream/docs-typo" \
  'Fix the typo "teh" to "the" in README.md. This is a small documentation-only change. Change nothing else, do not add planning documents, and verify the final diff.'
```

Repeat the command for `lite/docs-typo`, then for both variants of `normalize-tags` and `timeout-default` using the exact prompts above. Expected: six independent JSONL outputs. Confirm each run's tool trace reads the intended project-local skill revision; discard and rerun any contaminated pair.

- [ ] **Step 3: Grade and aggregate without cherry-picking model output**

For every run, record:

- functional result from the fixture's hidden grader;
- scope result from `git diff --name-only` and exact assertions;
- elapsed wall time;
- Codex JSON usage fields: input, cached input, output and total tokens;
- number of changed files and whether unrequested specs/plans were created.

Calculate paired totals and medians. `fresh input = input - cached_input`; do not add `reasoning_output_tokens` to output if it is already a subset of output. Do not select only favorable scenarios or rerun one variant alone.

- [ ] **Step 4: Write the sanitized benchmark report**

The report must contain:

- exact revisions, CLI version, model and effort;
- scenario prompts and grading rules, without local paths;
- raw per-run aggregate metrics and pass/fail results;
- percent changes calculated from paired totals;
- limitations: three scenarios, one run per scenario, stochastic model behavior, local Codex harness, and no Claude A/B yet;
- a separate observational note that a private long-running task motivated the work but cannot be used as a before/after benchmark because one repair turn crossed the installation time.

Run:

```bash
git diff --check -- docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md
git grep -n -E '/Users/[^/]+|019f[0-9a-f-]{20,}|@gv\.local' -- docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md
```

Expected: both commands produce no findings.

- [ ] **Step 5: Commit the benchmark evidence**

Run:

```bash
git add docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md
git commit -m "docs: publish preliminary GPT-5.6 comparison"
```

Expected: one report commit containing no fixture worktrees or raw transcripts.

### Task 3: Rewrite the English and Chinese README

**Files:**
- Modify: `README.md`
- Create: `README.zh-CN.md`

**Interfaces:**
- Consumes: the approved release design and the measured report from Task 2.
- Produces: a complete public introduction and a Chinese counterpart with matching claims.

- [ ] **Step 1: Replace upstream product copy with Lite positioning**

Both READMEs must state, near the title:

- Superpowers Lite is an unofficial lightweight derivative of `obra/superpowers` based on v6.1.1.
- It is for existing Superpowers projects that want to retain workflow names and document structure while reducing prescriptive rules and default orchestration.
- Official Superpowers remains the better choice for teams that value its strict, extensively pressure-tested guardrails.
- Lite and upstream should not be enabled in the same harness at the same time.

- [ ] **Step 2: Add the core comparison table**

Cover these exact dimensions: workflow, small clear changes, design, implementation default, subagents, review loops, TDD, debugging, verification, directory compatibility, skill-name compatibility, prompt size and intended trade-off. The table must distinguish measured facts from design intent.

- [ ] **Step 3: Explain the model-guidance basis accurately**

Link exactly:

- `https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6`
- `https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5`

Paraphrase that OpenAI recommends leaner prompts, one statement per instruction and workload-specific evals; Anthropic recommends reviewing skills written for prior models because excessive prescription can reduce Fable 5 quality. Explicitly state that neither vendor evaluated or endorses Superpowers Lite.

- [ ] **Step 4: Add honest evidence and compatibility sections**

State that the 14 core skill files changed from 3,322 to 1,052 lines (68% smaller by line count), then link the benchmark report and reproduce only its actual result. Include the upstream issue references from the approved design as related user reports, not endorsements. Mark Codex, Claude Code and Cursor as release candidates pending end-to-end release verification; mark the remaining adapters experimental until their tests pass.

- [ ] **Step 5: Add installation, migration and upstream relationship**

Until the GitHub repository is created, provide source-install commands using `https://github.com/nanyumeng/superpowers-lite` and label them “available after first release.” Explain how to disable/remove official Superpowers first, preserve project docs, install Lite, start a clean session and roll back. Retain the original MIT attribution and link to upstream.

- [ ] **Step 6: Remove copied upstream calls to action**

Delete the Prime Radiant hiring, sales, sponsorship, community and telemetry marketing copy from the README. Do not claim official marketplace availability for Lite. Point Lite issues and contributions to `nanyumeng/superpowers-lite` while leaving upstream links only in attribution and comparison context.

- [ ] **Step 7: Verify bilingual claim parity and commit**

Run:

```bash
git diff --check -- README.md README.zh-CN.md
rg -n 'GPT-5\.6|Fable 5|3,322|1,052|68%|unofficial|非官方|nanyumeng/superpowers-lite' README.md README.zh-CN.md
rg -n 'primeradiant\.com/jobs|sales@primeradiant|discord\.gg|official marketplace|官方市场' README.md README.zh-CN.md
```

Expected: the first two commands pass with required claims present; the third returns no copied upstream promotion or false marketplace claim.

Run:

```bash
git add README.md README.zh-CN.md
git commit -m "docs: introduce Superpowers Lite"
```

### Task 4: Final verification for the README milestone

**Files:**
- Verify: `README.md`
- Verify: `README.zh-CN.md`
- Verify: `docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md`

**Interfaces:**
- Consumes: all prior tasks.
- Produces: reviewable README milestone diff; no remote write.

- [ ] **Step 1: Verify public-history privacy and attribution**

Run:

```bash
git merge-base --is-ancestor c663772 HEAD
git log --format='%H %an <%ae>' d884ae0..HEAD
git grep -n -E '/Users/[^/]+|\.codex/sessions|019f[0-9a-f-]{20,}|BEGIN [A-Z ]*PRIVATE KEY|gh[pousr]_[A-Za-z0-9_]+' HEAD
```

Expected: the ancestor command exits `1`; the log is reviewed for generic automation authorship; the privacy/secret scan returns no sensitive results.

- [ ] **Step 2: Run documentation and repository sanity checks**

Run:

```bash
git diff --check d884ae0..HEAD
git status --short
```

Expected: no whitespace errors and a clean working tree.

- [ ] **Step 3: Present the complete milestone diff for owner review**

Run:

```bash
git diff --stat d884ae0..HEAD
git diff -- README.md README.zh-CN.md docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md
```

Expected: the user can review the complete README and evidence changes before any GitHub repository creation, push, issue setting or pull-request action.
