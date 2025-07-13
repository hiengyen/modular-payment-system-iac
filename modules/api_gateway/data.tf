data "aws_cognito_user_pool" "main" {
  user_pool_id = var.cognito_user_pool_id
}
