#!/usr/bin/env python
import Adafruit_DHT
from prometheus_client import start_http_server, Gauge
from time import sleep

dht_model   = 11
dht_pin     = 21
scrape      = 15 #Unit is seconds
temp        = Gauge('dht_temperature_celsius', 'Temperature in celsius')
hum         = Gauge('dht_humidity_percent', 'Humidity in percent')

start_http_server(8000)
while True:
    humidity, temperature = Adafruit_DHT.read_retry(dht_model, dht_pin)
    temp.set(dht_temperature_celsius)
    hum.set(dht_humidity_percent)
    sleep(scrape)

