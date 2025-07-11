#!/bin/bash
# scripts/plan.sh

set -e
# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-dev}
TERRAFORM_DIR="environments/${ENVIRONMENT}"

echo -e "${GREEN}📊 Planning Modular Payment Architecture - ${ENVIRONMENT}${NC}"

# Check if environment directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo -e "${RED}❌ Environment directory ${TERRAFORM_DIR} does not exist${NC}"
  exit 1
fi

# Change to environment directory
cd "$TERRAFORM_DIR"

# Initialize Terraform if needed
if [ ! -d ".terraform" ]; then
  echo -e "${YELLOW}🔧 Initializing Terraform...${NC}"
  terraform init
fi

# Validate configuration
echo -e "${YELLOW}✅ Validating Terraform configuration...${NC}"
terraform validate

# Format code
terraform fmt -recursive

# Create plan
echo -e "${YELLOW}📊 Creating Terraform plan...${NC}"
terraform plan -var-file="terraform.tfvars"

echo -e "${GREEN}✅ Plan completed successfully!${NC}"

# scripts/validate.sh
#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Validating Terraform Configuration${NC}"

# Check if Terraform is installed
if ! command -v terraform &>/dev/null; then
  echo -e "${RED}❌ Terraform is not installed${NC}"
  exit 1
fi

# Validate root configuration
echo -e "${YELLOW}📋 Validating root configuration...${NC}"
terraform validate
echo -e "${GREEN}✅ Root configuration is valid${NC}"

# Validate each module
echo -e "${YELLOW}📦 Validating modules...${NC}"
for module_dir in modules/*/; do
  if [ -d "$module_dir" ]; then
    module_name=$(basename "$module_dir")
    echo -e "${YELLOW}   - Validating module: $module_name${NC}"
    cd "$module_dir"
    terraform validate
    cd - >/dev/null
    echo -e "${GREEN}   ✅ Module $module_name is valid${NC}"
  fi
done

# Validate environments
echo -e "${YELLOW}🌍 Validating environments...${NC}"
for env_dir in environments/*/; do
  if [ -d "$env_dir" ]; then
    env_name=$(basename "$env_dir")
    echo -e "${YELLOW}   - Validating environment: $env_name${NC}"
    cd "$env_dir"
    terraform validate
    cd - >/dev/null
    echo -e "${GREEN}   ✅ Environment $env_name is valid${NC}"
  fi
done

# Format check
echo -e "${YELLOW}📝 Checking Terraform formatting...${NC}"
if terraform fmt -check -recursive; then
  echo -e "${GREEN}✅ All files are properly formatted${NC}"
else
  echo -e "${RED}❌ Some files need formatting. Run 'terraform fmt -recursive' to fix${NC}"
  exit 1
fi

echo -e "${GREEN}🎉 All validations passed successfully!${NC}"
