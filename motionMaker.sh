#!/bin/sh

# check if motion is running
if [ -n "$(pidof motion)" ]
then
  killall motion
  echo "killed motion"
else
  echo "no motion"
fi

CAM=-1

if [ -c /dev/video0 ]
then
  CAM=0
fi

if [ -c /dev/video1 ]
then
  CAM=1
fi

if [ "$CAM" -ge 0 ]
then
  echo "camera on $CAM"
else
  echo "no camera"
  exit 0
fi

cat motion.conf.template > motion.conf
echo "videodevice /dev/video$CAM" >> motion.conf

# start motion back up
motion
