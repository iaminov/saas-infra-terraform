# SaaS Infrastructure with AWS EKS

This repository contains the infrastructure as code (IaC) for our SaaS platform, built on AWS EKS.

## Overview

- Production-grade EKS cluster setup
- Multi-environment support (staging/production)
- Fully automated CI/CD pipeline
- Infrastructure monitoring and observability
- Secure networking with public/private subnets
- Managed RDS for persistent storage

## Structure

```
.
├── environments/        # Environment-specific configurations
│   ├── staging/        # Staging environment
│   └── prod/          # Production environment
├── modules/           # Reusable infrastructure modules
│   ├── networking/    # VPC, subnets, routing
│   ├── eks-cluster/   # EKS cluster and node groups
│   ├── iam/          # IAM roles and policies
│   ├── rds/          # Database infrastructure
│   └── ci-cd/        # CI/CD pipeline resources
└── test/             # Infrastructure tests
```

## Getting Started

1. Install required tools:
   - Terraform >= 0.14.0
   - AWS CLI v2
   - kubectl

2. Configure AWS credentials:
   ```bash
   aws configure
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

## Contributing

1. Clone this repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - see LICENSE file for details
