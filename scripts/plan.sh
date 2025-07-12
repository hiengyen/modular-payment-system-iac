#!/bin/bash

set -euo pipefail

ENVIRONMENT="$1" # Get the environment from the first argument

if [ -z "$ENVIRONMENT" ]; then
  echo "❌ Error: Environment not specified. Usage: ./plan.sh [dev|staging|prod]"
  exit 1
fi

ENV_DIR="environments/$ENVIRONMENT"
TFVARS_FILE="$ENV_DIR/terraform.tfvars"

if [ ! -d "$ENV_DIR" ]; then
  echo "❌ Error: Environment directory '$ENV_DIR' does not exist."
  exit 1
fi

if [ ! -f "$TFVARS_FILE" ]; then
  echo "❌ Error: File '$TFVARS_FILE' not found."
  exit 1
fi

# Save current working directory
ORIGINAL_DIR=$(pwd)

# Create logs and plan backups
LOG_DIR="logs"
PLAN_DIR="plans"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
PLAN_FILE="$PLAN_DIR/tfplan_${ENVIRONMENT}_${TIMESTAMP}"
LOG_FILE="$LOG_DIR/plan_${ENVIRONMENT}_${TIMESTAMP}.log"

mkdir -p "$LOG_DIR" "$PLAN_DIR"

# Redirect output to log file
exec > >(tee "$LOG_FILE") 2>&1

echo "🧪 Running Terraform plan for '$ENVIRONMENT'..."

# Initialize Terraform
terraform init | tee "$ORIGINAL_DIR/$LOG_FILE"

# Generate Terraform plan
terraform plan -var-file="$TFVARS_FILE" -out="tfplan" | tee -a "$ORIGINAL_DIR/$LOG_FILE"

# Backup the plan file with timestamp
cp tfplan "$ORIGINAL_DIR/$PLAN_FILE"

# Show summary
echo ""
echo "📋 Summary of Plan:"
terraform show tfplan | tee -a "$ORIGINAL_DIR/$LOG_FILE"

echo ""
echo "✅ Plan saved to: $PLAN_FILE"
echo "📄 Log saved to: $LOG_FILE"
