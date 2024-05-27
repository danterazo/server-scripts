#!/bin/bash

## description: preserve original filename as EXIF XMP data for photos, and apply additional attributes
## scope: current working directory
## usage: use after importing (and renaming) photos from camera to Windows using "EOS Utility"

# define arguments
args=(
    # "file processed?" criteria
    -if 'not defined $PreservedFileName'

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

    # preserve original filename
    '-Title<${FileName;s/\..*//}'
    '-PreservedFileName<${FileName;s/\..*//}'

    # automatically fill attribution fields across EXIF, XMP-DC, XMP-CC, and XMP-Photoshop namespaces
    -Artist="Dante Razo"
    -Copyright="© Dante Razo"
    -Creator="Dante Razo"
    -CaptionWriter="Dante Razo"
    -Credit="Dante Razo"
)

# execute in working directory + format output
exiftool "${args[@]}" . | sed 's/failed condition/skipped/g'
