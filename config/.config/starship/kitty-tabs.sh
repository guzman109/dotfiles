#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

if [ -z "${KITTY_WINDOW_ID:-}" ]; then
  exit 0
fi

state="$(kitten @ ls 2>/dev/null | tr -d '\r')" || exit 0

current_info="$(
  printf '%s' "$state" | jq -r --arg wid "$KITTY_WINDOW_ID" '
    to_entries[]
    | .key as $os_idx
    | .value.tabs
    | to_entries[]
    | .key as $tab_idx
    | .value.windows[]
    | select((.id | tostring) == $wid)
    | "\($os_idx):\($tab_idx)"
  ' | head -n1
)"

[ -n "$current_info" ] || exit 0

os_idx="${current_info%%:*}"
tab_idx="${current_info##*:}"

total_tabs="$(
  printf '%s' "$state" | jq -r --argjson os_idx "$os_idx" '
    .[$os_idx].tabs | length
  '
)"

current_tab="$((tab_idx + 1))"

printf '%s' "󰄛 $current_tab | $total_tabs"
