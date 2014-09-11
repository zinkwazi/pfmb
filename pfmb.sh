#!/bin/bash
# by Greg Lawler greg@outsideopen.com
# v1.0 7/1/2014
#
# To Do List:
# Encrypt the stored backups.
# Accept single hostname or IP from the command line and bypass hosts file.
# Give useful feedback on errors relating to SSH / connectivity. 
# Allow different SSH keys for each IP.

##### Configuration #####
# Hosts config file
config=hosts.conf

# SSH backup username
backupuser=backup

# Backup directory - relative to . or use full path.
backupdir=backups

# Number of backups to keep.
backupcopies=5 

##### Other settings - don't change these willy-nilly unless you know what you're doing! #####
datestamp=`date '+%Y-%m-%d-%s'`

# Path on pfSense to the XML configuration file.
xmlpath="/cf/conf/config.xml"

function isint() {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
	   echo "Error: $1 is not a valid port number.  Check your $config syntax..." >&2; exit 1
	fi
}

function rotateBackups() {
	files=(`ls $backupdir/*$1-*xml | sort | tail -n $backupcopies`)
	for i in $backupdir/*$1-*xml; do
		keep=0;
		for a in ${files[@]}; do
			if [ $i == $a ]; then
			keep=1;
			fi;
		done;
		if [ $keep == 0 ]; then
			rm $i
		fi;
	done
}

function main() {
	while IFS=':' read -r host port ; do
		if [ -n "$port" ] ; then
			isint $port
			scp -P $port $backupuser@$host:$xmlpath "$backupdir/$host-$datestamp.xml" #> /dev/null 2>&1
			echo "Backing up $host..."
			rotateBackups $host
		else
			scp $backupuser@$host:$xmlpath "$backupdir/$host-$datestamp.xml" #> /dev/null 2>&1
			echo "Backing up $host..."
			rotateBackups $host
		fi
	done < $config
}
main
