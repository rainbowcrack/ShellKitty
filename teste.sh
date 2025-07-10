#!/bin/bash

# Cores ANSI
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BLUE='\033[1;34m'
RESET='\033[0m'

# Função de animação por linha
print_line() {
  echo -e "$1"
  sleep 0.2
}

# Imprime a borda superior
print_line "${CYAN}+-----------------------------+"

# Corpo da arte com animação
print_line "${CYAN}|${MAGENTA}         /\\_/\\              ${CYAN}|"
print_line "${CYAN}|${MAGENTA}        ( o.o )             ${CYAN}|"
print_line "${CYAN}|${MAGENTA}        > ^ < ...........   ${CYAN}|"
print_line "${CYAN}|${YELLOW}    WELCOME TO ${CYAN}SHELLKITTY   ${CYAN}|"
print_line "${CYAN}|${BLUE}          ><)))º>           ${CYAN}|"

# Imprime a borda inferior
print_line "${CYAN}+-----------------------------+"

# Reset cor
echo -e "${RESET}"
