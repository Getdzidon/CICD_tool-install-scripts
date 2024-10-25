#!/bin/bash

# No3: On the TOMCAT server

# Tomcat Configurations:

# Add the port number of Tomcat server security group
# http://tomcat-server-public-ip-address:8080 

# To gain access to Tomcat's manager's page, you must edit the context.xml file

# Define file paths (Make sure the name of the tomcat dir matches with the version you installed)
CONTEXT_XML="/opt/tomcat9/webapps/manager/META-INF/context.xml"
USERS_XML="/opt/tomcat9/conf/tomcat-users.xml"
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="admin"
USER2_USERNAME="jomacs"
USER2_PASSWORD="jomacs"

# Backup the original files before making any changes
echo "Backing up original files..."
sudo cp $CONTEXT_XML "${CONTEXT_XML}.bak"
sudo cp $USERS_XML "${USERS_XML}.bak"
echo "Backup completed."

# Step 1: Uncomment the <Context> block and comment out the <Valve> line.
if [ -f "$CONTEXT_XML" ]; then
  echo "Editing $CONTEXT_XML..."

  # Use sed to:
  # - Uncomment the <Context> line by removing the surrounding <!-- and -->
  # - Comment the <Valve> line by adding <!-- and -->
  
  sed -i '/<!--/,/-->/{ s/^<!--//; s/-->$//; }' $CONTEXT_XML    # Uncomment the block
  sed -i '/<Valve className=/,/\/>/ s/^/   <!--/' $CONTEXT_XML   # Comment out <Valve> block
  sed -i '/<Valve className=/,/\/>/ s/$/ -->/' $CONTEXT_XML      # Close the comment block after <Valve>
  
  echo "context.xml successfully edited."
else
  echo "File $CONTEXT_XML not found!"
  exit 1
fi


# Step 2: Remove comment markers and replace the user lines
if [ -f "$USERS_XML" ]; then
  echo "Editing $USERS_XML..."

  # Use sed to:
  # - Uncomment the block (remove <!-- and -->)
  # - Replace the user lines with new entries

  # Uncomment the block by removing <!-- and -->
  sed -i '/<!--/,/-->/ { s/<!--//; s/-->//; }' $USERS_XML

  # Replace the user lines with the new user configuration
  sed -i "/<user username=\"$ADMIN_USERNAME\"/c\<user username=\"$ADMIN_USERNAME\" password=\"$ADMIN_PASSWORD\" roles=\"manager-gui, manager-script, admin-gui, manager-status\"/>" $USERS_XML
  sed -i "/<user username=\"robot\"/c\<user username=\"$USER2_USERNAME\" password=\"$USER2_PASSWORD\" roles=\"manager-script, manager-gui, admin-gui\"/>" $USERS_XML

  echo "tomcat-users.xml successfully edited."
else
  echo "File $USERS_XML not found!"
  exit 1
fi


# Provide feedback
echo "Tomcat configuration updated successfully. Original files are backed up with .bak extension."

