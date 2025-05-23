FROM openjdk:17-jdk-alpine

WORKDIR /app

ARG JAR_FILE=target/*.jar

COPY ./target/sample-info-0.0.1-SNAPSHOT.jar sample.jar

EXPOSE 8084

ENTRYPOINT [ "java", "-jar", "sample.jar" ]
