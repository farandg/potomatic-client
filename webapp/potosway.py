#!/usr/bin/env python

import Adafruit_DHT, pendulum, random
from flask import Flask, render_template, request
from gpiozero import LED, RGBLED

app       = Flask(__name__)
dht       = Adafruit_DHT.DHT11
led       = LED(17)
rgb       = RGBLED(13,19,6)
dht_pin   = 21

def rgb_on():
    rgb.color = (1,1,1)

def rgb_off():
    rgb.color = (0,0,0)

def disco_time():
  while True: 
    zzz     = round(random.uniform(.1,.5),1) 
    t_on    = round(random.uniform(.1,.5),1) 
    t_off   = round(random.uniform(.1,.5),1) 
    red     = random.random()
    green   = random.random()
    blue    = random.random()
    rgb.pulse(t_on, t_off, (red, green, blue), (0, 0, 0))
    sleep(zzz)

@app.route('/')
def index():
    (_humidity, _celsius) = Adafruit_DHT.read_retry(dht, dht_pin)
    templateData = {
      'title'       : 'POTOSWAY',
      'page_title'  : 'Welcome to Potosway',
      'subtitle'    : 'Smarter planting',
      '_humidity'   : _humidity,
      '_celsius'    : _celsius
    }
    return render_template('potosway.html', **templateData)

@app.route("/<deviceName>/<action>")
def led_action(deviceName, action):
    if deviceName == "led":
        device = led
    if action == "on":
        device.on()
    if action == "off":
        device.off()
    if action == "blink":
        device.blink(.5, .3)
    templateData = {
        'led_status' : str(led.is_lit)
    }
    return render_template('potosway.html', **templateData)

@app.route("/<deviceName>/<action>")
def rgb_action(deviceName, action):
    if deviceName == "rgb":
        device = rgb
    if action == "on":
        rgb_on()
    if action == "off":
        rgb_off()
    if action == "disco":
        disco_time()
    templateData = {
        'led_status' : str(led.is_lit)
    }
    return render_template('potosway.html', **templateData)

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')
