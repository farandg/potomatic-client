#!/usr/bin/python

##### lights.py #####
## This script turns the lights on and off according to local sunrise and sunset times
## Please note locality is not determined automatically (yet) and has to be set manually
## TODO: def fade for blue hour and golden hour

import pendulum
from time import sleep
from gpiozero import LED
from astral import LocationInfo
from astral.sun import dusk, dawn

now      = pendulum.now('Europe/Paris')
home     = LocationInfo("Mons-en-Baroeul", "France", "Europe/Paris", 50.6, 3.1)
dawn     = dawn(home.observer)
dusk     = dusk(home.observer)
blue     = LED(23)
red      = LED(24)

def lights_on():
  blue.on()
  red.on()

def lights_off():
  blue.off()
  red.off()

def lights_flash():
  blue.blink(on_time=.3, off_time=.5, n=3)
  red.blink(on_time=.3, off_time=.5, n=3)
  lights_on
  sleep(2)
  return

lights_flash() # Confirm at first run

while True:
  now = pendulum.now('Europe/Paris')
  if dawn <= now < dusk:
      lights_on()
  else:
      lights_off()

