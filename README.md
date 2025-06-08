# 🚀 DevOps

#### This code is a project for the DevOps course at Harokopio University of Athens, Department of Informatics and Telematics. A multi-component system deployed in remote virtual machines using Docker, Ansible and Jenkins, with HTTPS reverse proxy via NGINX.

## 🌱 Project Overview

##### This project simulates a distributed system consisting of the following components:

- **`main-app:`** A Spring Boot application
- **`minio:`** Object storage 
- **`mailhog:`** Email testing tool (SMTP + Web UI)
- **`mariadb:`** MYSQL database
- **`nginx:`** Reverse proxy with SSL certificates and DNS

## 📁 Project Structure

```bash
devops-2025/
├── ansible-playground/         # Ansible automation for VM setup and remote deployment (Gitsubmodule)
├── assets/                     # SSL certificates, NGINX configs, init.sql files
├── ds-project-2024/            # Spring Boot main app (Git submodule)
│
├── docker-compose.yaml         # Defines images and runs all components via Docker Compose
├── mailhog.Dockerfile          # Custom Dockerfile for MailHog
│
├── mailhog.Jenkinsfile         # Jenkins pipeline for MailHog image test + push in github
├── mariadb.Jenkinsfile         # Jenkins pipeline for MariaDB image test + push in github
├── minio.Jenkinsfile           # Jenkins pipeline for MinIO image test + push in github
├── nginx.Jenkinsfile           # Jenkins pipeline for nginx image test + push in github
│
├── .gitmodules                 # Git submodule configuration
├── .dockerignore               # Docker exclusions
├── .gitignore                  # Git exclusions
└── README.md                   # Project documentation

```

## 🗃️ Git clone

```bash
git clone https://github.com/it2022057/devops-2025.git
cd devops-2025
git submodule init
git submodule update
```

## ⚙️ Requirements

✅ Ansible

✅ Docker & Docker Compose

✅ A jenkins server configured to be able to run everything with ansible and upload the images in our github 

✅ A VM with a static IP (e.g AzureVm or local vm with Vagrant)

✅ Domain name with A record pointing to the VM (e.g. [CloudDNS](https://www.cloudns.net))

✅ SSL certificate (e.g. [SSLForFree](https://www.sslforfree.com/) or [Certbot](https://certbot.eff.org/))

## ☁️ Deployment

#### See *README.md* in ansible-playground submodule for instructions on how to run ansible and docker

* 🔧 Ansible 
* 🐳 Docker and docker compose 

#### Main app and mailhog have a custom docker image, although the others already have an official image and i decided not to create a custom one 

* 🔄 Jenkins CI/CD

#### Each component may include a Jenkinsfile. Jenkins builds, tests, tags, and pushes Docker images to GitHub packages.

## 🌐 NGINX Reverse Proxy & SSL

This project uses the web server **NGINX** as a reverse proxy to route incoming HTTPS traffic

### ✅ Features

* Reverse proxy for:
  * `/` → Spring Boot main app
  * `/minio/` → MinIO Console
  * `/mailhog/` → MailHog Web UI
  * `/pet-adoption-app/pet-photos/` → Path for images in MinIO storage
* *HTTPS* enabled using real *SSL* certificates
* Clean *HTTP* → *HTTPS* redirection (no reason to use *http*)

## 🔒 Example Access

### 🛡️ Main app page

* devops-vm-1
```bash
https://vm1.loukidns.ip-ddns.com
```
* devops-vm-2
```bash
https://vm2.loukidns.ip-ddns.com
```
* devops-vm-3
```bash
https://vm3.loukidns.ip-ddns.com
```

### 📤 Mailhog UI 

* devops-vm-1
```bash
https://vm1.loukidns.ip-ddns.com/mailhog/
```
* devops-vm-2
```bash
https://vm2.loukidns.ip-ddns.com/mailhog/
```
* devops-vm-3
```bash
https://vm3.loukidns.ip-ddns.com/mailhog/
```

### 🪣 Minio console

* devops-vm-1
```bash
https://vm1.loukidns.ip-ddns.com/minio/
```
* devops-vm-2
```bash
https://vm2.loukidns.ip-ddns.com/minio/
```
* devops-vm-3
```bash
https://vm3.loukidns.ip-ddns.com/minio/
```

## 📦 Docker Images

Each component in the project is published to GitHub Container Registry (GHCR). You can manually pull and run the images using Docker. Keep in mind each image has a unique tag that shows in which commit it got published.

### 🔐 Accessing Private Docker Images

The Docker images used in this project are hosted on **GitHub Container Registry (GHCR)** and are **private**!!!

### 🧭 Who Can Access?

* Users **invited to this repository** with at least **Read** permission.
* Users who **authenticate with a GitHub token** that includes the correct scopes.

---

### 🔑 Steps to Pull a Private Image

1. **Generate a GitHub Personal Access Token (PAT)**  
   Go to [GitHub → Developer Settings → Tokens](https://github.com/settings/tokens), select classic and create a token with the following scopes:
   * `read:packages`
   * (optional) `repo` — if you're accessing a private repo
   * `save` the token to a file

2. **Authenticate with GHCR via Docker**

```bash
cat ~/github-image-repo.txt | docker login ghcr.io -u <GITHUB-USERNAME> --password-stdin
```

### 🔽 Pull Commands

*  Spring Boot main app (custom image)
```bash
docker pull ghcr.io/it2022057/main-app:latest
```

* MinIO (official image with tag:latest)
```bash
docker pull ghcr.io/it2022057/minio:latest
```

* MailHog (custom image)
```bash
docker pull ghcr.io/it2022057/mailhog:latest
```

* MariaDB (official image with tag:10.2.44)
```bash
docker pull ghcr.io/it2022057/mariadb:latest
```
* Nginx (official image with tag:alpine)
```bass
docker pull ghcr.io/it2022057/nginx:latest
```

## 📬 Contact

For questions or issues, feel free to reach out at:
📧 it2022057@hua.gr

## ✍️ Author

Made with ❤️ by **it2022057**
