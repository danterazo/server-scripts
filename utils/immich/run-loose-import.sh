#!/bin/bash
./immich-go upload \
-create-stacks \
-stack-burst \
-stack-jpg-raw \
-exclude-files="*.CR3" \
-exclude-files="_Resized.*" \
-time-zone="America/Chicago" \
--overwrite \
"/mnt/r/dante\Cloud Storage\Proton Drive\My files\Offload\Final Google Photos Archive"
