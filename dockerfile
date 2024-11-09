# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
# Set environment variables for MySQL connection
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql-db:3306/crud-app?serverTimezone=UTC
ENV SPRING_DATASOURCE_USERNAME=habui
ENV SPRING_DATASOURCE_PASSWORD=pass

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
