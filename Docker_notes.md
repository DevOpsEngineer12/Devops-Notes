# 🐳 Docker Architecture, Dockerfile & Multi-stage Dockerfile

---

## 📦 Docker Architecture

Docker uses a **client-server architecture**. It consists of the following components:

### 🔹 1. **Docker Client**
- CLI tool (`docker`) to interact with Docker daemon.
- Sends commands via REST API.
- Users type commands like `docker build`, `docker run`, etc.

### 🔹 2. **Docker Daemon (dockerd)**
- Runs in the background.
- Builds, runs, and manages containers.
- Listens to Docker API requests.

### 🔹 3. **Docker Images**
- Read-only templates used to create containers.
- Built from Dockerfiles.

### 🔹 4. **Docker Containers**
- Running instances of images.
- Isolated environments using namespaces and cgroups.

### 🔹 5. **Docker Registries**
- Repositories for storing Docker images.
- Example: Docker Hub, GitHub Container Registry, Azure Container Registry.

### 🖼 Architecture Diagram (Textual)

+-------------------+ REST API +-------------------+ | Docker Client | <---------------------> | Docker Daemon | +-------------------+ +-------------------+ | v +-------------------+ | Docker Containers | +-------------------+

---

## 📄 Dockerfile – Basic to Advanced

### 🔹 What is a Dockerfile?
A **Dockerfile** is a text document with instructions to build a Docker image.

### 🔹 Basic Dockerfile Example

```Dockerfile
# Start from base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source files
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
```

### 🔹 Explanation of Instructions

**Instruction	Description**

| Command | Description |
|--------|-------------|
| FROM |	Base image to build on |
| WORKDIR |	Working directory inside the image |
| COPY	| Copy files from host to image |
| RUN |	Run commands during build |
| EXPOSE |	Inform container about port |
|CMD	| Default command to run |


## 🎯 Multi-stage Dockerfile
### 🔹 What is it?
- Multi-stage builds let you use multiple FROM statements to:

- Compile/build code in one stage.

- Copy only final output to a smaller image.

### 🔹 Benefits:
- Reduce final image size.

- Separate build-time and run-time dependencies.

- More secure and efficient.

### 🔹 Example: Node.js App

```Dockerfile

# Stage 1 - Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build  # creates /app/dist

# Stage 2 - Production Image
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm install --only=production

EXPOSE 3000
CMD ["node", "dist/index.js"]
```
### 🔹 Explanation

| Part | Purpose |
|--------|-------------|
| AS builder |	Names the build stage |
| COPY | --from=builder	Copies from previous stage | 
| node:18-alpine	| Smaller runtime image |
| npm run build	| Build app for production |

### ❌ Disadvantages of Multi-stage Builds
### Limitation	Details
- Debugging complexity	Hard to troubleshoot intermediate build steps
- Rebuild times	Changing source code may trigger full rebuild
- Not supported by old Docker versions	Requires Docker 17.05+
  
### 🔧 Best Practices
- Use .dockerignore to exclude unnecessary files.

- Use multistage builds to reduce image size.

- Prefer COPY over ADD unless you need auto-extraction.

- Set proper EXPOSE and CMD.

- Keep secrets out of Dockerfiles!

### 📂 File Structure Example
```css
my-app/
├── Dockerfile
├── .dockerignore
├── package.json
├── src/
└── dist/
```

### 📌 Useful Docker Build & Run Commands

```bash
# Build Docker image
docker build -t my-app .

# Run container
docker run -d -p 3000:3000 my-app

# View running containers
docker ps

# View image layers
docker history my-app
```

### 🔐 Bonus: .dockerignore Example

```bash
node_modules
dist
.env
.git
Dockerfile
*.log
```
## Happy Docking! 🚢
