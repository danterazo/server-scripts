# source machine-specific profile code
source /home/dante/scripts/config/$(hostname)/profile.sh
. "$HOME/.cargo/env"

# >>> JVM installed by coursier >>>
export JAVA_HOME="/home/dante/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.23%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.23_9.tar.gz/jdk-11.0.23+9"
export PATH="$PATH:/home/dante/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.23%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.23_9.tar.gz/jdk-11.0.23+9/bin"
# <<< JVM installed by coursier <<<

# >>> coursier install directory >>>
export PATH="$PATH:/home/dante/.local/share/coursier/bin"
# <<< coursier install directory <<<

# Created by `pipx` on 2024-07-08 11:42:54
export PATH="$PATH:/home/dante/.local/bin"
