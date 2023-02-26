#!/usr/bin/python

import pendulum
from gpiozero   import LED
from picamera   import PiCamera
from time       import sleep
from astral     import LocationInfo
from astral.sun import dusk, dawn

now              = pendulum.now('Europe/Paris')
home             = LocationInfo("Mons-en-Baroeul", "France", "Europe/Paris", 50.6, 3.1)
dawn             = dawn(home.observer)
dusk             = dusk(home.observer)
camera           = PiCamera()
camera.resolution = (1920, 1080)
image_dir        = "/potomatic/images/"
flash_led        = LED(17)

def flash(): ## Get a visual cue when a pic is taken
    flash_led.on()
    sleep(.1)
    flash_led.off()
    return

def take_pics():
    now    = pendulum.now('Europe/Paris')
    day    = now.day
    year   = now.year
    month  = now.month
    hour   = now.hour
    minute = now.minute
    camera.start_preview() ## Open the camera and give it time to adjust its settings
    sleep(5)
    camera.capture(image_dir + str("potomatic") + "-" + str(year) + str(month) + str(day) + str(hour) + str(minute) + ".jpg")
    flash()
    camera.stop_preview()
    sleep(600)
    return

while True:
    now   = pendulum.now('Europe/Paris')
    if dawn <= now < dusk:
        take_pics()
    else:
        sleep(600)
    return
