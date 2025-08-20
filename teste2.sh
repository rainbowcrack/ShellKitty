#!/bin/bash

#################
# GLOBAL ROUTES #
#################
DB_POSTGRESQL="./setups/database/setup-postgresql.sh"
DB_MARIADB="./setups/database/setup-mariadb.sh"
DB_MYSQL="./setups/database/setup-mysql.sh"

# other setups
DOCKER="./setups/docker/setup-docker.sh"
KUBERNETES="./setups/kubernetes/setup-kubernetes.sh"
MANAGERS="./setups/managers/setup-maven-spark.sh"
OS="./setups/OS/setup-os.sh"
SECURITY="./setups/security/setup-security.sh"
IA="./setups/IA/setup-ia.sh"
QA="./setups/QA/setup-qa.sh"
EYE="./setups/eyelock/config.sh"

############
# DATABASE #
############

submenu_database() {
    while true; do
        CHOICE=$(whiptail --title "Database Setup" --menu "Choose the database:" 15 60 4 \
        "1" "PostgreSQL" \
        "2" "MariaDB" \
        "3" "MySQL" \
        "0" "Back to main menu" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            break
        fi

        case $CHOICE in
            1)
                bash "$DB_POSTGRESQL"
                ;;
            2)
                bash "$DB_MARIADB"
                ;;
            3)
                bash "$DB_MYSQL"
                ;;
            0)
                break
                ;;
        esac
    done
}

#############
# MAIN MENU #
#############
main_menu() {
    while true; do
        CHOICE=$(whiptail --title "ShellKitty >^.^<" --menu "WELCOME TO SHELLKITTY ><)))º>\n\nChoose an option:" 20 70 10 \
        "1" "Database" \
        "2" "Docker" \
        "3" "Kubernetes" \
        "4" "Managers" \
        "5" "OS" \
        "6" "Security" \
        "8" "IA" \
        "9" "QA" \
        "10" "Eyelock" \
        "0" "Exit" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            exit
        fi

        case $CHOICE in
            1)
                submenu_database
                ;;
            2)
                bash "$DOCKER"
                ;;
            3)
                bash "$KUBERNETES"
                ;;
            4)
                bash "$MANAGERS"
                ;;
            5)
                bash "$OS"
                ;;
            6)
                bash "$SECURITY"
                ;;
            8)
                bash "$IA"
                ;;
            9)
                bash "$QA"
                ;;
            10)
                bash"$EYE"
                ;;
            0)
                exit
                ;;
        esac
    done
}

# start menu
main_menu
