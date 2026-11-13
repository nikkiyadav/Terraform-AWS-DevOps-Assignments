
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
  default     = "terraform-student-app"
}

variable "ssh_allowed_cidr" {
  description = "Public IP CIDR allowed to connect through SSH"
  type        = string
}