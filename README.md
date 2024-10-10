# Worker manager

Ability to manage working processes

The script in this repository would be used to manage background tasks running continuously.

There are 2 scripts

## 1. Manager ##

This script check if there are jobs which are not run and start a worker with that job.
The manager.sh should be adding to crontab like so:

```
* * * * * /...path.../worker-manager/bin/manager.sh > /dev/null 2>&1
```

On every run the script reads the files in /worker-manager/jobs and if they are not working
will add them to a loop worker which will run them until the job is not removed from the jobs dir.

If the job is already working, the script wouldn't bother to run it again

## 2. Worker ##

The script loops until the job is present in the jobs directory. And if it's not present will exit

The contents of the *.job file should be the command

## Example scenario ##

Add a file `task.job` into workers/jobs directory.

The contents of `task.job` are 
```
echo "Worker doing task 1"
```
The contents of the job file would be executed. So make sure it's one-liner. 
Also make sure the job has extension .job otherwise it woudn't start

Now run the ./bin/manager.sh

it will start 1 worker and you can see if you run
```
ps aux | grep "worker.sh task.job"
```

Now this is running forever with 1 sec sleep between the load

At some point you decide that the job is enough, so you want to stop it.
Just remove (or rename the file) task.job and the worker will exit and will stop working