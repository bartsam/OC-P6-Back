# =========================================
# Stage 1: Build the Spring Boot Application
# =========================================
ARG JDK_VERSION=21-jdk
ARG JRE_VERSION=21-jre

# Use a JDK image for building (customizable via ARG)
FROM eclipse-temurin:${JDK_VERSION} AS build

# Set the working directory inside the container
WORKDIR /workspace

# Copy the Gradle wrapper and build configuration.
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle

# Download project dependencies using the Gradle cache mount
RUN --mount=type=cache,target=/root/.gradle ./gradlew dependencies --no-daemon

# Copy the rest of the application source code into the container
COPY src ./src

# Compile and package the executable Spring Boot WAR
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew bootWar --no-daemon

# =========================================
# Stage 2: Run the Application with a Lightweight JRE
# =========================================

FROM eclipse-temurin:${JRE_VERSION} AS runner

# Create a dedicated non-root user and group for running the application
RUN addgroup --system spring && adduser --system --ingroup spring spring

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged WAR from the build stage to the runtime image
COPY --from=build /workspace/build/libs/*.war app.war

# Ensure the non-root user owns the application files
RUN chown spring:spring app.war

# Switch to the non-root user for security best practices
USER spring:spring

# Document that the application listens on port 8080
EXPOSE 8080

# Start the Spring Boot application (executable WAR with embedded server)
ENTRYPOINT ["java", "-jar", "app.war"]
