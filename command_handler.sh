#!/bin/bash

# Function to display commands
display_commands() {
    echo "Available Commands:"
    echo "  quit - Exit application"
    echo "  date - Append current date to journal"
    echo
}

while true; do
    # Clear the screen and display commands each time
    clear
    display_commands

    # Read command
    read -p "Enter command: " cmd

    case "$cmd" in
        quit)
            tmux kill-session -t journal
            break
            ;;
        date)
            echo -e "\n\033[7m$(date '+%A %B %d')\033[0m" >> journal.txt # this invert word box
            # echo -e "\033[31m$(date '+%A %B %d')\033[0m" >> journal.txt # this change color of text
            ;;
        *)
            echo "Unknown command: $cmd"
            ;;
    esac

    # Wait a bit before next iteration
    sleep 1
done
