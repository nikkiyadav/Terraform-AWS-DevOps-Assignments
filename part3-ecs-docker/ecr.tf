
# Private ECR repository for Flask backend
resource "aws_ecr_repository" "flask" {
  name                 = "${var.project_name}-flask"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name      = "${var.project_name}-flask"
    Component = "backend"
  }
}

# Private ECR repository for Express frontend
resource "aws_ecr_repository" "express" {
  name                 = "${var.project_name}-express"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name      = "${var.project_name}-express"
    Component = "frontend"
  }
}
