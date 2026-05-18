# Direct Ride Terraform

Terraform infrastructure for the Direct Ride application. This repository defines the AWS resources needed to run the dev environment for a containerized backend API, a static frontend website, and a managed PostgreSQL database.

The infrastructure is split into reusable modules under `modules/` and composed by the dev environment in `environments/dev/`.

## What This Deploys

The dev stack provisions:

- A VPC across two Availability Zones in `us-east-1`
- Public subnets for internet-facing load balancing
- Private application subnets for ECS Fargate tasks
- Private database subnets for RDS PostgreSQL
- An internet gateway and NAT gateway for outbound access from private app subnets
- An S3 bucket configured for static frontend website hosting
- An ECR repository for the backend API container image
- An ECS Fargate service behind an Application Load Balancer
- A private, encrypted PostgreSQL RDS instance
- Secrets Manager secrets for the database password and backend JWT secret
- SSM Parameter Store entries for non-secret backend configuration
- IAM roles for ECS task execution, application permissions, and optional GitHub Actions deployment

## Architecture

At a high level, the application traffic flow is:

1. Users reach the static frontend through the S3 website endpoint.
2. API traffic reaches the public Application Load Balancer.
3. The load balancer forwards requests to ECS Fargate tasks running in private app subnets.
4. ECS tasks connect to PostgreSQL in private database subnets.
5. ECS tasks read secrets from Secrets Manager and app config from SSM Parameter Store.
6. GitHub Actions can optionally assume an AWS deploy role through OIDC to push images, update ECS, upload frontend files, and invalidate CloudFront distributions when those are configured.

The database is not publicly accessible. Its security group only allows PostgreSQL traffic from the ECS task security group.

## Repository Layout

```text
.
+-- environments/
|   +-- dev/                 # Dev environment composition
+-- modules/
|   +-- compute/             # ECS Fargate, ALB, target group, logs, service SGs
|   +-- database/            # RDS PostgreSQL and database security group
|   +-- ecr/                 # Backend API image repository and lifecycle policy
|   +-- networking/          # VPC, subnets, routes, IGW, NAT, DB subnet group
|   +-- security/            # IAM, GitHub OIDC, Secrets Manager, SSM parameters
|   +-- storage/             # Frontend S3 website bucket
+-- docs/
    +-- architecture-notes.md
```

## Modules

### Networking

Creates the network foundation:

- VPC CIDR: `10.0.0.0/16`
- Public subnets: `10.0.1.0/24`, `10.0.2.0/24`
- Private app subnets: `10.0.11.0/24`, `10.0.12.0/24`
- Private database subnets: `10.0.21.0/24`, `10.0.22.0/24`
- Internet gateway for public subnets
- NAT gateway for outbound traffic from private app subnets
- Isolated route table for private database subnets
- RDS DB subnet group

### Storage

Creates the frontend website bucket:

- S3 static website configuration
- Bucket owner enforced object ownership
- Server-side encryption with AES256
- Versioning enabled
- Public read bucket policy for website objects

### ECR

Creates the backend API container repository:

- AES256 repository encryption
- Optional image scan on push
- Lifecycle rules for untagged and tagged image retention

### Database

Creates a private PostgreSQL RDS instance:

- PostgreSQL engine
- Encrypted `gp3` storage
- AWS-managed master password in Secrets Manager
- Private database subnet placement
- No public accessibility
- Configurable instance class, storage, backups, deletion protection, and final snapshot behavior

### Security

Creates application and deployment security resources:

- ECS task execution role
- ECS application task role
- JWT secret in Secrets Manager
- SSM Parameter Store app config values
- Optional permissions for an uploads bucket
- Optional SES send permissions
- Optional GitHub Actions OIDC provider and deploy role

The GitHub Actions role is only created when `github_repository` is set.

### Compute

Creates the backend runtime:

- ECS cluster with Container Insights enabled
- CloudWatch log group
- Fargate task definition
- ECS service in private app subnets
- Public Application Load Balancer
- HTTP listener on port `80`
- Target group health checks
- Security groups for ALB-to-ECS traffic

The task receives database connection values as environment variables and reads sensitive values from Secrets Manager.

## Prerequisites

- Terraform `>= 1.5.0`
- AWS provider `~> 5.0`
- Random provider `~> 3.0`
- AWS credentials configured locally or in CI
- Permissions to create VPC, ECS, ECR, RDS, S3, IAM, Secrets Manager, SSM, CloudWatch, and load balancing resources

## Working With Dev

From the dev environment directory:

```sh
cd environments/dev
terraform init
terraform plan
terraform apply
```

To inspect outputs after deployment:

```sh
terraform output
```

To destroy the dev stack:

```sh
terraform destroy
```

Review database settings before destroying. The dev defaults set `db_skip_final_snapshot = true` and `db_deletion_protection = false`, which makes teardown easier but is not appropriate for production data.

## Key Dev Variables

The dev environment includes sensible defaults for local development:

- `aws_region`: defaults to `us-east-1`
- `project_name`: defaults to `direct-ride`
- `environment`: defaults to `dev`
- `db_instance_class`: defaults to `db.t4g.micro`
- `backend_api_image_tag`: defaults to `latest`
- `backend_api_container_port`: defaults to `8080`
- `backend_api_desired_count`: defaults to `1`
- `backend_api_task_cpu`: defaults to `256`
- `backend_api_task_memory`: defaults to `512`
- `backend_api_health_check_path`: defaults to `/health`

Optional integrations:

- Set `github_repository` to `owner/repo` to create the GitHub Actions OIDC deploy role.
- Set `github_branch` to control which branch can assume that role. It defaults to `main`.
- Set `app_config_parameters` to create non-secret backend API config in SSM Parameter Store.
- Set `uploads_bucket_arn` to allow the backend task role to read and write uploads.
- Set `enable_ses_permissions = true` to allow the backend task role to send email through SES.

## Outputs

Important outputs include:

- VPC and subnet IDs
- Frontend S3 website bucket name, ARN, endpoint, and URL
- RDS endpoint, address, port, database name, username, and master secret ARN
- Backend API ECR repository name, ARN, and URL
- Backend API ECS cluster, service, task definition, ALB DNS name, and ALB URL
- ECS task execution and application role ARNs
- JWT secret ARN and name
- GitHub Actions OIDC provider and deploy role ARNs, when enabled

## Deployment Notes

The backend API image is expected to exist in ECR before the ECS service can run successfully. The container image URI is built from the managed ECR repository URL and `backend_api_image_tag`.

The frontend bucket is configured for direct S3 website hosting. The security module already includes optional CloudFront invalidation permissions for GitHub Actions, but this Terraform stack does not currently create a CloudFront distribution.

The ALB currently exposes an HTTP listener on port `80`. Security group ingress for HTTPS is present, but the compute module does not yet create an HTTPS listener or attach an ACM certificate.

## Naming and Tags

Resources use a shared name prefix:

```text
<project_name>-<environment>
```

For the default dev environment, resources are prefixed with:

```text
direct-ride-dev
```

The AWS provider also applies default tags:

- `Project`
- `Environment`
- `ManagedBy = Terraform`
