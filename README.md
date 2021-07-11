# README
## About
This is a set of _very_ specific scripts for my personal NAS, dubbed "[Starálfur](https://www.youtube.com/watch?v=7fEUUnXDnbk)". I hosted them here for versioning.

## Features
### Backups & Restoration
- `backup.sh`
  - Backup directories of interest as `tar` files or compressed `.7z` archives
  - Configurable compression level
  - Automated daily runs with `cron`
  - Downtime is minimized to mere minutes by first copying directories then working on said copies
  - Only one param (compression level). The script takes care of the rest
  - Temporarily reenables Intel's Turbo Boost (see `toggle_turbo_boost.sh` below) for speedier (?) compression
- `restore_plex.sh`
  - Restore [Plex Media Server](https://support.plex.tv/articles/200288286-what-is-plex/) config from a timestamped snapshot
  - Stops PMS service, deletes current PMS appdata directory, writes snapshot to it, restores permissions, removes instance-specific cache files, then restarts PMS
  - Only one param (datetime / snapshot name)

### Hardware Configuration
- `toggle_turbo_boost.sh`
  - Enables, disables, or toggles Intel's Turbo Boost tech to reduce wattage
    - I got a good deal on a K-series i5 chip, but this is a server and it doesn't need high clocks
  - Automatically toggles off with `cron` with each reboot
  - Optional param: `desired_state`
    - If no params are given, the script reports the current turbo boost status

### Installation Scripts
- `install_plex.sh`
  - Retrieves specified (hardcoded) Plex Media Server executable, installs it, enables service, verifies service status, then removes executable

### Fun Scripts
- `local_weather.sh` (alias: `lweather`)
  - Used primarily in my Message of the Day (MOTD). Prints a concise weather report for Bloomington, IN (ICAO: KBMG)
  - Optional verbose (`v`) flag to return slightly longer weather report

## TODO
- Fan control scripts (in `hardware/`) with `lm-sensors`
