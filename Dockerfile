# Build the application with the same Java version used by the project.
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN chmod +x mvnw

COPY src src
RUN ./mvnw -B clean package -DskipTests -DfinalName=app

# Keep the runtime image smaller than the build image.
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/app.war app.war

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
