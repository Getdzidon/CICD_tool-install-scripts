    1. Set up 2 instances and name them maven and tomcat

    2. Allow port 8080 for inbound rules on tomcat server

    3. Run maven1.sh on Maven server (Updates the server, installs java 11, git and  Maven)
   
Create a file, nano maven1.sh or vim maven1.sh then copy and paste the script and make it executable 
– If you receive the error "mavin1st.sh: line xx: mvn: command not found",
rerun "source ~/.bashrc" and check "mvn -version

    4. Clone the project to your instance - git clone <github-url> (I did cloned mine to the /home/ubuntu dir. If you clone your in a different directory, you will need to modify the variables on the next script, maven2.sh to reflect that.
- Here is how to clone the repo for the web app
git clone https://github.com/JOMACS-IT/web-app.git

Run: cd web-app (use the right path to your cloned project)
Then Run mvn clean package in the  directory containing the pom.xml file

Or

Start run the following maven goals: one after the other
mvn clean
mvn validate
mvn compile
mvn test-compile
mvn test
mvn package

    5. Run tomcat_install.sh on Tomcat server (Updates the server, installs Tomcat and configures the context.xml and tomcat-users.xml files)

Create a file, nano tomcat_install.sh or vim tomcat_install.sh then copy and paste the script and make it executable 
- You can as well paste this script as a User data file as bootstrap during launching the instance so it installs Tomcat while the server is launching

Note: 
- Be sure to use the current version of Tomcat in the script (Ref: https://archive.apache.org/dist/tomcat/tomcat-9/)
- Also make changes to variables in the script depending on your need

    6. Check if you can access the Tomcat interface using http://<tomcat-server-public-ip>:8080
Eg: http://3.121.185.96:8080

Click on the Manager App and log in with the credentials you set (it is set for user= admin and password= admin for my script. you can modify it in tomcat1.sh)

    7. Run maven2.sh on the Maven Sever (creates  Settings.xml file and appends maven-to-tomcat plugin on the pom.xml file)

Create a file, nano maven2.sh or vim maven1.sh then copy and paste the script and make it executable

    8. run  mvn tomcat7:deploy on the Maven server in the dir containing your pom.xml file

    9. Lunch your website/application

http://<public-ip-of-the-tomcatserver>:8080/<name-of-deployed folder>
Eg: 
http://18.184.215.249:8080/maven-web-application/

Done!!
