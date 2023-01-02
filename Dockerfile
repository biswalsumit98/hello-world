FROM jboss-eap-7/eap74-openjdk11-openshift-rhel8:latest
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps
