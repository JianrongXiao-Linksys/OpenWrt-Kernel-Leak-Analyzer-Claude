#!/bin/bash

# --- Configuration ---
# Assuming your Claude CLI tool is configured and executable.
# The command uses '-p' for print mode, reading the content from the pipeline.
CLAUDE_COMMAND="claude -p"
PROMPT_FILE="../PROMPT_TEMPLATE.md"
LOG_FILE_1="../data/sysinfo-Pinnacle2.0-0.txt"
LOG_FILE_2="../data/sysinfo-Pinnacle2.0-1.txt"
OUTPUT_DIR="../analysis_results"
OUTPUT_FILE="$OUTPUT_DIR/memory_leak_report.md"

# Check for required files
if [ ! -f "$PROMPT_FILE" ] || [ ! -f "$LOG_FILE_1" ] || [ ! -f "$LOG_FILE_2" ]; then
    echo "Error: One or more input files are missing."
    echo "Expected: $PROMPT_FILE, $LOG_FILE_1, $LOG_FILE_2"
    exit 1
fi

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

echo "Starting Claude Opus analysis..."

# Use cat to concatenate the Prompt file (instructions) and the two Log files (data).
# The entire output is piped to the Claude CLI tool for processing.
(
    cat "$PROMPT_FILE"
    echo "" # Add an empty line to separate the prompt from the data
    cat "$LOG_FILE_1"
    cat "$LOG_FILE_2"
) | $CLAUDE_COMMAND > "$OUTPUT_FILE"

# Check the exit status of the Claude command
if [ $? -eq 0 ]; then
    echo "Analysis complete. Report saved to $OUTPUT_FILE"
else
    echo "Error during Claude analysis execution. Please check your Claude CLI configuration and API access."
fi
