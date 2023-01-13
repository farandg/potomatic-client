#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs node_exporter, an open source monitoring tool which exposes metrics about your Potomatic
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode, the metrics are ingested by Prometheus, and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090

NODE_EXPORTER_VERSION=1.5.0
NODE_EXPORTER_ARCH=linux-armv6
NODE_EXPORTER_PORT=9100
NODE_EXPORTER_INSTALL_DIR=/opt
NODE_EXPORTER_DIR=$NODE_EXPORTER_INSTALL_DIR/node_exporter
POTOMATIC_IP=$(hostname -i)

echo "Welcome to the node_exporter installation subroutine"
sleep 1
echo "Providing your Potomatic with full observability."
echo ""
sleep 1
echo "Setting up the firewal" 
# Open the firewall for node_exporter traffic
iptables -A INPUT -i wlan0 -p tcp -m tcp --dport $NODE_EXPORTER_PORT -j ACCEPT
iptables -A OUTPUT -o wlan0 -p tcp -m tcp -m tcp --sport $NODE_EXPORTER_PORT -m state --state RELATED,ESTABLISHED -j ACCEPT
sleep 1
echo "Downloading the package..."
# Downloading and installing node_exporter and dependencies
mkdir $NODE_EXPORTER_DIR
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz --directory-prefix=$NODE_EXPORTER_INSTALL_DIR
echo "Package downloaded"
sleep 1

echo "Unpacking..."
sudo tar xfz $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz -C $NODE_EXPORTER_DIR --strip-components=1
sudo rm $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz

echo "Setting up and starting node_exporter"
sudo cp -f ../NODE_EXPORTER.yml $NODE_EXPORTER_DIR/NODE_EXPORTER.yml 
cd $NODE_EXPORTER_DIR
nohup ./node_exporter --collector.wifi &

echo "All done !!"

