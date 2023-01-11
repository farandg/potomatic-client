#!/usr/bin/env python

import Adafruit_DHT
from flask import Flask, request
from gpiozero import LED

app = Flask(__name__)
led = LED(17)
dht_pin = 21
dht = Adafruit_DHT.DHT11



@app.route('/')
def index():
  ( _humidity, _celsius ) = Adafruit_DHT.read_retry( dht, dht_pin )
  'title' = 'Potosway Webapp'

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



import Adafruit_DHT
from time import sleep
p=print # Alias 
# Note: Use &gt;=2000ms polling intervals
poll_interval = 2 # Seconds
dht_pin = 21 # BCM24/BOARD18
  
if __name__ == '__main__':
  while True: 
    ( _humidity, _celsius ) = Adafruit_DHT.read_retry( _dht, _dht_pin )
    p( "Humidity =&gt; %.1f%% RH" % _humidity ) 
    p( "Temperature =&gt; %.2fF" % _celsius )
    p( "%.2fC" % _celsius )
    sleep( _poll_interval )
