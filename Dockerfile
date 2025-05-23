FROM openjdk:17-jdk-alpine

WORKDIR /app

ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} sample.jar

EXPOSE 8084

ENTRYPOINT [ "java", "-jar", "sample.jar" ]
