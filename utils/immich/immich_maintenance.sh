#!/bin/bash
# constants
IMMICH_SCRIPT_PATH="/self-hosted/immich/scripts"

# retrieve secrets from host
ADMIN_API_KEY=$(sudo cat /home/dante/.creds/immich/immich-maintenance-admin-api-key)
USER_API_KEY=$(sudo cat /home/dante/.creds/immich/immich-maintenance-user-api-key)
IMMICH_ADDR=$(sudo cat /home/dante/.creds/immich/immich-address)

# run script to delete offline/orphaned files (fully automated, no prompts)
# script source: https://github.com/Thoroslives/immich_remove_offline_files
"${IMMICH_SCRIPT_PATH}/immich-py3/bin/python3" "${IMMICH_SCRIPT_PATH}/immich_remove_offline_files.py" \
--no_prompt \
--admin_apikey "${ADMIN_API_KEY}" \
--user_apikey "${USER_API_KEY}" \
--immichaddress "${IMMICH_ADDR}"

# pad operation output
echo

# delete untracked files from immich export
UNTRACKED_FILE_EXPORT="untracked.txt"
UNTRACKED_FILE_COUNT=$(sed -n "$=" ${UNTRACKED_FILE_EXPORT})
CURRENT_LINE=1
while IFS="" read -r p || [ -n "$p" ]
do
    # identify path
    OLD_PATH="${p}"

    # translate path from Docker to host machine
    DOCKER_PHOTOS_ROOT="/usr/src/app/upload/"
    HOST_PHOTOS_ROOT="/self-hosted/immich/photos/"
    NEW_PATH=$(echo "${OLD_PATH}" | sed "s#${DOCKER_PHOTOS_ROOT}#${HOST_PHOTOS_ROOT}#")

    # delete file
    echo -e "Deleting file (${CURRENT_LINE}/${UNTRACKED_FILE_COUNT}): ${NEW_PATH}"

    if rm -rf ${NEW_PATH}; then
        # remove deleted file from export
        echo -e "Successfully deleted file! Removing from export...\n"
        sed -i "1d" "${UNTRACKED_FILE_EXPORT}"

        # increment accumulator
        CURRENT_LINE=$(expr ${CURRENT_LINE} + 1)
    else
        echo -e "[${RED}]${BOLD}Unable to delete file! Exiting.${NC}\n"
        exit 1
    fi
    
done < ${UNTRACKED_FILE_EXPORT}
