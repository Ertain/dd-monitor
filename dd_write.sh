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

# This is a little script for writing disk images
# to block devices, mainly SD cards.
# Usage: dd_write.sh /dev/foo input_sd_card_image.img


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

# TODO This should be changed to include a check for
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
