#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
skill_file="$repo_root/skills/using-superpowers/SKILL.md"

if ! grep -Fq 'Resolve these paths relative to this `SKILL.md` file' "$skill_file"; then
  echo "FAIL: using-superpowers must explain how to resolve harness reference paths" >&2
  exit 1
fi

echo "PASS: using-superpowers makes harness reference resolution explicit"
