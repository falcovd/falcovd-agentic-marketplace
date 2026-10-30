#!/usr/bin/env bash
# Checks versions and changelogs. Run from anywhere. See VERSIONING.md.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

check() { # description, command
  if eval "$2" >/dev/null 2>&1; then echo "ok:   $1"; else echo "FAIL: $1"; fail=1; fi
}
semver='^[0-9]+\.[0-9]+\.[0-9]+$'
field() { # file, jq-less lookup of the first "version" value at the given pattern
  grep -m1 '"version"' "$1" | sed -E 's/.*"version": *"([^"]*)".*/\1/'
}

market="$root/.claude-plugin/marketplace.json"
mver="$(field "$market")"
check "marketplace version is semver ($mver)" "echo '$mver' | grep -Eq '$semver'"
check "root CHANGELOG.md has [Unreleased]" "grep -q '^## \\[Unreleased\\]' '$root/CHANGELOG.md'"
check "root CHANGELOG.md has [$mver]" "grep -q '^## \\[$mver\\]' '$root/CHANGELOG.md'"

for dir in "$root"/plugins/*/; do
  name="$(basename "$dir")"
  pver="$(field "$dir/.claude-plugin/plugin.json")"
  entry="$(grep -A6 "\"name\": \"$name\"" "$market" | grep -m1 '"version"' | sed -E 's/.*"version": *"([^"]*)".*/\1/')"
  check "$name version is semver ($pver)" "echo '$pver' | grep -Eq '$semver'"
  check "$name: plugin.json matches marketplace entry ($pver = $entry)" "[ '$pver' = '$entry' ]"
  check "$name has CHANGELOG.md with [Unreleased]" "grep -q '^## \\[Unreleased\\]' '$dir/CHANGELOG.md'"
  check "$name CHANGELOG.md has [$pver]" "grep -q '^## \\[$pver\\]' '$dir/CHANGELOG.md'"
done

exit $fail
