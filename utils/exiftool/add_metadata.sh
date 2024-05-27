#!/bin/bash

## description: add metadata (e.g. geolocation) to photos as EXIF/IPTC/etc. tags
## scope: current working directory
## usage: use after importing (and renaming) photos from camera to Windows using "EOS Utility"

# default arguments
city=""
state=""
country=""
verbose="false"

# translate long flags to short ones
for arg in "$@"; do
  shift

  case "$arg" in
  "--city") set -- "$@" "-c" ;;
  "--state") set -- "$@" "-s" ;;
  "--country") set -- "$@" "-o" ;;
  "--event") set -- "$@" "-e" ;;
  *) set -- "$@" "$arg" ;;
  esac
done

# process short flags
OPTIND=1
while getopts "csoe:" opt; do
  case "$opt" in
  "c")
    exiftool \
      -if "not defined $Title" \
      -if "not defined $PreservedFileName" \
      -overwrite_original_in_place \
      -fast2 \
      -preserve \
      -recurse \
      -progress:%40b \
      -progress \
      -city="$OPTARG"
    . |
      sed "s/failed condition/skipped/g"
    ;;
  "s")
    exiftool \
      -if "not defined $Title" \
      -if "not defined $PreservedFileName" \
      -overwrite_original_in_place \
      -fast2 \
      -preserve \
      -recurse \
      -progress:%40b \
      -progress \
      -state="$OPTARG"
    . |
      sed "s/failed condition/skipped/g"
    ;;
  "o")
    exiftool \
      -if "not defined $Title" \
      -if "not defined $PreservedFileName" \
      -overwrite_original_in_place \
      -fast2 \
      -preserve \
      -recurse \
      -progress:%40b \
      -progress \
      -country="$OPTARG"
    . |
      sed "s/failed condition/skipped/g"
    ;;
  "e")
    exiftool \
      -if "not defined $Title" \
      -if "not defined $PreservedFileName" \
      -overwrite_original_in_place \
      -fast2 \
      -preserve \
      -recurse \
      -progress:%40b \
      -progress \
      -event="$OPTARG"
    . |
      sed "s/failed condition/skipped/g"
    ;;
  "?")
    print_usage >&2
    exit 1
    ;;
  esac
done
