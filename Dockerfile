#FROM docker.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:latest
#RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
#COPY ./*.war /usr/local/tomcat/webapps

FROM openjdk:8-jdk-alpine
MAINTAINER Your Name <your.email@example.com>

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"

# download and install tomcat
RUN wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.63/bin/apache-tomcat-8.5.63.tar.gz \
    && tar -xvf apache-tomcat-8.5.63.tar.gz -C $CATALINA_HOME --strip-components=1 \
    && rm apache-tomcat-8.5.63.tar.gz

# create a tomcat user
RUN adduser -D -s /bin/sh tomcat
RUN chown -R tomcat:tomcat $CATALINA_HOME

USER tomcat
EXPOSE 8080
CMD ["catalina.sh", "run"]

