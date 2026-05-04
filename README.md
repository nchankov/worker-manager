# Worker Manager #

A lightweight, robust process management system designed to keep background tasks running continuously. Whether you're managing message queues or repetitive long-running scripts, Worker Manager ensures your processes stay alive and scales them dynamically based on your needs.

## Features ##

- Continuous Execution: Automatically restarts jobs if they exit.

- Dynamic Scaling: Increase or decrease the number of active workers based on external triggers (files, APIs, etc.).

- Decoupled Architecture: Separation of concerns between high-level task definition (Director), job orchestration (Manager), and execution (Worker).

## Installation ##

### 1. Clone the Repository ###

It is recommended to install the manager in `/usr/local/lib/worker-manager`, but it can be placed anywhere.

```
git clone https://github.com/nchankov/worker-manager.git /usr/local/lib/worker-manager
```

### 2. Configure Crontab ###

The system relies on a heartbeat check every minute to ensure the Director and Manager are active. Add the following entries to your crontab:

```
* * * * * /usr/local/lib/worker-manager/bin/director.sh > /dev/null 2>&1
* * * * * /usr/local/lib/worker-manager/bin/manager.sh > /dev/null 2>&1
```

## Configuration Modes ##

### 1. Manual Mode (Legacy) ###

You can bypass the Director by manually placing .job files in the jobs/ directory. The manager.sh script will detect these and assign them to workers immediately.


### 2. Dynamic Mode (Recommended) ###

Create .task templates in the tasks/ directory. The Director uses these templates to dynamically generate or remove job files based on your specific scaling logic.

## Task Definition Reference ##

Define your tasks in /tasks/[TaskName].task. Each file supports the following variables:

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| COMMAND | The actual command or script to be executed. | Yes | - |
| MIN_JOBS | The floor for how many workers should run. | No | 1 |
| MAX_JOBS | The ceiling for scaling. | No | |
| CHECK | Logic/Command to determine the current required job count. | No | -


## Task Examples ##

### Basic (Static) ###

A simple task that keeps exactly one worker running.

`./tasks/BasicTask.task`

```
COMMAND="/path/to/script.sh"
```

### File-Based Scaling ###

Scales between 2 and 10 workers based on the numerical value inside a text file.

`./tasks/FileCheckTask.task`
```
COMMAND="/path/to/script.sh"
MIN_JOBS=2
MAX_JOBS=10
CHECK=$(</path/to/scaling_indicator.txt)
```

### API-Driven Scaling ###

Fetches the desired worker count from a remote URL.

`./tasks/UrlCheckTask.task`
```
COMMAND="/path/to/script.sh"
MIN_JOBS=2
MAX_JOBS=10
CHECK=$(curl -s https://api.yourserver.com/worker-count)
```

## Core Components ##

### The Director (director.sh) ###
The "Brain." It runs via cron every minute, evaluates the CHECK logic in your task files, and creates or deletes .job 
files in the jobs/ folder. It manages the "big picture" of how many workers are needed.

### The Manager (manager.sh) ###

The "Orchestrator." It monitors the jobs/ folder. For every job file present, it ensures a Worker process is active. If 
a job file is removed, the Manager signals the corresponding worker to stop.

### The Worker (worker.sh) ###

The "Executor." It runs the COMMAND in a loop. As long as its specific .job file exists, it will immediately restart the command if it finishes or crashes.
License

Distributed under the MIT License. See LICENSE for more information.