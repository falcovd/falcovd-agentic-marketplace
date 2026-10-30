#!/usr/bin/env bash
# Static checks for the init-adlc-project skill. Run from anywhere.
set -u
skill="$(cd "$(dirname "$0")/.." && pwd)/skills/init-adlc-project"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}

# Skill file and frontmatter
check "SKILL.md exists" "[ -f '$skill/SKILL.md' ]"
check "frontmatter name" "grep -q '^name: init-adlc-project\$' '$skill/SKILL.md'"
check "frontmatter description" "grep -q '^description: .\\+' '$skill/SKILL.md'"

# PROJECT.md template (FR-1, FR-2, NFR-1)
tpl="$skill/templates/PROJECT.md"
check "template exists" "[ -f '$tpl' ]"
check "template title" "grep -q '^# Project Context\$' '$tpl'"
for h in "Tech Stack" "Coding Standards" "System Architecture" "UX Guide" "API Conventions"; do
  check "template heading: $h" "grep -q '^## $h\$' '$tpl'"
done
check "template within 250 lines" "[ \"\$(wc -l < '$tpl')\" -le 250 ]"

# AGENTS.md block (FR-12, AC-4.6)
blk="$skill/templates/agents-block.md"
check "block exists" "[ -f '$blk' ]"
check "block has one start marker" "[ \"\$(grep -c '<!-- adlc-project:start -->' '$blk')\" -eq 1 ]"
check "block has one end marker" "[ \"\$(grep -c '<!-- adlc-project:end -->' '$blk')\" -eq 1 ]"
check "block names .adlc-project/" "grep -q '\\.adlc-project/' '$blk'"
check "block says to load the folder when a session begins" "grep -qi 'load the folder' '$blk' && grep -qi 'session begins' '$blk'"
check "block is descriptive, no imperative-override phrasing" "! grep -qiE 'every session|read all|follow them|you must|always|ignore' '$blk'"

# SKILL.md must carry the hard rules (FR-10, FR-18 to FR-22, NFR-2)
for phrase in "never commit" "never assume" "TBD" "adlc-project:start" "templates/PROJECT.md" "templates/agents-block.md" "250" "125" "English"; do
  check "SKILL.md mentions: $phrase" "grep -qi -- '$phrase' '$skill/SKILL.md'"
done

# No literal HTML comment markers in running text of SKILL.md (injection detectors flag them); they live in one code block.
prose_markers="$(awk '/^```/{f=!f; next} !f' "$skill/SKILL.md" | grep -c '<!--')"
check "SKILL.md has no inline HTML comment markers" "[ '$prose_markers' -eq 0 ]"
start_count="$(grep -c 'adlc-project:start' "$skill/SKILL.md")"
check "SKILL.md defines the markers once, in a code block" "[ '$start_count' -eq 1 ]"
check "SKILL.md states the validation rule for an invalid block" "grep -q 'Validation rule' '$skill/SKILL.md' && grep -q 'invalid state' '$skill/SKILL.md'"

exit $fail
