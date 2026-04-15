#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
TESTS_DIR="$REPO_ROOT/tests"
TEST_REVIEWS_DIR="$REPO_ROOT/reviews/tests"

if [ ! -d "$TESTS_DIR" ]; then
	echo "Error: tests directory not found at $TESTS_DIR"
	exit 1
fi

mkdir -p "$TEST_REVIEWS_DIR"

found=0
while IFS= read -r file; do
	found=1
	REVIEW_OUTPUT_DIR="$TEST_REVIEWS_DIR" "$REPO_ROOT/review.sh" "$file"
done < <(find "$TESTS_DIR" -maxdepth 1 -name '*.md' ! -name '*__review.md' | sort)

if [ "$found" -eq 0 ]; then
	echo "No test Markdown files found in $TESTS_DIR"
fi
