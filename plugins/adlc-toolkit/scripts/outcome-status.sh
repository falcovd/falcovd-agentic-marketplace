#!/usr/bin/env bash
# Executable form of Steps 3 and 4 of skills/outcome-review/SKILL.md, for numeric goals:
# status per goal, overall verdict and recommendation.
# Usage: outcome-status.sh <dir containing feature.md>
# Optional MEASUREMENTS file in that dir, one line per fact:
#   G-n value <number>       the measured value
#   G-n baseline <number>    a baseline supplied afterwards
#   G-n direction up|down    which way is better, when there is no baseline
#   G-n too-early            the timeframe is not over
# Output: "<G> <status>" per goal, then "OVERALL <verdict>" and "RECOMMEND <action>".
set -u
dir="${1:?usage: outcome-status.sh <dir containing feature.md>}"
feature="$dir/feature.md"
meas="$dir/MEASUREMENTS"
[ -f "$feature" ] || { echo "ERROR no feature document"; exit 0; }

goals="$(awk '$0 == "## Goals" {f = 1; next} /^## / {f = 0} f' "$feature" | grep -E '^- G-[0-9]+:')"
[ -n "$goals" ] || { echo "ERROR no goals"; exit 0; }

num() { printf '%s' "$1" | grep -oE '[0-9]+(\.[0-9]+)?' | head -1; }
field() { printf '%s' "$3" | sed -nE "s/.*$1: (.*)\. $2: .*/\1/p"; }
cmp() { awk -v a="$1" -v op="$2" -v b="$3" 'BEGIN { if (op == ">") r = (a + 0 > b + 0); else if (op == ">=") r = (a + 0 >= b + 0); else if (op == "<") r = (a + 0 < b + 0); else r = (a + 0 <= b + 0); exit !r }'; }
fact() { [ -f "$meas" ] && awk -v g="$1" -v k="$2" '$1 == g && $2 == k {print $3; exit}' "$meas"; }
too_early() { [ -f "$meas" ] && awk -v g="$1" '$1 == g && $2 == "too-early" {f = 1} END {exit !f}' "$meas"; }

status_of() { # goal id, goal line
  local g="$1" line="$2" metric target baseline value dir
  if too_early "$g"; then echo "too early"; return; fi
  metric="$(field Metric Baseline "$line")"
  target="$(num "$(field Target Timeframe "$line")")"
  baseline="$(fact "$g" baseline)"
  [ -n "$baseline" ] || baseline="$(num "$(field Baseline Target "$line")")"
  value="$(fact "$g" value)"
  case "$metric" in ""|"to be determined") echo "not measurable"; return ;; esac
  if [ -z "$target" ] || [ -z "$value" ]; then echo "not measurable"; return; fi
  dir=""
  if [ -n "$baseline" ]; then
    if cmp "$target" ">" "$baseline"; then dir=up; elif cmp "$target" "<" "$baseline"; then dir=down; fi
  else
    dir="$(fact "$g" direction)"
  fi
  case "$dir" in
    up)
      if cmp "$value" ">=" "$target"; then echo "met"
      elif [ -z "$baseline" ]; then echo "not measurable"
      elif cmp "$value" ">" "$baseline"; then echo "partially met"
      else echo "missed"; fi ;;
    down)
      if cmp "$value" "<=" "$target"; then echo "met"
      elif [ -z "$baseline" ]; then echo "not measurable"
      elif cmp "$value" "<" "$baseline"; then echo "partially met"
      else echo "missed"; fi ;;
    *) echo "not measurable" ;;
  esac
}

statuses=""
while IFS= read -r line; do
  g="$(printf '%s' "$line" | sed -E 's/^- (G-[0-9]+):.*/\1/')"
  s="$(status_of "$g" "$line")"
  echo "$g $s"
  statuses="$statuses|$s"
done <<< "$goals"

count() { printf '%s\n' "$statuses" | tr '|' '\n' | grep -cx "$1"; }
met="$(count 'met')"; part="$(count 'partially met')"; miss="$(count 'missed')"
total="$(printf '%s\n' "$goals" | grep -c .)"
reviewable=$((met + part + miss))

if   [ "$met" -eq "$total" ];       then overall="achieved"
elif [ "$reviewable" -eq 0 ];       then overall="inconclusive"
elif [ "$met" -eq "$reviewable" ];  then overall="inconclusive"
elif [ "$met" -eq 0 ] && [ "$part" -eq 0 ]; then overall="not achieved"
else overall="partly achieved"; fi

case "$overall" in
  "achieved")        rec="close" ;;
  "partly achieved") rec="adjust" ;;
  "not achieved")    rec="new discovery" ;;
  *)                 rec="wait" ;;
esac
echo "OVERALL $overall"
echo "RECOMMEND $rec"
