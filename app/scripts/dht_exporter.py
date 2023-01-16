#!/usr/bin/env python
import Adafruit_DHT
from prometheus_client import start_http_server, Summary
from time import sleep

dht_model   = 11
dht_pin     = 21
scrape      = 15 #Unit is seconds
temp        = Summary('dht_temperature', 'Temperature in celsius')
hum         = Summary('dht_humidity', 'Humidity in percent')

start_http_server(8000)
while True:
    humidity, temperature = Adafruit_DHT.read_retry(11, 4)
    temp.set(temp)
    hum.set(hum)
    sleep(scrape)

