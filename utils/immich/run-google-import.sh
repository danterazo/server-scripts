#!/bin/bash
#./immich-go
immich-go upload from-google-photos \
--server $IMMICH_GO_SERVER \
--api-key $IMMICH_GO_API_KEY \
--manage-raw-jpeg=StackCoverJPG \
--manage-heic-jpeg=StackCoverJPG \
--manage-burst=stack \
--include-unmatched \
--include-untitled-albums \
--include-archived \
--exclude-extensions="CR3" \
--overwrite \
--time-zone="America/Indiana/Indianapolis" \
"/mnt/h/Temp M2/Takeout - 2022-03-29 - Complete, No YT Music/Google Photos/"
