# README: AWS Deployment with Terraform and WordPress

## Overview
This project automates the deployment of a WordPress site on AWS using Terraform and a Bash deployment script. It provisions the necessary AWS resources, including a VPC, RDS database, Redis cache, EC2 instance, and sets up CI/CD with GitHub Actions.

## Configuration Options

### Terraform Modules
- **VPC Module (`modules/vpc`)**: Creates a Virtual Private Cloud (VPC) with public and private subnets.
- **RDS Module (`modules/rds`)**: Sets up an Amazon RDS database.
- **Redis Module (`modules/redis`)**: Deploys an Amazon ElastiCache Redis cluster.
- **EC2 Module (`modules/ec2`)**: Launches an EC2 instance to host the WordPress site.

### Variables
Configuration values are passed via Terraform variables and `.env` files. The key variables include:

| Variable               | Description                                |
|------------------------|--------------------------------------------|
| `RDS_USER_NAME`        | Username for the RDS database.            |
| `RDS_PASSWORD`        | Password for the RDS database.            |
| `DB_NAME`             | Name of the database.                      |
| `REDIS_CLUSTER_ID`    | Redis cluster identifier.                   |
| `KEY_PAIR_NAME`       | Name of the SSH key pair for EC2 access.   |

To customize these variables, modify the Terraform variable files (`.tfvars`) or set environment variables.

### Deployment Script (`deploy.sh`)
The `deploy.sh` script automates the setup of WordPress on the EC2 instance:
- Configures Apache.
- Downloads and installs WordPress.
- Updates `wp-config.php` with RDS and Redis credentials.
- Sets up permissions and Apache settings.
- Installs and configures WP-CLI.
- Activates Redis caching for WordPress.

To customize:
- Modify Apache configuration settings inside `deploy.sh`.
- Change the WordPress site title, admin username, or other settings in the script.

### GitHub Actions CI/CD
The GitHub Actions workflow (`.github/workflows/deploy_wordpress.yml`) automates deployment when changes are pushed.

Key actions:
- Checks out the code.
- Configures AWS credentials.
- Initializes and applies Terraform configurations.
- Extracts Terraform outputs (EC2 IP, RDS, Redis endpoints).
- Runs the deployment script on the provisioned EC2 instance.

## Troubleshooting & Common Issues

### Terraform Issues
- **Terraform Initialization Fails**: Ensure correct AWS credentials are set (`aws configure`).
- **State File Locking Issues**: Check if another process is running `terraform apply`. Run `terraform force-unlock <lock-id>` if needed.

### Deployment Script Issues
- **Permission Errors**: Ensure `word-press-key.pem` has `chmod 400` applied.
- **Connection Timeout to EC2**: Verify the instance is running and security groups allow SSH (port 22).
- **WordPress Not Loading**: Check Apache logs (`sudo journalctl -u apache2 --no-pager`).
- **Database Connection Issues**: Verify `wp-config.php` settings match RDS endpoint and credentials.

### CI/CD Pipeline Failures
- **Authentication Issues**: Confirm AWS secrets and variables are set in GitHub.
- **Terraform Errors**: Check the workflow logs for errors in state or plan steps.

## Deployment Steps
1. Clone the repository.
2. Set up AWS credentials and Terraform variables.
3. Initialize Terraform: `terraform init`.
4. Apply Terraform configuration: `terraform apply -auto-approve`.
5. Retrieve Terraform outputs (EC2 Public IP, RDS endpoint, etc.).
6. Run the deployment script: `chmod +x deploy.sh && ./deploy.sh`.

Once completed, the WordPress site will be accessible via the EC2 Public IP.

## Contact & Support
For issues or feature requests, create an issue in the GitHub repository.

