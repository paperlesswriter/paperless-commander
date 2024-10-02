#!/bin/bash

# Paperless-ngx Commander
# This script provides a user-friendly interface for managing Paperless-ngx operations.
# It includes options for updating, exporting/importing documents, managing containers, and reindexing.

# Note: This script assumes Paperless-ngx is installed using docker-compose in a directory named "paperless-ngx".
# Document and export directories are expected to be subdirectories of this main path.
# If your setup differs, please adjust the paths in the functions below accordingly.

# Color definitions
BLUE_BG='\033[44m'
WHITE_FG='\033[97m'
CUSTOM_GREEN='\033[48;2;92;128;132m'
RESET='\033[0m'

# Function definitions

# Update Paperless-ngx to the latest version
update_paperless() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Updating Paperless-ngx...${RESET}"
    docker-compose -f /path/to/docker-compose.yml pull
    docker-compose -f /path/to/docker-compose.yml up -d
}

# Export settings and documents
export_files() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Exporting settings and documents...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver document_exporter ../export
}

# Import settings and documents
import_files() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Importing settings and documents...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver document_importer ../import
}

# Stop Paperless-ngx containers
stop_containers() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Stopping containers...${RESET}"
    docker-compose -f /path/to/docker-compose.yml down
}

# Start Paperless-ngx containers
restart_containers() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Starting containers...${RESET}"
    docker-compose -f /path/to/docker-compose.yml up -d
}

# Reindex all documents
reindex() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Reindexing all documents...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver manage document_index reindex
}

# Menu function
show_menu() {
    local options=("Update Paperless-ngx" "Export settings and documents" "Import settings and documents" "Stop Container" "Start Container" "Reindex all" "Exit")
    local selected=0

    while true; do
        clear
        echo -e "${WHITE_FG}${BLUE_BG}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "${WHITE_FG}${BLUE_BG}║            Paperless-ngx Commander               ║${RESET}"
        echo -e "${WHITE_FG}${BLUE_BG}╠══════════════════════════════════════════════════╣${RESET}"

        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "${WHITE_FG}${CUSTOM_GREEN}║ $((i+1)). ${options[$i]}$(printf '%*s' $((47 - ${#options[$i]})) )║${RESET}"
            else
                echo -e "${WHITE_FG}${BLUE_BG}║ $((i+1)). ${options[$i]}$(printf '%*s' $((47 - ${#options[$i]})) )║${RESET}"
            fi
        done

        echo -e "${WHITE_FG}${BLUE_BG}╚══════════════════════════════════════════════════╝${RESET}"
        echo -e "${WHITE_FG}${BLUE_BG}Use the arrow keys ↑↓ or digits to select${RESET}"

        read -sn1 key
        case "$key" in
            A) # Up arrow
                ((selected--))
                [ $selected -lt 0 ] && selected=$((${#options[@]} - 1))
                ;;
            B) # Down arrow
                ((selected++))
                [ $selected -ge ${#options[@]} ] && selected=0
                ;;
            [1-7]) # Digit input
                selected=$((key - 1))
                return $selected
                ;;
            "") # Enter
                return $selected
                ;;
        esac
    done
}

# Main loop
while true; do
    show_menu
    choice=$?

    case $choice in
        0) update_paperless ;;
        1) export_files ;;
        2) import_files ;;
        3) stop_containers ;;
        4) restart_containers ;;
        5) reindex ;;
        6) break ;;
    esac

    echo
    echo -e "${WHITE_FG}${BLUE_BG}Press any key to continue...${RESET}"
    read -n 1
done