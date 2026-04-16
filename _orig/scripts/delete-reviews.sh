#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

deleted=0

while IFS= read -r -d '' file; do
	rm -f "$file"
	echo "Deleted: $file"
	deleted=$((deleted + 1))
done < <(find "$REPO_ROOT" -type f -name '*__review.md' -print0)

echo "Deleted $deleted review file(s)."
