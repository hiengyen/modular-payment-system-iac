#!/bin/bash

# deploy.sh
# Script to deploy Terraform infrastructure

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Error: Environment not specified. Usage: ./deploy.sh [dev|staging|prod]"
  exit 1
fi

echo "Deploying to $ENVIRONMENT environment..."

# Navigate to environment directory
cd environments/$ENVIRONMENT

# Initialize Terraform
terraform init

# Apply Terraform configuration
terraform apply -var-file="terraform.tfvars" -auto-approve

echo "Deployment to $ENVIRONMENT completed successfully!"
