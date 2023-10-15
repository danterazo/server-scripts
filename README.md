# README
## About
This is a set of _very_ specific scripts for my personal servers, dubbed "[Starálfur](https://www.youtube.com/watch?v=7fEUUnXDnbk)" (NAS, Plex) and "[Sæglópur](https://www.youtube.com/watch?v=TFHCWZh0_Co)" (VPN, DNS Sinkhole, Seedbox). I'm hosting them here for versioning.

## Features
### Backups & Restoration
- `backup.sh`
  - Backup directories of interest as `tar` files or compressed `.7z` archives
  - Configurable compression level
  - Automated daily runs with `cron`
  - Downtime is minimized to mere minutes by first copying directories then working on said copies
  - Only one param (compression level). The script takes care of the rest
    - e.g. `backup 9` for max compression (7z mx=9)
  - Temporarily reenables Intel's Turbo Boost (see `toggle_turbo_boost.sh` below) for faster compression
- `restore_plex.sh`
  - Restore [Plex Media Server](https://support.plex.tv/articles/200288286-what-is-plex/) config from a timestamped snapshot
  - Stops PMS service, deletes current PMS appdata directory, writes snapshot to it, restores permissions, removes instance-specific cache files, then restarts PMS
  - Only one param (datetime / snapshot name) required

### Hardware Scripts
- `bad_blocks.sh`
  - Script to detect bad blocks on given storage device
    - Optional param: `drive`
    - If no params are given, the script will list attached storage devices and prompt the user to enter a device name
    - No need to include `/dev/` in the name for either parameter. Just use the storage device or partition name (e.g. `sda`)
- `bench.sh`
  - Benchmarks attached storage devices
  - Optional param: `drive`
    - If no params are given, the script will list attached storage devices and prompt the user to enter a device name
    - No need to include `/dev/` in the name for either parameter. Just use the storage device or partition name (e.g. `sda`)
- `hdd_smart.sh`
  - Script to query [SMART](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology) data for given storage device
    - Optional param: `drive`
    - If no params are given, the script will list attached storage devices and prompt the user to enter a device name
    - No need to include `/dev/` in the name for either parameter. Just use the storage device or partition name (e.g. `sda`)
- `temps.sh`
  - Shows formatted temperature data for CPU and attached storage devices
  - No params
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
- `install_mergerfs.sh`
  - Installs MergerFS prereqs, clones Git repo, builds, installs, then cleans residual files
- `install_plex.sh`
  - Retrieves specified (hardcoded) Plex Media Server executable, installs it, enables service, verifies service status, then removes executable

### Plex
- `force_loudness`
  - Forces a full "loudness analysis" scan on Plex's music library. CPU intensive!!
  - Note on logs: Loudness jobs don't show in the UI, so consider enabling logs
  - Defaults: normal scan, show logs
  - Scan flags
    - `-f`: kick off _forced_ deep analysis scan
    - `-s`: kick off _normal_ deep analysis scan (no `--forced` flag). Redundant since default is "normal scan"
  - Logging flags
    - `-v`: show logs ("v" for verbose). Redundant since default is "true"
    - `-q`: hide logs ("q" for quiet)
  - Shortcut flags
    - `-l`: show logs without starting a scan. Useful if SSH session times out. "l" for logs
  - Examples
    - `sh force_loudness.sh`: kick off normal scan and show logs
    - `sh force_loudness.sh -sv`: same as above
    - `sh force_loudness.sh -fq`: kick off forced deep analysis scan but hide logs
    - `sh force_loudness.sh -f`: kick off forced deep analysis scan and show logs
    - `sh force_loudness.sh -fv`: same as above

### Fun Scripts
- `local_weather.sh` (alias: `lweather`)
  - Used primarily in my Message of the Day (MOTD). Prints a concise weather report for Bloomington, IN (ICAO: KBMG)
  - Optional verbose (`v`) flag to return slightly longer weather report

### Constants
- `bash_formatting.sh`
  - Contains color and style codes for use in prints
  - Example color usage: `${yellow}Example${nocolor}`
  - Example format usage: `${underline}Example${noformat}`

## TODO
- Fan control scripts (in `hardware/`) with `lm-sensors`
