#!/bin/bash

set -euo pipefail

# Verify content filename provided
if [ $# -eq 0 ]; then
    echo "Please provide a file for review: ./review.sh <content-file>"
    exit 1
fi

# Construct the input file path
FILENAME=$1
REVIEWS_PATH="./reviews/"
INPUT_FILE="$REVIEWS_PATH$FILENAME"


# Does the file exist
if [ ! -f "$INPUT_FILE"  ]; then
    echo ""
    echo "-----"
    echo "Error: '$INPUT_FILE' does not exist."
    echo ""
    echo "Available files:"
    ls -1 "$REVIEWS_PATH" | sed 's/^/ - /'
    echo "-----"
    echo ""
    exit 1
fi

# Generate the review filename (<base_filename>__reivew.md)
REVIEW_FILE="$REVIEWS_PATH$(basename "$INPUT_FILE" .md)__review.md"
ALERTS_TEMPLATE="styles/config/templates/alerts.tmpl"

READABILITY_TMP=$(mktemp)
STYLE_TMP=$(mktemp)

cleanup() {
    rm -f "$READABILITY_TMP" "$STYLE_TMP"
}

trap cleanup EXIT

echo "Reviewing $INPUT_FILE"

# Collect base text metrics from Vale.
METRICS_JSON=$(vale ls-metrics "$INPUT_FILE")

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
vale --config=".vale-readability.ini" --output="$ALERTS_TEMPLATE" "$INPUT_FILE" > "$READABILITY_TMP" || true
if ! grep -q '[^[:space:]]' "$READABILITY_TMP"; then
    echo "- No readability issues found." > "$READABILITY_TMP"
fi

# Style and mechanics alerts from the main rule set.
vale --output="$ALERTS_TEMPLATE" "$INPUT_FILE" > "$STYLE_TMP" || true

if ! grep -q '[^[:space:]]' "$STYLE_TMP"; then
    echo "- No style/mechanics issues found." > "$STYLE_TMP"
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
} > "$REVIEW_FILE"
