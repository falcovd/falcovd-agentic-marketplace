#!/usr/bin/env bash
# Executable form of the ID and link rules of contracts/spec-document.md, used by spec-change.
# Usage: spec-rules.sh lint <spec.md>          prints OK, or one "ERROR <code> <id>" line per problem
#        spec-rules.sh next <spec.md> <kind>   prints the next free ID; kind: US FR NFR A OQ or AC-<story number>
# Lint codes: dangling-link, no-criterion, retired-present, history-version.
set -u
cmd="${1:?usage: spec-rules.sh lint|next <spec.md> [kind]}"
spec="${2:?usage: spec-rules.sh lint|next <spec.md> [kind]}"
[ -f "$spec" ] || { echo "ERROR no spec"; exit 0; }

section() { awk -v h="## $1" '$0 == h {f = 1; next} /^## / {f = 0} f' "$spec"; }
tokens() { grep -oE '[A-Z]+-[0-9]+(\.[0-9]+)?'; }
items() { grep -oE '^- [A-Z]+-[0-9]+(\.[0-9]+)?' | sed 's/^- //'; }

stories="$(section 'User Stories' | items)"
frs="$(section 'Functional Requirements' | grep -E '^- FR-[0-9]+:')"
nfrs="$(section 'Non-Functional Requirements' | grep -E '^- NFR-[0-9]+:')"
acs="$(section 'Acceptance Criteria' | items)"
history="$(section 'Change History' | grep -E '^- v[0-9]+ \(')"

# IDs listed under Retired in the Change History.
retired="$(printf '%s\n' "$history" | sed -nE 's/.*Retired: (.*)\. Record: .*/\1/p' | tokens)"

case "$cmd" in
  lint)
    out=""
    # dangling-link: a requirement or criterion names a story that is not in the spec.
    while IFS= read -r line; do
      [ -n "$line" ] || continue
      id="$(printf '%s' "$line" | tokens | head -1)"
      us="$(printf '%s' "$line" | grep -oE 'Story: US-[0-9]+' | grep -oE 'US-[0-9]+')"
      if [ -n "$us" ] && ! printf '%s\n' "$stories" | grep -qx "$us"; then out="$out
ERROR dangling-link $id"; fi
    done <<< "$frs
$nfrs"
    while IFS= read -r ac; do
      [ -n "$ac" ] || continue
      n="$(printf '%s' "$ac" | sed -E 's/^AC-([0-9]+)\..*/\1/')"
      if ! printf '%s\n' "$stories" | grep -qx "US-$n"; then out="$out
ERROR dangling-link $ac"; fi
    done <<< "$acs"
    # no-criterion: a story without an acceptance criterion.
    while IFS= read -r us; do
      [ -n "$us" ] || continue
      n="${us#US-}"
      if ! printf '%s\n' "$acs" | grep -qE "^AC-$n\."; then out="$out
ERROR no-criterion $us"; fi
    done <<< "$stories"
    # retired-present: a retired ID is back in a section (never reused).
    present="$(printf '%s\n%s\n%s\n%s\n' "$stories" "$(printf '%s\n' "$frs" | items)" "$(printf '%s\n' "$nfrs" | items)" "$acs")"
    while IFS= read -r id; do
      [ -n "$id" ] || continue
      if printf '%s\n' "$present" | grep -qx "$id"; then out="$out
ERROR retired-present $id"; fi
    done <<< "$retired"
    # history-version: entries ascend by one, starting at v2.
    expected=2
    while IFS= read -r h; do
      [ -n "$h" ] || continue
      v="$(printf '%s' "$h" | sed -E 's/^- v([0-9]+) .*/\1/')"
      if [ "$v" -ne "$expected" ]; then out="$out
ERROR history-version v$v"; expected="$v"; fi
      expected=$((expected + 1))
    done <<< "$history"
    if [ -z "$out" ]; then echo "OK"; else printf '%s\n' "${out#
}"; fi
    ;;
  next)
    kind="${3:?usage: spec-rules.sh next <spec.md> <kind>}"
    all="$(tokens < "$spec")"
    case "$kind" in
      AC-*)
        n="${kind#AC-}"
        max="$(printf '%s\n' "$all" | awk -F'[-.]' -v n="$n" '$1 == "AC" && $2 == n {print $3}' | sort -n | tail -1)"
        echo "AC-$n.$(( ${max:-0} + 1 ))" ;;
      *)
        max="$(printf '%s\n' "$all" | grep -v '\.' | awk -F- -v k="$kind" '$1 == k {print $2}' | sort -n | tail -1)"
        echo "$kind-$(( ${max:-0} + 1 ))" ;;
    esac
    ;;
  *) echo "ERROR unknown command" ;;
esac
