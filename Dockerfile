# Use an existing image as the base image
FROM tomcat:9-jdk11-openjdk

# Copy the JSP file to the webapps directory in the container
COPY index.jsp /usr/local/tomcat/webapps/ROOT/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container is run
CMD ["catalina.sh", "run"]
