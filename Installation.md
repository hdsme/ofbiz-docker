# Apache OFBiz Docker Installation Guide

## Overview
This guide provides instructions for setting up Apache OFBiz version 18.12.1 using Docker, based on the provided `.env` file and the publicly available Docker image from [Docker Hub](https://hub.docker.com/r/hdsme/ofbiz).

## Prerequisites
Ensure you have the following installed:
- **Docker**: Install from [Docker's official site](https://docs.docker.com/get-docker/)
- **Docker Compose**: Install from [Docker Compose site](https://docs.docker.com/compose/install/)
- **Git** (optional for cloning configurations): Install from [Git's official site](https://git-scm.com/downloads)

## Step-by-Step Installation

### 1. Pull the Pre-built Docker Image
Instead of building from source, pull the official OFBiz image from Docker Hub:
```bash
docker pull hdsme/ofbiz:18.12.1
```

### 2. Set Up the Environment Variables
Create a `.env` file with the following content:
```env
HTTPS_ENABLED=N
HTTP_ENABLED=Y
HTTP_PORT=80
HTTP_HOST=192.168.2.97
HTTPS_HOST=192.168.2.97
HTTP_PORTS=443
HOST_CORS=localhost,127.0.0.1,demo-trunk.ofbiz.apache.org,demo-stable.ofbiz.apache.org,demo-next.ofbiz.apache.org,192.168.2.97
DB_TYPE=postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=ofbiz
```

### 3. Run the OFBiz Container
Start the OFBiz application with Docker:
```bash
docker run -d --name ofbiz \
  --env-file .env \
  -p 80:80 -p 443:443 \
  hdsme/ofbiz:18.12.1
```

### 4. Access OFBiz
Once the container is running, open a browser and navigate to:
```
http://192.168.2.97:80/webtools/control/main
```
Default credentials:
- **Username**: admin
- **Password**: ofbiz

### 5. Stopping and Removing OFBiz
To stop the container:
```bash
docker stop ofbiz
```
To remove the container:
```bash
docker rm ofbiz
```

## Alternative: Use Docker Compose
For easier management, create a `docker-compose.yml` file:
```yaml
version: '3'
services:
  ofbiz:
    image: hdsme/ofbiz:18.12.1
    container_name: ofbiz
    restart: always
    ports:
      - "80:80"
      - "443:443"
    env_file:
      - .env
```
Start OFBiz with:
```bash
docker-compose up -d
```

## Additional Notes
- The **database is PostgreSQL**, and credentials are set in `.env`.
- **Logs are stored in** `/ofbiz_erp/runtime/logs/ofbiz_erp.log` inside the container.
- If you encounter issues, refer to the [official OFBiz documentation](https://ofbiz.apache.org/developers.html).
- Other [documentation] (https://gist.github.com/bagasme/1de1908c86303c83b7bd51d50a12e041).
This guide should help you set up Apache OFBiz using Docker efficiently.

