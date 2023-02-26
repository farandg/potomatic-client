# POTOMATIC-CLIENT

This is the repo for POTOMATIC's client-side code.
This includes:

## APP

## FILES

## INSTALL

## WEBAPP

## ENVIRONMENT

POTOMATIC is designed to run on a variety of systems.  
Current code is designed for ```armv6``` architectures running Debian-based systems.  

**COMING SOON** : support for different open source microcontrollers running micropython, including:
* Espressif esp32
* Raspberry Pi Pico W

## CODE CONVENTIONS
For simplicity, and in order to leverage the capabilities of a Debian-based system, the following conventions are applied:

### Install scripts
These consist in a master script and multiple slave scripts, allowing for greater flexibility and code economy. They are written in ```bash```

### Core services
Are written in ```python```, run as Linux services, and monitored using keepalive scripts.  
For maintainability, one script corresponds to one function/service.

### System scripts
Are mostly keepalive/autoremediation services used to monitor core services. They are written in ```bash```.

### Exporters
Are written in Python and use the ```prometheus_client``` library

### Versions
|Language/Tool/Library|Version|
|----|----|
|Python| 3.9|
