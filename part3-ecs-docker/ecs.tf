
# ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# Flask backend task definition
resource "aws_ecs_task_definition" "flask" {
  family                   = "${var.project_name}-flask"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "flask"
      image     = "${aws_ecr_repository.flask.repository_url}:v1"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.flask.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "flask"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-flask-task"
  }
}

# Express frontend task definition
resource "aws_ecs_task_definition" "express" {
  family                   = "${var.project_name}-express"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "express"
      image     = "${aws_ecr_repository.express.repository_url}:v1"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.express.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "express"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-express-task"
  }
}

# Flask ECS service
resource "aws_ecs_service" "flask" {
  name            = "${var.project_name}-flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.flask.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask.arn
    container_name   = "flask"
    container_port   = 5000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution,
    aws_lb_listener.http
  ]

  tags = {
    Name = "${var.project_name}-flask-service"
  }
}

# Express ECS service
resource "aws_ecs_service" "express" {
  name            = "${var.project_name}-express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.express.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.express.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express.arn
    container_name   = "express"
    container_port   = 3000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution,
    aws_lb_listener.http
  ]

  tags = {
    Name = "${var.project_name}-express-service"
  }
}
