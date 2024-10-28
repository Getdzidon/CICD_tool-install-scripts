#!/bin/bash

# Maven installation script

# Update and upgrade the Ubuntu EC2 instance
sudo apt update -y && sudo apt upgrade -y

#Variables
MAVEN_BASE_VERSION="maven-3"
MAVEN_VERSION="3.9.8"          # Set the version you want to install
MAVEN_FOLDER="maven"          # Desired directory name for Maven
MAVEN_TAR="apache-maven-${MAVEN_VERSION}-bin.tar.gz"  # Maven tar file name
MAVEN_URL="https://dlcdn.apache.org/maven/${MAVEN_BASE_VERSION}/${MAVEN_VERSION}/binaries/${MAVEN_TAR}"
EXTACTED_MAVEN_FOLDER="apache-maven-${MAVEN_VERSION}/" # Extracted folder name
# Variables (you can modify these as needed)
USER=ubuntu # state your username
M2_DIR="/home/${USER}/.m2"
SOURCE_CODE_DIR="/home/${USER}/web-app" #make sure you change this name "web-app if that is not exactly the name of the directory containing your source code"
SETTINGS_FILE="${M2_DIR}/settings.xml"
POM_FILE="${SOURCE_CODE_DIR}/pom.xml"  # Ensure you run the script from the root directory of your project
TOMCAT_USERNAME="admin"  # Set your Tomcat username
TOMCAT_PASSWORD="admin"  # Set your Tomcat password
TOMCAT_SERVER_ID="TomcatServer"
TOMCAT_URL="http://18.199.160.156:8080/manager/text"  # Change IP to your Tomcat server's IP if needed
TOMCAT_PLUGIN_VERSION="2.2" #change the version where necessary

# Install Java 11 and Git
sudo apt install openjdk-11-jdk git -y

# Verify the installation of Java and Git
java -version
git --version

# Install and extract Maven zip file
cd /opt
sudo wget ${MAVEN_URL}
sudo tar -xvzf ${MAVEN_TAR}

# Remove zip file and rename the extracted directory to 'maven'
sudo rm -rf ${MAVEN_TAR}
sudo mv ${EXTACTED_MAVEN_FOLDER} /opt/${MAVEN_FOLDER}

# Set environment variables for Maven
echo "export M2_HOME=/opt/${MAVEN_FOLDER}" | sudo tee -a /home/ubuntu/.bashrc
echo "export PATH=\$PATH:\$M2_HOME/bin" | sudo tee -a /home/ubuntu/.bashrc

# Notify user to source the .bashrc file manually
echo "Please run 'source ~/.bashrc' or restart your session to apply the changes."

# Verify Maven installation (will work if environment variables are applied)
source ~/.bashrc
mvn -version

echo "Maven installation complete!"
echo "If there is an error above, Please run 'source ~/.bashrc' again"

# if you receive the error "mavin.sh: line 34: mvn: command not found", 
# rerun "source ~/.bashrc" and "mvn -version"

# NOTE
# setting environmental variables for maven (note ~/.bashrc means the file is in /home/ubuntu/.bashrc. 
# Run ls -a under ubuntu to view

#________________________________________________________________________

# Factor Running "mvn clean package here" but this means the source code must have already been in place
# Also make sure the directory for the source code is well defined in the variables above
cd $SOURCE_CODE_DIR
mvn clean package

#________________________________________________________________________

# The below script will automate the process of:

# 1. Navigating to the .m2 directory.
# 2. Creating and configuring the settings.xml file for Maven.
# 3. Editing the pom.xml file to include the Tomcat plugin.
# 4. Deploying the application to Tomcat using Maven by running mvn tomcat7:deploy command

# What the script does:
# Step 1: Navigates to the ~/.m2 directory and creates the settings.xml file with the Tomcat server credentials.
# Step 2: Edits the pom.xml file to add the Tomcat Maven plugin if it isn't already there.
# Step 3: Runs the mvn tomcat7:deploy command to deploy your Maven project to Tomcat.


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

cd $SOURCE_CODE_DIR

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
