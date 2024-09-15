#!/bin/bash
### script to toggle Intel CPU Turbo Boost
### heavily modified from: http://notepad2.blogspot.com/2014/11/a-script-to-turn-off-intel-cpu-turbo.html

## sudo timeout trick
sudo-timeout

# requirement check
if [[ -z $(which rdmsr) ]]; then
    echo "msr-tools is not installed. Run 'sudo apt-get install msr-tools' to install it." >&2
    exit 1
fi

## arguments
mode=${1:-r} # default: report (r)

# register constants
register=1a0
disabled_state=4000850089
enabled_state=850089

# functions
disable_turbo() {
    core=${1}
    sudo wrmsr -p$core "0x${register}" "0x${disabled_state}"
}

enable_turbo() {
    core=${1}
    sudo wrmsr -p$core "0x${register}" "0x${enabled_state}"
}

toggle_core_turbo() {
    core=${2}

    if [[ $1 -eq $disabled_state ]]; then
        enable_turbo $core
    elif [[ $1 -eq $enabled_state ]]; then
        disable_turbo $core
    else
        echo -e "${ORANGE}Unable to toggle${NOCOLOR} Turbo Boost status for Core ${core}!"
    fi
}

# load modprobe driver


# retrieve list of processor cores
cores=$(cat /proc/cpuinfo | grep processor | awk '{print $3}')

# apply update to each core
for core in $cores; do
    # take note of current turbo state
    curr_turbo_state=$(sudo rdmsr -p"${core}" 0x${register})

    # disable, enable, or toggle state
    if [[ $mode != "report" && $mode != 3 && $mode != "r" ]]; then
        if [[ $mode == "disable" || $mode == 0 || $mode == "d" ]]; then
            disable_turbo $core
        elif [[ $mode == "enable" || $mode == 1 || $mode == "e" ]]; then
            enable_turbo $core
        elif [[ $mode == "toggle" || $mode == 2 || $mode == "t" ]]; then
            toggle_core_turbo $curr_turbo_state $core
        fi

        # verify turbo state
        new_turbo_state=$(sudo rdmsr -p$core "0x${register}" -f 38:38)
        if [[ $new_turbo_state -eq 1 ]]; then
            echo -e "${RED}Disabled${NOCOLOR} Turbo Boost for Core ${core}"
        else
            echo -e "${GREEN}Enabled${NOCOLOR} Turbo Boost for Core ${core}"
        fi
    
    # else, print report
    else
        echo -e -n "Turbo Boost Status: "
        if [[ $curr_turbo_state -eq $disabled_state ]]; then
            echo -e "${RED}Disabled${NOCOLOR}"
        elif [[ $curr_turbo_state -eq $enabled_state ]]; then
            echo -e "${GREEN}Enabled${NOCOLOR}"
        else
            echo -e "${ORANGE}Unknown${NOCOLOR}"
        fi
        echo
    fi
done
