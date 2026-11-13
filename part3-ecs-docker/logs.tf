
# Log group for Flask backend
resource "aws_cloudwatch_log_group" "flask" {
  name              = "/ecs/${var.project_name}/flask"
  retention_in_days = 7

  tags = {
    Name      = "${var.project_name}-flask-logs"
    Component = "backend"
  }
}

# Log group for Express frontend
resource "aws_cloudwatch_log_group" "express" {
  name              = "/ecs/${var.project_name}/express"
  retention_in_days = 7

  tags = {
    Name      = "${var.project_name}-express-logs"
    Component = "frontend"
  }
}
