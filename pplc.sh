#!/bin/bash

# Paperless-ngx Commander (pplc)
# This script assumes a docker-compose installation of Paperless-ngx in the "paperless-ngx" directory.
# Documents and exports are also located in this directory.
# To adapt this script to your own installation:
# 1. Change the 'paperless_dir' variable to match your Paperless-ngx installation path.
# 2. Adjust the docker-compose command if your setup differs (e.g., different service name).
# 3. Modify file paths in the script to match your directory structure if needed.

paperless_dir="/home/herby/paperless-ngx"

# Function to display the main menu
show_menu() {
    echo "Paperless-ngx Commander"
    echo "1. Start Paperless-ngx"
    echo "2. Stop Paperless-ngx"
    echo "3. Restart Paperless-ngx"
    echo "4. Check Paperless-ngx Status"
    echo "5. Export Documents"
    echo "6. Import Documents"
    echo "7. Update Paperless-ngx"
    echo "8. Exit"
}

# Main loop for user interaction
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            # Start Paperless-ngx services
            echo "Starting Paperless-ngx..."
            cd $paperless_dir && docker-compose up -d
            ;;
        2)
            # Stop Paperless-ngx services
            echo "Stopping Paperless-ngx..."
            cd $paperless_dir && docker-compose down
            ;;
        3)
            # Restart Paperless-ngx services
            echo "Restarting Paperless-ngx..."
            cd $paperless_dir && docker-compose restart
            ;;
        4)
            # Check the status of Paperless-ngx services
            echo "Checking Paperless-ngx status..."
            cd $paperless_dir && docker-compose ps
            ;;
        5)
            # Export documents from Paperless-ngx
            echo "Exporting documents..."
            cd $paperless_dir && docker-compose run --rm webserver document_exporter ../export
            echo "Export completed. Files are in the 'export' directory."
            ;;
        6)
            # Import documents into Paperless-ngx
            echo "Importing documents..."
            read -p "Enter the path to the directory containing documents to import: " import_dir
            if [ -d "$import_dir" ]; then
                cd $paperless_dir && docker-compose run --rm webserver document_importer "$import_dir"
                echo "Import completed."
            else
                echo "Error: The specified directory does not exist."
            fi
            ;;
        7)
            # Update Paperless-ngx to the latest version
            echo "Updating Paperless-ngx..."
            cd $paperless_dir
            docker-compose pull
            docker-compose up -d
            echo "Update completed."
            ;;
        8)
            # Exit the script
            echo "Exiting Paperless-ngx Commander. Goodbye!"
            exit 0
            ;;
        *)
            # Handle invalid input
            echo "Invalid option. Please try again."
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
    clear
done