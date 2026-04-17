#!/bin/bash

# Check if a file was provided
if [ -z "$1" ]; then
	echo "Error: No file specified."
	echo "Usage: ./review-content.sh <filename>"
	exit 1
fi

# Input file path
INPUT_FILE="$1"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
	echo "Error: File '$INPUT_FILE' not found."
	exit 1
fi

# Extract the directory, filename without extension, and extension
DIR=$(dirname "$INPUT_FILE")
BASE=$(basename "$INPUT_FILE")
FILENAME="${BASE%.*}"

# Construct the output path: directory/filename__review.md
OUTPUT_FILE="${DIR}/${FILENAME}__review.md"

# Run Vale with the custom template
# Ensure review.tmpl is in your current working directory
vale --output="review.tmpl" "$INPUT_FILE" >"$OUTPUT_FILE"

# Final status check
if [ $? -eq 0 ]; then
	echo "Review generated successfully: $OUTPUT_FILE"
else
	echo "Error: Vale failed to process the file."
	exit 1
fi
