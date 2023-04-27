# proxmox_restore
If a proxmox host is configured with a Proxmox Backup Server, this script can restore VMs from this PBS server onto the host.
Useful to run VMs in hot-standby in another datacenter where running Proxmox hosts in a shared storage cluster is not possible 
due to latency.

Tested on Proxmox Virtual Environment 7.4-3 and Proxmox Backup Server 2.4-1

# Usage
```
root@pve-2:~# ./proxmox-restore.sh 100
new volume ID is 'local-zfs:vm-100-disk-0'
restore proxmox backup image: /usr/bin/pbs-restore --repository root@pam@10.0.2.82:BackupDatastore vm/100/2023-04-27T06:51:58Z drive-scsi0.img.fidx /dev/zvol/rpool/data/vm-100-disk-0 --verbose --format raw --skip-zero
connecting to repository 'root@pam@10.0.2.82:BackupDatastore'
open block backend for target '/dev/zvol/rpool/data/vm-100-disk-0'
starting to restore snapshot 'vm/100/2023-04-27T06:51:58Z'
download and verify backup index
progress 1% (read 130023424 bytes, zeroes = 45% (58720256 bytes), duration 0 sec)
...
progress 100% (read 12884901888 bytes, zeroes = 40% (5234491392 bytes), duration 94 sec)
restore image complete (bytes=12884901888, duration=94.68s, speed=129.78MB/s)
rescan volumes...
```

