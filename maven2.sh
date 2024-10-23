#!/bin/bash

# No4. ON MAVEN SERVER
# The script will automate the process of:

# 1. Navigating to the .m2 directory.
# 2. Creating and configuring the settings.xml file for Maven.
# 3. Editing the pom.xml file to include the Tomcat plugin.
# 4. Deploying the application to Tomcat using Maven by running mvn tomcat7:deploy command

# What the script does:
# Step 1: Navigate to the ~/.m2 directory and create the settings.xml file with the Tomcat server credentials.
# Step 2: Edits the pom.xml file to add the Tomcat Maven plugin if it isn't already there.
# Step 3: Run the mvn tomcat7:deploy command to deploy your Maven project to Tomcat.

# Variables (you can modify these as needed)
USER=ubuntu # state your username
M2_DIR="/home/${USER}/.m2"
APP_DIR="/home/${USER}/web-app" #make sure you change this name "web-app if that is not exactly the name of the directory containing your source code"
SETTINGS_FILE="${M2_DIR}/settings.xml"
POM_FILE="${APP_DIR}/pom.xml"  # Ensure you run the script from the root directory of your project
TOMCAT_USERNAME="admin"  # Set your Tomcat username
TOMCAT_PASSWORD="admin"  # Set your Tomcat password
TOMCAT_SERVER_ID="TomcatServer"
TOMCAT_URL="http://18.199.160.156:8080/manager/text"  # Change IP to your Tomcat server's IP if needed
TOMCAT_PLUGIN_VERSION="2.2" #change the version where necessary

# Step 1: Create settings.xml in the .m2 directory
echo "Navigating to .m2 directory..."
cd $M2_DIR

echo "Creating settings.xml file..."
cat <<EOL > $SETTINGS_FILE
<settings>
  <servers>
    <server>
      <id>${TOMCAT_SERVER_ID}</id>
      <username>${TOMCAT_USERNAME}</username>
      <password>${TOMCAT_PASSWORD}</password>
    </server>
  </servers>
</settings>
EOL

echo "settings.xml file created."

cd $APP_DIR

# Step 2: Update pom.xml to add Tomcat Maven Plugin
if [ -f "$POM_FILE" ]; then
  echo "Editing pom.xml file to add Tomcat Maven Plugin..."
  
  # Check if the plugin already exists, if not, add it
  if ! grep -q "<artifactId>tomcat7-maven-plugin</artifactId>" $POM_FILE; then
 
    # Add the plugin with proper formatting and indentation just before the closing </plugins> tag
    sed -i "/<\/plugins>/i\ \ \ \ <plugin>\n\ \ \ \ \ \ <groupId>org.apache.tomcat.maven<\/groupId>\n\ \ \ \ \ \ <artifactId>tomcat7-maven-plugin<\/artifactId>\n\ \ \ \ \ \ <version>${TOMCAT_PLUGIN_VERSION}<\/version>\n\ \ \ \ \ \ <configuration>\n\ \ \ \ \ \ \ \ <server>${TOMCAT_SERVER_ID}<\/server>\n\ \ \ \ \ \ \ \ <url>${TOMCAT_URL}<\/url>\n\ \ \ \ \ \ <\/configuration>\n\ \ \ \ <\/plugin>" $POM_FILE

    echo "Tomcat Maven Plugin added to pom.xml."
  else
    echo "Tomcat Maven Plugin already exists in pom.xml."
  fi
else
  echo "pom.xml file not found. Make sure you're in the directory of your project."
  exit 1
fi

# Step 3: Run Maven deploy command
echo "Deploying application to Tomcat..."

# mvn tomcat7:deploy

# Finish
echo "Deployment completed."
