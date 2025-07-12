#!/bin/bash

set -euo pipefail

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo "❌ Error: Environment not specified. Usage: ./deploy.sh [dev|staging|prod]"
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

# Log & Plan Backup
LOG_DIR="logs"
PLAN_DIR="plans"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
PLAN_FILE="$PLAN_DIR/tfplan_${ENVIRONMENT}_${TIMESTAMP}"
LOG_FILE="$LOG_DIR/deploy_${ENVIRONMENT}_${TIMESTAMP}.log"

mkdir -p "$LOG_DIR" "$PLAN_DIR"

echo "🚀 Deploying Terraform for '$ENVIRONMENT'..."
cd "$ENV_DIR"

# Init Terraform
terraform init | tee "$OLDPWD/$LOG_FILE"

# Plan & Save
terraform plan -var-file="terraform.tfvars" -out="tfplan" | tee -a "$OLDPWD/$LOG_FILE"

# Apply
terraform apply "tfplan" | tee -a "$OLDPWD/$LOG_FILE"

# Backup Plan
cp tfplan "$OLDPWD/$PLAN_FILE"

cd "$OLDPWD"
echo ""
echo "✅ Deployed! Log: $LOG_FILE | Plan Backup: $PLAN_FILE"
