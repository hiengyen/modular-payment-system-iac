#!/bin/bash
# scripts/deploy.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-dev}
TERRAFORM_DIR="environments/${ENVIRONMENT}"
STATE_BUCKET="modular-payment-terraform-state-${ENVIRONMENT}"
STATE_KEY="terraform.tfstate"
DYNAMODB_TABLE="modular-payment-terraform-locks"
REGION="us-east-1"

echo -e "${GREEN}🚀 Deploying Modular Payment Architecture - ${ENVIRONMENT}${NC}"

# Check if environment directory exists
if [ ! -d "$TERRAFORM_DIR" ]; then
  echo -e "${RED}❌ Environment directory ${TERRAFORM_DIR} does not exist${NC}"
  exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo -e "${RED}❌ AWS CLI is not installed${NC}"
  exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &>/dev/null; then
  echo -e "${RED}❌ Terraform is not installed${NC}"
  exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &>/dev/null; then
  echo -e "${RED}❌ AWS credentials are not configured${NC}"
  exit 1
fi

echo -e "${YELLOW}📋 Deployment Configuration:${NC}"
echo "Environment: $ENVIRONMENT"
echo "State Bucket: $STATE_BUCKET"
echo "State Key: $STATE_KEY"
echo "DynamoDB Table: $DYNAMODB_TABLE"
echo "Region: $REGION"
echo ""

# Create S3 bucket for state if it doesn't exist
if ! aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
  echo -e "${YELLOW}📦 Creating S3 bucket for Terraform state...${NC}"
  aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$REGION"
  aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "$STATE_BUCKET" --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'
  echo -e "${GREEN}✅ S3 bucket created successfully${NC}"
fi

# Create DynamoDB table for locking if it doesn't exist
if ! aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$REGION" &>/dev/null; then
  echo -e "${YELLOW}🔒 Creating DynamoDB table for state locking...${NC}"
  aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region "$REGION"

  # Wait for table to be created
  aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE" --region "$REGION"
  echo -e "${GREEN}✅ DynamoDB table created successfully${NC}"
fi

# Change to environment directory
cd "$TERRAFORM_DIR"

# Initialize Terraform
echo -e "${YELLOW}🔧 Initializing Terraform...${NC}"
terraform init \
  -backend-config="bucket=$STATE_BUCKET" \
  -backend-config="key=$STATE_KEY" \
  -backend-config="region=$REGION" \
  -backend-config="dynamodb_table=$DYNAMODB_TABLE"

# Validate configuration
echo -e "${YELLOW}✅ Validating Terraform configuration...${NC}"
terraform validate

# Format code
terraform fmt -recursive

# Plan deployment
echo -e "${YELLOW}📊 Creating deployment plan...${NC}"
terraform plan -var-file="terraform.tfvars" -out="tfplan"

# Ask for confirmation
echo -e "${YELLOW}❓ Do you want to proceed with the deployment? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  echo -e "${GREEN}🚀 Applying Terraform configuration...${NC}"
  terraform apply "tfplan"

  # Clean up plan file
  rm -f tfplan

  echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
  echo -e "${GREEN}📋 Outputs:${NC}"
  terraform output
else
  echo -e "${RED}❌ Deployment cancelled${NC}"
  rm -f tfplan
  exit 1
fi
