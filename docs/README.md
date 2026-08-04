## Overview

This directory documents the Direct Ride development AWS infrastructure managed by Terraform. Each file focuses on one part of the stack so the networking, compute, database, IAM, security, and application configuration details are easier to review without digging through every Terraform module.

## Architecture Diagram

![Direct Ride AWS Architecture Diagram](DirectRide_AWS_Diagram.png)

## Environment Overview

- Project: Direct Ride (`project_name = "direct-ride"`)
- Environment: Development (`environment = "dev"`)
- AWS Region: `us-east-1`
- Infrastructure Management: Terraform (`>= 1.5.0`)
- Deployment Platform: GitHub Actions with AWS OIDC 

---

## Request Flow

1. A user accesses the React frontend through CloudFront.
2. AWS WAF evaluates the frontend request at the CloudFront edge.
3. The frontend sends an API request to the Application Load Balancer.
4. The ALB forwards the request to an ECS Fargate task in the private app subnets.
5. The API receives plain database connection settings from ECS environment variables.
6. The API receives sensitive values from ECS secrets backed by AWS Secrets Manager.
7. The API connects to the PostgreSQL RDS database in the private database subnets.
8. The response travels back through the ALB to the frontend.

---

## Documentation

### [Network](network.md)

Explains the VPC, CIDR ranges, Availability Zones, public subnets, private app subnets, private database subnets, and which resources run in each subnet tier.

### [Routing](routing.md)

Documents the public, private app, and private database route tables, including Internet Gateway access, NAT Gateway egress, and subnet associations.

### [Security Groups](security_groups.md)

Lists the ALB, ECS task, and RDS security groups with their inbound and outbound rules.

### [IAM Roles](iam_roles.md)

Explains the ECS task execution role, ECS task application role, backend GitHub Actions deploy role, and frontend GitHub Actions deploy role.

### [Compute](compute.md)

Describes the ECS cluster, ECS service, Fargate task definition, Application Load Balancer, target group, health checks, and CloudWatch logging.

### [Storage](storage.md)

Documents the frontend S3 website bucket, CloudFront distribution, WAF web ACL, public website access model, ownership controls, encryption, versioning, website configuration, and storage outputs.

### [Database](database.md)

Documents the RDS PostgreSQL instance, database defaults, storage settings, backup behavior, subnet group, security group, and outputs.

### [Application Configuration and Secrets](configuration_and_secrets.md)

Explains Secrets Manager, SSM Parameter Store, ECS environment variables, ECS secret injection, and which IAM roles can read configuration values.

### [Set Up Local Environment](local_environment_setup.md)

Explains the local tools, AWS authentication, Terraform working directory, variable setup, planning/applying workflow, outputs, deployment notes, and troubleshooting steps needed to work with the dev infrastructure.

---
