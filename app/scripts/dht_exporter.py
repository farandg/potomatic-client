#!/usr/bin/python
import pendulum, Adafruit_DHT, socket
from time import sleep
from prometheus_client import start_http_server, Gauge

scrape_interval = 15
dht_pin         = 21
sensor          = Adafruit_DHT.DHT11
potoname        = socket.gethostbyaddr(socket.gethostname())[0]

# Create a metric to track time spent and requests made.
g_temperature = Gauge('dht_temperature', 'Temperature in celsius provided by dht sensor or similar', ['soba'])
g_humidity = Gauge('dht_humidity', 'Humidity in percents provided by dht sensor or similar', ['soba'])

def update_sensor_data(gpio_pin, device):
    """Get sensor data and sleep."""
    # get sensor data from gpio pin provided in the argument
    humidity, temperature = Adafruit_DHT.DHT11.read_retry(sensor, dht_pin)
    if humidity is not None and temperature is not None:
        if abs(temperature) < 100:     #If sensor returns veird value ignore it and wait for the next one 
            g_temperature.labels(device).set('{0:0.1f}'.format(temperature))
        if abs(humidity) < 100:        #If sensor returns veird value ignore it and wait for the next one 
           g_humidity.labels(device).set('{0:0.1f}'.format(humidity))

# Start up the server to expose the metrics.
start_http_server(8001)

# Update temperature and humidity
while True:
    update_sensor_data(dht_pin, sensor)
    sleep(scrape_interval)