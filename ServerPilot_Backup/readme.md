# ServerPilot.io backup script

## Description

I am using free version of ServerPilot.io management engine. This engine is lack of backup capabilities. I tried to find something that solve this problem, but with no luck. So I wrote it myself. Feel free to use it or commit 
here. 

As always with free software: **You use it on you own risk. No warranty.**

## Action sequence

This script will do the following actions: 

1. It will use debian mysql config to access mysql with root rights. If you do not have such file you need to create it manually and change path in ***MYSQLCFG*** variable. 
2. It will collect all mysql databases directly from mysql 
3. It will get all users folders directly from ***/srv/users/*** 
4. It will check user for root rights. 
5. It will check and create logs structure if needed. 
6. It will create separate backup for each user folder. 
7. It will create separate backup for each database. 
8. It will force change access rights to backups just to **root** account. 
9. It will clean backups older than **24 * KEEPDAYS**

## Installation

 - Make copy of script on you server
 - Make it executable
 - Add it to cron table with root privileges.

## Versions

### 0.1

- Initial public release. 
