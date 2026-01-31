#!/bin/bash

API_KEY="${API_NINJAS_KEY:-}"
CACHE_DIR="$HOME/.cache/inspiration"
DB_FILE="$CACHE_DIR/quotes.db"

mkdir -p "$CACHE_DIR"

# Initialize database if it doesn't exist
if [ ! -f "$DB_FILE" ]; then
  sqlite3 "$DB_FILE" <<EOF
CREATE TABLE quotes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quote TEXT NOT NULL,
  author TEXT,
  category TEXT,
  fetched_date TEXT NOT NULL
);
CREATE INDEX idx_fetched_date ON quotes(fetched_date);
EOF
fi

TODAY=$(date +%Y-%m-%d)

# Check if we already have a quote for today
EXISTING=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM quotes WHERE fetched_date = '$TODAY';")

if [ "$EXISTING" -eq 0 ] && [ -n "$API_KEY" ]; then
  RESPONSE=$(curl -s --max-time 5 -H "X-Api-Key: $API_KEY" \
    "https://api.api-ninjas.com/v2/quotes?categories=success&max_length=80")

  QUOTE=$(echo "$RESPONSE" | jq -r '.[0].quote' 2>/dev/null)
  AUTHOR=$(echo "$RESPONSE" | jq -r '.[0].author' 2>/dev/null)

  if [ -n "$QUOTE" ] && [ "$QUOTE" != "null" ]; then
    # Escape single quotes for SQL
    QUOTE_ESC="${QUOTE//\'/\'\'}"
    AUTHOR_ESC="${AUTHOR//\'/\'\'}"

    sqlite3 "$DB_FILE" "INSERT INTO quotes (quote, author, category, fetched_date) VALUES ('$QUOTE_ESC', '$AUTHOR_ESC', 'success', '$TODAY');"
  fi
fi
