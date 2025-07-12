#!/bin/bash

set -euo pipefail

ENVIRONMENT="$1" # Get the environment from the first argument

if [ -z "$ENVIRONMENT" ]; then
  echo "❌ Error: Environment not specified. Usage: ./validate.sh [dev|staging|prod]"
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

# Create logs directory and log file
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/validate_${ENVIRONMENT}_${TIMESTAMP}.log"

# Redirect output to log file
exec > >(tee "$LOG_FILE") 2>&1

echo "🔍 Validating Terraform configuration for '$ENVIRONMENT'..."
echo "📝 Log: $LOG_FILE"
echo ""

# Init và validate
terraform init -backend=false
terraform validate -var-file="$TFVARS_FILE"

echo ""
echo "✅ Validation completed for environment: $ENVIRONMENT"
