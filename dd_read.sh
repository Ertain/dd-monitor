#!/bin/bash

# This script is mainly meant for making an image of
# SD cards.
# Usage: dd_read.sh /dev/foo output_image.img

function usage {
	echo "Usage:"
	echo "Create an image from a block device while \
	utilizing the pretty progress bar from pv."
	echo "dd_write.sh /dev/foo /Your/disc/image"
	}

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

if [ $# -ne 2 ]; then
  echo "Please pass two arguments."
  usage
  exit 2
fi

# Check to see whether they have pv installed.
[ ! -f /usr/bin/pv ] && echo "Please install pv (hint: try using \
 apt-get install pv)." && exit 3
 
if [ ! -b "$1" ]; then
  echo "Please pass a valid block device."
  exit 4
fi

if [ ! -f "$2" ]; then
  echo "File not found! Creating file..."
  touch "$2"
fi

# In the awk command, it filters the output of lsblk such that the second line is printed.
# In other words, the row after "SIZE" is used because that's the partition (or the whole
# disk) we're using.
file_size=$(lsblk -b --output SIZE "$1" | awk 'FNR == 2 {print}')
# Convert it from bytes to kilobytes.
file_size=$((file_size/1024))

echo "Now copying..."

dd if="$1" | pv -s "${file_size}k" | dd of="$2" bs=4096

echo "Okay, all done."
echo "Goodbye!"

exit 0
