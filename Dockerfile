# Stage 1: Build the Spring Boot application
FROM eclipse-temurin:17-jdk-focal AS builder
WORKDIR /app

# Copy Gradle wrapper and project files
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
COPY src src

# Make wrapper executable
RUN chmod +x gradlew

# Build the app (skip tests to speed up)
RUN ./gradlew bootJar -x test

# Stage 2: Create runtime image
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

# Copy built JAR from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
