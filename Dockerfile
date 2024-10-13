FROM eclipse-temurin:22.0.1_8-jre-ubi9-minimal
# Copy the executable JAR file from build stage to /app directory in container and rename it to app.jar
COPY --from=build /app/target/*.jar /app/app.jar

# Expose the port on which your Spring application will run (change as per your application)
EXPOSE 8181

# Set the command to run your Spring application when the container starts
CMD ["java", "-jar", "/app/app.jar"]
