#! /bin/bash
## This script is part of the installation of your potomatic.
## It installs Prometheus, an open source monitoring tool.
## In Cloud mode, the metrics produced will be stored and available in your Cloud Console
## In stand-alone mode metrics are stored for ............. and you can access live monitoring of your potomatic on your network at http://<YOUR-PI-HOSTNAME>:9090

# Exit immediately if any command returns a non-zero exit code
set -e

PROMETHEUS_VERSION=2.22.0
PROMETHEUS_ARCH=linux-armv6
PROMETHEUS_PORT=9090
PROMETHEUS_INSTALL_DIR=/opt
PROMETHEUS_DIR=$PROMETHEUS_INSTALL_DIR/prometheus
POTOMATIC_IP=$(hostname -i)

function abort {
  sudo rm -rf $PROMETHEUS_DIR
  sudo mv $PROMETHEUS_DIR.old $PROMETHEUS_DIR
}

echo "Welcome to the Prometheus installation subroutine"
sleep 1
echo "Providing your Potomatic with full observability."
echo ""
sleep 1

# echo "Setting up the firewall" 
# sleep 1
# # Open the firewall for Prometheus traffic
# sudo iptables -A INPUT -i wlan0 -p tcp --destination $PROMETHEUS_PORT -j ACCEPT
# sudo iptables -A OUTPUT -o wlan0 -p tcp -m state --state RELATED,ESTABLISHED -source $PROMETHEUS_PORT -j ACCEPT
# sleep 1

if [ -d "$PROMETHEUS_DIR" ]; then
  # Delete the Prometheus directory and its contents if it exists
  echo "Previous installation detected. Removing..."
  sudo mv $PROMETHEUS_DIR $PROMETHEUS_DIR.old
fi

sudo mkdir -p $PROMETHEUS_DIR || { echo "Error creating directory $PROMETHEUS_DIR. Aborting..." >&2; abort; exit 1; }

echo "Downloading package"
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

sudo wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz --directory-prefix=$PROMETHEUS_INSTALL_DIR && echo "Package downloaded"

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

echo "Unpacking..."
sudo tar xfz $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz -C $PROMETHEUS_DIR --strip-components=1
sudo rm $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz

if [ $? -eq 1 ]; then
    echo "[ERROR] deleting file $PROMETHEUS_INSTALL_DIR/prometheus-${PROMETHEUS_VERSION}.${PROMETHEUS_ARCH}.tar.gz" >&2
    echo "Please try again manually, or re-run this script"
    exit 1
fi

echo "Setting up, securing and starting Prometheus"
sleep 1
cp ../files/prometheus/* $PROMETHEUS_DIR
cd $PROMETHEUS_DIR

echo "Generating SSL certificate"
sleep 1
if ! command -v openssl > /dev/null; then
  # Install openssl if it is not present
  echo "[ERROR] openssl not found. Installing..."
  if ! command -v apt-get > /dev/null; then
    echo "[ERROR] apt-get is not installed. Please install apt-get and try again." >&2
    abort
    exit 1
  fi
  sudo apt-get update -y
  sudo apt-get install -y openssl
fi

openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout prometheus.key -out prometheus.crt -subj "/C=FR/ST=Lille/L=Brasschaat/O=Potomatic/CN=localhost" -addext "subjectAltName = DNS:potomatic"

if [ $? -ne 0 ]; then
    echo "[ERROR] generating SSL certificate."
    sleep 1
    echo " Please check and try again, or re-run this script"
    abort
    exit 1
fi

echo "Starting Prometheus..."
sleep 1
./prometheus --config.file=$PROMETHEUS_DIR/prometheus.yml &

if [ $? -ne 0 ]; then
    echo "[ERROR] starting Prometheus."
    echo " Please check and try again, or re-run this script"
    abort
    exit 1
fi

echo "All done !!"
echo "Browse to http://${POTOMATIC_IP}:9090 from any device on your home network to inspect your metrics"
