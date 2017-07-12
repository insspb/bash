#!/bin/bash
if [ -z "$1" ]
  then
    echo "Path to directory missing. Path should be first argument."
    exit
fi

SITE_PATH=$1

echo "Everything ok. Working on directories and files permissions now."

find $SITE_PATH/ -type f -exec chmod 644 {} \;
find $SITE_PATH/ -type d -exec chmod 755 {} \;

echo "Everything done. Exiting."
