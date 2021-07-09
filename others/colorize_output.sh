#!/usr/bin/env bash

#### Colorized Variables start ####
if test -t 1; then # if terminal
  ncolors=$(which tput > /dev/null && tput colors) # supports color
  if test -n "$ncolors" && test $ncolors -ge 8; then
    termcols=$(tput cols)
    bold="$(tput bold)"
    underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
  fi
fi
if [[ -t 1 ]]; then # is terminal?
  export BOLD="\e[1m";      export DIM="\e[2m";
  export RED="\e[0;31m";    export RED_BOLD="\e[1;31m";
  export YELLOW="\e[0;33m"; export YELLOW_BOLD="\e[1;33m";
  export GREEN="\e[0;32m";  export GREEN_BOLD="\e[1;32m";
  export BLUE="\e[0;34m";   export BLUE_BOLD="\e[1;34m";
  export GREY="\e[37m";     export CYAN_BOLD="\e[1;36m";
  export RESET="\e[0m";
fi

log() {       echo -e "${GREY}[~] ${@}${RESET}"; }
title() {     echo -e "${BLUE_BOLD}# ${@}${RESET}"; }
finish() {    echo -e "\n${GREEN_BOLD}# Finish!${RESET}\n"; exit 0; }
userAbort() { echo -e "\n${YELLOW_BOLD} Abort! ${RESET}\n"; exit 0; }
success() {   echo -e "${GREEN}  Success: ${@} ${RESET}"; }
warn() {      echo -e "${YELLOW_BOLD}  Warning: ${@} ${RESET}"; }
error() {     echo -e "${RED_BOLD}  Error: ${RED}$@${RESET}\n"; exit 1; }
export -f log
export -f title
export -f finish
export -f userAbort
export -f success
export -f warn
export -f error

# Usage:
#   title "hello world"
# or
#   echo -e "$RED"
#   echo xxxxxxxxxxxxx
#   echo -e "$RESET"

#### Colorized Variables end ####


