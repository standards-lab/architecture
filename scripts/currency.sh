#!/usr/bin/env bash
# Prints `<file>: <tool> <pin> -> <latest>` for each mise tool pinned in mise.toml behind its
# latest, and exits 1 if any; prints nothing when all are current. Reads the network.
set -euo pipefail
cd "$(dirname "$0")/.."

trailing=$(MISE_LOG_LEVEL=error mise outdated --bump --local --json |
  jq -r 'to_entries[] | (.value.bump // .value.latest) as $to | select($to != .value.requested) |
    "\(.value.source.path | split("/") | last): \(.key) \(.value.requested) -> \($to)"' | sort -u)

if [[ -n $trailing ]]; then
  echo "$trailing"
  exit 1
fi
