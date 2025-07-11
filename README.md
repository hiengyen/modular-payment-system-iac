# Cấu trúc dự án Terraform - Modular Payment Architecture

```
modular-payment-terraform/
├── README.md
├── .gitignore
├── terraform.tfvars.example
├── versions.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── data.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── waf.tf
│   │   ├── security_groups.tf
│   │   └── iam_roles.tf
│   ├── cognito/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── user_pool.tf
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── buckets.tf
│   ├── database/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── aurora.tf
│   │   ├── dynamodb.tf
│   │   └── iam_roles.tf
│   ├── ecr/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── repositories.tf
│   ├── ecs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── cluster.tf
│   │   ├── task_definition.tf
│   │   ├── service.tf
│   │   └── alb.tf
│   ├── lambda/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── router_function.tf
│   │   ├── processor_function.tf
│   │   └── src/
│   │       ├── router/
│   │       │   ├── index.js
│   │       │   └── package.json
│   │       └── processor/
│   │           ├── index.js
│   │           └── package.json
│   ├── api_gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── rest_api.tf
│   │   ├── resources.tf
│   │   └── deployment.tf
│   ├── messaging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── sqs.tf
│   │   └── sns.tf
│   ├── analytics/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── kinesis_firehose.tf
│   │   └── quicksight.tf
│   ├── ai_ml/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── sagemaker.tf
│   │   └── bedrock.tf
│   └── monitoring/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── cloudwatch.tf
│       └── dashboards.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── scripts/
│   ├── deploy.sh
│   ├── destroy.sh
│   ├── plan.sh
│   └── validate.sh
├── policies/
│   ├── ecs_task_policy.json
│   ├── lambda_policy.json
│   ├── sagemaker_policy.json
│   └── firehose_policy.json
└── docs/
    ├── architecture.md
    ├── deployment.md
    ├── troubleshooting.md
    └── api_documentation.md
```

## Mô tả các thành phần chính:

### 1. Root Level Files
- **main.tf**: File chính gọi các modules
- **variables.tf**: Định nghĩa biến cho toàn bộ dự án
- **outputs.tf**: Xuất các giá trị quan trọng
- **locals.tf**: Định nghĩa local values
- **data.tf**: Data sources
- **versions.tf**: Terraform và provider versions

### 2. Modules Directory
Mỗi module có cấu trúc chuẩn:
- **main.tf**: Logic chính của module
- **variables.tf**: Input variables
- **outputs.tf**: Output values
- **versions.tf**: Provider requirements (nếu cần)

### 3. Environments Directory
Cấu hình riêng cho từng môi trường:
- **dev/**: Môi trường development
- **staging/**: Môi trường staging
- **prod/**: Môi trường production

### 4. Scripts Directory
Các script tự động hóa:
- **deploy.sh**: Script triển khai
- **destroy.sh**: Script xóa infrastructure
- **plan.sh**: Script xem kế hoạch thay đổi
- **validate.sh**: Script kiểm tra cấu hình

### 5. Policies Directory
Các IAM policies JSON:
- Policies cho ECS tasks
- Policies cho Lambda functions
- Policies cho SageMaker
- Policies cho Firehose

### 6. Documentation
- **architecture.md**: Mô tả kiến trúc
- **deployment.md**: Hướng dẫn triển khai
- **troubleshooting.md**: Hướng dẫn xử lý lỗi
- **api_documentation.md**: Tài liệu API


## Thứ tự triển khai:

1. **Networking**: VPC, subnets, gateways
2. **Security**: Security groups, WAF, IAM roles
3. **Storage**: S3 buckets, ECR repositories
4. **Database**: Aurora cluster, DynamoDB
5. **Compute**: ECS cluster, Lambda functions
6. **Integration**: API Gateway, SQS, SNS
7. **Analytics**: Kinesis Firehose, QuickSight
8. **AI/ML**: SageMaker, Bedrock
9. **Monitoring**: CloudWatch, dashboards

## Lệnh triển khai:

```bash
# Khởi tạo Terraform
terraform init

# Xem kế hoạch thay đổi
terraform plan -var-file="terraform.tfvars"

# Triển khai
terraform apply -var-file="terraform.tfvars"

# Xóa infrastructure
terraform destroy -var-file="terraform.tfvars"
```

## Best Practices:

1. **State Management**: Sử dụng remote state (S3 + DynamoDB)
2. **Environment Separation**: Workspace hoặc directories riêng biệt
3. **Security**: Không commit sensitive data
4. **Validation**: Sử dụng terraform validate và terraform fmt
5. **Documentation**: Duy trì documentation cập nhật
6. **CI/CD**: Tích hợp với pipeline CI/CD
7. **Monitoring**: Thiết lập alerts và monitoring
8. **Backup**: Backup state files và databases
