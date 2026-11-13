
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-part3-state-666709165354-291113"
    key          = "part3-ecs-docker/terraform.tfstate"
    region       = "eu-north-1"
    profile      = "nikki-devops"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
