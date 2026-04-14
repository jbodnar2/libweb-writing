#!/bin/bash

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

echo "Reviewing $INPUT_FILE"

# Run vale and generate the review file.
vale --output="content-review.tmpl" "$INPUT_FILE" > "$REVIEW_FILE"
