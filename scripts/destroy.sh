#!/bin/bash

# destroy.sh
# Script to destroy Terraform infrastructure

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Error: Environment not specified. Usage: ./destroy.sh [dev|staging|prod]"
  exit 1
fi

echo "Destroying $ENVIRONMENT environment..."

# Navigate to environment directory
cd environments/$ENVIRONMENT

# Initialize Terraform
terraform init

# Destroy Terraform configuration
terraform destroy -var-file="terraform.tfvars" -auto-approve

echo "Destruction of $ENVIRONMENT completed successfully!"
