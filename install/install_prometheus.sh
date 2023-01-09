#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs Prometheus, an open source monitoring tool.
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode metrics are stored for ............. and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090

PROMETHEUS_VERSION=2.22.0
PROMETHEUS_ARCH=linux-armv6
PROMETHEUS_PORT=9090
PROMETHEUS_INSTALL_DIR=/opt
PROMETHEUS_DIR=$PROMETHEUS_INSTALL_DIR/prometheus
POTOMATIC_IP=$(hostname -i)

echo "Welcome to the Prometheus installation subroutine"
sleep 1
echo "Providing your Potomatic with full observability."
echo ""
sleep 1
echo "Setting up the firewall" 
# Open the firewall for Prometheus traffic
iptables -A INPUT -i wlan0 -p tcp -m tcp --dport $PROMETHEUS_PORT -j ACCEPT
iptables -A OUTPUT -o wlan0 -p tcp -m tcp -m tcp --sport $PROMETHEUS_PORT -m state --state RELATED,ESTABLISHED -j ACCEPT
sleep 1
echo "Downloading the package..."
# Downloading and installing Prometheus and dependencies
mkdir $PROMETHEUS_DIR
wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz --directory-prefix=$PROMETHEUS_INSTALL_DIR
echo "Package downloaded"
sleep 1

echo "Unpacking..."
sudo tar xfz $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz -C $PROMETHEUS_DIR --strip-components=1
sudo rm $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz

echo "Setting up and starting Prometheus"
cd $PROMETHEUS_DIR
nohup ./prometheus --config.file=$PROMETHEUS_DIR/prometheus.yml &

echo "All done !!"
echo "Browse to http://${POTOMATIC_IP}:9090 from any device on your home network to see your metrics"

