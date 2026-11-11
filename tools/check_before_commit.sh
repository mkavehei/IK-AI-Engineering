#!/usr/bin/env bash
# Run before every commit. Looks for API keys and files that are too big for GitHub.
# Usage (from the repository folder):  bash tools/check_before_commit.sh
cd "$(dirname "$0")/.."
problems=0

# 1. Things that look like real API keys, in files Git would upload
files=$(git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path './.git/*')
keys=$(echo "$files" | grep -v -E '(^|/)\.env\.example$' | while read -r f; do
  [[ -f "$f" ]] && grep -I -n -E '(sk-ant-[A-Za-z0-9_-]{20,}|sk-(proj-)?[A-Za-z0-9_-]{20,}|hf_[A-Za-z0-9]{30,}|AIza[0-9A-Za-z_-]{35}|ghp_[A-Za-z0-9]{36})' "$f" 2>/dev/null | sed "s|^|$f:|"
done)
if [[ -n "$keys" ]]; then
  echo "STOP: these lines look like real API keys. Move them into a .env file:"
  echo "$keys" | cut -c1-120
  problems=1
fi

# 2. Files over 50 MB (GitHub warns at 50 MB and rejects over 100 MB)
big=$(echo "$files" | while read -r f; do
  [[ -f "$f" ]] && size=$(wc -c < "$f") && (( size > 50000000 )) && echo "$f ($((size/1000000)) MB)"
done)
if [[ -n "$big" ]]; then
  echo "STOP: these files are too big for GitHub. Remove them or add them to .gitignore:"
  echo "$big"
  problems=1
fi

if [[ $problems -eq 0 ]]; then echo "OK: no API keys and no big files found. Safe to commit."; fi
exit $problems
