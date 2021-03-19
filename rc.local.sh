#!/usr/bin/env bash
# Author: Jan Christoph Uhde (2021)

# Variables that control this script ##########################################

rcl_noatime_volumes="1 2"

# Variables that control this script - END ####################################


## helper
rcl_error() {
    echo "ERROR (rc.local): $*"
}

## functions
remount_noatime() {
    # remount volumes noatime
    for rcl_i in $rcl_noatime_volumes; do
        rcl_mount_point="/volume$rcl_i"
        if [ -d "$rcl_mount_point" ]; then
            mount -o remount,noatime "$rcl_mount_point" || rcl_error "failed to remount $rcl_mount_point noatime"
        fi
    done
}

## main (calling the functions)
remount_noatime
