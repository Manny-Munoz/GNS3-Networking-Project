# !/bin/bash

set -e

require_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "\e[31mRun this script as root\e[0m"
        exit 1
    fi
}

# Color echo functions
cecho() { # usage: cecho "message" "color"
    local msg="$1"
    local color="$2"
    local nc="\e[0m"
    echo -e "${color}${msg}${nc}"
}
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'