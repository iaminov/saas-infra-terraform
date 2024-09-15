.PHONY: help init-staging plan-staging apply-staging init-prod plan-prod apply-prod lint test clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init-staging: ## Initialize Terraform for staging environment
	cd environments/staging && terraform init

plan-staging: ## Plan changes for staging environment
	cd environments/staging && terraform plan -out=tfplan

apply-staging: ## Apply changes to staging environment
	cd environments/staging && terraform apply tfplan

init-prod: ## Initialize Terraform for production environment
	cd environments/production && terraform init

plan-prod: ## Plan changes for production environment
	cd environments/production && terraform plan -out=tfplan

apply-prod: ## Apply changes to production environment
	cd environments/production && terraform apply tfplan

lint: ## Run pre-commit hooks on all files
	pre-commit run --all-files

validate: ## Validate Terraform configurations
	@echo "Validating staging environment..."
	cd environments/staging && terraform init -backend=false && terraform validate
	@echo "Validating production environment..."
	cd environments/production && terraform init -backend=false && terraform validate

clean: ## Clean up Terraform files
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name ".terraform.lock.hcl" -delete
	find . -type f -name "tfplan" -delete
	find . -type f -name "terraform.tfstate*" -delete

check-drift: ## Check for infrastructure drift
	@echo "Checking staging environment..."
	cd environments/staging && terraform plan
	@echo "Checking production environment..."
	cd environments/production && terraform plan

cost-estimate: ## Estimate infrastructure costs
	@echo "Estimating staging costs..."
	cd environments/staging && terraform plan -out=tfplan
	infracost breakdown --path environments/staging/tfplan
	@echo "Estimating production costs..."
	cd environments/production && terraform plan -out=tfplan
	infracost breakdown --path environments/production/tfplan
