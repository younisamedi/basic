#!/usr/bin/env bash

# Younis Amedi
# July 2018
# Must have "ffmpeg" installed
# This script will split a long audio file to smaller parts: original: Music.mp3 ---> Music000.mp3 Music001.mp3 Music002.mp3 etc...
# This works with all the common audio format
##############

### Provide an audio file
if [ -z "$1" ]
   then
	   echo "must have an audio file as a first argument. E.g: ./slice_audio_file.sh music.mp3"
	   exit 1
fi


file_extension=$(echo $1 | tail -c 4)

### 1800 means 30 minutes
ffmpeg -i "$1" -f segment -segment_time 3600 "${1::-4}"%03d.$file_extension

exit

### End
