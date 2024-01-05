#!/bin/bash

DIR="."

# Start tmux session
tmux new-session -d -s journal 

# Source session config
tmux source-file session.tmux.conf

tmux set-option -t journal:0.0 mode-keys vi # Make pane 0 read-only
# Setting pane background color
#tmux select-pane -t 0 -P 'bg=black'
tmux send-keys -t 0 "cd $DIR; clear; tail -f -n 10000 journal.txt | nl -w4 -s\"   \"" Enter
# Lock top panel
tmux select-pane -d

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
    read -e -p "Enter your journal entry: " entry
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

# Create the append_to_journal.sh script
cat <<EOF > lineremove.sh
#!/bin/bash

# Check if a line number is provided
if [ -z "$1" ]; then
    echo "Usage: lineremove.sh <line-number>"
    exit 1
fi

# The line number to be removed
line_number=$1

# Remove the specified line from journal.txt
sed -i "${line_number}d" journal.txt
EOF

# Give execute permission to the append_to_journal.sh script
chmod +x lineremove.sh


# Create the command_handler.sh script
cat <<EOF > command_handler.sh
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
    read -e -p "Enter command: " cmd

    case "\$cmd" in
        quit)
            tmux kill-session -t journal
            break
            ;;
        date)
            echo -e " \n\033[7m\$(date '+%A %B %d')\033[0m" >> journal.txt # this invert word box
            # echo -e "\033[31m\$(date '+%A %B %d')\033[0m" >> journal.txt # this change color of text
            ;;
        remove*)
            line_number=\$(echo "\$cmd" | cut -d ' ' -f2)
            if ! [[ \$line_number =~ ^[0-9]+$ ]]; then
                echo "Invalid line number"
            else
                # Check for OS type and apply appropriate sed command
                if [[ "\$(uname)" == "Darwin" ]]; then
                    sed -i '' "\${line_number}d" journal.txt
                else
                    sed -i "\${line_number}d" journal.txt
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
