#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

python3 - "$REPO_ROOT" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])

required = [
    "README.md",
    "README.zh-CN.md",
    "docs/INSTALL_WITH_AGENT.md",
    "docs/INSTALL_WITH_AGENT.zh-CN.md",
    "NOTICE",
    "CONTRIBUTING.md",
    "SECURITY.md",
    "SUPPORT.md",
    "PRIVACY.md",
    "UPSTREAM.md",
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ISSUE_TEMPLATE/bug_report.md",
    ".github/ISSUE_TEMPLATE/behavior_token_regression.md",
    ".github/ISSUE_TEMPLATE/feature_request.md",
    ".github/ISSUE_TEMPLATE/platform_support.md",
    ".github/ISSUE_TEMPLATE/config.yml",
]

for relative_path in required:
    path = root / relative_path
    if not path.is_file() or not path.read_text(encoding="utf-8").strip():
        raise AssertionError(f"required release file is missing or empty: {relative_path}")

contact_email = "nanyvmeng1021@gmail.com"
for relative_path in ["CODE_OF_CONDUCT.md", "SECURITY.md", "SUPPORT.md"]:
    if contact_email not in (root / relative_path).read_text(encoding="utf-8"):
        raise AssertionError(f"{relative_path}: private contact email is missing")

if (root / ".github/FUNDING.yml").exists():
    raise AssertionError("Lite must not inherit upstream GitHub sponsorship configuration")

active_surfaces = [
    *required,
    ".opencode/INSTALL.md",
    "docs/README.opencode.md",
    "docs/README.kimi.md",
    "package.json",
    "gemini-extension.json",
    ".agents/plugins/marketplace.json",
    ".claude-plugin/plugin.json",
    ".claude-plugin/marketplace.json",
    ".codex-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".kimi-plugin/plugin.json",
]

forbidden = [
    "jesse@",
    "sales@primeradiant",
    "discord.gg/35wsabtejz",
    "primeradiant.com/brand/",
    "github: [obra]",
]

for relative_path in active_surfaces:
    text = (root / relative_path).read_text(encoding="utf-8")
    lowered = text.lower()
    for value in forbidden:
        if value in lowered:
            raise AssertionError(f"{relative_path}: inherited release surface remains: {value}")

for relative_path in [
    ".opencode/INSTALL.md",
    "docs/README.opencode.md",
    "docs/README.kimi.md",
]:
    text = (root / relative_path).read_text(encoding="utf-8")
    if "github.com/obra/superpowers" in text:
        raise AssertionError(f"{relative_path}: install documentation still points to upstream")
    if "github.com/nanyumeng/superpowers-lite" not in text:
        raise AssertionError(f"{relative_path}: Lite repository URL is missing")

agent_install_docs = [
    "docs/INSTALL_WITH_AGENT.md",
    "docs/INSTALL_WITH_AGENT.zh-CN.md",
]
for relative_path in agent_install_docs:
    text = (root / relative_path).read_text(encoding="utf-8")
    for required_text in [
        "https://github.com/nanyumeng/superpowers-lite",
        "v6.1.1-lite.1",
        "skills/using-superpowers/SKILL.md",
        "Backup",
        "Rollback",
    ]:
        if required_text not in text:
            raise AssertionError(
                f"{relative_path}: agent installer requirement is missing: {required_text}"
            )
    if "rm -rf" in text:
        raise AssertionError(f"{relative_path}: installer must not recommend irreversible deletion")

readme_agent_links = {
    "README.md": "docs/INSTALL_WITH_AGENT.md",
    "README.zh-CN.md": "docs/INSTALL_WITH_AGENT.zh-CN.md",
}
for relative_path, target in readme_agent_links.items():
    text = (root / relative_path).read_text(encoding="utf-8")
    if target not in text:
        raise AssertionError(f"{relative_path}: agent installation guide is not linked")

markdown_files = [
    root / relative_path
    for relative_path in [
        *[path for path in required if path.endswith(".md")],
        ".opencode/INSTALL.md",
        "docs/README.opencode.md",
        "docs/README.kimi.md",
    ]
]
link_pattern = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
for path in markdown_files:
    for target in link_pattern.findall(path.read_text(encoding="utf-8")):
        target = target.strip()
        if not target or target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        target_path = target.split("#", 1)[0]
        if target_path and not (path.parent / target_path).exists():
            raise AssertionError(f"{path.relative_to(root)}: missing local link target {target}")

print("Superpowers Lite release surface looks good")
PY
