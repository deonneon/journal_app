#!/bin/bash

while true; do
    clear
    read -e -p "Enter your journal entry: " entry
    if [[ $entry == "exit" ]]; then
        break
    fi
    echo "$entry" >> journal.txt
done
