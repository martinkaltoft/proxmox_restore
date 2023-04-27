#!/bin/bash

# This script shuts down the VM with $VMID, 
# destroys the VM and restores from the backup 
# repository $BACKUP_STORAGE

# Set the variables for the backup storage and VMID
BACKUP_STORAGE="PBS"
VMID="$1"

# Check if VMID parameter is provided
if [ -z "$VMID" ]; then
  echo "Please provide the VMID as a parameter."
  exit 1
fi

# Function to shut down the VM
shutdown_vm() {
    MAX_RETRIES=3
    retries=0

    # Attempt to gracefully shutdown the VM
    while [[ $retries -lt $MAX_RETRIES ]]; do
        qm shutdown "$VMID"
        echo "Shutting down VM $VMID..."

        # Wait for the VM to stop
        while qm status "$VMID" | grep -q "status: running"; do
            sleep 1
        done

        if ! qm status "$VMID" | grep -q "status: running"; then
            echo "VM $VMID has stopped."
            return 0
        fi

        echo "Shutdown attempt timed out. Retrying..."
        retries=$((retries + 1))
    done

    echo "Failed to gracefully shutdown VM $VMID after $MAX_RETRIES attempts."
    # If the VM cannot be shut down gracefully after $MAX_RETRIES attempts, kill it
    qm stop "$VMID"
    return 1
}

destroy_vm() {
    qm destroy "$VMID"
    echo "Deleting VM $VMID..."
}

restore_vm() {
	# Get the latest backup for the specified VMID
	LATEST_BACKUP=$(pvesm list $BACKUP_STORAGE | grep "backup/vm/$VMID" | sort -r | head -n 1 | awk '{print $1}')

	# Check if a valid backup is found
	if [ -z "$LATEST_BACKUP" ]; then
	  echo "No backups found for VMID $VMID."
	  exit 1
	fi

	shutdown_vm "$VMID"
	destroy_vm "$VMID"

	# restore the latest backup to the specified VMID
	qmrestore $LATEST_BACKUP $VMID
}

start_vm() {
    qm start "$VMID"
    echo "Starting VM $VMID..."
}


restore_vm "$VMID"
start_vm "$VMID"
