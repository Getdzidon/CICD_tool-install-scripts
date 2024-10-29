#!/bin/bash

# No2. ON TOMCAT SERVER (Can be used when deploying directly from Maven to Tomcat)
# tomcat installation

# update and upgrade of ubuntu
sudo apt update -y && sudo apt upgrade -y

#Variables
TOMCAT_BASE_VERSION="tomcat-9"
TOMCAT_VERSION="9.0.96"          # Set the version you want to install
TOMCAT_FOLDER="tomcat9"          # Desired directory name for Tomcat
TOMCAT_USER="admin"              # Admin username
TOMCAT_PASSWORD="admin"           # Admin password
TOMCAT_TAR="apache-tomcat-${TOMCAT_VERSION}.tar.gz"  # Tomcat tar file name
TOMCAT_URL="https://dlcdn.apache.org/tomcat/${TOMCAT_BASE_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR}"
EXTACTED_TOMCAT_FOLDER="apache-tomcat-${TOMCAT_VERSION}/" # Extracted folder name

# move to opt dir for instalation
cd /opt
# install and verify java
sudo apt install openjdk-11-jdk -y
java -version

# install and extract tomcat
# be sure to check the lattest version https://tomcat.apache.org/whichversion.html && https://archive.apache.org/dist/tomcat/tomcat-9/
echo "Downloading Tomcat ${TOMCAT_VERSION}..."
sudo wget ${TOMCAT_URL}
sudo tar -xzvf ${TOMCAT_TAR}

# remove zip file and rename extracted file
# The version name musst correspond with the version you runned above so ensure you make all changes
sudo rm -rf ${TOMCAT_TAR}
sudo mv ${EXTACTED_TOMCAT_FOLDER}/ ${TOMCAT_FOLDER}


# give executable permissions (Make sure the name of the tomcat dir matches as above)
sudo chmod 777 -R /opt/${TOMCAT_FOLDER}

# Alternatively, Set appropriate permissions. Instead of granting chmod 777 permissions to all Tomcat files, chmod -R 755 for directories and chmod -R 644 for files within Tomcat’s home directory is generally sufficient for security.
# sudo chmod -R 755 /opt/${TOMCAT_FOLDER}
# sudo chmod -R 644 /opt/${TOMCAT_FOLDER}/conf
# sudo chmod -R 755 /opt/${TOMCAT_FOLDER}/bin /opt/${TOMCAT_FOLDER}/lib /opt/${TOMCAT_FOLDER}/webapps

# create symbolic (shortcut/short link) links to start/stop tomcat (Make sure the name of the tomcat dir matches as above)
sudo ln -s /opt/${TOMCAT_FOLDER}/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/${TOMCAT_FOLDER}/bin/shutdown.sh /usr/bin/stoptomcat

# start/stop tomcat
sudo starttomcat

echo "Tomcat installation complete!"


# Function to modify context.xml
modify_context_xml() {
  context_xml_file="/opt/${TOMCAT_FOLDER}/webapps/manager/META-INF/context.xml"
  cp "$context_xml_file" "$context_xml_file.bak"
  echo "Modifying $context_xml_file ..."

  # Comment out the <Valve> element in context.xml
  sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ {N; s#<Valve className="org.apache.catalina.valves.RemoteAddrValve".*allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" />#<!--\n &\n-->#; }' "$context_xml_file"

  echo "$context_xml_file has been modified."
}
 
# separating instalation with modifications 

# Function to modify the tomcat-users.xml file
modify_tomcat_users_xml() {
  tomcat_users_xml_file="/opt/${TOMCAT_FOLDER}/conf/tomcat-users.xml"

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
modify_context_xml
modify_tomcat_users_xml

echo "Tomcat installation and all modifications complete!"
