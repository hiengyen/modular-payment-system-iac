provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-ecs-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "banking_api" {
  family                   = "${var.name_prefix}-banking-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "banking-api"
      image     = var.banking_api_image
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = var.banking_api_env_vars
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name_prefix}-banking-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "banking_api" {
  name            = "${var.name_prefix}-banking-api"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.banking_api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.security_group_ids[0]] # Assuming the first security group is for langflow
    assign_public_ip = true
  }

  tags = var.tags

  depends_on = [aws_ecs_task_definition.banking_api]
}

resource "aws_ecs_task_definition" "langflow" {
  family                   = "${var.name_prefix}-langflow"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn
  container_definitions = jsonencode([
    {
      name      = "langflow"
      image     = var.langflow_image
      essential = true
      portMappings = [
        {
          containerPort = 7860
          protocol      = "tcp"
        }
      ]
      environment = var.langflow_env_vars
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name_prefix}-langflow"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "langflow" {
  name            = "${var.name_prefix}-langflow"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.langflow.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.security_group_ids[0]] # Assuming the first security group is for langflow
    assign_public_ip = true
  }

  tags = var.tags

  depends_on = [aws_ecs_task_definition.langflow]
}

resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name_prefix}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

