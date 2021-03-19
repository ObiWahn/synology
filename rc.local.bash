#!/usr/bin/env bash
# Author: Jan Christoph Uhde (2021)

# Variables that control this script ##########################################

rcl_last_volume=10
#rcl_noatime_skip_volumes=( 2 3 ) # for this volumes noatime will no not be set

# Variables that control this script - END ####################################
set -uo pipefail

if ! [[ -v rcl_noatime_skip_volumes ]]; then
    rcl_noatime_skip_volumes=( none )
fi
echo "volumes to skip: ${rcl_noatime_skip_volumes[@]}"

## helper
rcl_error() {
    echo "ERROR (rc.local): $*"
}

in_list() {
    # Associative arrays would be more efficient
    # but the variables would look less nice.

    local to_find="$1"
    shift
    local e
    for e in "$@"; do
        [[ "$e" == "$to_find" ]] && return 0
    done
    return 1
}

## functions
remount_noatime() {
    # remount volumes noatime
    local i
    for i in $(seq 1 $rcl_last_volume); do
        local mount_point="/volume$i"
        if [[ -d "$mount_point" ]]; then
            if in_list "$i" "${rcl_noatime_skip_volumes[@]}"; then
                continue
            fi
            echo "remount $mount_point"
            mount -o remount,noatime "$mount_point" || rcl_error "failed to remount $mount_point noatime"
        fi
    done
}

## main (calling the functions)
remount_noatime
