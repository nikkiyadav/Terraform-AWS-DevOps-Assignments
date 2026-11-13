
variable "aws_region" {
  description = "AWS region for Part 3 deployment"
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used for deployment"
  type        = string
  default     = "nikki-devops"
}

variable "project_name" {
  description = "Project name used for AWS resource tags"
  type        = string
  default     = "terraform-part3-ecs"
}

variable "vpc_cidr" {
  description = "CIDR block for the Part 3 VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for two public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
