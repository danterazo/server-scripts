#!/bin/bash
### script for daily backup cronjob (can also be run manually with `sh ~/backup.sh`)
start_time=$SECONDS

## input / arguments
plex_compression=0
while getopts 'qm:' flag; do
  case "${flag}" in
    q) plex_compression=0 ;;			# -q. flag skips 7z compression of Plex appdata for quicker backups. deprecated / redundant now
    m) plex_compression="${OPTARG}" ;;	# -m <mx level>. arg sets specific compression level
    *) exit 1 ;;
  esac
done

## common variables for all files
datetime=`date +"%Y-%m-%d_%H-%M-%S"`
backup_dir_root="/media/sg01/custom"	# og: /media/wd00/backups
backup_dir="${backup_dir_root}/snapshot_${datetime}"
working_dir_ram="/dev/shm/bkp_work"
working_dir_nvme="/tmp/bkp_work"
bar_constant=1024	# MB. for GB: $((1024 * 1024))
bar_length=80

# colors
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
yellow="\033[1;33m"
nocolor="\033[0m"

## funny goat + stop Plex
echo -e "Running backups. ${yellow}Stopping Plex...${nocolor}" | goatthink -b -W 60
sudo service plexmediaserver stop

## prep working dirs (recreate, remove residuals)
echo -e "Preparing working directories..."
mkdir -p ${backup_dir_root}
mkdir -p ${backup_dir}
mkdir -p ${working_dir_ram}
mkdir -p ${working_dir_nvme}
sudo rm -rf "${working_dir_ram}"/staralfur*
sudo rm -rf "${working_dir_nvme}"/plex*
echo -e "${green}Working directories ready!${nocolor}\n"

## ensure permissions are correct
echo "Verifying permissions..."
sudo chown -R dante:dante ${backup_dir}
sudo chmod -R 777 ${backup_dir}
sudo chown -R dante:dante ${working_dir_ram}
sudo chmod -R 777 ${working_dir_ram}
sudo chown -R dante:dante ${working_dir_nvme}
sudo chmod -R 777 ${working_dir_nvme}
echo -e "${green}Permissions verified!${nocolor}\n"

### backup installed packages
echo "Creating lists of installed packages..."
sudo dpkg --get-selections | sed "s/.*deinstall//" | sudo sed "s/install$//g" > ${backup_dir}/pkglist_${datetime}.txt
sudo dpkg-query -l | sed "s/.*deinstall//" | sudo sed "s/install$//g" > ${backup_dir}/pkglist_${datetime}_dpkg.txt
echo -e "${green}Package lists created!${nocolor}\n"

### backup plex directory. no compression because these are mostly image files
## get estimated size of plex tarball
plex_appdata_path="/var/lib/plexmediaserver"
plex_compressed_destination="${backup_dir}/plex_${datetime}_mx${plex_compression}.7z"

## if mx=0, write tarball directly to backup directory instead of working dir. else, default to latter
plex_tarball_path="${working_dir_nvme}/plex_${datetime}.tar"
if [ $plex_compression -eq 0 ]; then
   plex_tarball_path="${backup_dir}/plex_${datetime}.tar"
fi

## get estimated size of plex tarball
echo "Analyzing Plex appdata directory size..."
plex_appdata_size=`sudo du -sk --apparent-size ${plex_appdata_path} | cut -f 1`
echo -e "${green}Plex appdata directory analyzed!${nocolor}\n"

## create plex tarball + print progress bar
echo "Creating Plex tarball..."
echo -e -n "Estimated: [`printf %${bar_length}s |tr ' ' '='`] (Estimate: $((plex_appdata_size / bar_constant)) MB)\nProgress:  ["
sudo tar -c --warning="no-file-ignored" --warning="no-file-changed" --record-size=1K --checkpoint=`echo ${plex_appdata_size}/${bar_length} | bc` --checkpoint-action="ttyout=>" -cPf $plex_tarball_path $plex_appdata_path
echo -e ">] (Actual:   $((`sudo du -sk --apparent-size ${plex_tarball_path} | cut -f 1` / bar_constant)) MB)"
echo -e "${green}Plex tarball created!${nocolor}\n"

## restart Plex
echo -e "${yellow}Restarting Plex...${nocolor}"
sudo service plexmediaserver start
echo -e "${green}Plex initialized!${nocolor}\n"

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
		filesystem_size=$((filesystem_size + `sudo du -sk --exclude=/var/lib/plexmediaserver --exclude=/var/lock --exclude=/var/run --exclude=/dev/shm --apparent-size $path | cut -f 1`))
	fi
done < /home/dante/.backup_dirs
echo -e "${green}Filesystem analyzed!${nocolor}\n"

## create filesystem tarball + print progress bar
echo -e "Creating filesystem tarball..."
echo -e -n "Estimated: [`printf %${bar_length}s |tr ' ' '='`] (Estimate: $((filesystem_size / bar_constant)) MB)\nProgress:  ["
sudo tar -c --warning="no-file-ignored" --warning="no-file-changed" --record-size=1K --checkpoint=`echo ${filesystem_size}/${bar_length} | bc` --checkpoint-action="ttyout=>" -cPf ${filesystem_tarball_path} -T /home/dante/.backup_dirs
echo -e ">] (Actual:   $((`sudo du -sk --apparent-size ${filesystem_tarball_path} | cut -f 1` / bar_constant)) MB)"
echo -e "${green}Filesystem tarball created!${nocolor}\n"

### compression + wrapping up
## compress Plex tarball (if applicable) + remove tarball after compression (-sdel flag)
if [ $plex_compression -ne 0 ]; then
   echo -e "Compressing Plex tarball (${yellow}mx=${plex_compression}, LZMA2${nocolor})..."
	sudo 7z a -m0=lzma2 -mx=$plex_compression -sdel $plex_compressed_destination $plex_tarball_path
	echo -e "${green}Plex tarball compressed!${nocolor}\n"
fi

## compress filesystem tarball + remove tarball after compression (-sdel flag)
echo -e "Compressing filesystem tarball (${yellow}mx=${filesystem_compression}, LZMA2${nocolor})..."
sudo 7z a -m0=lzma2 -mx=$filesystem_compression -sdel $filesystem_compressed_destination $filesystem_tarball_path
echo -e "${green}Filesystem tarball compressed!${nocolor}\n"

## wipe working dirs
echo -e "Cleaning up residual files..."
sudo rm -rf "${working_dir_ram}"/staralfur*
sudo rm -rf "${working_dir_nvme}"/plex*
echo -e "${green}Residual files cleared!${nocolor}\n"

### funny goat again
end_time=$SECONDS
time_elapsed=$((end_time - start_time))
echo -e "Finished daily backups in ${yellow}${time_elapsed}s${nocolor}. See ya space cowboy..." | goatthink -b -W 80
