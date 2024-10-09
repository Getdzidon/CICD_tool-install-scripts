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
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz
sudo tar -xzvf apache-tomcat-9.0.96.tar.gz

# remove zip file and rename extracted file
# The version name musst correspond with the version you runned above so ensure you make all changes
sudo rm -rf apache-tomcat-9.0.96.tar.gz
sudo mv apache-tomcat-9.0.96/ tomcat9


# give executable permissions (Make sure the name of the tomcat dir matches as above)
sudo chmod 777 -R /opt/tomcat9

# create symbolic (shortcut/short link) links to start/stop tomcat (Make sure the name of the tomcat dir matches as above)
sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat

# start/stop tomcat
sudo starttomcat

echo "Tomcat installation complete!"


# Function to modify context.xml
modify_context_xml() {
  context_xml_file="/opt/tomcat9/webapps/manager/META-INF/context.xml"
  cp "$context_xml_file" "$context_xml_file.bak"
  echo "Modifying $context_xml_file ..."

  # Comment out the <Valve> element in context.xml
  sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ {N; s#<Valve className="org.apache.catalina.valves.RemoteAddrValve".*allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" />#<!--\n &\n-->#; }' "$context_xml_file"

  echo "$context_xml_file has been modified."
}
 
# separating instalation with modifications 

# Function to modify the tomcat-users.xml file
modify_tomcat_users_xml() {
  tomcat_users_xml_file="/opt/tomcat9/conf/tomcat-users.xml"

  if [ -f "$tomcat_users_xml_file" ]; then
    # Backup the original file
    cp "$tomcat_users_xml_file" "$tomcat_users_xml_file.bak"
    echo "Modifying $tomcat_users_xml_file ..."

    # Add new user lines before the closing </tomcat-users> tag
    sed -i '/<\/tomcat-users>/i\
 <user username="admin" password="admin" roles="manager-gui, manager-script, admin-gui, manager-status"/>\
 <user username="jomacs" password="jomacs" roles="manager-script, manager-gui, admin-gui"/>' "$tomcat_users_xml_file"

    echo "$tomcat_users_xml_file has been modified."
  else
    echo "tomcat-users.xml file not found!"
  fi
}

# Call the functions
modify_context_xml
modify_tomcat_users_xml

echo "Tomcat installation and all modifications complete!"
