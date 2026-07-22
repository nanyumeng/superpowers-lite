#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

python3 - "$REPO_ROOT" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
version = "6.1.1-lite.1"
repository = "https://github.com/nanyumeng/superpowers-lite"


def load(relative_path):
    path = root / relative_path
    return json.loads(path.read_text(encoding="utf-8"))


def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")


def assert_author(author, label):
    if not isinstance(author, dict):
        raise AssertionError(f"{label}: author must be an object")
    assert_equal(author.get("name"), "nanyumeng", f"{label} author name")
    if author.get("email"):
        raise AssertionError(f"{label}: public manifest must not publish an email")


package = load("package.json")
assert_equal(package.get("name"), "superpowers-lite", "package name")
assert_equal(package.get("version"), version, "package version")
assert_equal(package.get("homepage"), repository, "package homepage")
assert_equal(package.get("repository"), repository, "package repository")
assert_author(package.get("author"), "package")

gemini = load("gemini-extension.json")
assert_equal(gemini.get("name"), "superpowers-lite", "Gemini extension name")
assert_equal(gemini.get("version"), version, "Gemini extension version")

for relative_path in [
    ".claude-plugin/plugin.json",
    ".codex-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".kimi-plugin/plugin.json",
]:
    manifest = load(relative_path)
    assert_equal(manifest.get("name"), "superpowers-lite", f"{relative_path} name")
    assert_equal(manifest.get("version"), version, f"{relative_path} version")
    assert_equal(manifest.get("homepage"), repository, f"{relative_path} homepage")
    if "repository" in manifest:
        assert_equal(manifest.get("repository"), repository, f"{relative_path} repository")
    assert_author(manifest.get("author"), relative_path)

claude_marketplace = load(".claude-plugin/marketplace.json")
assert_equal(claude_marketplace.get("name"), "superpowers-lite-dev", "Claude marketplace name")
assert_author(claude_marketplace.get("owner"), "Claude marketplace")
claude_plugins = claude_marketplace.get("plugins", [])
assert_equal(len(claude_plugins), 1, "Claude marketplace plugin count")
assert_equal(claude_plugins[0].get("name"), "superpowers-lite", "Claude marketplace plugin name")
assert_equal(claude_plugins[0].get("version"), version, "Claude marketplace plugin version")
assert_author(claude_plugins[0].get("author"), "Claude marketplace plugin")

codex_marketplace = load(".agents/plugins/marketplace.json")
assert_equal(codex_marketplace.get("name"), "superpowers-lite-dev", "Codex marketplace name")
assert_equal(
    codex_marketplace.get("interface", {}).get("displayName"),
    "Superpowers Lite Dev",
    "Codex marketplace display name",
)
codex_plugins = codex_marketplace.get("plugins", [])
assert_equal(len(codex_plugins), 1, "Codex marketplace plugin count")
assert_equal(codex_plugins[0].get("name"), "superpowers-lite", "Codex marketplace plugin name")

codex = load(".codex-plugin/plugin.json")
interface = codex.get("interface", {})
assert_equal(interface.get("displayName"), "Superpowers Lite", "Codex display name")
assert_equal(interface.get("developerName"), "nanyumeng", "Codex developer name")
assert_equal(interface.get("websiteURL"), repository, "Codex website URL")
assert_equal(
    interface.get("privacyPolicyURL"),
    repository + "/blob/main/PRIVACY.md",
    "Codex privacy policy URL",
)
assert_equal(
    interface.get("termsOfServiceURL"),
    repository + "/blob/main/LICENSE",
    "Codex terms URL",
)

for relative_path in [
    "package.json",
    "gemini-extension.json",
    ".claude-plugin/plugin.json",
    ".claude-plugin/marketplace.json",
    ".codex-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".kimi-plugin/plugin.json",
    ".agents/plugins/marketplace.json",
]:
    text = (root / relative_path).read_text(encoding="utf-8")
    lowered = text.lower()
    for forbidden in ["jesse@", "primeradiant", "prime radiant", "https://github.com/obra/superpowers"]:
        if forbidden in lowered:
            raise AssertionError(f"{relative_path}: inherited identity remains: {forbidden}")

print("Superpowers Lite release metadata looks good")
PY
