# Docker Commands Cheat Sheet

A comprehensive reference of Docker CLI commands categorized by purpose.

---

## 🐳 Docker Basics

| Command | Description |
|--------|-------------|
| `docker --version` | Show Docker version |
| `docker info` | Display system-wide information |
| `docker help` | Show help for Docker commands |

---

## 📦 Image Commands

| Command | Description |
|--------|-------------|
| `docker build -t <image-name> .` | Build an image from a Dockerfile |
| `docker pull <image>` | Pull an image from Docker Hub |
| `docker push <image>` | Push an image to Docker Hub |
| `docker images` | List all local images |
| `docker rmi <image>` | Remove an image |
| `docker tag <src> <target>` | Tag an image with a new name |

---

## 🚢 Container Commands

| Command | Description |
|--------|-------------|
| `docker run <image>` | Run a container from an image |
| `docker run -d <image>` | Run in detached mode |
| `docker run -it <image>` | Run interactively with a terminal |
| `docker run -p 8080:80 <image>` | Map host port to container port |
| `docker run --name <name> <image>` | Assign a name to the container |
| `docker start <container>` | Start a stopped container |
| `docker stop <container>` | Stop a running container |
| `docker restart <container>` | Restart a container |
| `docker rm <container>` | Remove a stopped container |
| `docker exec -it <container> /bin/bash` | Open a bash shell inside a running container |
| `docker logs <container>` | View container logs |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker top <container>` | Display running processes inside a container |

---

## 🧱 Dockerfile Related

| Command | Description |
|--------|-------------|
| `FROM` | Base image to use |
| `RUN` | Execute command in image at build time |
| `COPY` | Copy files from host to container image |
| `ADD` | Like COPY but supports remote URLs and unpacking |
| `CMD` | Default command to run at container start |
| `ENTRYPOINT` | Configures a container as an executable |
| `WORKDIR` | Set working directory |
| `ENV` | Set environment variables |
| `EXPOSE` | Inform Docker which port the app uses |

---

## 🗂️ Volume & Network

| Command | Description |
|--------|-------------|
| `docker volume create <name>` | Create a new volume |
| `docker volume ls` | List volumes |
| `docker volume rm <name>` | Remove a volume |
| `docker network create <name>` | Create a custom network |
| `docker network ls` | List all networks |
| `docker network inspect <name>` | Show network details |
| `docker network rm <name>` | Delete a network |

---

## 🧹 System Cleanup

| Command | Description |
|--------|-------------|
| `docker system prune` | Remove all unused data |
| `docker image prune` | Remove unused images |
| `docker container prune` | Remove stopped containers |
| `docker volume prune` | Remove unused volumes |
| `docker builder prune` | Remove build cache |

---

## 🛠️ Docker Compose

| Command | Description |
|--------|-------------|
| `docker-compose up` | Create and start containers |
| `docker-compose up -d` | Run in detached mode |
| `docker-compose down` | Stop and remove containers |
| `docker-compose ps` | List running compose services |
| `docker-compose build` | Build images |
| `docker-compose logs` | View logs from services |

---

## 📁 Docker Context

| Command | Description |
|--------|-------------|
| `docker context ls` | List available contexts |
| `docker context use <name>` | Switch context |
| `docker context create <name>` | Create a new context |

---
