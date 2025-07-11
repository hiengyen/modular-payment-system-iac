Troubleshooting Guide
Common Issues
1. Missing Variable Error
Error: Required attribute "aws_region" not specifiedSolution:

Ensure terraform.tfvars exists in the environment directory with aws_region defined.
Example:aws_region = "ap-south-1"


Alternatively, set the environment variable:export TF_VAR_aws_region="ap-south-1"



2. Terraform Validation Failure
Error: terraform validate failsSolution:

Run terraform fmt -check -recursive to identify formatting issues.
Fix any syntax errors in .tf files.
Ensure all required variables are defined in terraform.tfvars.

3. AWS Permission Errors
Error: Insufficient permissions for AWS resourcesSolution:

Verify AWS CLI credentials have necessary IAM permissions.
Check IAM policies in policies/ directory for correctness.
Update IAM roles if needed.

4. API Gateway 403/500 Errors
Solution:

Verify Cognito user pool configuration and authorizer settings.
Check WAF rules for potential blocking.
Ensure ECS and Lambda services are running and accessible.

5. Database Connection Issues
Solution:

Verify security group rules allow traffic from ECS/Lambda to Aurora (port 5432).
Check Aurora endpoint and credentials.
Ensure db_master_password is correctly set in Secrets Manager or terraform.tfvars.

Debugging Tips

Use CloudWatch logs for ECS, Lambda, and API Gateway.
Check Terraform state file for consistency: terraform state list.
Run terraform plan to identify resource misconfigurations.

