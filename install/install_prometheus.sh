#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs Prometheus, an open source monitoring tool.
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode metrics are stored for ............. and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090

PROMETHEUS_VERSION=2.22.0
PROMETHEUS_ARCH=linux-armv7
POTOMATIC_IP=$(hostname -i | awk )

echo "Welcome to the Prometheus installation subroutine \nProviding your Potomatic with full observability."
# Downloading and installing Prometheus and dependencies
wget -P / https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz
tar xfz /prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz
mv /prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH} /prometheus
rm /prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz

echo "Setting up the Prometheus service"
cp ../files/prometheus.service /etc/systemd/system/prometheus.service
systemctl enable prometheus
systemctl start prometheus




