# Scalable Multi-Tenant SaaS Infrastructure (Terraform)

Modular Terraform for a multi-region, multi-tenant SaaS backend on AWS with networking, EKS, Aurora PostgreSQL, IAM, CI/CD, and observability. Production-ready with isolated environments, compliance hooks, and automated validation.

## Features

- **Multi-region**: Providers for primary and aliased regions. Deterministic tagging across regions.
- **Multi-tenant**: Tenant-scoped IAM roles and IRSA for workload isolation on EKS.
- **Network segmentation**: Public and private subnets per AZ, NAT per AZ, strict SGs.
- **Secure by default**: Encryption at rest/in transit, deletion protection, least-privilege IAM.
- **Observability**: Helm-based Prometheus/Grafana/Loki on EKS, CloudWatch integration.
- **CI/CD**: GitHub Actions for fmt/validate/plan and optional AWS CodePipeline module.
- **Compliance**: terraform-compliance feature tests to enforce policies.

## Structure

```
saas-infra-terraform/
├── modules/
│   ├── networking/
│   ├── eks-cluster/
│   ├── rds/
│   ├── iam/
│   ├── ci-cd/
│   └── observability/
├── environments/
│   ├── prod/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── staging/
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── globals/
│   ├── providers.tf
│   └── variables.tf
├── compliance/
│   └── features/
│       ├── rds_encryption.feature
│       └── resource_tagging.feature
└── .github/workflows/terraform.yml
```

## Prerequisites

- Terraform 1.8+
- AWS account with permissions to provision VPC, EKS, RDS, IAM, and Code* services
- kubectl and helm if deploying observability

## Bootstrap

1) Create remote state S3 bucket and DynamoDB table (names referenced in `environments/*/backend.tf`).

2) Configure AWS credentials (SAML, SSO, or access keys). For CI, use OIDC with a role exposed as `AWS_IAM_ROLE_ARN` secret.

3) Initialize an environment:

```sh
cd environments/staging
terraform init
terraform plan
terraform apply
```

## Providers and Regions

`globals/providers.tf` pins provider versions and applies default tags. Aliases `us-east-1` and `us-west-2` are available for multi-region patterns.

## Modules

- `modules/networking`: VPC, public/private subnets per AZ, Internet/NAT gateways, routing, outputs for subnet/VPC IDs.
- `modules/eks-cluster`: EKS control plane, SG, managed node group, IAM roles and policy attachments, outputs for endpoint and IDs.
- `modules/rds`: Aurora PostgreSQL cluster with encrypted storage, parameter group (SSL enforced), subnet group, SG, multi-instance.
- `modules/iam`: Tenant role, policy attachment, EKS OIDC provider, IRSA roles with constrained subjects.
- `modules/observability`: Helm releases for kube-prometheus-stack, Loki, Grafana. Supply `grafana_admin_password` via secret.
- `modules/ci-cd`: CodeBuild + CodePipeline. Provide `github_oauth_token` via secure secrets store; do not hardcode.

## Environments

- `staging` and `prod` define backend state per env and wire modules with env-specific variables. Adjust `variables.tf` defaults or pass via `-var`/`-var-file`.

## Tenancy Model

- Create a tenant by instantiating `modules/iam` with a unique `tenant` and a minimal inline policy for that tenant’s scope. IRSA roles restrict service accounts by issuer subject. Example subjects: `system:serviceaccount:ns:sa`.

## CI/CD

- GitHub Actions: `terraform.yml` runs `fmt`, validates, plans with OIDC. Configure `AWS_IAM_ROLE_ARN` secret in the repo.
- CodePipeline module is optional for organizations preferring AWS-native pipelines. Parameterize `github_owner`, `repo`, and `oauth token` via a secret manager.

## Testing

- Terratest scaffolding under `test/terratest` validates init/plan for the `staging` environment.
- Policy tests via `terraform-compliance` under `compliance/features` ensure encryption and tagging are enforced.

## Security

- Default tags include `Environment`, `Project`, and `ManagedBy`. All state backends are encrypted and locked.
- Aurora: encryption, SSL enforced, deletion protection enabled by default.
- EKS: restricted SG egress by default and IRSA for fine-grained pod permissions.

## Operations

- Rotate database credentials using AWS Secrets Manager and pass to Terraform via environment variables (`TF_VAR_master_password`).
- Pass sensitive inputs only via environment or secret stores.

## License

MIT License