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
    if temperature is not None:
        temperature = float(temperature)
        temp.set(temperature)
    if humidity is not None:
        humidity = float(humidity)
        hum.set(humidity)
    sleep(scrape)