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
        clear
        echo "=============================="
        echo "        DATABASE SETUP        "
        echo "=============================="
        echo "1) PostgreSQL"
        echo "2) MariaDB"
        echo "3) MySQL"
        echo "0) Back to main menu"
        echo "------------------------------"
        read -p "Choose an option: " CHOICE

        case $CHOICE in
            1) bash "$DB_POSTGRESQL" ;;
            2) bash "$DB_MARIADB" ;;
            3) bash "$DB_MYSQL" ;;
            0) break ;;
            *) echo "Invalid option. Try again."; sleep 2 ;;
        esac
    done
}

#############
# MAIN MENU #
#############
main_menu() {
    while true; do
        clear
        

        PALETTE=(219 218 217 212 211 207 206 201 200 199)

print_gradient() {
  local i=0 n=${#PALETTE[@]}
  while IFS= read -r line; do
    printf "\e[38;5;%sm%s\e[0m\n" "${PALETTE[i]}" "$line"
    (( i=(i+1)%n ))
  done
}

clear

print_gradient <<'EOF'
       `*-.                    
        )  _`-.                 
       .  : `. .                
       : _   '  \               
       ; *` _.   `*-._               
       `-.-'          `-.             
         ;       `       `.     
         :.       .        \                  
         . \  .   :   .-'   .      
         '  `+.;  ;  '      :   
         :  '  |    ;       ;-. 
         ; '   : :`-:     _.`* ;                            
     .*' /  .*' ; .*`- +'  `*'  
      `*-*   `*-*  `*-*'        

        ******** **      ** ******** **       **       **   ** ** ********** ********** **    **
 **////// /**     /**/**///// /**      /**      /**  ** /**/////**/// /////**/// //**  ** 
/**       /**     /**/**      /**      /**      /** **  /**    /**        /**     //****  
/*********/**********/******* /**      /**      /****   /**    /**        /**      //**   
////////**/**//////**/**////  /**      /**      /**/**  /**    /**        /**       /**   
       /**/**     /**/**      /**      /**      /**//** /**    /**        /**       /**   
 ******** /**     /**/********/********/********/** //**/**    /**        /**       /**   
////////  //      // //////// //////// //////// //   // //     //         //        //    
EOF

        echo " "
        echo " "

        echo "================================================="
        echo "| ..**. *.. Developed by Rainbowcrack ... >)))º> |"
        echo "================================================="
        echo " "
        echo "1) Database"
        echo "2) Docker"
        echo "3) Kubernetes"
        echo "4) Managers"
        echo "5) OS"
        echo "6) Security"
        echo "8) AI"
        echo "9) QA"
        echo "10) Eyelock"
        echo "0) Exit"
        echo "-----------------------------------------------"
        read -p "Choose an option: " CHOICE

        case $CHOICE in
            1) submenu_database ;;
            2) bash "$DOCKER" ;;
            3) bash "$KUBERNETES" ;;
            4) bash "$MANAGERS" ;;
            5) bash "$OS" ;;
            6) bash "$SECURITY" ;;
            8) bash "$IA" ;;
            9) bash "$QA"; echo -e "\nPress ENTER to return to menu..."; read ;;
            10) bash "$EYE"; echo -e "\nPress ENTER to return to menu..."; read ;;
            0) exit ;;
            *) echo "Invalid option. Try again."; sleep 2 ;;
        esac

    done
}

# start menu
main_menu
