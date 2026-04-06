#!/bin/bash
set -e
cd "$(dirname "$0")"

copy_war() {
  src="$1"
  dst="$2"
  if [ ! -f "$src" ]; then
    echo "Missing WAR: $src"
    exit 1
  fi
  cp "$src" "$dst"
}

if command -v mvn >/dev/null 2>&1; then
  echo "==> Building WARs..."
  (cd frontend && mvn clean package -q)
  (cd search-service && mvn clean package -q)
  (cd appointment-service && mvn clean package -q)
else
  echo "==> Maven not found, using existing WAR files from target/ if present..."
fi

echo "==> Copying WARs to Docker folder..."
copy_war frontend/target/frontend.war Docker-Lab5Microservices/
copy_war search-service/target/search-service.war Docker-Lab5Microservices/
copy_war appointment-service/target/appointment-service.war Docker-Lab5Microservices/

echo "==> Starting all containers..."
docker compose up --build
