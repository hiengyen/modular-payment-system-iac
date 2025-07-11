provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "banking_api" {
  name                 = "${var.name_prefix}-banking-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository" "langflow" {
  name                 = "${var.name_prefix}-langflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
