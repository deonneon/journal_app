#!/bin/bash

# Check if a line number is provided
if [ -z "" ]; then
    echo "Usage: lineremove.sh <line-number>"
    exit 1
fi

# The line number to be removed
line_number=

# Remove the specified line from journal.txt
sed -i "d" journal.txt
