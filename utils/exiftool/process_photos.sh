#!/bin/bash

## description: preserve original filename as EXIF XMP data for photos, and apply additional attributes
## scope: current working directory
## usage: use after importing (and renaming) photos from camera to Windows using "EOS Utility"

# define arguments
args=(
    # "file processed?" criteria
    -if 'not defined $XMP-xmpMM:PreservedFileName'

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
    '-XMP-dc:Title<${FileName;s/\..*//}'
    '-XMP-xmpMM:PreservedFileName<${FileName;s/\..*//}'

    # populate focal length FFE tag
    "-ExifIFD:FocalLengthIn35mmFormat<Composite:FocalLength35efl" -n

    # note: this returns warnings when run in this script, but not otherwise. ignore them.
    # offline geocoding; update location fields from GPS coordinates
    "-XMP-photoshop:XMP-iptcCore:XMP-iptcExt:Geolocate<Composite:GPSPosition"

    # automatically fill attribution fields across EXIF, XMP-DC, XMP-CC, and XMP-Photoshop namespaces
    -EXIF:Artist="Dante Razo"
    -EXIF:Copyright="© Dante Razo"
    -XMP-dc:Creator="Dante Razo"
    -XMP-cc:AttributionName="Dante Razo"
    -XMP-photoshop:CaptionWriter="Dante Razo"
    -XMP-photoshop:Credit="Dante Razo"

    # move metadata to preferred namespaces
    "-EXIF:All<IFD0:All"
    "-EXIF:All<ExifIFD:All"
)

# execute in working directory + format output
exiftool "${args[@]}" . | sed "s/failed condition/skipped/g"
