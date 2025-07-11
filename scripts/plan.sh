#!/bin/bash

# plan.sh
# Script to generate Terraform plan

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Error: Environment not specified. Usage: ./plan.sh [dev|staging|prod]"
  exit 1
fi

echo "Generating plan for $ENVIRONMENT environment..."

# Navigate to environment directory
cd environments/$ENVIRONMENT

# Initialize Terraform
terraform init

# Generate Terraform plan
terraform plan -var-file="terraform.tfvars" -out=tfplan

echo "Plan for $ENVIRONMENT generated successfully! Saved as tfplan"
