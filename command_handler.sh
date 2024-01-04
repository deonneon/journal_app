#!/bin/bash

# Function to display commands
display_commands() {
    echo "Available Commands:"
    echo "  quit - Exit application"
    echo "  date - Append current date to journal"
    echo "  remove n - Remove nth line number"
    echo "  refresh - refresh app"
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
            echo -e " \n\033[7m$(date '+%A %B %d')\033[0m" >> journal.txt # this invert word box
            # echo -e "\033[31m$(date '+%A %B %d')\033[0m" >> journal.txt # this change color of text
            ;;
        remove*)
            line_number=$(echo "$cmd" | cut -d ' ' -f2)
            if ! [[ $line_number =~ ^[0-9]+$ ]]; then
                echo "Invalid line number"
            else
                # Check for OS type and apply appropriate sed command
                if [[ "$(uname)" == "Darwin" ]]; then
                    sed -i '' "${line_number}d" journal.txt
                else
                    sed -i "${line_number}d" journal.txt
                fi
                
                # Refresh the tail -f pane
                tmux send-keys -t 0 C-c 'clear; tail -f -n 10000 journal.txt | nl -w4 -s"   "' C-m
            fi
            ;;
        refresh)
            # Refresh the tail -f pane
            tmux send-keys -t 0 C-c 'clear; tail -f -n 10000 journal.txt | nl -w4 -s"   "' C-m
            
            # Refresh pane 1 (Journal Entry Input)
            tmux send-keys -t 1 C-c "clear; ./append_to_journal.sh" C-m
            ;;
        *)
            echo "Unknown command: $cmd"
            ;;
    esac

    # Wait a bit before next iteration
    sleep 1
done
