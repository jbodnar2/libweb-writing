#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
REVIEWS_DIR="$REPO_ROOT/reviews"

if [ ! -d "$REVIEWS_DIR" ]; then
    echo "Error: reviews directory not found at $REVIEWS_DIR"
    exit 1
fi

while IFS= read -r file; do
    base="$(basename "$file")"
    "$REPO_ROOT/review.sh" "$base"
done < <(find "$REVIEWS_DIR" -maxdepth 1 -name '*.md' ! -name '*__review.md' | sort)
