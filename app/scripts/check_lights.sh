#!/bin/bash

# this script checks if processes are running and attempts to restart them if they are not
# it is run hourly via root's crontab by default

now=$(date --rfc-3339)
lights_processes=$(ps -ef | grep -c lights.py)
lights_service_running=$(systemctl status lights.service | grep -c "active (running)")

echo "$now - [INFO] - checking the lights" | tee /var/log/potomatic.log
if [ $lights_processes -lt 2 ]
then
  echo "$now - [ERROR] - lights.py not active. attempting CPR..." | tee /var/log/potomatic.log
  systemctl restart lights.service | tee /var/log/potomatic.log
    if [ $? -ne 0 ]
    then
      echo "$now - [ERROR] - CPR failed on lights script. code blue..." | tee /var/log/potomatic.log
      systemctl stop light.service | tee /var/log/potomatic.log
      systemctl restart lights.service | tee /var/log/potomatic.log
      if [ $? -ne 0 ]
      then
        echo "$now - [FATAL] - could not revive lights service. RIP" | tee /var/log/potomatic.log
    else
      echo "$now - [INFO] - lights service started. going to sleep now..." | tee /var/log/potomatic.log
      exit 0
      fi
    fi
else
  echo "$now - [INFO] - lights service active. end of check" | tee /var/log/potomatic.log
  exit 0
fi
