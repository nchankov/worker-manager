#!/bin/bash

# The Director knows the tasks and assigns how many jobs there are for each task

# The script should be added on the crontab and should run every minute

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TASKS_DIR="$DIR/../tasks"
JOBS_DIR="$DIR/../jobs"

if [ ! -d "$TASKS_DIR" ]; then
    echo "Tasks directory not found: $TASKS_DIR"
    exit 1
fi

# Remove all existing job files before recreating from current tasks
rm -f "$JOBS_DIR"/*.job

for task_file in "$TASKS_DIR"/*.task; do
    [ -f "$task_file" ] || continue

    # Load task parameters
    source "$task_file"

    # Derive task name from filename (without extension)
    task_name=$(basename "$task_file" .task)

    # Use CHECK if it's a valid integer, otherwise fall back to MIN_JOBS (or 1)
    if [[ "${CHECK}" =~ ^[0-9]+$ ]]; then
        job_count=$CHECK
    else
        job_count=${MIN_JOBS:-1}
    fi
    min=${MIN_JOBS:-1}
    max=${MAX_JOBS:-$job_count}
    [ "$job_count" -lt "$min" ] && job_count=$min
    [ "$job_count" -gt "$max" ] && job_count=$max

    # Create numbered job files
    for i in $(seq 1 "$job_count"); do
        echo "$COMMAND" > "$JOBS_DIR/${task_name}.${i}.job"
    done
done

