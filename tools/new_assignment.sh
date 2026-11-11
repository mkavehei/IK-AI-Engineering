#!/usr/bin/env bash
# Creates a new assignment folder from the template and adds a row to the main README table.
# Usage (from the repository folder):
#   bash tools/new_assignment.sh 02 "RAG chatbot" "Retrieval-augmented generation"
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
  echo "An assignment with number ${num} already exists:"; ls -d assignments/${num}-*; exit 1
fi

cp -R assignments/_template "$dir"
# Make the title and topic safe to use in sed (characters like & and / have special meaning there)
esc() { printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'; }
title_s=$(esc "$title"); topic_s=$(esc "$topic")
sed -i.bak -e "s/^# NN — Assignment title/# ${num} — ${title_s}/" -e "s/^\*\*Topic:\*\* .*/**Topic:** ${topic_s}  /" -e "s/^\*\*Date:\*\* YYYY-MM-DD/**Date:** $(date +%Y-%m-%d)  /" "$dir/README.md"
rm -f "$dir/README.md.bak"

row="| ${num} | [${title}](${dir}/) | ${topic} | In progress |"
marker='<!-- ASSIGNMENTS-TABLE'
awk -v row="$row" -v m="$marker" 'index($0, m) == 1 { print row } { print }' README.md > README.md.tmp && mv README.md.tmp README.md

echo "Created ${dir}"
echo "Added it to the table in README.md (status: In progress)."
