FROM adoptopenjdk/openjdk11:alpine-jre
WORKDIR /usr/src/app
COPY target/*.jar ./app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
