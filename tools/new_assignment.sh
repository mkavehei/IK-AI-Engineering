#!/usr/bin/env bash
# Makes a folder for a new assignment and adds it to the table in README.md.
# Usage (from the repository folder):
#   bash tools/new_assignment.sh 02 "Assignment title" "Topic"
set -euo pipefail
cd "$(dirname "$0")/.."

num="${1:-}"; title="${2:-}"; topic="${3:-}"
if [[ -z "$num" || -z "$title" ]]; then
  echo 'Usage: bash tools/new_assignment.sh 02 "Assignment title" "Topic"'; exit 1
fi
num=$(printf "%02d" "$((10#$num))")
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
dir="assignments/${num}-${slug}"

if ls -d assignments/${num}-* >/dev/null 2>&1; then
  echo "Assignment ${num} already exists:"; ls -d assignments/${num}-*; exit 1
fi

mkdir -p "$dir"
row="| ${num} | [${title}](${dir}/) | ${topic} |"
awk -v row="$row" 'index($0, "<!-- ASSIGNMENTS-TABLE") == 1 { print row } { print }' README.md > README.md.tmp && mv README.md.tmp README.md

echo "Created folder: ${dir}"
echo "Added it to the table in README.md."
echo "Now put your notebook (and any screenshots) into that folder."
