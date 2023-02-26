#!/usr/bin/python

import pendulum
from time import sleep
from gpiozero import LED,RGBLED

water_hour = 10
pump      = LED(25)
pump_led = RGBLED(36,38,40, active_high=True, initial_value=(0,0,0), pwm=True, pin_factory=None)

def led_it_rain(led_time):
    pump_led.pulse(fade_in_time=2,fade_out_time=.5, on_color=(0,1,0), off_color=(0,.5,0), n=led_time, background=True)

def make_it_rain(rain_time):
    led_time = rain_time
    pump.on()
    sleep(rain_time)
    pump.off()
    led_it_rain(led_time)

def water(plant):
    now = pendulum.now('Europe/Paris')
    month = now.month
    day = now.day_of_week
    hour = now.hour      
    if plant == "cactus" or "cactae" or "cacti":
        mid_water_days = [6]
        high_water_days = [3,7]
        mid_water_months = [3,4,9,10] 
        high_water_months = [5,6,7,8]
        no_water_months = [1,2,11,12]
    if plant == "succulent":
        low_water_days = [7]
        mid_water_days = [2,4]
        high_water_days = [1,3,6]
        low_water_months = [1,2,11,12]
        mid_water_months = [3,4,9,10] 
        high_water_months = [5,6,7,8]
    if plant == "hungry":
        mid_water_days = [2,4]
        high_water_days = [1,3,6]
        low_water_months = [1,2,11,12]
        mid_water_months = [3,4,9,10] 
        high_water_months = [5,6,7,8]
    if month in no_water_months:
        sleep(3600)        
    if month in low_water_months and day in low_water_days and hour == water_hour:
        make_it_rain(5)        
    if month in mid_water_months and day in mid_water_days and hour == water_hour:
        make_it_rain(10)        
    if month in high_water_months and day in high_water_days and hour == water_hour:
        make_it_rain(20)