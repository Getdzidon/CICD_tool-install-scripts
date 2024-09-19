#!/bin/bash

# No2. ON TOMCAT SERVER
# tomcat installation

# update and upgrade of ubuntu
sudo apt update -y
sudo apt upgrade -y

cd /opt
# install and verify java
sudo apt install openjdk-11-jdk -y
java -version

# move to opt dir for instalation
cd /opt

# install and extract tomcat
# be sure to check the lattest version https://tomcat.apache.org/whichversion.html && https://archive.apache.org/dist/tomcat/tomcat-9/
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz
sudo tar -xzvf apache-tomcat-9.0.95.tar.gz

# remove zip file and rename extracted file
# The version name musst correspond with the version you runned above so ensure you make all changes
sudo rm -rf apache-tomcat-9.0.95.tar.gz
sudo mv apache-tomcat-9.0.95/ tomcat9


# give executable permissions (Make sure the name of the tomcat dir matches as above)
sudo chmod 777 -R /opt/tomcat9

# create symbolic (shortcut/short link) links to start/stop tomcat (Make sure the name of the tomcat dir matches as above)
sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat

# start/stop tomcat
sudo starttomcat

echo "Tomcat installation complete!"