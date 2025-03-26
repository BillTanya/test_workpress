# 📌 Project Documentation: WordPress Deployment on AWS

## 📖 Overview
This project automates the deployment of a WordPress website on AWS using Terraform and a deployment script. The infrastructure includes:
- **EC2 instance** for hosting WordPress.
- **RDS MySQL instance** for database storage.
- **ElastiCache Redis** for session storage.
- **GitHub Actions CI/CD pipeline** for automated deployment.

## 🛠️ Tools & Technologies Used
### 1️⃣ **Infrastructure as Code (IaC)**
- **Terraform**: Used to provision AWS resources programmatically.
  - Modules are structured to ensure reusability and maintainability.
  
### 2️⃣ **Deployment Automation**
- **Bash Script (`deploy.sh`)**: Automates WordPress setup, configuration, and integration with RDS and Redis.

### 3️⃣ **CI/CD Pipeline**
- **GitHub Actions**: Automates infrastructure deployment and application setup on EC2.

## 📂 Project Structure
```plaintext
├── .github/workflows/
│   ├── deploy_wordpress.yml  # CI/CD pipeline for deployment
│
├── .terraform/  # Terraform state files
│
├── modules/  # Modular Terraform configuration
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── rds/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── redis/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── vpc/
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│
├── deploy.sh  # WordPress deployment script
├── main.tf  # Root Terraform configuration
├── outputs.tf  # Terraform output variables
├── variables.tf  # Terraform input variables
├── terraform.tfvars  # Terraform variable values
├── README.md  # Project description and setup guide
├── DOCUMENTATION.md  # This file (detailed documentation)
```

## 📌 Terraform Modules
### 1️⃣ **VPC Module** (`modules/vpc`)
- Creates a Virtual Private Cloud (VPC) for the infrastructure.
- Includes necessary subnets, security groups, and networking configurations.

### 2️⃣ **EC2 Module** (`modules/ec2`)
- Provisions an EC2 instance to host WordPress.
- Configures security groups to allow HTTP/S and SSH access.

### 3️⃣ **RDS Module** (`modules/rds`)
- Creates an Amazon RDS MySQL instance.
- The database is not publicly accessible.

### 4️⃣ **Redis Module** (`modules/redis`)
- Deploys an ElastiCache Redis instance for session storage.

## 🚀 Deployment Process
### 1️⃣ **Infrastructure Deployment**
```sh
terraform init
terraform plan
terraform apply -auto-approve
```

### 2️⃣ **Application Deployment**
```sh
chmod +x deploy.sh
./deploy.sh
```

## 📝 Additional Notes
- **Environment variables** are used to securely pass sensitive data.
- **State management** is handled by Terraform.
- **Security best practices**: EC2 has minimal open ports, and RDS/Redis are private.

## 📌 Troubleshooting
| Issue | Solution |
|--------|----------|
| Permissions error on `deploy.sh` | Run `chmod +x deploy.sh` |
| WordPress database connection issue | Check RDS security groups & credentials |
| Terraform state conflict | Run `terraform refresh` and retry |

---
💡 *For any questions, refer to the `README.md` file or check the repository issues!*

