#!/usr/bin/env python

import Adafruit_DHT, pendulum, random
from flask import Flask, render_template, request
from threading import Thread
from time import sleep
from gpiozero import LED, RGBLED

app         = Flask(__name__)
dht         = Adafruit_DHT.DHT11
led         = LED(17)
rgb         = RGBLED(13,19,6,True)
dht_pin     = 21

def disco_time():
    rgb.off()
    while True: 
        zzz          = round(random.uniform(.1,.5),1) 
        t_on         = round(random.uniform(.1,.5),1) 
        t_off        = round(random.uniform(.1,.5),1) 
        redLight     = random.random()
        greenLight   = random.random()
        blueLight    = random.random()
        rgb.pulse(t_on, t_off, (redLight, greenLight, blueLight), (0, 0, 0))
        sleep(zzz)
        return

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
def action(deviceName, action):
    if not rgb.is_lit: 
        rgb_status = "OFF" 
    else: rgb_status = "ON"
    if not led.is_lit: 
        led_status = "OFF" 
    else: led_status = "ON"
    if deviceName == "led":
        device = led
        if action == "on":
            device.on()
        if action == "off":
            device.off()
        if action == "blink":
            device.blink(.5, .3)
    if deviceName == "rgb":
        device = rgb
        if action == "on":
            device.on()
        if action == "off":
            zzz   = 0 
            t_on  = 0
            t_off = 0
            device.off()
        if action == "red":
            device.off()
            device.color = (1,0,0)
        if action =="green":
            rgb.off()
            rgb.color = (0,1,0)
        if action == "blue":
            rgb.off()
            rgb.color = (0,0,1)
        if action == "disco":
            disco_time()
    templateData = {
        'led_status' : led_status,
        'rgb_status' : rgb_status
    }
    return render_template('potosway.html', **templateData)

@app.route('/result/<color>/<value>')
def result(color,value):
    global redPWM,greenPWM,bluePWM
    if(color == "red"):
        redPWM = int(value)
    elif(color == "green"):
        greenPWM = int(value)
    elif(color == "blue"):
        bluePWM = int(value)

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')
