#!/bin/bash

# Worker script.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# id of the worker
id=$1

#command to be executed
work=$2

while :
do
	# If the file doens't exists in available dir then stop and clear the running indicator
    if [ ! -f $DIR/../workers/jobs/$id ]; then
        exit;
    fi
    `$work`
	
    #just to release the resources - 1 second of sleep
    sleep 1
done