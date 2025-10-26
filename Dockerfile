# Stage 1: Build the Spring Boot application
FROM eclipse-temurin:17-jdk-focal AS builder

WORKDIR /app

# Copy Gradle wrapper and gradle folder
COPY gradlew .
COPY gradle gradle

# Copy build files
COPY build.gradle settings.gradle .

# Copy source code
COPY src src

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Build the executable JAR
RUN ./gradlew bootJar -x test

# Stage 2: Runtime image
FROM eclipse-temurin:17-jre-focal

WORKDIR /app

# Copy JAR from builder stage
# Make sure JAR name matches your project (Youtube_Tools-0.0.1-SNAPSHOT.jar)
COPY --from=builder /app/build/libs/Youtube_Tools-0.0.1-SNAPSHOT.jar app.jar

# Expose port (check application.properties)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
