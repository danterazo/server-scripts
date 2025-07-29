#!/bin/bash
./immich-go upload \
-create-stacks \
-create-album-folder \
-stack-burst \
-stack-jpg-raw \
-exclude-files="*.CR3" \
-exclude-files="*_Resized.*" \
-time-zone="America/Indiana/Indianapolis" \
"/mnt/r/Temp/Google Photos - Shared Albums/*.zip"
