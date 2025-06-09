# 🚀 Guide for devops-2025

## 🔑 Generating SSH Key and Adding It to GitHub

To enable secure ssh access to your GitHub repositories (especially private ones), follow the steps below.


### 🔧 1. Generate a New SSH Key

* Run the following command on your local machine

```bash
ssh-keygen -t rsa -C "your_email@example.com"
```

* Press Enter to save in the default location (~/.ssh/id_rsa)

* Optionally set a passphrase for added security

* This creates two files:

    `~/.ssh/id_rsa` (private key)

    `~/.ssh/id_rsa.pub` (public key)

### 📤 2. Copy the public key

* Manual copy
```bash
cat ~/.ssh/id_rsa.pub
```

### 🌐 3. Add the Key to GitHub

Do the following:

* Add this exact key to your account under: https://github.com/settings/keys
* Click new ssh key
* Set a name you like
* Paste the public key
* Click add ssh key

## 🔐 Cloning Private Git Repositories via SSH in Ansible

This project supports cloning private repositories over SSH using ssh-agent forwarding. Below are the required steps to enable this securely and efficiently:


### ✅ 1. Start SSH Agent Locally

* Make sure your ssh agent is running and your key is added:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa  # Replace with your SSH private key path and name if different
```

### ✅ 2. Configure Local SSH (Optional but recommended)

* Edit your local ~/.ssh/config
* Enable Agent Forwarding **(ForwardAgent = yes)**

```bash
Host <YOUR_VM_NAME>
  HostName <YOUR_VM_IP>
  User <YOUR_USER>
  IdentityFile ~/.ssh/id_rsa # replace this with your ssh key
  ForwardAgent yes
```

### ✅ 3. Verify SSH Access from Remote

* ssh into the target VM and run:
```bash
ssh -T git@github.com
```

## 🤖 Jenkins configuration

Before running pipelines and jobs, make sure you already did the following:

### Install global tools

* Jenkins → Manage Jenkins → Global Tool configuration
   * Ansible ([guide](https://cyberpanel.net/blog/ansible-in-jenkins))
   * Docker ([guide](https://medium.com/@lilnya79integrating-docker-with-jenkins-20690bb7a146))
   * Git ([guide](https://medium.com/@sangeetv09/how-to-integrate-git-with-jenkins-dcc63f5cbb13))

### Install Plugins

* Git (in startup)
* Ansible
* Docker
* Ssh agent 
* Email extension plugin

### Ssh setup for cloning private git repositories and accessing remote vms

To allow jenkins user to interact with private git repositories or access remote VMs using Ansible, follow these steps to configure the Jenkins user's SSH environment.


#### 🔐 1. Generate or Copy an SSH Key

* If you haven't already, generate a key as the `jenkins` user:

```bash
sudo su jenkins
ssh-keygen -t rsa -C "jenkins@yourdomain.com"
```

#### 📎 2. Configure ~/.ssh/config

#### 🧪 3. Test the Connection

### Add ssh key to GitHub

* Go to GitHub → Settings → SSH and GPG Keys
* Click "New SSH key"
* Set name jenkins-ssh
* Paste contents of ~/.ssh/id_jenkins_github.pub

### 🐙 Create GitHub Personal Access Token (PAT)

Used to authenticate Docker pushes to GitHub Container Registry (ghcr.io)

* Go to GitHub → Settings → Developer Settings → Personal Access Tokens
* Generate a classic token or fine-grained token with scopes:
   * repo 
   * read:packages
   * write:packages

### 🔧 Store Credentials in Jenkins (UI)

* Go to Jenkins → Manage Jenkins → Credentials → (global) → Add Credentials
   * **a)** 🔑 Add SSH Key Credential
      * Kind: SSH Username with private key
      * ID: github-ssh-key
      * Username: git
      * Private Key: Paste contents of id_jenkins_github

   * **b)** 🔐 Add GitHub Token
      * Kind: Secret text
      * ID: github-token
      * Secret: Paste your GitHub token information

## 📦 Docker Images

Each component in the project is published to GitHub Container Registry (GHCR). You can manually pull and run the images using Docker. Keep in mind each image has a unique tag that shows in which commit it got published.

### 🔐 Accessing Private Docker Images

The Docker images used in this project are hosted on **GitHub Container Registry (GHCR)** and are **private**!!!

### 🧭 Who Can Access?

* Users **invited to this repository** with at least **Read** permission.
* Users who **authenticate with a GitHub token** that includes the correct scopes.

---

### 🔍 Steps to Pull a Private Image

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