# SaaS Infrastructure as Code

This repository contains the Terraform configurations for our SaaS platform's infrastructure on AWS.

## Architecture Overview

The infrastructure consists of the following components:

### Core Components
- **VPC and Networking**
  - Private and public subnets across multiple AZs
  - NAT Gateways for private subnet internet access
  - Security groups and routing tables

- **EKS Cluster**
  - Managed Kubernetes cluster
  - Node groups with auto-scaling
  - IAM roles and OIDC integration

- **RDS PostgreSQL**
  - Managed PostgreSQL instance
  - Automated backups
  - Performance Insights enabled
  - Encrypted storage and secrets

- **Monitoring & Alerting**
  - CloudWatch dashboards
  - CloudWatch alarms for critical metrics
  - SNS topics for notifications
  - Container Insights enabled

### Security Features
- KMS encryption for sensitive data
- IAM roles with least privilege
- Security groups with minimal access
- Regular security scanning with tfsec, Checkov, and Trivy

## Repository Structure

```
.
├── modules/
│   ├── networking/    # VPC, subnets, routing
│   ├── eks/          # Kubernetes cluster and node groups
│   ├── rds/          # PostgreSQL database
│   ├── iam/          # IAM roles and policies
│   └── monitoring/   # CloudWatch dashboards and alarms
│
├── environments/
│   ├── staging/      # Staging environment configuration
│   └── production/   # Production environment configuration
│
└── .github/
    └── workflows/    # CI/CD and security scanning
```

## Getting Started

### Prerequisites
- AWS CLI configured
- Terraform 1.x installed
- kubectl installed
- pre-commit installed

### Setup
1. Clone the repository
2. Install pre-commit hooks:
   ```bash
   pre-commit install
   ```

3. Initialize Terraform for your environment:
   ```bash
   cd environments/staging  # or production
   terraform init
   ```

### Deployment
1. Plan your changes:
   ```bash
   terraform plan -out=tfplan
   ```

2. Apply the changes:
   ```bash
   terraform apply tfplan
   ```

## CI/CD Pipeline

Our CI/CD pipeline includes:
- Terraform format and validation checks
- Security scanning (tfsec, Checkov, Trivy)
- Infrastructure cost estimation (Infracost)
- Automated documentation updates

## Environment Management

### Staging Environment
- Reduced capacity and cost-optimized
- Used for testing and validation
- Automated cleanup of resources

### Production Environment
- High availability configuration
- Multi-AZ deployments
- Enhanced monitoring and alerting
- Regular automated backups

## Security and Compliance

- All sensitive data is encrypted at rest and in transit
- Regular security scans in CI pipeline
- IAM roles follow least privilege principle
- Network security with private subnets and security groups

## Cost Management

- Infrastructure cost estimation in pull requests
- Resource tagging for cost allocation
- Auto-scaling to optimize resource usage
- Regular cost optimization reviews

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on:
- Development workflow
- Code review process
- Testing requirements
- Security considerations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
