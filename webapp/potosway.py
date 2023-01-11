#!/usr/bin/env python

import Adafruit_DHT, pendulum
from flask import Flask, render_template
from gpiozero import LED

app       = Flask(__name__)
led       = LED(17)
dht_pin   = 21
dht       = Adafruit_DHT.DHT11

@app.route('/')
def index():
    (_humidity, _celsius) = Adafruit_DHT.read_retry(dht, dht_pin)
    templateData = {
      'title': 'POTOSWAY',
      'page_title': 'Welcome to Potosway',
      'subtitle': 'Smarter planting',
      '_humidity': _humidity,
      '_celsius': _celsius
    }
    return render_template('potosway.html', **templateData)

@app.route("/<deviceName>/<action>")
def action(deviceName, action):
    if deviceName == "led":
        device == led
    if action == "on":
        device.on()
    if action == "off":
        device.off()
    if action == "blink":
        device.blink(.5, .3)
    if action == "status":
        device.value()
    templateData = {
        'led_status' : led.value()
    }
    return render_template('potosway.html', **templateData)

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')
