#! /bin/bash

## This script gathers all images stored in /potomatic/images and concatenates them into a timelapse.
## The .mp4 file is then uploaded to your Google Drive
## Its is run on the first day of the month via cron

NOW=$(date --rfc-3339)
IMAGES_DIR=/potomatic/images
VIDEOS_DIR=/potomatic/videos
LOG_FILE=/var/log/potomatic_images.log
LAST_MONTH=`date -d "$(date +%Y-%m-1) -1 month" +%B%Y`

echo "$NOW - [INFO] - Making your potomatic timelapse for $LAST_MONTH" | tee -a $LOG_FILE
if [ -d $IMAGES_DIR ]
then
  IMAGES = $(ls $IMAGES_DIR | wc -l)
    if [ $IMAGES -lt 1 ]
    then 
      echo "$NOW - [FATAL] - No images in directory. Aborting" | tee -a $LOG_FILE
      exit 1
    else 
      mkdir -p $VIDEOS_DIR
      ffmpeg -y \
        -r 25 \
        -pattern_type glob \
        -i "$IMAGES_DIR/*.jpg" \
        -s 1920x1080 \
        -vcodec libx264 \
        $VIDEOS_DIR/timelapse_$HOSTNAME_$LAST_MONTH.mp4 | tee -a $LOG_FILE
      exit 0
      if [ $? -ne 0 ]
      then
        echo "$NOW - [FATAL] - Could not create timelapse. Please check $LOG_FILE" | tee -a $LOG_FILE
        exit 1
      else
        echo "$NOW - [INFO] - Timelapse created successfully. Enjoy !" | tee -a $LOG_FILE
        rm $IMAGES_DIR/*
        if [ $? -ne 0 ]
        then
          echo "$NOW - [ERROR] - Could not clean image folder. Please do so manually." | tee -a $LOG_FILE
        else
          echo "$NOW - [INFO] - Clean up complete. Going back to sleep for a month." | tee -a $LOG_FILE
        fi
      fi
    fi
else
  echo "$NOW - [ERROR] - $IMAGE_DIR not present. Aborting..." | tee -a $LOG_FILE
  exit 1
fi