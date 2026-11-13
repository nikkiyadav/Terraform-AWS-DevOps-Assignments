
output "vpc_id" {
  description = "ID of the Part 3 VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the two public subnets"
  value       = aws_subnet.public[*].id
}

output "flask_ecr_repository_url" {
  description = "Flask backend ECR repository"
  value       = aws_ecr_repository.flask.repository_url
}

output "express_ecr_repository_url" {
  description = "Express frontend ECR repository"
  value       = aws_ecr_repository.express.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "flask_ecs_service_name" {
  description = "Flask ECS service name"
  value       = aws_ecs_service.flask.name
}

output "express_ecs_service_name" {
  description = "Express ECS service name"
  value       = aws_ecs_service.express.name
}

output "load_balancer_dns" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "application_url" {
  description = "Public URL of the application"
  value       = "http://${aws_lb.main.dns_name}"
}
