#!/usr/bin/env bash
# Static checks for the feature.md contract between product-discovery and feature-to-spec. Run from anywhere.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
contract="$root/contracts/feature-document.md"
discovery="$root/skills/product-discovery/SKILL.md"
spec="$root/skills/feature-to-spec/SKILL.md"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

check "contract exists" "[ -f '$contract' ]"
for h in "Problem Statement" "Goals" "Requirements" "Scope" "Out of Scope" "Open Questions, Assumptions and Risks" "Status"; do
  check "contract heading: $h" "grep -q '^## $h\$' '$contract'"
  check "product-discovery names section: $h" "grep -q '\\*\\*$h:\\*\\*\\|\\*\\*$h\\.\\*\\*' '$discovery'"
done
for h in "Problem Statement" "Goals" "Requirements" "Scope" "Out of Scope"; do
  check "feature-to-spec requires: $h" "grep -q '$h' '$spec'"
done
check "product-discovery links the contract" "grep -q 'contracts/feature-document.md' '$discovery'"
check "feature-to-spec links the contract" "grep -q 'contracts/feature-document.md' '$spec'"
check "product-discovery says the contract changes first" "grep -qi 'contract first' '$discovery'"
check "feature-to-spec says the contract changes first" "grep -qi 'contract first' '$spec'"

exit $fail
