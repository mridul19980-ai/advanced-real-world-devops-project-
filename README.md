# React + Node + MySQL Docker Project

Is project me:

- Frontend: React JS with Vite, Nginx webserver ke through port `80`
- Backend: Node.js + Express
- Database: MySQL 8
- Orchestration: Docker Compose
- Deployment: AWS EC2 with Terraform
- CI/CD: Jenkins Pipeline

## Local Run

```powershell
docker compose up --build
```

Open:

- Frontend: http://localhost
- Backend health: http://localhost/api/health

## Project Structure

```text
frontend/      React app served by Nginx
backend/       Node.js API connected to MySQL
database/      MySQL init scripts
terraform/     AWS EC2 infrastructure
Jenkinsfile    CI/CD pipeline
```

## Environment

Local Docker Compose defaults:

```env
MYSQL_DATABASE=college_app
MYSQL_USER=college_user
MYSQL_PASSWORD=college_password
MYSQL_ROOT_PASSWORD=root_password
```

Production me strong passwords use karo.

## AWS EC2 Deploy With Terraform

1. AWS CLI configure karo.
2. `terraform/terraform.tfvars` banao:

```hcl
aws_region           = "ap-south-1"
project_name         = "college-project"
key_name             = "your-ec2-keypair-name"
allowed_ssh_cidr     = "YOUR_PUBLIC_IP/32"
repository_url       = "https://github.com/YOUR_USER/YOUR_REPO.git"
repository_branch    = "main"
mysql_database       = "college_app"
mysql_user           = "college_user"
mysql_password       = "CHANGE_ME_STRONG_PASSWORD"
mysql_root_password  = "CHANGE_ME_STRONG_ROOT_PASSWORD"
```

3. Run:

```powershell
cd terraform
terraform init
terraform apply
```

Terraform EC2 par Docker install karega, repo clone karega, aur `docker compose up -d --build` run karega.

## Jenkins Setup

Jenkins me credentials add karo:

- `ec2-ssh-key`: SSH private key for EC2 user `ubuntu`
- `ec2-host`: Secret text with EC2 public IP or DNS

Pipeline:

```text
checkout -> build/test -> docker compose config -> deploy to EC2
```

Jenkins deploy stage EC2 par latest code pull karke Docker Compose se services restart karta hai.

