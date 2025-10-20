# Base image with OpenJDK 17 (recommended for latest PaperMC)
FROM openjdk:17-jdk-slim

# Maintainer info
LABEL maintainer="Krishna Mishra <your-email@example.com>"

# Set environment variables
ENV PAPER_VERSION=1.20.2 \
    HEAP_MIN=512M \
    HEAP_MAX=2G \
    SERVER_JAR=paper-${PAPER_VERSION}.jar \
    EULA=true

# Create a working directory for Minecraft server
WORKDIR /minecraft

# Download PaperMC jar
RUN apt-get update && apt-get install -y curl && \
    curl -o ${SERVER_JAR} https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/1/downloads/${SERVER_JAR} && \
    chmod +x ${SERVER_JAR} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Accept EULA automatically
RUN echo "eula=${EULA}" > eula.txt

# Expose Minecraft default port
EXPOSE 25565

# Set JVM args & start server
CMD ["sh", "-c", "java -Xms${HEAP_MIN} -Xmx${HEAP_MAX} -jar ${SERVER_JAR} nogui"]
