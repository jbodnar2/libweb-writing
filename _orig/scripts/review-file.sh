#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_REVIEWS_DIR="$REPO_ROOT/reviews"
TEST_REVIEWS_DIR="$REPO_ROOT/tests/test-reviews"
MAIN_CONFIG="$REPO_ROOT/.vale.ini"
READABILITY_CONFIG="$REPO_ROOT/.vale-readability.ini"
ALERTS_TEMPLATE="$REPO_ROOT/styles/config/templates/alerts.tmpl"

if [ $# -eq 0 ]; then
	echo "Please provide a file for review: ./scripts/review-file.sh <content-file>"
	echo "Example: ./scripts/review-file.sh /full/path/to/file.md"
	exit 1
fi

INPUT_ARG="$1"
if [ -f "$INPUT_ARG" ]; then
	INPUT_FILE="$(cd "$(dirname "$INPUT_ARG")" && pwd)/$(basename "$INPUT_ARG")"
elif [ -f "$REPO_ROOT/$INPUT_ARG" ]; then
	INPUT_FILE="$REPO_ROOT/$INPUT_ARG"
else
	echo "Error: could not find '$INPUT_ARG'. Provide a full path or a path relative to the repo root."
	exit 1
fi

if [ -n "${REVIEW_OUTPUT_DIR:-}" ]; then
	OUTPUT_DIR="$REVIEW_OUTPUT_DIR"
elif [[ "$INPUT_FILE" == "$REPO_ROOT/tests/"* ]]; then
	OUTPUT_DIR="$TEST_REVIEWS_DIR"
else
	OUTPUT_DIR="$DEFAULT_REVIEWS_DIR"
fi

mkdir -p "$OUTPUT_DIR"

INPUT_BASENAME="$(basename "$INPUT_FILE")"
INPUT_STEM="${INPUT_BASENAME%.*}"
REVIEW_FILE="$OUTPUT_DIR/${INPUT_STEM}__review.md"

echo "Reviewing $INPUT_FILE"
echo "Writing review to $REVIEW_FILE"

METRICS_JSON=$(vale --config="$MAIN_CONFIG" ls-metrics "$INPUT_FILE")

metric_value() {
	local key="$1"
	printf '%s\n' "$METRICS_JSON" | awk -F': ' -v key="$key" '$1 ~ "\"" key "\"" { gsub(/,/, "", $2); print $2 }'
}

WORDS=$(metric_value words)
SENTENCES=$(metric_value sentences)
SYLLABLES=$(metric_value syllables)
PARAGRAPHS=$(metric_value paragraphs)

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

collect_alerts() {
	local config="$1"
	local fallback="$2"
	local alerts
	alerts=$(vale --config="$config" --output="$ALERTS_TEMPLATE" "$INPUT_FILE" || true)
	# Normalize template output so section headers always have exactly one blank line after them.
	alerts=$(printf '%s\n' "$alerts" | awk 'BEGIN{seen=0} { if (!seen && $0 ~ /^[[:space:]]*$/) next; seen=1; print }')
	if ! printf '%s' "$alerts" | grep -q '[^[:space:]]'; then
		printf '%s\n' "$fallback"
	else
		printf '%s\n' "$alerts"
	fi
}

READABILITY_ALERTS=$(collect_alerts "$READABILITY_CONFIG" "- No readability issues found.")
STYLE_ALERTS=$(collect_alerts "$MAIN_CONFIG" "- No style/mechanics issues found.")

{
	echo "# Review for $INPUT_BASENAME"
	echo
	echo "## Readability (Priority)"
	echo
	echo "- **Target:** 12th-grade reading level or below"
	echo "- **Estimated Flesch-Kincaid Grade:** $FK_GRADE"
	echo "- **Status:** $READABILITY_STATUS"
	echo "- **Words/Sentences/Paragraphs:** $WORDS / $SENTENCES / $PARAGRAPHS"
	echo "- **Average Sentence Length:** $AVG_SENTENCE words"
	echo
	echo "### Readability Alerts"
	echo
	printf '%s\n' "$READABILITY_ALERTS"
	echo
	echo "## Style and Mechanics"
	echo
	printf '%s\n' "$STYLE_ALERTS"
} >"$REVIEW_FILE"
