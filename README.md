# README
## About
This is a set of _very_ specific scripts for my personal servers, dubbed "[Starálfur](https://www.youtube.com/watch?v=7fEUUnXDnbk)" (NAS, Plex) and "[Sæglópur](https://www.youtube.com/watch?v=TFHCWZh0_Co)" (VPN, Seedbox). I'm hosting them here for versioning.

## Features
### Backups & Restoration
- `backup.sh`
  - Backup directories of interest as `tar` files or compressed `.7z` archives
  - Configurable compression level
  - Automated daily runs with `cron`
  - Downtime is minimized to mere minutes by first copying directories then working on said copies
  - Only one param (compression level). The script takes care of the rest
    - e.g. `backup 9` for max compression (7z mx=9)
  - Temporarily reenables Intel's Turbo Boost (see `toggle_turbo_boost.sh` below) for speedier (?) compression
- `restore_plex.sh`
  - Restore [Plex Media Server](https://support.plex.tv/articles/200288286-what-is-plex/) config from a timestamped snapshot
  - Stops PMS service, deletes current PMS appdata directory, writes snapshot to it, restores permissions, removes instance-specific cache files, then restarts PMS
  - Only one param (datetime / snapshot name)

### Hardware Configuration
- `bench.sh`
  - Benchmarks attached storage devices
  - Optional param: `drive`
    - If no params are given, the script will list attached storage devices and prompt the user to enter a name
    - No need to include `/dev/` in the name for either parameter. Just use the storage device or partition name (e.g. `sdc1`)
- `toggle_turbo_boost.sh`
  - Enables, disables, or toggles Intel's Turbo Boost tech to reduce wattage
    - I got a good deal on a K-series i5 chip, but this is a server and it doesn't need high clocks
  - Automatically toggles off with `cron` with each reboot
  - Optional param: `desired_state`
    - Disable: `turbo disable` / `turbo d` / `turbo 0`
    - Enable: `turbo enable` / `turbo e`, `turbo 1`
    - Toggle: `turbo toggle` / `turbo t` / `turbo 2`
    - Report: `turbo report` / `turbo r`, `turbo 3`
    - If no params are given, the script reports the current turbo boost status

### Installation Scripts
- `install_plex.sh`
  - Retrieves specified (hardcoded) Plex Media Server executable, installs it, enables service, verifies service status, then removes executable

### Fun Scripts
- `local_weather.sh` (alias: `lweather`)
  - Used primarily in my Message of the Day (MOTD). Prints a concise weather report for Bloomington, IN (ICAO: KBMG)
  - Optional verbose (`v`) flag to return slightly longer weather report

### Constants
- `bash_colors.sh`
  - Contains color codes for use in prints
  - Example usage: `${yellow}Example${nocolor}`
- `bash_formats.sh`
  - Contains style codes for use in prints
  - Example usage: `${underline}Example${noformat}`

## TODO
- Fan control scripts (in `hardware/`) with `lm-sensors`
