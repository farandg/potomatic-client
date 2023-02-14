#!/usr/bin/env python
import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
from prometheus_client import start_http_server, Gauge
from time import sleep

i2c                  = busio.I2C(board.SCL, board.SDA)
ads                  = ADS.ADS1115(i2c)
water                = AnalogIn(ads, ADS.P1)
water_level          = water.voltage * 26.6 #rough evaluation method, as voltage is roughly 1.5V when the water is at 4cm
water_level_exporter = Gauge('water_level', 'Water level in mm')
scrape               = 15 #Unit is seconds

start_http_server(8001)

while True:
    water_level = water.voltage * 26.6
    if water_level is not None:
        water_level = float(water_level)
        water_level_exporter.set(water_level)
    sleep(scrape)
