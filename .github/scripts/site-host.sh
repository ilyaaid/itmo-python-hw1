#!/usr/bin/env bash
set -euo pipefail

branch_name=${1:?Usage: site-host.sh BRANCH DOMAIN}
deploy_domain=${2:?Usage: site-host.sh BRANCH DOMAIN}

if [[ "$branch_name" == main ]]; then
  printf '%s\n' "$deploy_domain"
  exit 0
fi

export LC_ALL=C
slug=$(printf '%s' "$branch_name" | tr '[:upper:]' '[:lower:]' |
  sed -E 's/[^a-z0-9]+/-/g; s/^-//; s/-$//')
slug=${slug:0:42}
slug=${slug%-}
branch_hash=$(printf '%s' "$branch_name" | sha256sum | cut -c1-12)
printf 'preview-%s-%s.%s\n' "${slug:-branch}" "$branch_hash" "$deploy_domain"
