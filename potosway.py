#!/usr/bin/env python

from flask import Flask, request
from gpiozero import LED

app = Flask(__name__)
led = LED(17)

@app.route('/led/on', methods=['POST'])
def led_on():
    led.on()
    return 'LED turned on', 200

@app.route('/led/off', methods=['POST'])
def led_off():
    led.off()
    return 'LED turned off', 200

if __name__ == '__main__':
    app.run()
