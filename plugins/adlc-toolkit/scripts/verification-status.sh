#!/usr/bin/env bash
# Executable form of Steps 2 and 4 of skills/verify-against-spec/SKILL.md:
# ID search, criterion status, story verdict and overall verdict.
# Usage: verification-status.sh <dir containing spec.md>
# Input besides spec.md: any project files (evidence) and an optional TEST-RESULTS file
# with lines "<AC id> pass|fail|manual".
# Output: "<AC> <status>" per criterion, "STORY <US> <verdict>" per story, "OVERALL <verdict>".
set -u
dir="${1:?usage: verification-status.sh <dir containing spec.md>}"
spec="$dir/spec.md"
[ -f "$spec" ] || { echo "ERROR no spec"; exit 0; }

section() { awk -v h="## $1" '$0 == h {f = 1; next} /^## / {f = 0} f' "$spec"; }

acs="$(section 'Acceptance Criteria' | grep -oE '^- AC-[0-9]+\.[0-9]+' | sed 's/^- //')"
stories="$(section 'User Stories' | grep -oE '^- US-[0-9]+' | sed 's/^- //')"
[ -n "$acs" ] || { echo "ERROR no acceptance criteria"; exit 0; }
[ -n "$stories" ] || { echo "ERROR no user stories"; exit 0; }

# Status of one criterion. The AC id must not be followed by another digit (AC-1.1 is not AC-1.10).
status_of() {
  local ac="$1" re result
  re="$(printf '%s' "$ac" | sed 's/\./\\./g')([^0-9]|\$)"
  result=""
  [ -f "$dir/TEST-RESULTS" ] && result="$(awk -v a="$ac" '$1 == a {print $2}' "$dir/TEST-RESULTS")"
  if [ "$result" = "manual" ]; then echo "not verifiable"; return; fi
  if ! grep -rqE "$re" "$dir" --exclude=spec.md --exclude=EXPECTED --exclude=TEST-RESULTS --exclude='verification-v*.md'; then
    echo "uncovered"; return
  fi
  if [ "$result" = "fail" ]; then echo "deviating"; else echo "covered"; fi
}

statuses=""
while IFS= read -r ac; do
  s="$(status_of "$ac")"
  echo "$ac $s"
  statuses="$statuses$ac=$s;"
done <<< "$acs"

rank_of() { case "$1" in failed) echo 0 ;; unverified) echo 1 ;; partial) echo 2 ;; *) echo 3 ;; esac; }
name_of() { case "$1" in 0) echo failed ;; 1) echo unverified ;; 2) echo partial ;; *) echo verified ;; esac; }

overall=3
while IFS= read -r us; do
  n="${us#US-}"
  total=0; covered=0; deviating=0
  while IFS= read -r ac; do
    case "$ac" in "AC-$n."*) ;; *) continue ;; esac
    total=$((total + 1))
    s="$(printf '%s' "$statuses" | tr ';' '\n' | grep "^$ac=" | cut -d= -f2)"
    [ "$s" = "covered" ] && covered=$((covered + 1))
    [ "$s" = "deviating" ] && deviating=$((deviating + 1))
  done <<< "$acs"
  if   [ "$total" -eq 0 ];          then v=unverified
  elif [ "$deviating" -gt 0 ];      then v=failed
  elif [ "$covered" -eq "$total" ]; then v=verified
  elif [ "$covered" -eq 0 ];        then v=unverified
  else v=partial; fi
  echo "STORY $us $v"
  r="$(rank_of "$v")"
  [ "$r" -lt "$overall" ] && overall="$r"
done <<< "$stories"
echo "OVERALL $(name_of "$overall")"
