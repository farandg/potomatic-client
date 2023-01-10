#!/usr/bin/python
import pendulum
from astral import LocationInfo
from astral.sun import dawn, dusk
from gpiozero import DigitalInputDevice, LED
from time import sleep
from signal import pause

home        = LocationInfo("Mons-en-Baroeul", "France", "Europe/Paris", 50.6, 3.1)
sensor      = DigitalInputDevice(18)
now         = pendulum.now('Europe/Paris')
day         = now.day
month       = now.month
hour        = now.hour
warning_led = LED(17)

def water_high():
    sleep(3600)

def water_low():
    warning_led.blink(on_time=.3, off_time=1, n=None, background=True)

def light_flash():
  warning_led.blink(on_time=.3, off_time=.5, n=3)
  warning_led.on()
  sleep(2)
  return

light_flash() # Confirm at first run

while True:
    now   = pendulum.now('Europe/Paris')
    dawn  = dawn(home.observer)
    dusk  = dusk(home.observer)
    value = sensor.value
    if dawn <= now < dusk and value == 0: # Only flash the warning led during the day to avoid being annoying at night
        water_low()
    else:
        water_high()
    sleep(1)
