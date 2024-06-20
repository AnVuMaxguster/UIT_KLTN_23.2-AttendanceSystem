#!/bin/bash

arg1=$1

source /home/ubuntu/anvu/myvenv/bin/activate

python3 /home/ubuntu/anvu/AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem/Scheduler/task.py --id $arg1

deactivate