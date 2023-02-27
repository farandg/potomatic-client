#!/usr/bin/env python
import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
from prometheus_client import start_http_server, Gauge
from time import sleep

## TODO: refine methods for values
scrape                      = 15 #Unit is seconds
i2c                         = busio.I2C(board.SCL, board.SDA)
ads                         = ADS.ADS1115(i2c)
water                       = AnalogIn(ads, ADS.P1)
water_level                 = water.voltage * 26.6 #rough evaluation method, as voltage is roughly 1.5V when the water is at 4cm
water_level_exporter        = Gauge('water_level', 'Water level in mm')
moisture                    = AnalogIn(ads, ADS.P2)
moisture_level              = moisture.value
moisture_level_exporter     = Gauge('moisture_level', 'Soil moisture level in percent')
light                       = AnalogIn(ads, ADS.P3)
light_level                 = light.value
light_level_exporter        = Gauge('light_level', 'Light level in lumens')


start_http_server(8001)

while True:
    water_level     = water.voltage * 26.6
    moisture_level  = moisture.value
    light_level     = light.value
    water_level     = float(water_level)
    moisture_level  = float(moisture_level)
    light_level     = float(light_level)
    water_level_exporter.set(water_level)
    moisture_level_exporter.set(water_level)
    light_level_exporter.set(water_level)
    sleep(scrape)
