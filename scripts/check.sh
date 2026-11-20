#!/usr/bin/env bash
# Checks that every relative link in the repository's markdown resolves, that every page opens
# with the front matter its type requires, and that every reference in the scripts resolves.
#
# A reference is a path ending in .md named on a whole-line # comment in a file under scripts/.
# It resolves from the repository root; a leading architecture/ segment names this repository, as
# the standards files across the workspace write it.
set -euo pipefail

cd "$(dirname "$0")/.."

fail=0
err() {
  echo "FAIL: $*" >&2
  fail=1
}

mapfile -t markdown_outside_gitignore < <(git ls-files --cached --others --exclude-standard -- '*.md' | sort)

link_targets_outside_code() {
  awk '
    /^[[:space:]]*(```|~~~)/ { in_fenced_code = !in_fenced_code; next }
    in_fenced_code { next }
    {
      line_without_code_spans = $0
      gsub(/`[^`]*`/, "", line_without_code_spans)
      if (match(line_without_code_spans, /^ {0,3}\[[^]]+\]:[[:space:]]*[^[:space:]]+/)) {
        reference_definition = substr(line_without_code_spans, RSTART, RLENGTH)
        sub(/^ {0,3}\[[^]]+\]:[[:space:]]*/, "", reference_definition)
        print FNR "\t" reference_definition
      }
      while (match(line_without_code_spans, /\]\(<[^>]*>|\]\([^)[:space:]]+/)) {
        print FNR "\t" substr(line_without_code_spans, RSTART + 2, RLENGTH - 2)
        line_without_code_spans = substr(line_without_code_spans, RSTART + RLENGTH)
      }
    }
  ' "$1"
}

uri_scheme='^[A-Za-z][A-Za-z0-9+.-]*:'

for file in "${markdown_outside_gitignore[@]}"; do
  dir=$(dirname "$file")
  while IFS=$'\t' read -r line target; do
    target=${target#<}
    target=${target%>}
    case "$target" in
      '#'*) continue ;;
    esac
    [[ "$target" =~ $uri_scheme ]] && continue
    path_without_fragment=${target%%#*}
    [ -e "$dir/$path_without_fragment" ] || err "$file:$line: link $target does not resolve"
  done < <(link_targets_outside_code "$file")
done

closed_front_matter() {
  awk 'NR == 1 { if ($0 != "---") exit; next } $0 == "---" { closed = 1; exit } { block = block $0 "\n" }
    END { if (closed) printf "%s", block }' "$1"
}

is_page() {
  case "$1" in
    context/* | CLAUDE.md | STANDARDS.md) return 1 ;;
  esac
}

for file in "${markdown_outside_gitignore[@]}"; do
  is_page "$file" || continue
  fields=$(closed_front_matter "$file")
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

mapfile -t scripts_outside_gitignore < <(git ls-files --cached --others --exclude-standard -- scripts | sort)

references_on_comment_lines() {
  awk '
    /^[[:space:]]*#/ {
      comment = $0
      while (match(comment, /[A-Za-z0-9_.\/-]+\.md/)) {
        print FNR "\t" substr(comment, RSTART, RLENGTH)
        comment = substr(comment, RSTART + RLENGTH)
      }
    }
  ' "$1"
}

for file in "${scripts_outside_gitignore[@]}"; do
  while IFS=$'\t' read -r line reference; do
    [ -e "${reference#architecture/}" ] ||
      err "\`$file:$line\`: reference \`$reference\` does not resolve; fix the path or remove the reference"
  done < <(references_on_comment_lines "$file")
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo "All checks passed."
