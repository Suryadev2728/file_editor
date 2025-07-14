#!/bin/bash

LOG_FILE="backup_log.txt"
EDITOR="vim" 

# Check if script is run with more than one argument
if [[ $# -gt 1 ]]; then
    echo "ERROR: Too many parameters entered. Use only one parameter."
    exit 1
fi

while true; do
    clear
    echo "====================================="
    echo "     SafeEdit Script - File Editor   "
    echo "====================================="
    echo "This script can run in two modes:"
    echo "[*] Interactive mode - You will be asked for a filename."
    echo "[*] Command-Line mode - Provide a filename as an argument."
    echo "[Q] Quit - Exit the program."
    echo "====================================="
    echo "If no argument is provided, Interactive mode will start automatically."
    echo "-------------------------------------"
    
    # Check if script is run with an argument
    if [[ -n "$1" ]]; then
        filename="$1"
        echo "\nYou have selected COMMAND-LINE MODE."
        echo "The file '$filename' will be processed."
        echo "-------------------------------------"
    else
        read -p "Enter filename to edit (or Q to quit): " filename
    fi
    
    clear
    # Check for quit command
    if [[ "$filename" == "Q" || "$filename" == "q" ]]; then
        echo "Exiting SafeEdit. Goodbye!"
        exit 0
    fi
    
    # Ensure filename is not empty
    if [[ -z "$filename" ]]; then
        echo "ERROR: Filename cannot be empty."
        read -p "Press Enter to continue..."
        clear
        continue
    fi
    
    clear
    # Check if file exists
    if [[ ! -f "$filename" ]]; then
        echo "ERROR: File '$filename' does not exist."
        read -p "Press Enter to continue..."
        [[ -n "$1" ]] && exit 1
        continue
    fi
    
    clear
    # Create a backup
    backup_file="$filename.bak"
    cp "$filename" "$backup_file"
    echo "Backup Created: $filename to $backup_file"
    
    # Log the backup operation with timestamp
    echo "[$(date)] Backup created: $filename to $backup_file" >> "$LOG_FILE"
    
    # Maintain only last 5 log entries
    if [[ -f "$LOG_FILE" ]]; then
        line_count=$(wc -l < "$LOG_FILE")
        if (( line_count > 5 )); then
            tail -n 5 "$LOG_FILE" > temp_log.txt && mv temp_log.txt "$LOG_FILE"
        fi
    fi
    
    clear
    # Open file in editor
    $EDITOR "$filename"
    
    clear
    echo "Editing completed successfully."
    echo "The file '$filename' has been opened in Vim."
    read -p "Press Enter to continue..."
    
    # If script was run with an argument, exit after processing
    [[ -n "$1" ]] && exit 0

done

