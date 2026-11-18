#!/usr/bin/env bash
set -euo pipefail

site_url=${1:?Usage: check-site.sh URL}
expected_text=${HEALTHCHECK_EXPECTED_TEXT:-Моя документация}
html_file=$(mktemp)
trap 'rm -f "$html_file"' EXIT

status=$(curl --silent --show-error --max-time 30 \
  --output "$html_file" --write-out '%{http_code}' -- "$site_url")
if [[ "$status" != 200 ]]; then
  echo "::error::Expected HTTP 200 from $site_url, got $status"
  exit 1
fi

if ! grep -Fq -- "$expected_text" "$html_file"; then
  echo "::error::Expected text '$expected_text' was missing from $site_url"
  exit 1
fi
