# POTOMATIC-CLIENT

## APP

This contains all the necessary live code to make POTOMATIC function locally.  
This includes:
* scripts  
* system scripts
* exporters 

### Scripts
Scripts manage the core POTOMATIC functionalities, such as lighting, water etc.  
They rely on POTOMATIC's array of sensors and actuators to do so.  

### System scripts
System scripts manage the scripts. In other terms, they are scheduled keepalive checks for core functions.

### Exporters
Exporters stream data from POTOMATIC's sensors, formatted as Prometheus metrics.  
These can then be used by a variety of tools to build dashboards.  

## SYSTEM FILES
Static code to run and schedule core services is contained in files/system

## CODE
For consistency purposes, core services are written in Python.  
System scripts are written in bash.
