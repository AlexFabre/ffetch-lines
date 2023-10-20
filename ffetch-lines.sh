#!/bin/sh
# ==========================================
#   ffetch-lines - A little bash script to extract specific
#                   lines from a file
#   Copyright (C) 2023 Alex Fabre
#   [Released under MIT License. Please refer to license.txt for details]
# ==========================================

# ==========================================
# Usage:
#   $> ffetch-lines.sh dir/subdir/file.c 2 6 9-63 output.txt
# ==========================================

# Script self version informations
FFETCH_LINES_MAJOR=0
FFETCH_LINES_MINOR=1
FFETCH_LINES_FIX=0

# Print variables
FFETCH_LINES="ffetch-lines.sh"
FFETCH_LINES_REV="$FFETCH_LINES_MAJOR.$FFETCH_LINES_MINOR.$FFETCH_LINES_FIX"
FFETCH_LINES_INTRO_L1="A little bash script to extract specific"
FFETCH_LINES_INTRO_L2="lines from a file"

# ==========================================
# Script call checks
# ==========================================

# The user has to provide the path for the
# dest file when calling the script
usage() {
    echo "==> $FFETCH_LINES $FFETCH_LINES_REV"
    echo "$FFETCH_LINES_INTRO_L1"
    echo "$FFETCH_LINES_INTRO_L2"
    echo "Usage:"
    echo "$FFETCH_LINES <file> <line1> [<line2> ...] -o <output-file> [options]"
    echo "-h <help>"
    echo "-v <script version>"
}

# Check the call of the script
while getopts ":hv" opt; do
    case "${opt}" in
        h)
            usage
            exit 0
            ;;
        v)
            echo "$FFETCH_LINES_REV"
            exit 0
            ;;
        *)  ;;
    esac
done

# ==========================================
# Script
# ==========================================

# Read the file name from the first argument
input_file=$1

# Initialize variables for storing the output file and line arguments
output_file=""
lines=()

# Shift the arguments by one to exclude the input_file
shift

# Parse the arguments in a loop, regardless of their order
while [[ $# -gt 0 ]]; do
    case $1 in
        -o)
            shift
            output_file=$1
            shift
            ;;
        *)
            lines+=("$1")
            shift
            ;;
    esac
done

# Check if the output file is not provided or empty
if [ -z "$output_file" ]; then
    echo "Output file is not specified!"
    exit 1
fi

# Create an empty file for the output
true > "$output_file"

# Variable to store the count of lines written
written_line_count=0

# Loop through each line argument
for arg in "${lines[@]}"; do
    # Check if the argument is a range
    if [[ $arg == *-* ]]; then
        # Extract the start and end line numbers from the range
        start=${arg%-*}
        if [ "$start" -eq 0 ]; then
            start=1
        fi

        end=${arg#*-}

        # Check if the start line exceeds the total number of lines in the input file
        if [ "$start" -gt "$(wc -l < "$input_file")" ]; then
            echo "Line $start does not exist in the input file!"
            continue
        fi

        # Check if the end line exceeds the total number of lines in the input file
        total_lines=$(wc -l < "$input_file")
        if [ "$end" -gt "$total_lines" ]; then
            echo "Line $end does not exist in the input file!"
            end=$total_lines
        fi

        # Write the lines within the range to the output file using sed command
        sed -n "${start},${end}p" "$input_file" >> "$output_file"
        written_line_count=$((written_line_count + end - start + 1))
        
    else
        if [ "$arg" -eq 0 ]; then
            arg=1
        fi
        # Check if the specified line exceeds the total number of lines in the input file
        if [ "$arg" -gt "$(wc -l < "$input_file")" ]; then
            echo "Line $arg does not exist in the input file!"
            continue
        fi

        # Write the specified line to the output file using sed command
        sed -n "${arg}p" "$input_file" >> "$output_file"
        written_line_count=$((written_line_count + 1))
        
    fi
done

echo "$written_line_count lines written to $output_file"
