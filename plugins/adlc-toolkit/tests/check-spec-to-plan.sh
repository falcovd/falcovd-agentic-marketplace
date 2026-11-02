#!/usr/bin/env bash
# Checks for spec-to-plan: the template and the skill stay in step, and the prompt is right on fixtures.
# Run from anywhere. The placeholders are read from the template.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
skill="$root/skills/spec-to-plan/SKILL.md"
template="$root/skills/spec-to-plan/templates/plan-prompt.md"
script="$root/scripts/plan-prompt.sh"
fixtures="$root/tests/fixtures/spec-to-plan"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Skill file and frontmatter
check "SKILL.md exists" "[ -f '$skill' ]"
check "frontmatter name" "grep -q '^name: \"spec-to-plan\"\$' '$skill'"
check "frontmatter description" "grep -q '^description: .\\+' '$skill'"

# Template and its placeholders
check "template exists" "[ -f '$template' ]"
placeholders="$(grep -oE '\{\{[A-Z_]+\}\}' "$template" 2>/dev/null | sort -u)"
count="$(printf '%s\n' "$placeholders" | grep -c .)"
check "template has placeholders ($count)" "[ '$count' -gt 0 ]"
while IFS= read -r p; do
  [ -n "$p" ] || continue
  check "SKILL.md names placeholder: $p" "grep -qF '\`$p\`' '$skill'"
done <<< "$placeholders"
check "template names the traceability rule" "grep -q 'names the US, FR, NFR and AC IDs it delivers' '$template'"
check "template asks for a coverage table" "grep -q 'coverage table' '$template'"
check "template is self-contained for other people" "grep -q 'can be used by anyone, in any session' '$template'"
check "template uses paths relative to the repository root" "grep -q 'relative to the repository root' '$template'"

# The skill links the contract and the template, and carries the hard rules.
check "SKILL.md links the spec contract" "grep -q 'contracts/spec-document.md' '$skill'"
check "SKILL.md links the template" "grep -q 'templates/plan-prompt.md' '$skill'"
check "SKILL.md says the project context is optional" "grep -q 'not required' '$skill'"
for phrase in "Never edit the spec" "Never write the plan" "Never commit" "Do not invent facts" "feature-to-spec" "init-adlc-project" "superpowers:writing-plans" "AskUserQuestion" "uncommitted"; do
  check "SKILL.md mentions: $phrase" "grep -qF -- '$phrase' '$skill'"
done

# The prompt on fixtures: the script is the executable form of Steps 0 to 3.
check "script exists" "[ -f '$script' ]"
for dir in "$fixtures"/*/; do
  name="$(basename "$dir")"
  check "fixture $name matches EXPECTED" "diff <(bash '$script' '$dir') '$dir/EXPECTED'"
  case "$(head -1 "$dir/EXPECTED")" in
    ERROR*) ;;
    *) check "fixture $name leaves no placeholder" "! bash '$script' '$dir' | grep -q '{{'" ;;
  esac
done
for code in "no-spec" "spec-headings" "no-criteria"; do
  check "a fixture expects error: $code" "grep -rqF 'ERROR $code' '$fixtures'/*/EXPECTED"
done
check "a fixture covers a missing project context" "grep -rqF 'no .adlc-project/PROJECT.md exists' '$fixtures'/*/EXPECTED"
check "a fixture covers TBD project fields" "grep -rqF -- '- Tech Stack: Databases' '$fixtures'/*/EXPECTED"
check "a fixture covers a technical question" "grep -rqF -- '- OQ-1:' '$fixtures'/*/EXPECTED"
check "a fixture covers a changed spec version" "grep -rqF '(spec v3)' '$fixtures'/*/EXPECTED"

# Fixture files must not be git-ignored: the root .gitignore ignores the local docs/ and specs/ folders,
# and a fixture that is ignored passes on a machine that has it and fails in CI.
check "no fixture file is git-ignored" "[ -z \"\$(git -C '$root' ls-files --others --ignored --exclude-standard -- tests/fixtures)\" ]"

exit $fail
