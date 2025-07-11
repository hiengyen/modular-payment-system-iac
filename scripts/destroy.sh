#!/bin/bash
# scripts/destroy.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-dev}
TERRAFORM_DIR="environments/${ENVIRONMENT}"

echo -e "${RED}🔥 Destroying Modular Payment Architecture - ${ENVIRONMENT}${NC}"

# Check if environment directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo -e "${RED}❌ Environment directory ${TERRAFORM_DIR} does not exist${NC}"
  exit 1
fi

# Warning message
echo -e "${RED}⚠️  WARNING: This will destroy all infrastructure in the ${ENVIRONMENT} environment!${NC}"
echo -e "${RED}⚠️  This action cannot be undone!${NC}"
echo ""

# Ask for confirmation
echo -e "${YELLOW}❓ Are you absolutely sure you want to destroy all resources? (type 'yes' to confirm)${NC}"
read -r response
if [[ "$response" != "yes" ]]; then
  echo -e "${GREEN}❌ Destruction cancelled${NC}"
  exit 0
fi

# Second confirmation
echo -e "${RED}❓ Type the environment name '${ENVIRONMENT}' to confirm:${NC}"
read -r env_confirmation
if [[ "$env_confirmation" != "$ENVIRONMENT" ]]; then
  echo -e "${RED}❌ Environment name doesn't match. Destruction cancelled${NC}"
  exit 1
fi

# Change to environment directory
cd "$TERRAFORM_DIR"

# Plan destruction
echo -e "${YELLOW}📊 Creating destruction plan...${NC}"
terraform plan -destroy -var-file="terraform.tfvars" -out="destroy.tfplan"

# Final confirmation
echo -e "${RED}❓ Proceed with destruction? (type 'DESTROY' to confirm)${NC}"
read -r final_response
if [[ "$final_response" == "DESTROY" ]]; then
  echo -e "${RED}🔥 Destroying infrastructure...${NC}"
  terraform apply "destroy.tfplan"

  # Clean up plan file
  rm -f destroy.tfplan

  echo -e "${GREEN}🎉 Infrastructure destroyed successfully!${NC}"
else
  echo -e "${GREEN}❌ Destruction cancelled${NC}"
  rm -f destroy.tfplan
  exit 1
fi
