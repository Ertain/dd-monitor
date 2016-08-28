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

# Description: This little script is used to read and write SD card images.
# Usage: dd-monitor.sh read /dev/foo /path/to/sd_card_image.img
#        dd-monitor.sh write /dev/foo /path/to/sd_card_image.img

function usage {
	echo "Usage:"
	echo "dd-monitor.sh read /dev/foo /path/to/sd_card_image.img"
	echo "dd-monitor.sh write /dev/foo /path/to/sd_card_image.img"
	echo "Note that \"read\" or \"write\" are mandatory"
	}
	
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  usage
  exit 1
fi

if [ $# -ne 3 ]; then
  echo "Please pass three arguments."
  usage
  exit 2
fi

case "$1" in
    "read")
       ./dd_read.sh "$2" "$3"
     ;;
     "write")
       ./dd_write.sh "$2" "$3"
     ;;
     *)
       echo "Please pass the word \"read\" or \"write\" as the first argument."
       usage
       exit 3
     ;;
esac

exit 0
