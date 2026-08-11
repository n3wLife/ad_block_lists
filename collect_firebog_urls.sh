#!/bin/bash
# ============================================================================
# firebog-blocklist.sh
# Extracts blocklist URLs from Firebog.net and outputs:
# 1. The total count of URLs found
# 2. A single comma-separated string of all URLs
# Compatible with macOS & Linux (no dependencies)
# ============================================================================

set -euo pipefail

echo "🔍 Fetching Firebog.net recommended blocklists..." >&2

# 1. Fetch, filter for 'bdTick' class, extract hrefs, and remove duplicates
URL_LIST=$(curl -sL --max-time 30 https://firebog.net/ \
  | grep '<a href=' \
  | grep 'bdTick' \
  | sed -n 's/.*href="\([^"]*\)".*/\1/p' \
  | sort -u)

# 2. Count the URLs (wc -l counts newlines)
if [ -z "$URL_LIST" ]; then
    COUNT=0
else
    COUNT=$(echo "$URL_LIST" | wc -l)
fi

# 3. Convert newline-separated list to comma-separated string
CSV_STRING=$(echo "$URL_LIST" | tr '\n' ',' | sed 's/,$//')

# 4. Output results
echo "✅ Total URLs collected: ${COUNT}"
echo ""
echo "${CSV_STRING}"
