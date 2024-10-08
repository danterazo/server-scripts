#!/bin/bash
### script for daily backup cronjob (can also be run manually with `backup <mx>`)
start_time=$SECONDS

## input / arguments
plex_compression=${1:-9} # default: 9 (max compression)

## common variables
datetime=$(date +"%Y-%m-%d_%H-%M-%S")
working_dir_nvme="/media/ssd-pool/cache/bkp_work"   # og: /tmp/bkp_work
backup_dir_root="/media/hdd-pool/app-data/plex/backups/snapshots" # og: /media/wd00/backups
backup_dir="${backup_dir_root}/snapshot_${datetime}"
working_dir_ram="/dev/shm/bkp_work"
bar_constant=1024 # MB. for GB: $((1024 * 1024))
bar_length=80

## sudo timeout trick
sudo-timeout

## funny goat go brrrrr + stop Plex
if [ $plex_compression -eq 0 ]; then
	echo -e "Running backups (tar mode). ${YELLOW}Stopping Plex...${NOCOLOR}" | goatthink -b -W 80
else
	echo -e "Running backups (${ORANGE}mx=${plex_compression}${NOCOLOR}). ${YELLOW}Stopping Plex...${NOCOLOR}" | goatthink -b -W 80
fi
sudo service plexmediaserver stop

## prep working dirs (recreate, remove residuals)
echo -e "Preparing working directories..."
sudo mkdir -p ${backup_dir_root}
sudo mkdir -p ${backup_dir}
sudo mkdir -p ${working_dir_ram}
sudo mkdir -p ${working_dir_nvme}
sudo rm -rf "${working_dir_ram}"/staralfur*
sudo rm -rf "${working_dir_nvme}"/plex*
echo -e "${GREEN}Working directories ready!${NOCOLOR}\n"

## ensure permissions are correct
echo "Verifying permissions..."
sudo chown -R dante:dante ${backup_dir}
sudo chmod -R 777 ${backup_dir}
sudo chown -R dante:dante ${working_dir_ram}
sudo chmod -R 777 ${working_dir_ram}
sudo chown -R dante:dante ${working_dir_nvme}
sudo chmod -R 777 ${working_dir_nvme}
echo -e "${GREEN}Permissions verified!${NOCOLOR}\n"

### backup installed packages
echo "Creating lists of installed packages..."
sudo dpkg --get-selections | sed "s/.*deinstall//" | sudo sed "s/install$//g" >${backup_dir}/pkglist_${datetime}.txt
sudo dpkg-query -l | sed "s/.*deinstall//" | sudo sed "s/install$//g" >${backup_dir}/pkglist_${datetime}_dpkg.txt
echo -e "${GREEN}Package lists created!${NOCOLOR}\n"

### backup plex directory. no compression by default since these are mostly images
plex_appdata_path="/self-hosted/plex/plexmediaserver"
plex_cache_path="/self-hosted/plex/plexmediaserver/Library/Application Support/Plex Media Server/Cache" # TODO: deprecate
plex_compressed_destination="${backup_dir}/plex_${datetime}_mx${plex_compression}.7z"

## if mx=0, write tarball directly to backup directory instead of working dir. else, default to latter
plex_tarball_path="${working_dir_nvme}/plex_${datetime}.tar"
if [ $plex_compression -eq 0 ]; then
	plex_tarball_path="${backup_dir}/plex_${datetime}.tar"
fi

## enable Intel turbo boost temporarily
echo -e "Enabling Intel Turbo Boost..."
turbo enable

## get estimated size of plex tarball
echo "Analyzing Plex appdata directory size..."
plex_appdata_size=$(sudo du -sk --exclude="Cache" --apparent-size ${plex_appdata_path} | cut -f 1)
echo -e "${GREEN}Plex appdata directory analyzed!${NOCOLOR}\n"

## create plex tarball + print progress bar
echo "Creating Plex tarball..."
echo -e -n "Estimated: [$(printf %${bar_length}s | tr ' ' '=')] (Estimate: $((plex_appdata_size / bar_constant)) MB)\nProgress:  ["
sudo tar -c --warning="no-file-ignored" --warning="no-file-changed" --record-size=1K --checkpoint=$(echo ${plex_appdata_size}/${bar_length} | bc) --checkpoint-action="ttyout=>" --exclude "Application\ Support/Plex\ Media\ Server/Cache" -cPf $plex_tarball_path $plex_appdata_path
actual_plex_size=$(sudo du -sk --apparent-size ${plex_tarball_path} | cut -f 1)
echo -e ">] (Actual:   $((actual_plex_size / bar_constant)) MB)"
echo -e "${GREEN}Plex tarball created!${NOCOLOR}\n"

## restart Plex
echo -e "${YELLOW}Restarting Plex...${NOCOLOR}"
sudo service plexmediaserver start
echo -e "${GREEN}Plex initialized!${NOCOLOR}\n"

### backup filesystem
## variables for easy modification
filesystem_compression=9
filesystem_tarball_path="${working_dir_ram}/staralfur_${datetime}.tar"
filesystem_compressed_destination="${backup_dir}/staralfur_${datetime}_mx${filesystem_compression}.7z"

## get estimated size of filesystem tarball
echo "Analyzing filesystem size..."
filesystem_size=0
while IFS= read -r path; do
	if ! [[ $path == "--exclude"* ]]; then
		filesystem_size=$((filesystem_size + $(sudo du -sk --exclude=/var/lib/plexmediaserver --exclude=/var/lock --exclude=/var/run --apparent-size $path | cut -f 1)))
	fi
done </home/dante/.backup_dirs
echo -e "${GREEN}Filesystem analyzed!${NOCOLOR}\n"

## create filesystem tarball + print progress bar
echo -e "Creating filesystem tarball..."
echo -e -n "Estimated: [$(printf %${bar_length}s | tr ' ' '=')] (Estimate: $((filesystem_size / bar_constant)) MB)\nProgress:  ["
sudo tar -c --warning="no-file-ignored" --warning="no-file-changed" --record-size=1K --checkpoint=$(echo ${filesystem_size}/${bar_length} | bc) --checkpoint-action="ttyout=>" -cPf ${filesystem_tarball_path} -T /home/dante/.backup_dirs
actual_filesystem_size=$(sudo du -sk --apparent-size ${filesystem_tarball_path} | cut -f 1)
echo -e ">] (Actual:   $((actual_filesystem_size / bar_constant)) MB)"
echo -e "${GREEN}Filesystem tarball created!${NOCOLOR}\n"

### compression + wrapping up
## compress filesystem tarball + remove tarball after compression (-sdel flag)
echo -e -n "Compressing filesystem tarball (${YELLOW}mx=${filesystem_compression}, LZMA2${NOCOLOR})..."
sudo 7z a -m0=lzma2 -mx=$filesystem_compression -sdel $filesystem_compressed_destination $filesystem_tarball_path
echo -e "${GREEN}Filesystem tarball compressed!${NOCOLOR}\n"

## compress Plex tarball (if applicable) + remove tarball after compression (-sdel flag)
if [ $plex_compression -ne 0 ]; then
	echo -e -n "Compressing Plex tarball (${YELLOW}mx=${plex_compression}, LZMA2${NOCOLOR})..."
	sudo 7z a -m0=lzma2 -mx=$plex_compression -sdel $plex_compressed_destination $plex_tarball_path
	echo -e "${GREEN}Plex tarball compressed!${NOCOLOR}\n"
fi

## disable Intel turbo boost
echo -e "Disabling Intel Turbo Boost..."
turbo disable

## wipe working dirs
echo -e "Cleaning up residual files..."
sudo rm -rf "${working_dir_ram}"/staralfur*
sudo rm -rf "${working_dir_nvme}"/plex*
echo -e "${GREEN}Residual files cleared!${NOCOLOR}\n"

### funny goat go brrrrrr again
end_time=$SECONDS
time_elapsed=$((end_time - start_time))
echo -e "Finished daily backups in ${YELLOW}${time_elapsed}s${NOCOLOR}. See ya space cowboy..." | goatthink -b -W 80
