#!/bin/bash

set -euo pipefail

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo "❌ Error: Environment not specified. Usage: ./destroy.sh [dev|staging|prod]"
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

# Logging
LOG_DIR="logs"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/destroy_${ENVIRONMENT}_${TIMESTAMP}.log"

mkdir -p "$LOG_DIR"

echo "🧨 Destroying Terraform resources for '$ENVIRONMENT'..."
cd "$ENV_DIR"

# Init & Destroy
terraform init | tee "$OLDPWD/$LOG_FILE"
terraform destroy -var-file="terraform.tfvars" -auto-approve | tee -a "$OLDPWD/$LOG_FILE"

cd "$OLDPWD"
echo ""
echo "✅ Destroyed. Log saved at: $LOG_FILE"
