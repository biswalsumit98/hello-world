# Use a Maven image as the base image
FROM maven:3.6.3-jdk-11

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Download the dependencies to a local repository in the container
RUN mvn dependency:go-offline

# Copy the rest of the project files to the container
COPY src src

# Build the project with Maven
RUN mvn package

# Specify the command to run when the container starts
CMD java -jar target/*.jar
