# Contributing to Superpowers Lite

Thanks for helping make Superpowers Lite smaller, clearer, and more reliable.
Contributions should solve a real, reproducible problem without weakening
safety, verification, or compatibility for existing Superpowers projects.

## Before opening an issue

Search open and closed issues first. For a bug or behavior regression, record:

- the exact Lite revision or release;
- model, reasoning effort, harness, harness version, and installed plugins;
- the smallest prompt or repository fixture that reproduces the behavior;
- expected and actual results;
- a sanitized transcript or tool trace when it materially supports the report.

Remove credentials, personal data, private repository content, and local paths
before sharing logs. Use [SUPPORT.md](SUPPORT.md) to decide whether the problem
belongs here, upstream, or in the harness.

## Pull requests

1. Open or identify one issue that describes the experienced problem.
2. Fork the repository and create a focused branch from `main`.
3. Keep one problem per pull request.
4. Add the smallest test that fails for the reported reason.
5. Make the minimum implementation change, then run the relevant adapter and
   behavior tests.
6. Review the complete diff yourself and remove generated noise or private data.
7. Complete every section of the pull request template.

Do not bundle rebranding, formatting, unrelated cleanup, or speculative fixes
with a behavior change. Project-specific skills and third-party integrations
usually belong in their own plugin.

## Skill behavior changes

Skills shape agent behavior and are reviewed like code. A skill change should
include:

- a real baseline failure;
- an upstream and Lite comparison when the claim concerns their difference;
- matched prompts, model, effort, harness, and initial context;
- functional and scope grading, not token counts alone;
- repeated runs for broad quality or efficiency claims;
- an explanation of which safety and compatibility invariants remain intact.

Line-count reduction by itself is not evidence of better behavior. Token
comparisons must distinguish cached input, fresh input, output, and processed
tokens and must disclose whether the task outcomes were equally correct.

## AI-assisted contributions

AI assistance is welcome, but the submitter remains responsible for the work.
Disclose:

- model and version;
- harness and version;
- installed plugins or skills that materially influenced the change;
- which tests or evals were run;
- the human who reviewed the complete diff.

Do not fabricate a problem statement, test result, transcript, or human review.

## Development checks

Run the narrowest relevant test first. Before requesting review, also run:

```bash
git diff --check
bash tests/release/test-release-metadata.sh
bash tests/shell-lint/test-lint-shell.sh
```

Adapter-specific changes must run that adapter's test suite. Changes to
`skills/brainstorming/scripts/` must run the brainstorm server tests.

## License

By contributing, you agree that your contribution is licensed under this
repository's [MIT License](LICENSE).
