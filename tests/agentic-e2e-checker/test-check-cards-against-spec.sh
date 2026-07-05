#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CHECKER="$REPO_ROOT/skills/agentic-end-to-end-testing/scripts/check-cards-against-spec"

FAILURES=0
TEST_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$TEST_ROOT"; }
trap cleanup EXIT

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

assert_exit() { # expected_code description -- command...
  local expected="$1" desc="$2"; shift 2
  local code=0
  "$@" >"$TEST_ROOT/out.txt" 2>&1 || code=$?
  if [ "$code" -eq "$expected" ]; then pass "$desc"; else
    fail "$desc (expected exit $expected, got $code)"; sed 's/^/    /' "$TEST_ROOT/out.txt"; fi
}

assert_out_contains() { # needle description
  if grep -Fq -- "$1" "$TEST_ROOT/out.txt"; then pass "$2"; else
    fail "$2 (output missing: $1)"; sed 's/^/    /' "$TEST_ROOT/out.txt"; fi
}

# ---- fixture builders ----------------------------------------------------

make_spec() { # dir  (spec with 2-row table; row 2 has \| and regex chars)
  mkdir -p "$1"
  cat > "$1/spec.md" <<'EOF'
# Widget Design

## Requirements

Widgets render a table with a TOTAL row.

## E2E scenario cards

| Card | Covers | Falsification |
| --- | --- | --- |
| widget-show-table | Rendered table incl. TOTAL row | If stdout's last line is not `TOTAL` followed by the two-decimal sum (20.85 for the seed fixture), or the TOTAL row is absent entirely, the scenario FAILS. |
| widget-status-flags | Status output | If `widget status` does not print exactly `OK \| DEGRADED` (a literal pipe) with dots . and stars * intact, the scenario FAILS. |
EOF
}

good_card_1() {
  cat <<'EOF'
# widget-show-table: table renders with TOTAL

**What this covers**: the rendered table.

## Pre-state
A built widget binary.

## Steps
1. Run `widget show`.

## Expected
If stdout's last line is not `TOTAL` followed by the
two-decimal sum (20.85 for the seed
fixture), or the TOTAL row is absent entirely, the scenario FAILS.

## Cleanup
Nothing to clean.
EOF
}

good_card_2() {
  cat <<'EOF'
# widget-status-flags: status output

**What this covers**: status flags.

## Pre-state
A built widget binary.

## Steps
1. Run `widget status`.

## Expected
If `widget status` does not print exactly `OK | DEGRADED` (a literal pipe) with dots . and stars * intact, the scenario FAILS.

## Cleanup
Nothing to clean.
EOF
}

make_cards() { # dir
  mkdir -p "$1"
  good_card_1 > "$1/widget-show-table.md"
  good_card_2 > "$1/widget-status-flags.md"
}

# ---- tests ----------------------------------------------------------------

echo "happy path"
make_spec "$TEST_ROOT/t1"; make_cards "$TEST_ROOT/t1/cards"
assert_exit 0 "2 rows, 2 conforming cards -> exit 0" \
  "$CHECKER" "$TEST_ROOT/t1/spec.md" "$TEST_ROOT/t1/cards"

echo "re-wrapped falsification line still matches (whitespace normalization)"
# good_card_1 already wraps the line across three lines; covered above. Prove
# the inverse too: collapse the card line to one line, still passes.
make_spec "$TEST_ROOT/t2"; make_cards "$TEST_ROOT/t2/cards"
perl -0pi -e 's/\n(two-decimal)/ $1/; s/\n(fixture\))/ $1/' "$TEST_ROOT/t2/cards/widget-show-table.md" 2>/dev/null || \
  sed -i '' -e ':a' -e 'N;$!ba' -e 's/the\ntwo-decimal/the two-decimal/' "$TEST_ROOT/t2/cards/widget-show-table.md"
assert_exit 0 "single-line variant -> exit 0" \
  "$CHECKER" "$TEST_ROOT/t2/spec.md" "$TEST_ROOT/t2/cards"

echo "escaped pipe in table cell matches literal pipe in card"
# covered by widget-status-flags in the happy path; also prove failure when
# the card drops the pipe phrase entirely:
make_spec "$TEST_ROOT/t3"; make_cards "$TEST_ROOT/t3/cards"
sed -i.bak 's/OK | DEGRADED/OK or DEGRADED/' "$TEST_ROOT/t3/cards/widget-status-flags.md"
assert_exit 1 "reworded falsification -> exit 1" \
  "$CHECKER" "$TEST_ROOT/t3/spec.md" "$TEST_ROOT/t3/cards"
assert_out_contains "widget-status-flags" "failure names the card"

echo "missing card file"
make_spec "$TEST_ROOT/t4"; make_cards "$TEST_ROOT/t4/cards"
rm "$TEST_ROOT/t4/cards/widget-show-table.md"
assert_exit 1 "missing card -> exit 1" \
  "$CHECKER" "$TEST_ROOT/t4/spec.md" "$TEST_ROOT/t4/cards"
assert_out_contains "widget-show-table.md" "failure names the missing file"

echo "missing required section"
make_spec "$TEST_ROOT/t5"; make_cards "$TEST_ROOT/t5/cards"
sed -i.bak '/^## Cleanup/,$d' "$TEST_ROOT/t5/cards/widget-show-table.md"
assert_exit 1 "card without Cleanup heading -> exit 1" \
  "$CHECKER" "$TEST_ROOT/t5/spec.md" "$TEST_ROOT/t5/cards"
assert_out_contains "Cleanup" "failure names the section"

echo "extra card is a warning, not a failure"
make_spec "$TEST_ROOT/t6"; make_cards "$TEST_ROOT/t6/cards"
good_card_1 > "$TEST_ROOT/t6/cards/extra-exploration.md"
assert_exit 0 "extra card -> exit 0" \
  "$CHECKER" "$TEST_ROOT/t6/spec.md" "$TEST_ROOT/t6/cards"
assert_out_contains "extra-exploration" "warning names the extra card"

echo "no scenario table"
mkdir -p "$TEST_ROOT/t7/cards"
printf '# Widget Design\n\nNo table here.\n' > "$TEST_ROOT/t7/spec.md"
assert_exit 2 "table-less spec -> exit 2" \
  "$CHECKER" "$TEST_ROOT/t7/spec.md" "$TEST_ROOT/t7/cards"
assert_out_contains "no scenario table" "diagnostic present"

echo "heading match is case-insensitive"
make_spec "$TEST_ROOT/t8"; make_cards "$TEST_ROOT/t8/cards"
sed -i.bak 's/^## E2E scenario cards/## E2E Scenario Cards/' "$TEST_ROOT/t8/spec.md"
assert_exit 0 "title-case heading still found" \
  "$CHECKER" "$TEST_ROOT/t8/spec.md" "$TEST_ROOT/t8/cards"

echo "usage"
assert_exit 64 "no args -> exit 64" "$CHECKER"
assert_exit 0 "--help -> exit 0" "$CHECKER" --help
assert_out_contains "Usage:" "help text present"

echo
if [ "$FAILURES" -gt 0 ]; then echo "$FAILURES test(s) failed"; exit 1; fi
echo "all tests passed"
