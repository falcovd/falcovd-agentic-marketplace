#!/usr/bin/env bash
# Checks for spec-change: the contract amendment and the skill stay in step, and the ID and link rules hold on fixtures.
# Run from anywhere.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
contract="$root/contracts/spec-document.md"
skill="$root/skills/spec-change/SKILL.md"
rules="$root/scripts/spec-rules.sh"
fixtures="$root/tests/fixtures/spec-change"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Skill file and frontmatter
check "SKILL.md exists" "[ -f '$skill' ]"
check "frontmatter name" "grep -q '^name: \"spec-change\"\$' '$skill'"
check "frontmatter description" "grep -q '^description: .\\+' '$skill'"

# The contract defines the Change History and the change record.
check "contract exists" "[ -f '$contract' ]"
check "contract has the optional Change History section" "grep -q '^## Change History (optional section)\$' '$contract'"
check "contract has the change record section" "grep -q '^## Change record' '$contract'"
check "required headings do not include Change History" "! awk '/^\`\`\`markdown/{f=1; next} /^\`\`\`/{f=0} f' '$contract' | grep -q '^## Change History'"

# Fields and vocabulary appear in both the contract and the skill.
for word in "Added" "Changed" "Retired" "Record" "Approved by" "Impact" "Reason" "SC-n" "never reused" "highest number"; do
  check "contract defines: $word" "grep -qF -- '$word' '$contract'"
  check "SKILL.md uses: $word" "grep -qF -- '$word' '$skill'"
done

# The skill links the contract and carries the hard rules.
check "SKILL.md links the spec contract" "grep -q 'contracts/spec-document.md' '$skill'"
check "SKILL.md says the contract changes first" "grep -qi 'contract first' '$skill'"
check "SKILL.md names the Change History heading" "grep -qF '\`## Change History\`' '$skill'"
check "SKILL.md points to the rules script" "grep -q 'scripts/spec-rules.sh' '$skill'"
for phrase in "Nothing is written before" "Never commit" "Never edit plans" "Do not invent facts" "SendUserFile" "AskUserQuestion" "decisions.md"; do
  check "SKILL.md mentions: $phrase" "grep -qF -- '$phrase' '$skill'"
done

# ID and link rules on fixtures: spec-rules.sh is the executable form.
check "rules script exists" "[ -f '$rules' ]"
for dir in "$fixtures"/*/; do
  name="$(basename "$dir")"
  check "fixture $name lint matches EXPECTED" "diff <(bash '$rules' lint '$dir/spec.md') '$dir/EXPECTED'"
  if [ -f "$dir/NEXT" ]; then
    while read -r kind want; do
      [ -n "$kind" ] || continue
      check "fixture $name next $kind is $want" "[ \"\$(bash '$rules' next '$dir/spec.md' '$kind')\" = '$want' ]"
    done < "$dir/NEXT"
  fi
done
for code in "dangling-link" "no-criterion" "retired-present" "history-version"; do
  check "a fixture expects error: $code" "grep -rqF 'ERROR $code' '$fixtures'/*/EXPECTED"
done
check "a fixture expects OK" "grep -rqx 'OK' '$fixtures'/*/EXPECTED"

exit $fail
