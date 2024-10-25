#!/bin/bash

# Nexus Installation Script on Ubuntu
# Note: Designed for a t2.large EC2 instance

# Variables
NEXUS_VERSION="3.72.0-04"      # Set the version you want to install
NEXUS_USER="nexus"    # User to run Nexus
NEXUS_PASSWORD="admin"          # Password to run Nexus
INSTALL_DIR="/opt/nexus"       # Installation directory
DATA_DIR="/opt/sonatype-work"  # Nexus data directory
NEXUS_TAR="nexus-${NEXUS_VERSION}-unix.tar.gz"  # Nexus tar file name
NEXUS_URL="https://download.sonatype.com/nexus/3/${NEXUS_TAR}"

# Update and upgrade packages
sudo apt update -y && sudo apt upgrade -y

#### Create a new user called nexus with no password prompt for sudo commands
echo "Creating Nexus user..."
sudo adduser --gecos "" --disabled-password ${NEXUS_USER}
echo "${NEXUS_USER}:${NEXUS_PASSWORD}" | sudo chpasswd

echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus

# Install and verify Java (OpenJDK 17)
cd /opt
sudo apt install openjdk-17-jdk -y
java -version

# Download and extract Nexus
cd /opt
echo "Downloading Nexus ${NEXUS_VERSION}..."
sudo wget ${NEXUS_URL}
sudo tar -xzvf ${NEXUS_TAR}
sudo rm -rf ${NEXUS_TAR}
sudo mv nexus-${NEXUS_VERSION} nexus

# Change ownership of Nexus and its data directories
sudo chown -R ${NEXUS_USER}:${NEXUS_USER} ${INSTALL_DIR}
sudo chown -R ${NEXUS_USER}:${NEXUS_USER} ${DATA_DIR}

# Set 'run_as_user' in nexus.rc
sudo sed -i 's/#run_as_user=/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc

# Create a systemd service file for Nexus
sudo bash -c 'cat > /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and start Nexus
sudo systemctl daemon-reload
sudo systemctl start nexus.service
sudo systemctl enable nexus.service
sudo systemctl status nexus.service

# Wait for Nexus to start and display the initial admin password
echo "Waiting for Nexus to initialize..."
sleep 30  # Allow time for Nexus to generate initial files

echo "Initial admin password:"
sudo cat ${DATA_DIR}/nexus3/admin.password # sudo cat /opt/sonatype-work/nexus3/admin.password

echo "Nexus installation complete. Access it at http://<your-server-ip>:8081"
