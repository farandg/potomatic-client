#!/usr/bin/env python

import Adafruit_DHT, pendulum
from flask import Flask, request
from gpiozero import LED

app       = Flask(__name__)
led       = LED(17)
dht_pin   = 21
dht       = Adafruit_DHT.DHT11

@app.route('/')
def index():
  ( _humidity, _celsius ) = Adafruit_DHT.read_retry( dht, dht_pin )
  templateData = {
    'title' : 'POTOSWAY webapp',
    'subtitle' : 'Plant smarter'
  }
  return render_template('index.html', **templateData)

@app.route('/led/on', methods=['POST'])
def led_on():
    led.on()
    return 'LED turned on', 200

@app.route('/led/off', methods=['POST'])
def led_off():
    led.off()
    return 'LED turned off', 200

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')
