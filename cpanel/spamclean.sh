#!/bin/bash
MAILDIRS=$(find /home/*/mail/*/* -maxdepth 0 -type d)
INBOXFOLDERS=(.Trash .Junk .Spam .spam .Low\ Priority .cPanel\ Reports)
for basedir in $MAILDIRS; do
  for ((i = 0; i < ${#INBOXFOLDERS[*]}; i++)); do
    for dir in cur new; do
        [ -e "$basedir/${INBOXFOLDERS[$i]}/$dir" ] && (
        echo "Processing $basedir/${INBOXFOLDERS[$i]}/$dir..."
        find "$basedir/${INBOXFOLDERS[$i]}/$dir/" -type f -mtime +2 -delete
        )
    done
  done
done

/scripts/generate_maildirsize --confirm --allaccounts --verbose

