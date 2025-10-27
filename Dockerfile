# Stage 1: Build the Spring Boot application
FROM eclipse-temurin:18-jdk-focal AS builder
WORKDIR /app

# Copy all project files at once
COPY . .

# Build Spring Boot fat JAR (skip tests)
RUN ./gradlew bootJar -x test || gradle bootJar -x test

# Stage 2: Runtime image
FROM eclipse-temurin:18-jre-focal
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
