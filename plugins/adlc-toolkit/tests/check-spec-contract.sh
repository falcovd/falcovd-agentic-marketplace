#!/usr/bin/env bash
# Static checks for the spec.md contract used by feature-to-spec. Run from anywhere.
# The headings are read from the format block of the contract, so the contract is the single source.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
contract="$root/contracts/spec-document.md"
spec="$root/skills/feature-to-spec/SKILL.md"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

check "contract exists" "[ -f '$contract' ]"

# Headings of the format block (the fenced markdown block in the contract).
headings="$(awk '/^```markdown/{f=1; next} /^```/{f=0} f' "$contract" 2>/dev/null | grep '^## ' | sed 's/^## //')"
count="$(printf '%s\n' "$headings" | grep -c .)"
check "contract format block has headings ($count)" "[ '$count' -gt 0 ]"

# The five core parts must be among them.
for h in "User Stories" "Functional Requirements" "Non-Functional Requirements" "Acceptance Criteria" "Out of Scope"; do
  check "contract heading: $h" "printf '%s\n' '$headings' | grep -qx '$h'"
done

# Every contract heading is named in feature-to-spec as a code-formatted heading.
while IFS= read -r h; do
  [ -n "$h" ] || continue
  check "feature-to-spec names heading: $h" "grep -qF '\`## $h\`' '$spec'"
done <<< "$headings"

# ID formats appear in both the contract and the skill.
for id in "US-1" "FR-1" "NFR-1" "AC-1.1"; do
  check "contract uses $id" "grep -qF '$id' '$contract'"
  check "feature-to-spec uses $id" "grep -qF '$id' '$spec'"
done

check "feature-to-spec links the contract" "grep -q 'contracts/spec-document.md' '$spec'"
check "feature-to-spec says the contract changes first" "grep -qi 'contract first' '$spec'"

exit $fail
