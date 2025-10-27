# Stage 1: Build the Spring Boot application
FROM eclipse-temurin:18-jdk-focal AS builder
WORKDIR /app

# Install Gradle inside container
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://services.gradle.org/distributions/gradle-9.1.0-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-9.1.0-bin.zip && \
    rm /tmp/gradle-9.1.0-bin.zip

ENV GRADLE_HOME=/opt/gradle/gradle-9.1.0
ENV PATH=$GRADLE_HOME/bin:$PATH

# Copy project files
COPY . .

# Build Spring Boot fat JAR (skip tests)
RUN gradle bootJar -x test

# Stage 2: Runtime image
FROM eclipse-temurin:18-jre-focal
WORKDIR /app

# Copy built JAR
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run app
ENTRYPOINT ["java", "-jar", "app.jar"]
