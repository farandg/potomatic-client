#!/usr/bin/python
import pendulum
from astral import LocationInfo
from astral.sun import dawn, dusk
import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
from gpiozero import RGBLED
from time import sleep
# from signal import pause

i2c         = busio.I2C(board.SCL, board.SDA)
ads         = ADS.ADS1115(i2c)
water       = AnalogIn(ads, ADS.P1)
water_level = water.voltage * 26.6 #rough evaluation method, as voltage is roughly 1.5V when the water is at 4cm
home        = LocationInfo("Lille", "France", "Europe/Paris", 50.6, 3.1)
now         = pendulum.now('Europe/Paris')
day         = now.day
month       = now.month
hour        = now.hour
scrape      = 3600 #Unit is seconds
warning_led = RGBLED(36,38,40, active_high=True, initial_value=(0,0,0), pwm=True, pin_factory=None)

def water_high():
    sleep(scrape)

def water_low():
    warning_led.blink(on_time=.3, off_time=1, n=None, background=True)

def light_flash():
    warning_led.blink(on_time=.3, off_time=.5, n=3)
    warning_led.on()
    sleep(2)
    return

light_flash() # Confirm at first run

while True:
    water_level = water.voltage * 26.6
    now         = pendulum.now('Europe/Paris')
    dawn        = dawn(home.observer)
    dusk        = dusk(home.observer)
    # value       = sensor.value
    if dawn <= now < dusk and water_level < 3 : # Only flash the warning led during the day to avoid being annoying at night
        water_low()
    elif dawn <= now < dusk and water_level > 3 :
        water_high()
    else:
        water_high()
    sleep(scrape)
