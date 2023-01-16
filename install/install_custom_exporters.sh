#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs dht_exporter, an open source monitoring tool which exposes metrics about your Potomatic
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode, the metrics are ingested by dht_exporter, and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090
set -e

EXPORTERS_DIR=/opt/exporters
POTOMATIC_HOSTNAME=$(hostname -s)

function abort {
  if [ -d $EXPORTERS_DIR ]; then
    sudo rm -rf $EXPORTERS_DIR/  
  fi
  if [ -d $EXPORTERS_DIR.old ]; then
    sudo mv -f $EXPORTERS_DIR.old/ $EXPORTERS_DIR/
  fi
}

function cleanup {
  if [ -d $EXPORTERS_DIR.old ]; then
    sudo rm -rf $PROMETHEUS_DIR.old/
  fi
}

# Cleanup eventual previous failed installs
cleanup
clear
echo ""
echo ""
echo "###########################################################"
echo "# Welcome to the custom exporters installation subroutine #"
echo "# Providing your Potomatic with full observability        #"
echo "###########################################################"
echo ""
sleep 1

if ! command -v apt-get > /dev/null; then
  echo "[ERROR] apt-get is not installed. Please install apt-get and try again." >&2
  sleep 1
  abort
  exit 1
fi

if [ -d "$EXPORTERS_DIR" ]; then
  # Delete the dht_exporter directory and its contents if it exists
  echo "Previous installation detected. Removing..."
  sleep 1
  sudo mv -f $EXPORTERS_DIR $EXPORTERS_DIR.old
  echo "Removing done."
  sleep 1
else
  sudo mkdir -p $EXPORTERS_DIR
fi

# Downloading and installing dht_exporter and dependencies
echo "Installing components..."
sudo cp ../app/exporters/* $EXPORTERS_DIR
sudo cp ../files/system/services/dht_exporter.service /etc/systemd/system/dht_exporter.service

echo "Setting up and starting dht_exporter"
sleep 1
PATH=/$EXPORTERS_DIR:$PATH
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable dht_exporter
sleep 1
sudo systemctl start dht_exporter
sleep 1

echo "All done !!"
sleep 1
cleanup
echo "dht_exporter should now be exposing data at http://${POTOMATIC_HOSTNAME}.local:8000"
