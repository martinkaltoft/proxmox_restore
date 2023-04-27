#!/bin/bash

# This script restores $VMID from PBS to this machine using the same VMID

# set the variables for the backup storage and VMID
BACKUP_STORAGE="PBS"
VMID="$1"

# Check if VMID parameter is provided
if [ -z "$VMID" ]; then
  echo "Please provide the VMID as a parameter."
  exit 1
fi

# Get the latest backup for the specified VMID
LATEST_BACKUP=$(pvesm list $BACKUP_STORAGE | grep "backup/vm/$VMID" | sort -r | head -n 1 | awk '{print $1}')

# Check if a valid backup is found
if [ -z "$LATEST_BACKUP" ]; then
  echo "No backups found for VMID $VMID."
  exit 1
fi


# Restore the latest backup to the specified VMID
qmrestore $LATEST_BACKUP $VMID

