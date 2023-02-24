#!/bin/bash
### script to toggle Intel CPU Turbo Boost
### heavily modified from: http://notepad2.blogspot.com/2014/11/a-script-to-turn-off-intel-cpu-turbo.html

# bash colors
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
yellow="\033[1;33m"
nocolor="\033[0m"

# requirement check
if [[ -z $(which rdmsr) ]]; then
    echo "msr-tools is not installed. Run 'sudo apt-get install msr-tools' to install it." >&2
    exit 1
fi

# param check
mode="report"   # default
while getopts 'dert' flag; do
  case "${flag}" in
    0) mode="disable" ;;
    d) mode="disable" ;;
    1) mode="enable" ;;
    e) mode="enable" ;;
    r) mode="report" ;;
    t) mode="toggle" ;; # switches to opposite state
	*) echo -e "${red}Invalid arg.${nocolor} Printing report anyway..." && mode="report" ;;
  esac
done

# constants
register=1a0
disabled_state=4000850089
enabled_state=850089

# functions
disable_turbo () {
    sudo wrmsr -p0 "0x${register}" "0x${disabled_state}"
}

enable_turbo () {
    sudo wrmsr -p0 "0x${register}" "0x${enabled_state}"
}

toggle_core_turbo () {
    if [[ $1 -eq $disabled_state ]]; then
        enable_turbo
    elif [[ $1 -eq $enabled_state ]]; then
        disable_turbo
    else
        echo -e "${orange}Unable to toggle${nocolor} Turbo Boost status"
    fi
}

# take note of current turbo state
curr_turbo_state=`sudo rdmsr -p0 0x${register}`

# disable, enable, or toggle state
if [[ $mode != "report" ]]; then
    if [[ $mode == "disable" || $mode == 0 ]]; then
        disable_turbo
    elif [[ $mode == "enable" || $mode == 1 ]]; then
        enable_turbo
    elif [[ $mode == "toggle" ]]; then
        toggle_core_turbo "$curr_turbo_state"
    fi

    new_turbo_state=`sudo rdmsr -p0 0x${register}`
    if [[ $new_turbo_state == $disabled_state ]]; then
        echo -e "${red}Disabled${nocolor} Turbo Boost"
    elif [[ $new_turbo_state == $enabled_state ]]; then
        echo -e "${green}Enabled${nocolor} Turbo Boost"
    else
        echo -e "${orange}Unable to verify${nocolor} Turbo Boost status"
    fi
    echo
else
    echo -e -n "Turbo Boost Status: "
    if [[ $curr_turbo_state -eq $disabled_state ]]; then
        echo -e "${red}Disabled${nocolor}"
    elif [[ $curr_turbo_state -eq $enabled_state ]]; then
        echo -e "${green}Enabled${nocolor}"
    else
        echo -e "${orange}Unknown${nocolor}"
    fi
    echo
fi