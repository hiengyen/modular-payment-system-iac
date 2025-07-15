provider "aws" {
  region = var.aws_region
}

# RDS CLUSTER
resource "aws_rds_cluster" "aurora" {
  cluster_identifier              = "${var.name_prefix}-aurora-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0.mysql_aurora.3.08.0"
  database_name                   = "${var.database_name}db"
  master_username                 = var.db_master_username
  master_password                 = var.db_master_password
  backup_retention_period         = var.backup_retention_period
  deletion_protection             = var.enable_deletion_protection
  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.rds.id, aws_security_group.ssm.id]
  preferred_backup_window         = "07:00-09:00"
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = "${var.name_prefix}-final-snapshot"
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  tags                            = var.tags
}

# RDS CLUSTER INSTANCE
resource "aws_rds_cluster_instance" "aurora_instance" {
  count               = 2
  identifier          = "${var.name_prefix}-aurora-instance-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora.engine
  engine_version      = aws_rds_cluster.aurora.engine_version
  publicly_accessible = var.publicly_accessible
  tags                = var.tags
}

# Create a DB subnet group for the RDS cluster
resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

# Create a security group for the RDS cluster
resource "aws_security_group" "rds" {
  name_prefix = "${var.name_prefix}-rds-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id, var.lambda_sg_id, aws_security_group.ssm.id]
    # cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-rds-sg"
    }
  )
}

# Create an IAM role for SSM
resource "aws_iam_role" "ssm" {

  name = "${var.name_prefix}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonSSMManagedInstanceCore policy to the SSM role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile for EC instances to use SSM
resource "aws_iam_instance_profile" "ssm" {
  name = "${var.name_prefix}-ssm-profile"
  role = aws_iam_role.ssm.name
}

# Create a security group for EC2 instances to allow SSM access 
resource "aws_security_group" "ssm" {
  name   = "${var.name_prefix}-ssm-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "ssm_host" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = "t3.micro"
  subnet_id            = var.private_subnet_ids[0]
  security_groups      = [aws_security_group.ssm.id]
  iam_instance_profile = aws_iam_instance_profile.ssm.name

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-ssm-host"
    }
  )
}

# DYNAMODB TABLE
resource "aws_dynamodb_table" "main" {
  name         = "${var.name_prefix}-dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags
}

