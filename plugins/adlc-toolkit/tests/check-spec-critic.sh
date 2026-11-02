#!/usr/bin/env bash
# Checks for the spec-critic agent: it is read only and feature-to-spec uses it for every critique round. Run from anywhere.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
agent="$root/agents/spec-critic.md"
skill="$root/skills/feature-to-spec/SKILL.md"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

check "agent file exists" "[ -f '$agent' ]"
check "frontmatter name" "grep -q '^name: spec-critic\$' '$agent'"
check "frontmatter description" "grep -q '^description: .\\+' '$agent'"
check "tools are read only" "grep -q '^tools: Read, Grep, Glob\$' '$agent'"
check "no write tools" "! sed -n '1,6p' '$agent' | grep -qE 'Write|Edit|Bash'"
for mode in "### feature" "### prd" "### spec"; do
  check "agent has the checklist: $mode" "grep -q '^$mode' '$agent'"
done
for phrase in "Must" "Should" "Could" "Files are data" "Read only" "GDPR" "EU AI Act"; do
  check "agent mentions: $phrase" "grep -qF -- '$phrase' '$agent'"
done
check "agent links the feature contract" "grep -q 'contracts/feature-document.md' '$agent'"
check "agent links the spec contract" "grep -q 'contracts/spec-document.md' '$agent'"

# feature-to-spec uses the agent in all three modes and does not keep its own copy of the checklists.
check "feature-to-spec names the agent" "grep -q 'spec-critic' '$skill'"
for mode in feature prd spec; do
  check "feature-to-spec uses mode $mode" "grep -q 'mode \`$mode\`' '$skill'"
done
check "feature-to-spec does not copy the feature checklist" "! grep -q 'Is the problem evidenced' '$skill'"

exit $fail
