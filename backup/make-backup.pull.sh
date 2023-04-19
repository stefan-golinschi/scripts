#!/bin/bash

############### GLOBAL SETTINGS ###############
#                User editable                #
################################################
ssh_host="homeserver-lan"
remote_dir="/root/homeserver"
local_temp_dir="/opt/Datastore/backups/homeserver/backup"
local_archive_basename="homeserver"
local_archive_extension="tar.xz"
archive_digest_extension="md5"
local_backup_dir="/opt/Datastore/backups/homeserver"
retention_period_days="90"
################################################

### Dynamic Settings ###
# Try not to edit here #
########################
timestamp="$(date +%d.%m.%Y.h%Hm%M)"
archive_tar_filename="${local_backup_dir}/${local_archive_basename}_${timestamp}.${local_archive_extension}"
archive_digest_filename="${local_backup_dir}/${local_archive_basename}_${timestamp}.${archive_digest_extension}"
rsync_options="--archive --partial --progress --omit-dir-times --no-perms --delete"
rsync_uri="${ssh_host}:${remote_dir}/"
#########################

# Create missing dirs
mkdir -p ${local_temp_dir}

echo "Fetching remote backup data. This may take a while..."
rsync ${rsync_options} ${rsync_uri} ${local_temp_dir}/
echo "Remote backup data transferred."

echo "Creating tar archive. This will take a while..."
tar -C ${local_temp_dir}/../ -c -I"pxz -9" -f ${archive_tar_filename} $(basename ${local_temp_dir})
echo "Archive created: ${archive_tar_filename}."

echo "tar -C ${local_temp_dir}/../ -c -I"pxz -9" -f ${archive_tar_filename} $(basename ${local_temp_dir})"
digest=$(md5sum ${archive_tar_filename})
echo $digest > $archive_digest_filename
echo "Digest: ${archive_digest_filename}"

echo "Remove files older than ${retention_period_days}"
find "${local_backup_dir}/${local_archive_basename}*" -type f -mtime +${retention_period_days} -exec rm -v {} \;
echo "Deleted all files older than ${retention_period_days} days (if any)."
