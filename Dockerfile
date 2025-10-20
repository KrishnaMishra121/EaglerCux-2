# Use OpenJDK 17 slim (lightweight)
FROM openjdk:17-jdk-slim

LABEL maintainer="Krishna Mishra"

# Install required tools
RUN apt-get update && apt-get install -y curl jq && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PAPER_VERSION=1.20.2 \
    HEAP_MIN=512M \
    HEAP_MAX=2G \
    SERVER_JAR=paper.jar \
    EULA=true

# Set working directory
WORKDIR /minecraft

# Download latest PaperMC build
RUN LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION} | jq '.builds | last') && \
    echo "Latest build: $LATEST_BUILD" && \
    curl -o ${SERVER_JAR} https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/$LATEST_BUILD/downloads/paper-${PAPER_VERSION}-${LATEST_BUILD}.jar && \
    chmod +x ${SERVER_JAR}

# Accept EULA automatically
RUN echo "eula=${EULA}" > eula.txt

# Expose default Minecraft port
EXPOSE 25565

# Start server with memory settings
CMD ["sh", "-c", "java -Xms${HEAP_MIN} -Xmx${HEAP_MAX} -jar ${SERVER_JAR} nogui"]
