#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs Prometheus, an open source monitoring tool.
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode metrics are stored for ............. and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090

# Exit immediately if any command returns a non-zero exit code
set -e

PROMETHEUS_VERSION=2.41.0
PROMETHEUS_ARCH=linux-armv6
PROMETHEUS_PORT=9090
PROMETHEUS_INSTALL_DIR=/opt
PROMETHEUS_DIR=$PROMETHEUS_INSTALL_DIR/prometheus
POTOMATIC_HOSTNAME=$(hostname -s)

function abort {
  if [ -d $PROMETHEUS_DIR ]; then
    sudo rm -rf $PROMETHEUS_DIR/ 
  fi
  if [ -d $PROMETHEUS_DIR.old ]; then
    sudo mv $PROMETHEUS_DIR.old/ $NODE_EXPORTER_DIR/
  fi
}

function cleanup {
  sudo rm -rf $PROMETHEUS_DIR.old/
  sudo rm -rf $PROMETHEUS_DIR/prometheus-${PROMETHEUS_VERSION}*
}

# Cleanup eventual previous failed installs
cleanup
clear
echo ""
echo ""
echo "#####################################################"
echo "# Welcome to the Prometheus installation subroutine #"
echo "# Providing your Potomatic with full observability  #"
echo "#####################################################"
echo ""
sleep 1

# Check all necessary components are present
BINARIES=( wget tar )

if ! command -v apt-get > /dev/null; then
  echo "[ERROR] apt-get is not installed. Please install apt-get and try again." >&2
  sleep 1
  abort
  exit 1
fi

for val in $BINARIES; do
  if ! command -v $val > /dev/null; then
    apt-get -y $val
  fi
done

if [ -d "$PROMETHEUS_DIR" ]; then
  # Delete the Prometheus directory and its contents if it exists
  echo "Previous installation detected. Removing..."
  sleep 1
  sudo mv $PROMETHEUS_DIR $PROMETHEUS_DIR.old
  echo "Removing done."
  sleep 1
fi

# Downloading and installing node_exporter and dependencies
echo "Downloading install package..."
sudo mkdir -p $PROMETHEUS_DIR || { echo "Error creating directory $PROMETHEUS_DIR. Aborting..." >&2; abort; exit 1; }
sudo wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz --directory-prefix=$PROMETHEUS_INSTALL_DIR || { echo "Error while unpacking. Aborting..." >&2; abort; exit 1; }
echo "Package downloaded."
sleep 1
echo "Unpacking..."
sudo tar xfz $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz -C $PROMETHEUS_DIR --strip-components=1 || { echo "[ERROR] unpacking. Aborting..." >&2; echo "Please try again manually, or re-run this script"; abort; exit 1; }
sudo rm $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz || { echo "[ERROR] deleting file $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz" >&2; echo "Please try again manually, or re-run this script"; abort; exit 1; }
echo "Unpacking done."
sleep 1

echo "Setting up, securing and starting Prometheus"
sleep 1
PATH=/$PROMETHEUS_DIR:$PATH
sudo cp ../files/prometheus/* $PROMETHEUS_DIR/
sudo cp ../files/system/services/prometheus.service /etc/systemd/system/
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable node_exporter
sleep 1
sudo systemctl start node_exporter

cleanup
echo "All done !!"
echo "Browse to http://${POTOMATIC_HOSTNAME}.local:9090 from any device on your home network to inspect your metrics"
