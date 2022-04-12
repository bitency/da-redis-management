#!/bin/bash
#
# Monitoring redis instances
#

REDISINSTANCESDIR=/etc/redis/instances/*.conf
COUNTER=1
hostname=`hostname`

for f in $REDISINSTANCESDIR
do
	# Strip .conf from filename
	filename=$(basename -- "$f")
	redisid=${filename%%.conf*}

	# test if running
	testredis=0
	testredis=`ps -aux | grep -c "[1]27.0.0.1:$redisid"`

	if [[ $testredis == 1 ]]
	then
  		echo "$redisid is running"	
	else
  		echo "$redisid is not running"
		systemctl restart redis
		service redis restart
		echo -e "Redis restart host: $hostname" | mail -s "Redis restart host: $hostname" mail@mail.nl
	fi
	      

done
