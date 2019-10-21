#!/bin/bash
set -e
dev=$(readlink -f /dev/disk/by-path/*guest-docker* | head -n1)

if [[ -n "${dev}" ]]
then
    if ! egrep -q "^${dev} " /proc/mounts
    then
        mkfs.xfs -L guest-docker "${dev}"
        mkdir -p /var/lib/docker
        fstab_line="LABEL=guest-docker /var/lib/docker xfs defaults,auto,_netdev 0 0 "
        grep -qF "${fstab_line}" /etc/fstab || echo "${fstab_line}" >> /etc/fstab
        systemctl daemon-reload
        mount -a
    fi
fi
