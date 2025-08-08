#!/bin/bash
### script to restore Plex to last backup state

## input / arguments
plex_compression=9
while getopts 'd:m:t' flag; do
	case "${flag}" in
	d) backup_datetime="${OPTARG}" ;;  # -d <snapshot timestamp>. arg sets desired snapshot to restore from
	m) plex_compression="${OPTARG}" ;; # -m <mx level>. arg sets expected compression level for Plex 7z
	t) plex_compression=0 ;;
	*) exit 1 ;;
	esac
done

## common variables
bar_length=80
backup_dir="/media/ts/backups/snapshots"
tmp_dir="/tmp/plex_restore"

## funny goat go brrrrrr + stop Plex
goatthink -b "Welcome to Dante's Plex restore script."

## get date+time for desired backup
#read -r -p "Please enter date+time of desired backup (24hr, format: YYYY-MM-DD_HH-MM-SS): " backup_datetime

## TODO: infer compression level automatically
plex_archive_compression_level=9
plex_backup_file="plex_${backup_datetime}_mx${plex_archive_compression_level}.7z" # TODO: wildcard mx

## format into readable month, etc.
date=$(date -d $(cut -d"_" -f1 <<<${backup_datetime}) +"%B %d, %Y")
time=$(cut -d"_" -f2 <<<${backup_datetime} | sed 's/^0*//' | tr - :)

# get confirmation from user, then proceed with restore
if [[ -f "${backup_dir}/snapshot_${backup_datetime}/${plex_backup_file}" ]]; then
	echo -n -e "\n${GREEN}Backup found!${NOCOLOR} "
	read -r -p "Are you sure you want to restore the Plex snapshot from ${date} @ ${time}? (y/n) "

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		est_minutes=14

		echo -n -e "Process will take ${YELLOW}~${est_minutes}m${NOCOLOR} to finish. ${RED}DO NOT${NOCOLOR} power off the machine, quit this script, or close this session until the restore is complete. "
		read -r -p "Do you accept? (y/n) "
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "\nStarting restore...\n"
			echo "Shutting down Plex..."
			sudo service plexmediaserver stop
			echo -e "${GREEN}Plex stopped!${NOCOLOR}\n"

			## common paths
			plex_appdata_path="/var/lib/plexmediaserver/"
			plex_archive_path="${backup_dir}/snapshot_${backup_datetime}/${plex_backup_file}"
			plex_tarball_path="${tmp_dir}/plex_${backup_datetime}.tar"

			## TODO: differentiate between 7z and tar

			## uncompress Plex 7z archive -> tarball
			echo -e "Extracting Plex backup..."
			7z x $plex_archive_path -o${tmp_dir}
			echo -e "\n${GREEN}Backup extracted!${NOCOLOR}\n"

			## get size of Plex tarball
			plex_tarball_size=$(du -sk --apparent-size $plex_tarball_path | cut -f 1)

			## wipe Plex appdata directory
			echo "Wiping Plex appdata directory..."
			sudo rm -rf ${plex_appdata_path}*
			echo -e "${GREEN}Plex appdata directory successfully wiped!${NOCOLOR}\n"

			## progress bar for Plex tarball creation
			echo "Restoring Plex backup..."
			bar_constant=$((1024 * 1024))
			echo -e -n "Source:  [$(printf %${bar_length}s | tr ' ' '=')] (Size: $((plex_tarball_size / bar_constant)) GB)\nRestore: ["
			sudo tar --record-size=1K --checkpoint=$(echo ${plex_tarball_size}/${bar_length} | bc) --checkpoint-action="ttyout=>" -xPf $plex_tarball_path $plex_appdata_path
			restore_size=$(sudo du -sk --apparent-size ${plex_appdata_path} | cut -f 1)
			echo -e "] (Written: $((restore_size / bar_constant)) GB)\n"
			echo -e "${GREEN}Successfully restored backup! ${NOCOLOR}\n"

			## change ownership of Plex appdata folder
			echo "Modifying ownership of Plex appdata directory..."
			sudo chown -R plex:plex /var/lib/plexmediaserver
			echo -e "${GREEN}Ownership restored!${NOCOLOR}\n"

			## remove residual files from previous installation
			echo "Removing cache database files from last backup..."
			sudo rm -f ${plex_appdata_path}/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/*.db-shm
			sudo rm -f ${plex_appdata_path}/Plug-in\ Support/Databases/*.db-wal
			echo -e "${GREEN}Removed old database cache!${NOCOLOR}\n"

			## wipe working dir
			echo "Cleaning up residual files from working directory..."
			sudo rm -rf ${tmp_dir}/plex*
			echo -e "${GREEN}Residual files cleared!${NOCOLOR}\n"

			goatthink -b -W 60 "Restore complete. Restarting Plex..."
			sudo service plexmediaserver start
			exit
		fi
	else
		goatthink -b "Alright then. Restarting Plex..."
		sudo service plexmediaserver start
		exit
	fi
else
	echo -e "\n${RED}Backup not found.${NOCOLOR} Listing available backups below:"
	sudo find ${backup_dir} -name 'plex*.*'
	echo -e "\nPlease ${YELLOW}rerun${NOCOLOR} the script and enter a valid backup. Exiting..." | goatthink -b -W 60
	exit
fi
