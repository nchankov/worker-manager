#!/bin/bash

# Script which will manage the workers

# this should be put in the crontab and should run every minute
# It would start tasks which are not already running

#current working dir
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#check if there are non running jobs
for file in $DIR/../jobs/*.job
do
    isworking=`ps aux | grep worker.sh\ ${file##*/} | grep "/bash" | wc -l`
    if [ $isworking == 0 ]; then
        work=`cat $file`
        nohup $DIR/worker.sh ${file##*/} "$work" >> /var/log/worker-manager.log &
    fi
done