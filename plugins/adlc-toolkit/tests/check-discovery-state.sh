#!/usr/bin/env bash
# Dry tests for Step 0 (state detection) of product-discovery. Run from anywhere.
# Each fixture in fixtures/discovery/<case>/ holds a discovery/ folder and an EXPECTED file with the resume point.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
skill="$here/../skills/product-discovery/SKILL.md"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Every fixture resolves to its expected resume point.
for dir in "$here"/fixtures/discovery/*/; do
  name="$(basename "$dir")"
  want="$(tr -d '[:space:]' < "$dir/EXPECTED")"
  got="$(bash "$here/discovery-state.sh" "$dir")"
  check "fixture $name -> $want" "[ '$got' = '$want' ]"
done

# Every resume point is covered by at least one fixture.
for token in NEW ASK_TOPIC ASK_OVERWRITE PHASE_1 PHASE_2 PHASE_3 BREAKPOINT PHASE_4 PHASE_5 DONE; do
  check "a fixture expects $token" "grep -rqx '$token' '$here'/fixtures/discovery/*/EXPECTED"
done

# SKILL.md Step 0 documents the same resume points the resolver can print.
for token in NEW ASK_TOPIC ASK_OVERWRITE PHASE_1 PHASE_2 PHASE_3 BREAKPOINT PHASE_4 DONE; do
  check "SKILL.md Step 0 names $token" "sed -n '/^## Step 0/,/^## Phase 1/p' '$skill' | grep -q '$token'"
done

exit $fail
