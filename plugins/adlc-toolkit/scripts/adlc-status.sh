#!/usr/bin/env bash
# Executable form of the report rules of skills/adlc-status/SKILL.md.
# Usage: adlc-status.sh <project dir>
# Output, one line per item (discovery topics first, then spec folders, each sorted by name):
#   DISCOVERY <topic> <STATE> <next>
#   SPEC <feature> <stage> version=<n> plan=<found|none> verification=<verdict|none> outdated=<yes|no> outcome=<verdict|none> <next>
# or NOTHING when there is nothing to report. Discovery states come from discovery-state.sh (reused, not copied).
set -u
here="$(cd "$(dirname "$0")" && pwd)"
dir="${1:?usage: adlc-status.sh <project dir>}"
dir="${dir%/}"
found=0

# Highest version number of <prefix>-vN.md files in a folder.
latest() { ls "$1"/"$2"-v*.md 2>/dev/null | sed -E 's/.*-v([0-9]+)\.md$/\1/' | sort -n | tail -1; }
section() { awk -v h="## $1" '$0 == h {f = 1; next} /^## / {f = 0} f' "$2"; }

# Discovery topics.
for t in "$dir"/discovery/*/; do
  [ -d "$t" ] || continue
  topic="$(basename "$t")"
  state="$(bash "$here/discovery-state.sh" "$dir" "$topic")"
  case "$state" in
    DONE) if [ -d "$dir/specs/$topic" ]; then next="none"; else next="feature-to-spec"; fi ;;
    *)    next="product-discovery" ;;
  esac
  echo "DISCOVERY $topic $state $next"
  found=1
done

# Spec folders.
for d in "$dir"/specs/*/; do
  [ -d "$d" ] || continue
  d="${d%/}"
  feature="$(basename "$d")"
  version="-"; plan="-"; verdict="-"; outdated="-"; outcome="-"
  if [ ! -f "$d/spec.md" ]; then
    if   [ -f "$d/prd.md" ];     then stage="requirements-prd"
    elif [ -f "$d/feature.md" ]; then stage="requirements-feature"
    else stage="requirements-empty"; fi
    next="feature-to-spec"
  else
    # Spec version and the date of the latest change.
    last="$(section 'Change History' "$d/spec.md" | grep -E '^- v[0-9]+ \(' | sed -E 's/^- v([0-9]+) \(([0-9-]+)\).*/\1 \2/' | sort -n | tail -1)"
    version="${last%% *}"; version="${version:-1}"
    spec_date=""; [ -n "$last" ] && spec_date="${last##* }"
    # Plan: a plan file names the spec path (inferred).
    plan="none"
    if grep -qsF "specs/$feature/spec.md" "$dir"/docs/plans/*.md "$dir"/plans/*.md; then plan="found"; fi
    # Latest verification report.
    vn="$(latest "$d" verification)"; verdict="none"; outdated="no"
    if [ -n "$vn" ]; then
      vf="$d/verification-v$vn.md"
      verdict="$(grep -m1 '^Verdict:' "$vf" | sed -E 's/^Verdict: *//')"
      vdate="$(grep -m1 -oE 'Date: [0-9]{4}-[0-9]{2}-[0-9]{2}' "$vf" | sed 's/^Date: //')"
      if [ -n "$spec_date" ] && [ -n "$vdate" ] && [[ "$spec_date" > "$vdate" ]]; then outdated="yes"; fi
    fi
    # Latest outcome review.
    on="$(latest "$d" outcome-review)"; outcome="none"; rec=""
    if [ -n "$on" ]; then
      of="$d/outcome-review-v$on.md"
      outcome="$(grep -m1 '^Overall:' "$of" | sed -E 's/^Overall: *//')"
      rec="$(section 'Recommendation' "$of" | grep -m1 . | sed -E 's/:.*//')"
    fi
    # Stage and next step.
    if [ "$outcome" != "none" ]; then
      stage="outcome"
      case "$rec" in
        close) next="none" ;;
        adjust) next="spec-change" ;;
        "new discovery") next="product-discovery" ;;
        *) next="outcome-review" ;;
      esac
    elif [ "$verdict" != "none" ]; then
      stage="verification"
      if [ "$outdated" = "yes" ]; then next="verify-against-spec"
      elif [ "$verdict" = "verified" ]; then next="outcome-review"
      else next="implement"; fi
    elif [ "$plan" = "found" ]; then stage="plan"; next="implement"
    else stage="spec"; next="spec-to-plan"; fi
  fi
  echo "SPEC $feature $stage version=$version plan=$plan verification=$verdict outdated=$outdated outcome=$outcome $next"
  found=1
done

[ "$found" -eq 1 ] || echo "NOTHING"
