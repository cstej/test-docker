#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Log in to the Docker registry
echo "Logging in to Docker registry..."
echo "$DOCKER_REGISTRY_PASSWORD" | docker login "$DOCKER_REGISTRY_URL" -u "$DOCKER_REGISTRY_USER" --password-stdin

# Check if login was successful
if [ $? -ne 0 ]; then
  echo "Docker login failed. Exiting..."
  exit 1
fi

# Run Docker Compose
echo "Starting Docker Compose..."
docker compose -p "$DOCKER_COMPOSE_PROJECT_NAME" -f "$DOCKER_COMPOSE_FILE" up -d --build --remove-orphans

# Check if Docker Compose ran successfully
if [ $? -ne 0 ]; then
  echo "Docker Compose failed. Exiting..."
  exit 1
fi

echo "Deployment completed successfully!"
