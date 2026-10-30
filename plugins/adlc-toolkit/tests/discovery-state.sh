#!/usr/bin/env bash
# Executable form of Step 0 (state detection) in skills/product-discovery/SKILL.md.
# Usage: discovery-state.sh <dir containing discovery/>
# Prints one token: NEW ASK_TOPIC ASK_OVERWRITE PHASE_1 PHASE_2 PHASE_3 BREAKPOINT PHASE_4 PHASE_5 DONE
set -u
root="${1:?usage: discovery-state.sh <dir containing discovery/>}"

topics=()
if [ -d "$root/discovery" ]; then
  for d in "$root"/discovery/*/; do [ -d "$d" ] && topics+=("${d%/}"); done
fi
[ "${#topics[@]}" -eq 0 ] && { echo NEW; exit 0; }
[ "${#topics[@]}" -gt 1 ] && { echo ASK_TOPIC; exit 0; }
t="${topics[0]}"

has_file() { compgen -G "$t/$1" >/dev/null; }

# Empty artifact files are half-written.
for f in framing.md problem-statement.md evidence/interview-guide.md evidence/verdict*.md feature.md; do
  for m in $t/$f; do
    [ -f "$m" ] && [ ! -s "$m" ] && { echo ASK_OVERWRITE; exit 0; }
  done
done

if [ -f "$t/status.md" ]; then
  i=0
  for token in PHASE_1 PHASE_2 PHASE_3 BREAKPOINT PHASE_4 PHASE_5; do
    i=$((i + 1))
    status="$(grep '^|' "$t/status.md" | grep -v -- '---' | grep -v '^| Phase' | sed -n "${i}p" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')"
    case "$status" in
      approved*|done*|received*) continue ;;
      waiting*) has_file 'evidence/interviews/*.md' && continue ;;
    esac
    echo "$token"; exit 0
  done
  echo DONE; exit 0
fi

has_file 'feature.md'                  && { echo DONE; exit 0; }
has_file 'evidence/verdict*.md'        && { echo PHASE_4; exit 0; }
has_file 'evidence/interviews/*.md'    && { echo PHASE_4; exit 0; }
has_file 'evidence/interview-guide.md' && { echo BREAKPOINT; exit 0; }
has_file 'evidence/data/*.md'          && { echo PHASE_3; exit 0; }
has_file 'problem-statement.md'        && { echo PHASE_2; exit 0; }
has_file 'framing.md'                  && { echo PHASE_1; exit 0; }
echo NEW
