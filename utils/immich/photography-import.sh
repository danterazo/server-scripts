#!/bin/bash

# define source dir
SRC="/mnt/r/dante/My Pictures/Photography/Canon R50"

# process EXIF data
#exif-proc "$SRC"

# import to immich
./immich-go upload \
-create-stacks \
-stack-burst \
-stack-jpg-raw \
-exclude-files="*.CR3" \
"$SRC"
