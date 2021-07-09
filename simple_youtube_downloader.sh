#!/bin/bash

# Younis Amedi - June 2021
# Very Simple YouTube Downloader - no need of YouTube API key

# Install youtube-dl library
# pip3 install --upgrade youtube_dl

####################################

# Replace this with your YouTube list link
yt_list="https://www.youtube.com/playlist?list=PLFjq8z-aGyQ4Y3mSWGBptr7SArEsfdWQA"

youtube-dl -i -f mp4 --yes-playlist "$yt_list"

exit
