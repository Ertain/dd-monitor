#!/bin/bash

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This script is mainly meant for making an image of
# SD cards.
# Usage: dd_read.sh /dev/foo output_sd_card_image.img

function usage {
	echo "Usage:"
	echo "Create an image from a block device while utilizing the pretty progress bar from pv."
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
  exit 4
fi

# TODO Is this check really necessary?
if [ ! -f "$2" ]; then
  echo "File not found! Creating file."
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

echo "Okay, all copied."
echo "Goodbye!"

exit 0
