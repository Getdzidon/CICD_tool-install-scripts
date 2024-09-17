#!/bin/bash

# No4. ON MAVEN SERVER
# The script will automate the process of:

# 1. Navigating to the .m2 directory.
# 2. Creating and configuring the settings.xml file for Maven.
# 3. Editing the pom.xml file to include the Tomcat plugin.
# 4. Deploying the application to Tomcat using Maven by running mvn tomcat7:deploy command

# What the script does:
# Step 1: Navigates to the ~/.m2 directory and creates the settings.xml file with the Tomcat server credentials.
# Step 2: Edits the pom.xml file to add the Tomcat Maven plugin if it isn't already there.
# Step 3: Runs the mvn tomcat7:deploy command to deploy your Maven project to Tomcat.

# Variables (you can modify these as needed)
M2_DIR="$HOME/.m2"
SETTINGS_FILE="$M2_DIR/settings.xml"
POM_FILE="pom.xml"  # Ensure you run the script from the root directory of your project
TOMCAT_USERNAME="admin"  # Set your Tomcat username
TOMCAT_PASSWORD="admin"  # Set your Tomcat password
TOMCAT_SERVER_ID="TomcatServer"
TOMCAT_URL="http://localhost:8080/manager/text"  # Change localhost to your Tomcat server's IP if needed
TOMCAT_PLUGIN_VERSION="2.1"

# Step 1: Create settings.xml in the .m2 directory
echo "Navigating to .m2 directory..."
mkdir -p $M2_DIR
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

# Step 2: Update pom.xml to add Tomcat Maven Plugin
if [ -f "$POM_FILE" ]; then
  echo "Editing pom.xml file to add Tomcat Maven Plugin..."
  
  # Check if the plugin already exists, if not, add it
  if ! grep -q "<artifactId>tomcat7-maven-plugin</artifactId>" $POM_FILE; then
    sed -i "/<\/plugins>/i \
    <plugin> \
      <groupId>org.apache.tomcat.maven</groupId> \
      <artifactId>tomcat7-maven-plugin</artifactId> \
      <version>${TOMCAT_PLUGIN_VERSION}</version> \
      <configuration> \
        <server>${TOMCAT_SERVER_ID}</server> \
        <url>${TOMCAT_URL}</url> \
      </configuration> \
    </plugin>" $POM_FILE

    echo "Tomcat Maven Plugin added to pom.xml."
  else
    echo "Tomcat Maven Plugin already exists in pom.xml."
  fi
else
  echo "pom.xml file not found. Make sure you're in the root directory of your Maven project."
  exit 1
fi

# Step 3: Run Maven deploy command
echo "Deploying application to Tomcat..."

mvn tomcat7:deploy

# Finish
echo "Deployment completed."
