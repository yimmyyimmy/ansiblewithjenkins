FROM tomcat
COPY target/SimpleWebApplication*.war /usr/local/tomcat/webapps/SimpleWebApplication.war
