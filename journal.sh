#!/bin/bash

# Start tmux session
tmux new-session -d -s journal 'tail -f journal.txt'

# Split the top screen vertically and run 'tail -f' on journal.txt
tmux split-window -v 

# Split the bottom screen horizontally
tmux split-window -h

# Select the middle screen
tmux select-pane -t 1

# Create the append_to_journal.sh script
cat <<EOF > append_to_journal.sh
#!/bin/bash

while true; do
    clear
    read -p "Enter your journal entry: " entry
    if [[ \$entry == "exit" ]]; then
        break
    fi
    echo "\$entry" >> journal.txt
done
EOF

# Give execute permission to the append_to_journal.sh script
chmod +x append_to_journal.sh

# Run the append_to_journal.sh script in the middle screen
tmux send-keys -t 1 "./append_to_journal.sh" C-m

# Select the third screen
tmux select-pane -t 2

# Create the command_handler.sh script
cat <<EOF > command_handler.sh
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

    case "\$cmd" in
        quit)
            tmux kill-session -t journal
            break
            ;;
        date)
            echo -e "\n\033[7m\$(date '+%A %B %d')\033[0m" >> journal.txt # this invert word box
            # echo -e "\033[31m\$(date '+%A %B %d')\033[0m" >> journal.txt # this change color of text
            ;;
        *)
            echo "Unknown command: \$cmd"
            ;;
    esac

    # Wait a bit before next iteration
    sleep 1
done
EOF

# Give execute permission to the command_handler.sh script
chmod +x command_handler.sh

# Run the command_handler.sh script in the third screen
tmux send-keys -t 2 "./command_handler.sh" C-m

# Attach to the tmux session
tmux attach-session -t journal
