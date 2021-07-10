#!/bin/bash
# heavily modified from: http://notepad2.blogspot.com/2014/11/a-script-to-turn-off-intel-cpu-turbo.html

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
    d) echo -e "\n${yellow}Disable${nocolor} Turbo Boost:" &&mode="disable" ;;
    e) echo -e "\n${yellow}Enable${nocolor} Turbo Boost:" && mode="enable" ;;
    r) echo -e "\n${orange}Turbo Boost Report${nocolor}:" &&mode="report" ;;
    t) echo -e "\n${yellow}Toggle${nocolor} Turbo Boost:" && mode="toggle" ;; # switches to opposite state
	*) echo -e "\n${red}Invalid arg.${nocolor} Printing report anyway:" && mode="report" ;;
  esac
done

# constants
register=1a0
disabled_state=4000850089
enabled_state=850089

# functions
disable_core_turbo () {
    sudo wrmsr -p$1 "0x${register}" "0x${disabled_state}"
}

enable_core_turbo () {
    sudo wrmsr -p$1 "0x${register}" "0x${enabled_state}"
}

toggle_core_turbo () {
    if [[ $3 -eq $disabled_state ]]; then
        echo -e "state before: `sudo rdmsr -p$1 0x${register}`" # TODO: remove
        enable_core_turbo $1
        echo -e "state after: `sudo rdmsr -p$1 0x${register}`"  # TODO: remove
    elif [[ $3 -eq $enabled_state ]]; then
        disable_core_turbo $1
    else
        echo -e "${orange}Unable to toggle${nocolor} Core $2 Turbo Boost status"
    fi
}

cores=$(cat /proc/cpuinfo | grep processor | awk '{print $3}')
for core in $cores; do
    # format (pad) core name if necessary
    if [ $core -lt 10 ]; then
        core_formatted="0${core}"
    else
        core_formatted=$core
    fi

    # take note of current core state
    curr_core_state=`sudo rdmsr -p${core} 0x${register}`

    # disable, enable, or toggle state
    if [[ $mode != "report" ]]; then
        if [[ $mode == "disable" ]]; then
            disable_core_turbo "$core"
        elif [[ $mode == "enable" ]]; then
            enable_core_turbo "$core"
        elif [[ $mode == "toggle" ]]; then
            toggle_core_turbo "$core" "$core_formatted" "$curr_core_state"
        fi

        new_core_state=`sudo rdmsr -p${core} 0x${register}`
        if [[ $new_core_state == $disabled_state ]]; then
            echo -e "${red}Disabled${nocolor} Core ${core_formatted} Turbo Boost"
        elif [[ $new_core_state == $enabled_state ]]; then
            echo -e "${green}Enabled${nocolor} Core ${core_formatted} Turbo Boost"
        else
            echo -e "${orange}Unable to verify${nocolor} Core ${core_formatted} Turbo Boost status"
        fi
    else
        if [ $curr_core_state -eq $disabled_state ]; then
            echo -e "Core ${core_formatted} Turbo Boost Status: ${red}Disabled${nocolor}"
        elif [ $curr_core_state -eq $enabled_state ]; then
            echo -e "Core ${core_formatted} Turbo Boost Status: ${green}Enabled${nocolor}"
        else
            echo -e "Core ${core_formatted} Turbo Boost Status: ${orange}Unknown${nocolor}"
        fi
    fi
done
