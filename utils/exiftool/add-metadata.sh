#!/bin/bash

## description: add metadata (e.g. geolocation) to photos as EXIF/IPTC/etc. tags
## scope: current working directory
## usage: use after importing (and renaming) photos from camera to Windows using "EOS Utility"

# TODO: review example and apply to script
# exiftool -xmp:iptc:geolocate="paris,fr" test.jpg

# common exiftool args
common_args=(
  # performance
  -fast2

  # scope
  -recurse

  # metadata preservation
  -preserve
  -overwrite_original_in_place

  # show progress
  -progress:%40b
  -progress
)

# translate long flags to short ones
for arg in "$@"; do
  shift

  case "$arg" in
  "--event") set -- "$@" "-e" ;;
  "--sublocation") set -- "$@" "-l" ;;
  "--city") set -- "$@" "-c" ;;
  "--state") set -- "$@" "-s" ;;
  "--country") set -- "$@" "-o" ;;
  *) set -- "$@" "$arg" ;;
  esac
done

# debugging, to remove
echo "args: $@"

# TODO: debug issues when passing arg with space; e.g. event="Aurora Borealis".

# default values
event=()
sublocation=()
city=()
state=()
country=()

# process short flags
OPTIND=1
while getopts "e: l: c: s: o:" opt; do
  case "$opt" in

  # event case
  "e")
    # case_cond=(
    #   # case-specific conditional
    #   -if 'not defined $xmp-iptcExt:Event'
    # )
    event=(
      # case-specific args
      -xmp-iptcExt:Event="$OPTARG"
    )
    ;;

  # sublocation case
  "l")
    sublocation=(
      # case-specific args
      -xmp-iptcCore:Location="$OPTARG"
    )
    ;;

  # city case
  "c")
    # case_cond=(
    #   # case-specific conditional
    #   -if 'not defined $City'
    # )
    city=(
      # case-specific args
      -City="$OPTARG"
    )
    ;;

  # state case
  "s")
    # case_cond=(
    #   # case-specific conditional
    #   -if 'not defined $State'
    # )
    state=(
      # case-specific args
      -State="$OPTARG"
    )
    ;;

  # country case
  "o")
    # case_cond=(
    #   # case-specific conditional
    #   -if 'not defined $Country'
    # )
    country=(
      # case-specific args
      -Country="$OPTARG"
    )
    ;;

  # base case
  "?")
    echo "Illegal argument: $opt = $OPTARG" >&2
    exit 1
    ;;
  esac
done

# debugging, to remove
# echo "case cond: ${case_cond[@]}"
echo "Event: ${event[@]}"
echo "Sublocation: ${sublocation[@]}"
echo "City: ${city[@]}"
echo "State: ${state[@]}"
echo "Country: ${country[@]}"
# echo "common args: ${common_args[@]}"

# execute with args in working directory + format output
# exiftool "${case_cond[@]}" "${common_args[@]}" "${case_args[@]}" . | sed "s/failed condition/skipped/g"
