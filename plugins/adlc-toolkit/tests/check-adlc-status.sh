#!/usr/bin/env bash
# Checks for adlc-status: the skill and the reference script stay in step, and the report rules hold on fixtures.
# Run from anywhere.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
skill="$root/skills/adlc-status/SKILL.md"
script="$root/tests/adlc-status.sh"
fixtures="$root/tests/fixtures/adlc-status"
discovery="$root/tests/fixtures/discovery"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Skill file and frontmatter
check "SKILL.md exists" "[ -f '$skill' ]"
check "frontmatter name" "grep -q '^name: \"adlc-status\"\$' '$skill'"
check "frontmatter description" "grep -q '^description: .\\+' '$skill'"

# Reuse: the skill points to Step 0 of product-discovery and does not copy its table.
check "SKILL.md points to Step 0 of product-discovery" "grep -q 'product-discovery/SKILL.md' '$skill' && grep -q 'Step 0: Detect state' '$skill'"
check "SKILL.md does not copy the Step 0 table" "! grep -q 'Newest artifact present' '$skill'"
check "the script calls discovery-state.sh" "grep -q 'discovery-state.sh' '$script'"
check "the script does not repeat the discovery state rules" "! grep -q 'evidence/interview-guide.md' '$script'"

# Resume points, spec stages and next steps are named in the skill.
for word in "NEW" "PHASE_1" "PHASE_5" "BREAKPOINT" "ASK_OVERWRITE" "DONE" \
            "requirements-empty" "requirements-feature" "requirements-prd" "spec" "plan" "verification" "outcome" \
            "product-discovery" "feature-to-spec" "spec-to-plan" "implement" "verify-against-spec" "outcome-review" "spec-change" \
            "close" "adjust" "new discovery" "wait"; do
  check "SKILL.md names: $word" "grep -qF -- '$word' '$skill'"
done
for phrase in "Read only" "Write no file" "status.md" "not tracked" "inferred" "Unknown stays unknown" "Change History" "outdated" "docs/plans" "waiting for"; do
  check "SKILL.md mentions: $phrase" "grep -qiF -- '$phrase' '$skill'"
done

# Git does not track empty folders: a fixture that relies on one passes locally and fails on a fresh checkout.
check "no fixture folder is empty" "[ -z \"\$(find '$root/tests/fixtures' -type d -empty)\" ]"

# The report on fixtures: the script is the executable form of the rules.
check "script exists" "[ -f '$script' ]"
for dir in "$fixtures"/*/; do
  name="$(basename "$dir")"
  check "fixture $name matches EXPECTED" "diff <(bash '$script' '$dir') '$dir/EXPECTED'"
done
for stage in requirements-empty requirements-feature requirements-prd spec plan verification outcome; do
  check "the chain fixture covers stage: $stage" "grep -q '^SPEC [^ ]* $stage ' '$fixtures/chain/EXPECTED'"
done
for next in feature-to-spec spec-to-plan implement verify-against-spec outcome-review spec-change product-discovery none; do
  check "the chain fixture covers next step: $next" "grep -qE ' $next\$' '$fixtures/chain/EXPECTED'"
done
for state in BREAKPOINT DONE PHASE_1; do
  check "the chain fixture covers discovery state: $state" "grep -q '^DISCOVERY [^ ]* $state ' '$fixtures/chain/EXPECTED'"
done

# The existing discovery fixtures are reused: the status line carries the expected resume point.
for dir in "$discovery"/*/; do
  name="$(basename "$dir")"
  want="$(tr -d '[:space:]' < "$dir/EXPECTED")"
  [ "$want" = "ASK_TOPIC" ] && continue
  [ -d "$dir/discovery" ] || continue
  check "discovery fixture $name shows $want" "bash '$script' '$dir' | grep -q '^DISCOVERY [^ ]* $want '"
done

exit $fail
