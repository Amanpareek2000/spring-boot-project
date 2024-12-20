# Stage 1: Build Stage
FROM maven:3.8.5-eclipse-temurin-17-alpine AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Production Stage
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy built application jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Configure environment variables for runtime (secure secrets through .env or Docker secrets)
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Add health check (example with curl)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Entry point for the application with support for custom Java options
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
