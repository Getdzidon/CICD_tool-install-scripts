#!/bin/bash

# No3: On the TOMCAT server

# Tomcat Configurations:

# Add the port mumber of Tomcat server security group
# http://tomcat-server-public-ip-address:8080 

# To gain access to Tomcat's manager's page, you must edit the context.xml file

# Define file paths
CONTEXT_XML="/opt/tomcat9/webapps/manager/META-INF/context.xml"
USERS_XML="/opt/tomcat9/conf/tomcat-users.xml"

# Backup the original files before making any changes
echo "Backing up original files..."
sudo cp $CONTEXT_XML "${CONTEXT_XML}.bak"
sudo cp $USERS_XML "${USERS_XML}.bak"
echo "Backup completed."

# Edit context.xml to comment out RemoteAddrValve lines
echo "Modifying context.xml to comment out RemoteAddrValve..."
sudo sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/,/<\/Valve>/s/^/<!--/g' $CONTEXT_XML
sudo sed -i '/<\/Valve>/s/$/ -->/g' $CONTEXT_XML
echo "context.xml modification completed."

# Edit tomcat-users.xml to update users
echo "Updating tomcat-users.xml with new user configurations..."
sudo sed -i '/<user username=/d' $USERS_XML
sudo bash -c "cat >> $USERS_XML <<EOL
<user username=\"admin\" password=\"admin\" roles=\"manager-gui, manager-script, admin-gui, manager-status\"/>
<user username=\"jomacs\" password=\"jomacs\" roles=\"manager-script, manager-gui, admin-gui\"/>
EOL"

# Note: Update the password and username above.

echo "tomcat-users.xml update completed."

# Provide feedback
echo "Tomcat configuration updated successfully. Original files are backed up with .bak extension."
