#!/bin/bash

set -euo pipefail

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo "❌ Error: Environment not specified. Usage: ./scripts/destroy.sh [dev|staging|prod]"
  exit 1
fi

ENV_DIR="environments/$ENVIRONMENT"
TFVARS_FILE="$ENV_DIR/terraform.tfvars"
LOG_DIR="logs"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/destroy_${ENVIRONMENT}_${TIMESTAMP}.log"

if [ ! -d "$ENV_DIR" ]; then
  echo "❌ Error: Environment directory '$ENV_DIR' does not exist."
  exit 1
fi

if [ ! -f "$TFVARS_FILE" ]; then
  echo "❌ Error: File '$TFVARS_FILE' not found."
  exit 1
fi

mkdir -p "$LOG_DIR"

exec > >(tee "$LOG_FILE") 2>&1

echo "🔥 Destroying Terraform resources for '$ENVIRONMENT'"
echo "📄 Using tfvars: $TFVARS_FILE"
echo "📝 Logging to: $LOG_FILE"
echo ""

terraform init

terraform destroy -var-file="$TFVARS_FILE" -auto-approve

echo ""
echo "✅ Destroy complete!"
echo "📝 Log saved to: $LOG_FILE"
