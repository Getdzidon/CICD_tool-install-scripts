#!/bin/bash

# No2. ON TOMCAT SERVER
# tomcat installation

# update and upgrade of ubuntu
sudo apt update -y
sudo apt upgrade -y

# install and verify java
sudo apt install openjdk-11-jdk -y
java -version

# install and extract tomcat
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz
sudo tar -xzvf apache-tomcat-9.0.93.tar.gz

# remove zip file and rename extracted file
sudo rm -rf apache-tomcat-9.0.93.tar.gz
sudo mv apache-tomcat-9.0.93/ /opt/tomcat9

# give executable permissions
sudo chmod 777 -R /opt/tomcat9

# create symbolic (shortcut/short link) links to start/stop tomcat
sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat

# start/stop tomcat
sudo starttomcat

echo "Tomcat installation complete!"