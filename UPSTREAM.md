# Upstream Relationship

Superpowers Lite is an independent, unofficial derivative of
[`obra/superpowers`](https://github.com/obra/superpowers).

## Baseline

- Upstream release: `v6.1.1`
- Upstream commit: `d884ae0`
- Lite skill namespace: `superpowers:*` retained for existing-project
  compatibility
- License: MIT; original attribution remains in [LICENSE](LICENSE) and
  [NOTICE](NOTICE)

## Recommended remotes

After the Lite repository is public, use the personal repository as `origin`
and the official project as `upstream`:

```bash
git remote set-url origin https://github.com/nanyumeng/superpowers-lite.git
git remote add upstream https://github.com/obra/superpowers.git
git remote -v
```

If `upstream` already exists, update it with:

```bash
git remote set-url upstream https://github.com/obra/superpowers.git
```

## Sync policy

1. Fetch upstream tags and branches without merging directly into a release
   branch.
2. Review upstream changes in a dedicated sync branch.
3. Preserve Lite's explicit behavior differences instead of mechanically
   resolving skill conflicts in favor of either side.
4. Run manifest, hook, adapter, package, and behavior comparisons.
5. Record the new upstream baseline in this file, NOTICE, and CHANGELOG.
6. Obtain human review of the complete diff before merging the sync.

Historical upstream release notes may retain upstream links and names. Current
Lite manifests, install docs, support links, and repository governance must
point to `nanyumeng/superpowers-lite`.

## Contributing fixes upstream

Do not open an upstream issue merely to announce or promote Lite. If Lite
testing isolates a small, general problem that also exists upstream:

1. reproduce it on the current upstream `dev` branch;
2. search open and closed upstream issues and pull requests;
3. read the current upstream contribution and PR templates;
4. submit one focused fix with a real transcript or reproduction and matched
   tests;
5. disclose the model, harness, version, and installed plugins;
6. show the complete diff to the human owner before any upstream submission;
7. target the upstream `dev` branch.

Fork-specific rebranding, lightweight policy, and prompt-guidance alignment stay
in Superpowers Lite.
