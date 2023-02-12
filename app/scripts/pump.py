#!/usr/bin/python

##### pump.py #####
## This script turns the pump on for one hour according to days and months
## nov-feb: 1x per week on sundays
## mar-jun: 2x per week on sundays and wednesdays
## jul-aug: 3x per week on sundays, wednesdays and fridays
## sep-oct: 2x per week on sundays and wednesdays
## Please note locality is not determined automatically (yet) and has to be set manually

import pendulum
from time import sleep
from gpiozero import LED

now       = pendulum.now('Europe/Paris')
day       = now.day_of_week
month     = now.month
hour      = now.hour
pump      = LED(25)
pump_led  = LED()

def water_one_hour():
    pump.on()
    sleep(3600)
    pump.off()
    pump_led.blink

while True:
    now     = pendulum.now('Europe/Paris')
    month   = now.month
    day     = now.day_of_week
    hour    = now.hour
    if 1 <= month <= 2 or 11 <= month <= 12:    ## water for one hour on sundays nov-feb
        if  day == 0 and 10 <= hour <= 11:
            water_one_hour()
    elif 3 <= month <= 6 or 9 <= month <= 10:   ## water for one hour on sundays and wednesdays mar-jun and sep-oct
        if day == 0 and 10 <= hour <= 11:
            water_one_hour()
        elif day == 3 and 10 <= hour <= 11:
            water_one_hour()
    elif 7 >= month <= 8 :                      ## water for one hour on sundays, wednesdays and fridays jul-aug
        if day == 0 and 10 <= hour <= 11:
            water_one_hour()
        elif day == 3 and 10 <= hour <= 11:
            water_one_hour()
        elif day == 5 and 10 <= hour <= 11:
            water_one_hour()
    else:
        pump.off()
