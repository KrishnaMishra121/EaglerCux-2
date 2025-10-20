FROM openjdk:17-jdk-slim

WORKDIR /app
COPY server.jar .
COPY server.properties .
COPY plugins ./plugins

EXPOSE 25565
CMD ["java", "-jar", "server.jar", "nogui"]
