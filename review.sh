#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_REVIEWS_DIR="$REPO_ROOT/reviews"
MAIN_CONFIG="$REPO_ROOT/.vale.ini"
READABILITY_CONFIG="$REPO_ROOT/.vale-readability.ini"
ALERTS_TEMPLATE="$REPO_ROOT/styles/config/templates/alerts.tmpl"
OUTPUT_DIR="${REVIEW_OUTPUT_DIR:-$DEFAULT_REVIEWS_DIR}"

# Verify content filename provided.
if [ $# -eq 0 ]; then
	echo "Please provide a file for review: ./review.sh <content-file>"
	echo "Example: ./review.sh /full/path/to/file.md"
	exit 1
fi

INPUT_ARG="$1"
INPUT_FILE=""

# Accept a full path, a repo-relative path, or a legacy reviews-relative path.
if [ -f "$INPUT_ARG" ]; then
	INPUT_FILE="$(cd "$(dirname "$INPUT_ARG")" && pwd)/$(basename "$INPUT_ARG")"
elif [ -f "$REPO_ROOT/$INPUT_ARG" ]; then
	INPUT_FILE="$REPO_ROOT/$INPUT_ARG"
elif [ -f "$DEFAULT_REVIEWS_DIR/$INPUT_ARG" ]; then
	INPUT_FILE="$DEFAULT_REVIEWS_DIR/$INPUT_ARG"
fi

# Does the file exist.
if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
	echo ""
	echo "-----"
	echo "Error: could not find input file '$INPUT_ARG'."
	echo ""
	echo "Accepted formats:"
	echo " - Full path to a file"
	echo " - Path relative to repo root"
	echo " - Legacy path relative to ./reviews"
	echo "-----"
	echo ""
	exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Generate the review filename (<base_filename>__review.md).
INPUT_BASENAME="$(basename "$INPUT_FILE")"
INPUT_STEM="${INPUT_BASENAME%.*}"
REVIEW_FILE="$OUTPUT_DIR/${INPUT_STEM}__review.md"

READABILITY_TMP=$(mktemp)
STYLE_TMP=$(mktemp)

cleanup() {
	rm -f "$READABILITY_TMP" "$STYLE_TMP"
}

trap cleanup EXIT

echo "Reviewing $INPUT_FILE"
echo "Writing review to $REVIEW_FILE"

# Collect base text metrics from Vale.
METRICS_JSON=$(vale --config="$MAIN_CONFIG" ls-metrics "$INPUT_FILE")

WORDS=$(printf '%s\n' "$METRICS_JSON" | awk -F': ' '/"words"/{gsub(/,/,"",$2); print $2}')
SENTENCES=$(printf '%s\n' "$METRICS_JSON" | awk -F': ' '/"sentences"/{gsub(/,/,"",$2); print $2}')
SYLLABLES=$(printf '%s\n' "$METRICS_JSON" | awk -F': ' '/"syllables"/{gsub(/,/,"",$2); print $2}')
PARAGRAPHS=$(printf '%s\n' "$METRICS_JSON" | awk -F': ' '/"paragraphs"/{gsub(/,/,"",$2); print $2}')

if [ -z "$WORDS" ] || [ -z "$SENTENCES" ] || [ -z "$SYLLABLES" ] || [ "$WORDS" -eq 0 ] || [ "$SENTENCES" -eq 0 ]; then
	FK_GRADE="N/A"
	AVG_SENTENCE="N/A"
	READABILITY_STATUS="Unable to score readability from metrics."
else
	FK_GRADE=$(awk -v w="$WORDS" -v s="$SENTENCES" -v y="$SYLLABLES" 'BEGIN { printf "%.1f", (0.39*(w/s) + 11.8*(y/w) - 15.59) }')
	AVG_SENTENCE=$(awk -v w="$WORDS" -v s="$SENTENCES" 'BEGIN { printf "%.1f", (w/s) }')

	if awk -v fk="$FK_GRADE" 'BEGIN { exit !(fk <= 12.0) }'; then
		READABILITY_STATUS="Meets target (12th grade or below)."
	else
		READABILITY_STATUS="Above target (>12th grade). Simplify wording and sentence structure."
	fi
fi

# Readability-focused alerts only (long sentences/paragraph density).
vale --config="$READABILITY_CONFIG" --output="$ALERTS_TEMPLATE" "$INPUT_FILE" >"$READABILITY_TMP" || true
if ! grep -q '[^[:space:]]' "$READABILITY_TMP"; then
	echo "- No readability issues found." >"$READABILITY_TMP"
fi

# Style and mechanics alerts from the main rule set.
vale --config="$MAIN_CONFIG" --output="$ALERTS_TEMPLATE" "$INPUT_FILE" >"$STYLE_TMP" || true

if ! grep -q '[^[:space:]]' "$STYLE_TMP"; then
	echo "- No style/mechanics issues found." >"$STYLE_TMP"
fi

{
	echo "# Review for $INPUT_FILE"
	echo
	echo "## Readability (Priority)"
	echo "- **Target:** 12th-grade reading level or below"
	echo "- **Estimated Flesch-Kincaid Grade:** $FK_GRADE"
	echo "- **Status:** $READABILITY_STATUS"
	echo "- **Words/Sentences/Paragraphs:** $WORDS / $SENTENCES / $PARAGRAPHS"
	echo "- **Average Sentence Length:** $AVG_SENTENCE words"
	echo
	echo "### Readability Alerts"
	cat "$READABILITY_TMP"
	echo
	echo "## Style and Mechanics"
	cat "$STYLE_TMP"
} >"$REVIEW_FILE"
