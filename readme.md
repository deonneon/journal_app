# Tmux Journal App

A simple, terminal-based journaling application leveraging Tmux. It allows adding entries, viewing the journal, and deleting specific entries.

## Features

- **Real-time Journal Viewing**: Continuously tails the journal file, displaying updates as they happen.
- **Interactive Entry Addition**: Prompts for and adds new journal entries.
- **Line Removal**: Deletes specific lines from the journal.
- **Dynamic Commands**: Supports various commands like adding the current date, refreshing the app, and quitting.

## Setup

1. **Clone Repository**: Clone this repository to your local machine.
2. **Edit Start Directory**: Redefine DIR variable to point to the same directory as the journal.sh script.
3. **Initial Setup**: Run the provided setup script to initialize the application.
4. **Aliasing**: Launch app through journal command by appending to the .bash_profile -- aliasing journal='{path}/start_journal_app.sh'

## Usage

### Starting the App

- Run `./start_journal_app.sh` to start the Tmux session with all panes configured.
  or
- Type journal command to launch if already aliased.

### Using the App

- **Main Pane**: Shows the real-time view of your journal.
- **Entry Addition Pane**: Add new journal entries.
- **Command Handler Pane**: Enter commands to interact with the journal.

#### Commands

- `quit`: Exits the application.
- `date`: Appends the current date to the journal.
- `remove <line_number>`: Removes the specified line from the journal.
- `refresh`: Refreshes the journal view and entry addition pane.

## Customization

- **Journal Directory**: Set the journal directory in the `start_journal_app.sh` script.
- **Journal File**: By default, `journal.txt` is used. Change this in the script if needed.
- **Aliasing**: Improve convenience by aliasing to journal command. Change this in the .bash_profile if needed.

## Dependencies

- **Tmux**: Ensure Tmux is installed on your system.
- **Bash**: Scripts are written for Bash.

## Known Issues

- **Cross-platform Compatibility**: `sed` command usage might vary based on the operating system.

## Contributing

Feel free to fork the repository and submit pull requests.

## License

[MIT License](LICENSE)

## Author

Danh Tran
