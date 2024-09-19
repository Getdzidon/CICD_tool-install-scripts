#!/bin/bash

# No1. ON MAVEN SERVER
# Maven installation script

# Update and upgrade the Ubuntu EC2 instance
sudo apt update -y
sudo apt upgrade -y

cd /opt
# Install Java 11 and Git
sudo apt install openjdk-11-jdk git -y

# Verify the installation of Java and Git
java -version
git --version

# Install and extract Maven zip file
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.8-bin.tar.gz

# Remove zip file and rename the extracted directory to maven
sudo rm -rf apache-maven-3.9.8-bin.tar.gz
sudo mv apache-maven-3.9.8/ maven

# Set environmental variables for Maven
echo "export M2_HOME=/opt/maven" | sudo tee -a /home/ubuntu/.bashrc
echo "export PATH=\$PATH:\$M2_HOME/bin" | sudo tee -a /home/ubuntu/.bashrc

# Notify user to source the .bashrc file manually
echo "Please run 'source /home/ubuntu/.bashrc' or restart your session to apply the changes., then run 'mvn -version' "

# Verify Maven installation (will work if environment variables are applied)
source /home/ubuntu/.bashrc
mvn -version

echo "Maven installation complete!"

# if you receive the error "mavin.sh: line 36: mvn: command not found", 
# rerun "source /home/ubuntu/.bashrc" and "mvn -version"

# NOTE
# setting environmental variables for maven (note ~/.bashrc means the file is in /home/ubuntu/.bashrc. 
# Run ls -a under ubuntu to view

# My observation
# I noticed Running the following commands appended the environmental variables to .bashrc file under the root user ref: "sudo cat /root/.bashrc" 
# As ~/ (tilde slash) from ~/.bashrc is refering to the home directory
# why?
###echo "export M2_HOME=/opt/maven" >> ~/.bashrc
###echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bashrc
