#!/usr/bin/env bash
# Checks for outcome-review: contract and skill stay in step, and the status rules hold on fixtures.
# Run from anywhere. The headings are read from the format block of the contract.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
contract="$root/contracts/outcome-document.md"
skill="$root/skills/outcome-review/SKILL.md"
resolver="$root/scripts/outcome-status.sh"
fixtures="$root/tests/fixtures/outcome"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Skill file and frontmatter
check "SKILL.md exists" "[ -f '$skill' ]"
check "frontmatter name" "grep -q '^name: \"outcome-review\"\$' '$skill'"
check "frontmatter description" "grep -q '^description: .\\+' '$skill'"

# Contract and its headings
check "contract exists" "[ -f '$contract' ]"
headings="$(awk '/^```markdown/{f=1; next} /^```/{f=0} f' "$contract" 2>/dev/null | grep '^## ' | sed 's/^## //')"
count="$(printf '%s\n' "$headings" | grep -c .)"
check "contract format block has headings ($count)" "[ '$count' -gt 0 ]"
while IFS= read -r h; do
  [ -n "$h" ] || continue
  check "SKILL.md names heading: $h" "grep -qF '\`## $h\`' '$skill'"
done <<< "$headings"

# Vocabulary of the contract appears in the skill.
for word in "met" "partially met" "missed" "not measurable" "too early" "achieved" "partly achieved" "not achieved" "inconclusive" "close" "adjust" "new discovery" "wait"; do
  check "contract defines: $word" "grep -qF '$word' '$contract'"
  check "SKILL.md uses: $word" "grep -qF '$word' '$skill'"
done

# The skill links the contracts and carries the hard rules.
check "SKILL.md links the outcome contract" "grep -q 'contracts/outcome-document.md' '$skill'"
check "SKILL.md links the feature contract" "grep -q 'contracts/feature-document.md' '$skill'"
check "SKILL.md says the contract changes first" "grep -qi 'contract first' '$skill'"
for phrase in "Never edit" "Never commit" "Never write to an external system" "Never invent" "Unknown stays unknown" "SendUserFile" "AskUserQuestion"; do
  check "SKILL.md mentions: $phrase" "grep -qF -- '$phrase' '$skill'"
done

# Status rules on fixtures: the resolver is the executable form of Steps 3 and 4.
check "resolver exists" "[ -f '$resolver' ]"
for dir in "$fixtures"/*/; do
  name="$(basename "$dir")"
  check "fixture $name matches EXPECTED" "diff <(bash '$resolver' '$dir') '$dir/EXPECTED'"
done
for status in "met" "partially met" "missed" "not measurable" "too early"; do
  check "a fixture expects goal status: $status" "grep -rqE '^G-[0-9]+ $status\$' '$fixtures'/*/EXPECTED"
done
for verdict in "achieved" "partly achieved" "not achieved" "inconclusive"; do
  check "a fixture expects overall: $verdict" "grep -rqx 'OVERALL $verdict' '$fixtures'/*/EXPECTED"
done
for rec in "close" "adjust" "new discovery" "wait"; do
  check "a fixture expects recommendation: $rec" "grep -rqx 'RECOMMEND $rec' '$fixtures'/*/EXPECTED"
done

exit $fail
