#!/bin/bash

# Bash-Script für Paperless-ngx Auswahlmenü

# Farbdefinitionen
BLUE_BG='\033[44m'
WHITE_FG='\033[97m'
CUSTOM_GREEN='\033[48;2;92;128;132m'
RESET='\033[0m'

# Funktionsdefinitionen
update_paperless() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Updating Paperless-ngx...${RESET}"
    docker-compose -f /path/to/docker-compose.yml pull
    docker-compose -f /path/to/docker-compose.yml up -d
}

export_files() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Exporting files...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver document_exporter ../export
}

import_files() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Importing files...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver document_importer ../import
}

stop_containers() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Stopping containers...${RESET}"
    docker-compose -f /path/to/docker-compose.yml down
}

restart_containers() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Restarting containers...${RESET}"
    docker-compose -f /path/to/docker-compose.yml up -d
}

reindex() {
    echo -e "${WHITE_FG}${CUSTOM_GREEN}Reindexing...${RESET}"
    docker-compose -f /path/to/docker-compose.yml run --rm webserver manage document_index reindex
}

# Menü-Funktion
show_menu() {
    local options=("Update Paperless-ngx" "Export settings and documents" "Import settings and documents" "Stop Container" "Start Container" "Reindex all" "Exit")
    local selected=0

    while true; do
        clear
        echo -e "${WHITE_FG}${BLUE_BG}╔══════════════════════════════════════════════════╗${RESET}"
        echo -e "${WHITE_FG}${BLUE_BG}║            Paperless-ngx Commander                ║${RESET}"
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
            A) # Pfeil nach oben
                ((selected--))
                [ $selected -lt 0 ] && selected=$((${#options[@]} - 1))
                ;;
            B) # Pfeil nach unten
                ((selected++))
                [ $selected -ge ${#options[@]} ] && selected=0
                ;;
            [1-7]) # Zifferneingabe
                selected=$((key - 1))
                return $selected
                ;;
            "") # Enter
                return $selected
                ;;
        esac
    done
}

# Hauptschleife
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
    echo -e "${WHITE_FG}${BLUE_BG}Drücken Sie eine Taste, um fortzufahren...${RESET}"
    read -n 1
done
