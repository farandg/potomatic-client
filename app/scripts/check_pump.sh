#!/bin/bash

# this script checks if processes are running and attempts to restart them if they are not
# it is run hourly via root's crontab by default

now=$(date --rfc-3339)
pump_processes=$(ps -ef | grep -c pump.py)

echo "$now - [INFO] - checking the pump" | tee /var/log/potomatic.log
if [ $pump_processes -lt 2 ]
then
  echo "$now - [ERROR] - pump.py not active. attempting CPR..." | tee /var/log/potomatic.log
  nohup /potomatic/scripts/pump.py &
    if [ $? -ne 0 ]
    then
      echo "$now - [FATAL] - CPR failed on pump script. code blue..." | tee /var/log/potomatic.log
      exit 1
    else
      echo "$now - [INFO] - pump script started. going for a nap..." | tee /var/log/potomatic.log
      exit 0
    fi
else
  echo "$now - [INFO] - pump.py active. end of check" | tee /var/log/potomatic.log
  exit 0
fi
