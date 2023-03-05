#!/bin/bash
### script to toggle Intel CPU Turbo Boost
### heavily modified from: http://notepad2.blogspot.com/2014/11/a-script-to-turn-off-intel-cpu-turbo.html

## imports
source ~/scripts/constants/bash_colors.sh

# requirement check
if [[ -z $(which rdmsr) ]]; then
    echo "msr-tools is not installed. Run 'sudo apt-get install msr-tools' to install it." >&2
    exit 1
fi

## arguments
mode=${1:-r}	# default: report (r)

# register constants
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
if [[ $mode != "report" && $mode != 3 && $mode != "r" ]]; then
    if [[ $mode == "disable" || $mode == 0 || $mode == "d" ]]; then
        disable_turbo
    elif [[ $mode == "enable" || $mode == 1 || $mode == "e" ]]; then
        enable_turbo
    elif [[ $mode == "toggle" || $mode == 2 || $mode == "t" ]]; then
        toggle_core_turbo "$curr_turbo_state"
    fi

    # verify turbo state
    new_turbo_state=`sudo rdmsr -p0 0x${register}`
    if [[ $new_turbo_state == $disabled_state ]]; then
        echo -e "${red}Disabled${nocolor} Turbo Boost"
    elif [[ $new_turbo_state == $enabled_state ]]; then
        echo -e "${green}Enabled${nocolor} Turbo Boost"
    else
        echo -e "${orange}Unable to verify${nocolor} Turbo Boost status"
    fi
    echo

# print report
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