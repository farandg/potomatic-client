#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs node_exporter, an open source monitoring tool which exposes metrics about your Potomatic
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode, the metrics are ingested by NODE_EXPORTER, and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090
set -e

NODE_EXPORTER_VERSION=1.5.0
NODE_EXPORTER_ARCH=linux-armv6
NODE_EXPORTER_PORT=9100
NODE_EXPORTER_INSTALL_DIR=/opt
NODE_EXPORTER_DIR=$NODE_EXPORTER_INSTALL_DIR/node_exporter
POTOMATIC_HOSTNAME=$(hostname -s)

function abort {
  if [ -d $NODE_EXPORTER_DIR ]; then
    sudo rm -rf $NODE_EXPORTER_DIR/  
  fi
  if [ -d $NODE_EXPORTER_DIR.old ]; then
    sudo mv -f $NODE_EXPORTER_DIR.old/ $NODE_EXPORTER_DIR/
  fi
}

function cleanup {
  sudo rm -rf $NODE_EXPORTER_INSTALL_DIR.old/
  sudo rm -rf $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}*
}

# Cleanup eventual previous failed installs
cleanup
clear
echo ""
echo ""
echo "########################################################"
echo "# Welcome to the node_exporter installation subroutine #"
echo "# Providing your Potomatic with full observability     #"
echo "########################################################"
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

if [ -d "$NODE_EXPORTER_DIR" ]; then
  # Delete the node_exporter directory and its contents if it exists
  echo "Previous installation detected. Removing..."
  sleep 1
  sudo mv -f $NODE_EXPORTER_DIR $NODE_EXPORTER_DIR.old
  echo "Removing done."
  sleep 1
fi

# Downloading and installing node_exporter and dependencies
echo "Downloading install package..."
sudo mkdir -p $NODE_EXPORTER_DIR || { echo "Error creating directory $NODE_EXPORTER_DIR. Aborting..." >&2; abort; exit 1; }
sudo wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz --directory-prefix=$NODE_EXPORTER_INSTALL_DIR || { echo "Error while unpacking. Aborting..." >&2; abort; exit 1; }
echo "Package downloaded"
sleep 1
echo "Unpacking..."
sudo tar xfz $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz -C $NODE_EXPORTER_DIR --strip-components=1 || { echo "[ERROR] unpacking. Aborting..." >&2; echo "Please try again manually, or re-run this script"; abort; exit 1; }
sudo rm $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz || { echo "[ERROR] deleting file $NODE_EXPORTER_INSTALL_DIR/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz" >&2; echo "Please try again manually, or re-run this script"; abort; exit 1; }
echo "Unpacking done."
sleep 1

echo "Setting up and starting node_exporter"
sleep 1
PATH=/$NODE_EXPORTER_DIR:$PATH
sudo cp ../files/system/services/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable node_exporter
sleep 1
sudo systemctl start node_exporter

echo "All done !!"
cleanup
echo "Node_exporter should now be exposing data at http://${POTOMATIC_HOSTNAME}.local:9100/metrics"
