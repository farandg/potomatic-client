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
  sudo rm -rf $PROMETHEUS_INSTALL_DIR
  sudo mv $PROMETHEUS_INSTALL_DIR.old $PROMETHEUS_INSTALL_DIR
}

function cleanup {
  sudo rm -rf $PROMETHEUS_INSTALL_DIR/prometheus.old
  sudo rm -rf $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}*
}

# Cleanup eventual previous failed installs
cleanup

echo ""
echo ""
echo "#####################################################"
echo "# Welcome to the Prometheus installation subroutine #"
echo "# Providing your Potomatic with full observability  #"
echo "#####################################################"
echo ""
sleep 2

if [ -d "$PROMETHEUS_DIR" ]; then
  # Delete the Prometheus directory and its contents if it exists
  echo "Previous installation detected. Removing..."
  sleep 1
  sudo mv $PROMETHEUS_DIR $PROMETHEUS_DIR.old
fi

sudo mkdir -p $PROMETHEUS_DIR || { echo "Error creating directory $PROMETHEUS_DIR. Aborting..." >&2; abort; exit 1; }
echo ""
echo "Removing done. Downloading package..."
sleep 1
if ! command -v wget > /dev/null; then
  # Install wget if it is not present
  echo "[ERROR] wget not found. Installing ..."
  if ! command -v apt-get > /dev/null; then
    echo "[ERROR] apt-get is not installed. Please install apt-get and try again." >&2
    abort
    exit 1
  fi
  sudo apt-get update -y
  sudo apt-get install -y wget
fi
sudo wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz --directory-prefix=$PROMETHEUS_INSTALL_DIR

echo ""
sleep 1
echo "Package downloaded. Unpacking..."
if ! command -v tar > /dev/null; then
  # Install wget if it is not present
  echo "[ERROR] tar not found. Installing ..."
  if ! command -v apt-get > /dev/null; then
    echo "[ERROR]  apt-get is not installed. Please install apt-get and try again." >&2
    abort
    exit 1
  fi
  sudo apt-get update -y
  sudo apt-get install -y tar
fi
sudo tar xfz $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz -C $PROMETHEUS_DIR --strip-components=1 || {echo "[ERROR] unpacking. Aborting..." >&2; echo "Please try again manually, or re-run this script"; abort; exit 1;}
sudo rm $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz || {echo "[ERROR] deleting file $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz" >&2; echo "Please try again manually, or re-run this script"; abort; exit 1;}

echo ""
echo "Unpacking done."
sleep 1
echo ""
echo "Setting up, securing and starting Prometheus"
sleep 1
sudo cp ../files/prometheus/* $PROMETHEUS_DIR
cd $PROMETHEUS_DIR

echo "Starting Prometheus..."
sleep 1
sudo nohup ./prometheus --config.file=prometheus.yml --web.enable-lifecycle & || {echo "[ERROR] starting Prometheus. Please check and try again, or re-run this script" >&2; abort; exit 1;}

cleanup
echo "All done !!"
echo "Browse to http://${POTOMATIC_HOSTNAME}.local:9090 from any device on your home network to inspect your metrics"
