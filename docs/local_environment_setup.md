# Local Environment Setup

This guide helps a developer configure a local workstation to work with the
Direct Ride Terraform infrastructure.

## What This Repository Manages

The dev environment in `environments/dev` provisions AWS infrastructure for the
Direct Ride platform:

- VPC networking across two Availability Zones in `us-east-1`
- Public, private application, and private database subnets
- Internet Gateway, NAT Gateway, and route tables
- S3 static website bucket for the frontend
- ECR repository for the backend API container image
- ECS Fargate cluster, service, task definition, ALB, target group, and logs
- RDS PostgreSQL database with AWS-managed master password
- IAM roles and policies for ECS tasks and GitHub Actions OIDC deployment
- Secrets Manager JWT secret
- SSM Parameter Store application config parameters
- AWS Budget email notifications

## Required Tools

Install these tools before running Terraform:

- Terraform `>= 1.5.0`
- AWS CLI v2
- Git
- Docker, if you need to build and push the backend API image to ECR

Check your local versions:

```sh
terraform -version
aws --version
git --version
docker --version
```

## AWS Access

Authenticate to the AWS account where the dev infrastructure should be created.
Any AWS CLI-supported auth method is fine, including SSO, named profiles, or
environment variables.

For AWS SSO:

```sh
aws sso login --profile <profile-name>
export AWS_PROFILE=<profile-name>
aws sts get-caller-identity
```

For static credentials:

```sh
export AWS_ACCESS_KEY_ID=<access-key-id>
export AWS_SECRET_ACCESS_KEY=<secret-access-key>
export AWS_SESSION_TOKEN=<session-token-if-needed>
aws sts get-caller-identity
```

The authenticated identity needs permission to create and manage the AWS
services listed above.

## Terraform Working Directory

Run Terraform from the dev environment directory:

```sh
cd environments/dev
```

This repository currently uses local Terraform state. The state file is ignored
by Git and should not be committed. Coordinate with the team before applying
changes to a shared AWS account so multiple developers do not overwrite each
other's state.

## Local Terraform Variables

Create a local `terraform.tfvars` file in `environments/dev`. This file is
ignored by Git and can contain developer-specific values.

Minimum required example:

```hcl
github_repository          = "<github-owner>/direct-ride-aws-terraform"
backend_github_repository  = "<github-owner>/direct-ride-apis"
frontend_github_repository = "<github-owner>/direct-ride-web"
github_org                 = "<github-owner>"
github_repo                = "direct-ride-web"
github_branch              = "main"
notification_email         = "<developer-or-team-email@example.com>"
```

Required variables without defaults:

| Variable | Purpose |
| --- | --- |
| `github_org` | GitHub organization or username that owns the frontend repository. |
| `github_repo` | Frontend repository name allowed to assume the frontend deploy role. |
| `notification_email` | Email address that receives AWS Budget notifications. |

Important optional variables:

| Variable | Default | Purpose |
| --- | --- | --- |
| `aws_region` | `us-east-1` | AWS region for the dev environment. |
| `project_name` | `direct-ride` | Prefix used in tags and resource names. |
| `environment` | `dev` | Environment name used in tags and resource names. |
| `frontend_website_bucket_name` | `direct-ride-frontend-dev` | S3 bucket name for the frontend website. S3 bucket names must be globally unique. |
| `backend_api_image_tag` | `latest` | ECR image tag used by the ECS task definition. |
| `backend_api_container_port` | `8080` | Container port exposed by the backend API. |
| `backend_api_health_check_path` | `/health` | ALB target group health check path. |
| `backend_api_desired_count` | `1` | Desired ECS task count. |
| `backend_api_task_cpu` | `256` | Fargate task CPU units. |
| `backend_api_task_memory` | `512` | Fargate task memory in MiB. |
| `backend_github_repository` | `null` | Backend repo allowed to assume the backend GitHub Actions deploy role. |
| `frontend_github_repository` | `null` | Frontend repo allowed to assume the frontend deploy role. |
| `frontend_github_oidc_provider_arn` | `null` | Existing GitHub OIDC provider ARN to reuse for frontend deploy role. |
| `cloudfront_distribution_arn` | `null` | CloudFront distribution ARN the frontend deploy role can invalidate. |
| `cloudfront_distribution_id` | `null` | CloudFront distribution ID exposed as an output for frontend deploy workflows. |
| `app_config_parameter_path_prefix` | `/<project>-<environment>/api/config` | SSM path prefix for non-secret backend API config. |
| `app_config_parameters` | `{}` | Map of non-secret backend API config values to create in SSM. |
| `uploads_bucket_arn` | `null` | Optional uploads bucket ARN the backend API can read and write. |
| `enable_ses_permissions` | `false` | Allows the backend API task role to send email through SES. |

Example with optional backend application config:

```hcl
app_config_parameters = {
  CORS_ORIGINS = "https://example.com"
  LOG_LEVEL    = "info"
}

uploads_bucket_arn     = "arn:aws:s3:::direct-ride-dev-uploads"
enable_ses_permissions = true
```

Do not put secret values in `app_config_parameters`. Secrets should be managed in
AWS Secrets Manager or another approved secret store.

## Initialize and Validate Terraform

From `environments/dev`:

```sh
terraform init
terraform fmt -recursive
terraform validate
```

Use `terraform fmt -check -recursive` in CI or before opening a pull request if
you only want to verify formatting.

## Plan and Apply

Review the plan before creating or changing cloud resources:

```sh
terraform plan -out=tfplan
```

Apply only after reviewing the planned changes:

```sh
terraform apply tfplan
```

You can also pass variables at runtime when needed:

```sh
terraform plan -var="notification_email=<email@example.com>"
```

## Backend API Image

Terraform creates the ECR repository and configures ECS to run:

```text
<backend_api_ecr_repository_url>:<backend_api_image_tag>
```

The default tag is `latest`. Before the ECS service can become healthy, the
backend API image for the selected tag must exist in ECR and the container must
listen on `backend_api_container_port` and return a successful response from
`backend_api_health_check_path`.

After applying ECR, get the repository URL:

```sh
terraform output backend_api_ecr_repository_url
```

Then authenticate Docker and push an image from the backend API repository:

```sh
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

docker build -t <repository-url>:latest .
docker push <repository-url>:latest
```

## Useful Terraform Outputs

After `terraform apply`, these outputs are commonly needed by app developers and
GitHub Actions workflows:

```sh
terraform output frontend_website_bucket_id
terraform output frontend_website_url
terraform output backend_api_ecr_repository_url
terraform output backend_api_alb_url
terraform output backend_deploy_role_arn
terraform output frontend_deploy_role_arn
terraform output jwt_secret_name
terraform output app_config_parameter_path_prefix
```

Database connection details are also output, but the RDS database is private and
is intended to be reached from ECS tasks inside the VPC:

```sh
terraform output db_address
terraform output db_name
terraform output db_username
terraform output db_master_user_secret_arn
```

The database password is generated and stored by AWS Secrets Manager. Do not add
database passwords to Terraform variables or source-controlled files.

## GitHub Actions OIDC Notes

The dev environment can create GitHub Actions OIDC deploy roles:

- `backend_github_repository` controls the backend deploy role.
- `frontend_github_repository`, `github_org`, `github_repo`, and `github_branch`
  control the frontend deploy role.
- `github_branch` defaults to `main`, so workflows from other branches cannot
  assume these roles unless this value is changed.

Use these outputs as GitHub Actions secrets or variables in the related
application repositories:

```sh
terraform output backend_deploy_role_arn
terraform output frontend_deploy_role_arn
terraform output backend_api_ecr_repository_url
terraform output frontend_website_bucket_id
terraform output frontend_cloudfront_distribution_id
```

## Cost and Cleanup

This environment creates billable resources, including NAT Gateway, ALB, ECS
Fargate tasks, RDS PostgreSQL, ECR storage, S3 storage, CloudWatch logs, and AWS
Budgets. The budget module defaults to a USD 20 monthly limit with notification
emails at 50 percent and 100 percent usage.

To destroy the dev infrastructure:

```sh
terraform destroy
```

Before destroying, confirm that:

- Any needed database data has been backed up.
- The ECR repository can be deleted. By default, Terraform will not force-delete
  a repository that still contains images.
- No frontend website assets or logs need to be retained.

## Troubleshooting

Common checks:

```sh
aws sts get-caller-identity
terraform init -upgrade
terraform validate
terraform plan
```

If S3 bucket creation fails, choose a globally unique
`frontend_website_bucket_name`.

If ECS tasks do not become healthy, verify that the backend image exists in ECR,
the container listens on the configured port, and the health check path returns a
`200-399` response.

If GitHub Actions cannot assume a role, verify that the repository owner, repo
name, and branch in `terraform.tfvars` match the workflow source exactly.
