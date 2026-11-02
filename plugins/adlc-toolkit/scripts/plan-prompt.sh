#!/usr/bin/env bash
# Executable form of Steps 0 to 3 of skills/spec-to-plan/SKILL.md: fills templates/plan-prompt.md
# from a project directory, or prints "ERROR <code>" lines (no-spec, spec-headings, no-criteria).
# Usage: plan-prompt.sh <project dir containing specs/<feature>/spec.md and optionally .adlc-project/PROJECT.md>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
contract="$here/contracts/spec-document.md"
template="$here/skills/spec-to-plan/templates/plan-prompt.md"
dir="${1:?usage: plan-prompt.sh <project dir>}"
dir="${dir%/}"

# Step 0: find and check the spec.
spec="$(ls "$dir"/specs/*/spec.md 2>/dev/null | head -1)"
[ -n "$spec" ] || { echo "ERROR no-spec"; exit 0; }
section() { awk -v h="## $1" '$0 == h {f = 1; next} /^## / {f = 0} f' "$2"; }

missing=0
while IFS= read -r h; do
  [ -n "$h" ] || continue
  if ! grep -qx "## $h" "$spec"; then echo "ERROR spec-headings $h"; missing=1; fi
done <<< "$(awk '/^```markdown/{f=1; next} /^```/{f=0} f' "$contract" | grep '^## ' | sed 's/^## //')"
[ "$missing" -eq 0 ] || exit 0

acs="$(section 'Acceptance Criteria' "$spec" | grep -oE '^- AC-[0-9]+\.[0-9]+' | sed 's/^- //')"
[ -n "$acs" ] || { echo "ERROR no-criteria"; exit 0; }

# Step 2: gather.
feature="$(head -1 "$spec" | sed -E 's/^# //; s/: Spec$//')"
version="$(section 'Change History' "$spec" | grep -oE '^- v[0-9]+' | sed 's/^- v//' | sort -n | tail -1)"
version="${version:-1}"
ids_of() { section "$1" "$spec" | grep -oE "^- $2-[0-9]+(\.[0-9]+)?" | sed 's/^- //' | paste -sd, - | sed 's/,/, /g'; }
count_of() { section "$1" "$spec" | grep -cE "^- $2-[0-9]+(\.[0-9]+)?:"; }
us="$(ids_of 'User Stories' US)"; fr="$(ids_of 'Functional Requirements' FR)"
nfr="$(ids_of 'Non-Functional Requirements' NFR)"; ac="$(ids_of 'Acceptance Criteria' AC)"
ids="- User stories: $us
- Functional requirements: $fr
- Non-functional requirements: $nfr
- Acceptance criteria: $ac"

tq="$(section 'Open Questions' "$spec" | grep -E '^- OQ-[0-9]+:.*Type: technical\.?$' | sed -E 's/\.?[[:space:]]+Type: technical\.?$//')"
[ -n "$tq" ] || tq="None"

project="$dir/.adlc-project/PROJECT.md"
if [ -f "$project" ]; then
  project_read="- .adlc-project/PROJECT.md: the project's tech stack, coding standards and architecture."
  constraints=""; gaps=""
  for s in "Tech Stack" "Coding Standards" "System Architecture" "UX Guide" "API Conventions"; do
    body="$(section "$s" "$project" | grep -E '^- ')"
    [ -n "$body" ] || continue
    lines=""
    while IFS= read -r l; do
      field="$(printf '%s' "$l" | sed -E 's/^- ([^:]+):.*/\1/')"
      value="$(printf '%s' "$l" | sed -E 's/^- [^:]+: //; s/ \(source: [^)]*\)$//')"
      case "$value" in
        TBD*) gaps="${gaps}${gaps:+
}- $s: $field" ;;
        *) lines="${lines}${lines:+
}- $field: $value" ;;
      esac
    done <<< "$body"
    [ -z "$lines" ] || constraints="${constraints}${constraints:+
}$s:
$lines"
  done
  [ -n "$constraints" ] || constraints="None recorded."
  [ -n "$gaps" ] || gaps="None"
else
  project_read="- The codebase itself: no .adlc-project/PROJECT.md exists, so inspect it for the tech stack, coding standards and architecture, state what you find, and ask about anything unclear."
  constraints="None recorded. Follow what the codebase shows."
  gaps="None"
fi

# Step 3: fill the template.
export V_FEATURE="$feature" V_SPEC_PATH="${spec#$dir/}" V_VERSION="$version" V_PROJECT_READ="$project_read" \
  V_CONSTRAINTS="$constraints" V_PROJECT_GAPS="$gaps" V_TECHNICAL_QUESTIONS="$tq" V_IDS="$ids" \
  V_COUNT_US="$(count_of 'User Stories' US)" V_COUNT_FR="$(count_of 'Functional Requirements' FR)" \
  V_COUNT_NFR="$(count_of 'Non-Functional Requirements' NFR)" V_COUNT_AC="$(count_of 'Acceptance Criteria' AC)"
awk '
function repl(s, key, val,   out, i) {
  out = ""
  while ((i = index(s, "{{" key "}}")) > 0) { out = out substr(s, 1, i - 1) val; s = substr(s, i + length(key) + 4) }
  return out s
}
{
  line = $0
  n = split("FEATURE SPEC_PATH VERSION PROJECT_READ CONSTRAINTS PROJECT_GAPS TECHNICAL_QUESTIONS IDS COUNT_US COUNT_FR COUNT_NFR COUNT_AC", keys, " ")
  for (k = 1; k <= n; k++) line = repl(line, keys[k], ENVIRON["V_" keys[k]])
  print line
}' "$template"
