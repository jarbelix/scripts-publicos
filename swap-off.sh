#!/bin/bash
# https://help.ubuntu.com/community/SwapFaq
export PATH="/usr/sbin:/usr/bin:/sbin:/bin"

echo "========"
echo "Before - `date`"
echo "========"
free -h

sync

echo 3 > /proc/sys/vm/drop_caches

mem=$(LC_ALL=C free  | awk '/Mem:/ {print $4}')
swap=$(LC_ALL=C free | awk '/Swap:/ {print $3}')

if [ $mem -lt $swap ]; then
        echo "ERROR: [$swap > $mem]not enough RAM to write swap back, nothing done" >&2
        exit 1
fi

if [ $swap -gt 0 ]; then
	swapoff -a
	swapon -a
fi

echo "========"
echo "After - `date` "
echo "========"
free -h
