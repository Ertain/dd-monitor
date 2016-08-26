#!/bin/bash

# This is a little script for writing disk images
# to block devices, mainly SD cards.

function usage {
	echo "Usage:"
	echo "Write an image to a block device while"
	echo "utilizing the pretty progress bar from pv."
	echo "dd_write.sh /dev/foo /Your/disc/image"
	}

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  usage
  exit 1
fi

if [ $# -ne 2 ]; then
  echo "Please pass two arguments."
  usage
  exit 2
fi

# Check to see whether they have pv installed.
if [ ! $(which pv) ]; then
  echo "Please install pv (hint: try using \
  apt-get install pv)."
  usage
  exit 3
fi

if [ ! -b "$1" ]; then
  echo "Please pass a valid block device."
  usage
  exit 3
fi

# This should be changed to include a check for
# whether the file is a disc image.
if [ -f "$2" ]; then
    file_size=$(du -sb "$2" | awk '{print $1}')
    file_size=$((file_size/1024)) # This is  to convert it to kilobytes... I think.
else
    echo "Please pass a disc image as the second argument."
    usage
    exit 4
fi

echo "Now writing..."

dd if="$2" | pv -s "${file_size}k" | dd of="$1" bs=4096

echo "Okay, all done."
echo "Goodbye!"

exit 0
