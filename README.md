##dd-monitor.sh
###A script which shows the status of SD card image reads and writes

-----

These are some scripts that I have written to make copying and writing SD card images easier.  What you do
is take `dd-monitor.sh` and pass it some simple arguments.

* For copying an SD card image to file, use the following command:

`dd-monitor.sh read /dev/foo /path/to/sd.img`

The argument `/dev/foo` is the block device for your SD card while `/path/to/sd.img` is the path to which
you can write your SD card image.

* For writing an SD card image to a file, use the following commnad:

`dd-monitor.sh write /dev/foo /path/to/sd.img`

The argument `/dev/foo` is the block device of your SD card while `/path/to/sd.img` is the SD card image
that you want to write to your SD card.

I have mainly written these scripts to make copying and writing my SD card images easier since I do a lot
of stuff with my Raspberry Pi units.  Please note that all of these files _must_ be in the same directory.
Otherwise, `dd-monitor.sh` will _not_ work.
