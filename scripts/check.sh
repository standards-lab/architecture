#!/usr/bin/env bash
# Repository consistency checks, runnable locally; marathon runs it for every slice and review.
set -euo pipefail

cd "$(dirname "$0")/.."

fail=0
err() {
  echo "FAIL: $*" >&2
  fail=1
}

# Every markdown file in the repository, outside .git/.
mapfile -t markdown < <(find . -path ./.git -prune -o -type f -name '*.md' -printf '%P\n' | sort)

# Every relative link in the markdown resolves to an existing file or directory. A link with
# a scheme (https:, mailto:, ...) or a pure #anchor is not a path, and a #fragment is stripped
# before resolving. Fenced code blocks and inline code spans are illustration, not links, so
# they are skipped.
links() {
  awk '
    /^[[:space:]]*(```|~~~)/ { fenced = !fenced; next }
    fenced { next }
    {
      line = $0
      gsub(/`[^`]*`/, "", line)
      while (match(line, /\]\([^)[:space:]]+/)) {
        print FNR "\t" substr(line, RSTART + 2, RLENGTH - 2)
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$1"
}

for file in "${markdown[@]}"; do
  dir=$(dirname "$file")
  while IFS=$'\t' read -r line target; do
    target=${target#<}
    target=${target%>}
    case "$target" in
      '#'* | mailto:*) continue ;;
    esac
    [[ "$target" =~ ^[A-Za-z][A-Za-z0-9+.-]*: ]] && continue
    path=${target%%#*}
    [ -e "$dir/$path" ] || err "$file:$line: link $target does not resolve"
  done < <(links "$file")
done

# Every page opens with the front matter README.md's "Page metadata" section requires: key,
# name, and type on every page, plus the fields its type requires. The context/ notes and
# goal records are marathon's working notes, not pages, and CLAUDE.md is agent instructions,
# so neither carries front matter.
frontmatter() {
  awk 'NR == 1 { if ($0 != "---") exit; next } $0 == "---" { exit } { print }' "$1"
}

for file in "${markdown[@]}"; do
  case "$file" in
    context/* | CLAUDE.md) continue ;;
  esac
  fields=$(frontmatter "$file")
  if [ -z "$fields" ]; then
    err "$file: no front matter"
    continue
  fi
  value() { sed -n "s/^$1:[[:space:]]*\(.*[^[:space:]]\)[[:space:]]*$/\1/p" <<<"$fields" | head -n1; }

  type=$(value type)
  case "$type" in
    index) required=() ;;
    principle) required=(level) ;;
    architecture) required=(status) ;;
    standard) required=(architecture status) ;;
    '') required=() ;;
    *)
      err "$file: type $type is not index, principle, architecture, or standard"
      required=()
      ;;
  esac
  for key in key name type "${required[@]}"; do
    [ -n "$(value "$key")" ] || err "$file: front matter lacks $key${type:+ (required for type $type)}"
  done
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo "All checks passed."
