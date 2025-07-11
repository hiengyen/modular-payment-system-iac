#!/bin/bash

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Error: Environment not specified. Usage: ./validate.sh [dev|staging|prod]"
  exit 1
fi

echo "Validating $ENVIRONMENT environment..."

# Navigate to environment directory
cd environments/$ENVIRONMENT

# Initialize Terraform
terraform init

# Format Terraform files
terraform fmt -check -recursive

# Validate Terraform configuration
terraform validate

echo "Validation for $ENVIRONMENT completed successfully!"
