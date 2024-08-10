# source machine-specific bashrc code
source /home/dante/scripts/config/$(hostname)/bashrc.sh

# rust
. "$HOME/.cargo/env"

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# poetry / pipx
export PATH="$PATH:/home/dante/.local/bin"

# python dev for pyenv, specifically tkinter
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
export PATH=$PATH:/usr/local/opt/tcl-tk/bin

# ble.sh. Enables right-hand-side prints, enhanced autocompletions, and more
#source ~/.local/share/blesh/ble.sh

# change default starship config path
export STARSHIP_CONFIG="/home/dante/.config/starship/starship.toml"

# golang
export PATH=$PATH:/usr/local/go/bin

# qmk
export QMK_HOME="/home/dante/projects/qmk/firmware"
