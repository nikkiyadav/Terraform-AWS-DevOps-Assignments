# Part 3 – Deploy Flask and Express Applications on AWS ECS using Terraform

## 1. Project Overview

This project deploys a full-stack web application on AWS using Docker, Amazon ECR, Amazon ECS Fargate, an Application Load Balancer (ALB), and Terraform.

The application consists of:
- **Frontend:** Node.js with Express
- **Backend:** Python with Flask
- **Containerization:** Docker
- **Container Registry:** Amazon Elastic Container Registry (ECR)
- **Container Orchestration:** Amazon ECS with AWS Fargate
- **Infrastructure as Code:** Terraform
- **Remote Terraform State:** Amazon S3

## 2. Architecture

The application follows this request flow:

1. A user accesses the application through the Application Load Balancer.
2. The ALB forwards normal frontend requests to the Express container on port 3000.
3. Requests starting with `/api/` are forwarded to the Flask backend on port 5000.
4. Both containers run as ECS Fargate tasks.
5. Docker images are stored in Amazon ECR.
6. Terraform provisions and manages the AWS infrastructure.

## 3. Project Structure

```text
part3-ecs-docker/
├── app/
│   ├── backend/
│   │   ├── app.py
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   └── frontend/
│       ├── server.js
│       ├── package.json
│       ├── public/
│       └── Dockerfile
├── evidence/
│   ├── 01-terraform/
│   ├── 02-docker-ecr/
│   ├── 03-aws-infrastructure/
│   └── 04-application-testing/
├── provider.tf
├── variables.tf
├── network.tf
├── security_groups.tf
├── ecr.tf
├── iam.tf
├── logs.tf
├── alb.tf
├── ecs.tf
├── outputs.tf
└── README.md
```

## 4. AWS Infrastructure Created

Terraform provisions the following resources:

- VPC with two public subnets
- Internet Gateway and public route table
- Security groups for ALB, frontend, and backend
- Two Amazon ECR repositories
- ECS cluster
- Flask and Express ECS task definitions
- Flask and Express ECS services using Fargate
- Application Load Balancer
- Target groups and listener rules
- IAM task execution role
- CloudWatch log groups

## 5. Docker Images

Two Docker images were created and pushed to Amazon ECR:

- `terraform-part3-ecs-flask:v1`
- `terraform-part3-ecs-express:v1`

The Flask container listens on port 5000, and the Express container listens on port 3000.

## 6. Terraform Deployment

Terraform was used to provision the infrastructure.

Commands used:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Terraform state is stored remotely in an Amazon S3 bucket with encryption and versioning enabled. Native S3 state locking is configured.

## 7. Application Access and Testing

Application URL:

http://terraform-part3-ecs-alb-1665399878.eu-north-1.elb.amazonaws.com

Health endpoints:

- Frontend: `/health`
- Backend: `/api/students`

The application was tested by submitting student details through the frontend form. The frontend successfully communicated with the Flask backend, and the registered student was displayed in the application.

Both ECS services were verified as running, and both ALB target groups were verified as healthy.

## 8. Security and Monitoring

- ALB accepts HTTP traffic on port 80.
- Frontend traffic is allowed from the ALB security group.
- Backend traffic is allowed from the ALB security group.
- ECS tasks use an IAM execution role to retrieve container images and publish logs.
- Application logs are sent to Amazon CloudWatch Logs.

## 9. Important Notes

- The student records are stored in application memory and are not persisted in a database. They can be lost when the backend container restarts.
- This is a learning and demonstration deployment, not a production-hardened architecture.
- The application currently uses HTTP rather than HTTPS.

## 10. Cleanup

To remove the Part 3 infrastructure when testing and evidence collection are complete, run:

```bash
terraform destroy
```

Review the proposed resources carefully and confirm before proceeding.

**Important:** The S3 bucket used for remote Terraform state was created separately and is not managed by this Terraform configuration. Do not delete it while the state is still needed.

AWS resources such as the ALB, ECS tasks, and public IPv4 addresses may incur charges while running.