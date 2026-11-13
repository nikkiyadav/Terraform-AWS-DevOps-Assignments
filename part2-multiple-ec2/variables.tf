
variable "ssh_allowed_cidr" {
  description = "Public IP CIDR allowed to SSH into the EC2 instances. Set this in terraform.tfvars."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Flask and Express"
  type        = string
  default     = "t3.small"
}

