#!/usr/bin/env python
import Adafruit_DHT
from prometheus_client import start_http_server, Gauge
from time import sleep

dht_model   = 11
dht_pin     = 21
scrape      = 15 #Unit is seconds
temp        = Gauge('dht_temperature', 'Temperature in celsius')
hum         = Gauge('dht_humidity', 'Humidity in percent')

start_http_server(8000)
while True:
    humidity, temperature = Adafruit_DHT.read_retry(dht_model, dht_pin)
    temp.observe(temp)
    hum.observe(hum)
    sleep(scrape)

