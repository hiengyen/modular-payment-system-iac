variable "name_prefix" {
  type        = string
  description = "Prefix for ECS resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}


