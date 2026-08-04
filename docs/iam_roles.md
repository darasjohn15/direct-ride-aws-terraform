# IAM Roles

## Overview 

The DirectRide infrastructure uses dedicated IAM roles for application runtime, infrastructure deployment, and CI/CD automation. Each role follows the principle of least privilege by granting only the permissions required for its specific responsibility.

## ECS Task Execution Role

**Role name:** `direct-ride-dev-api-task-execution-role`  
**Assumed by:** `ecs-tasks.amazonaws.com`  
**Used by:** Amazon ECS while starting the backend API task

**Attached permissions:**

- AWS managed policy: `AmazonECSTaskExecutionRolePolicy`
- Inline policy: `direct-ride-dev-api-task-execution-secrets`

**What it can do:**

- Pull the backend API image from ECR
- Write container logs to CloudWatch Logs
- Read startup secrets from Secrets Manager

**Secrets available during task startup:**

- RDS-managed database master user secret
- JWT secret created by Terraform

## ECS Task Application Role

**Role name:** `direct-ride-dev-api-task-role`  
**Assumed by:** `ecs-tasks.amazonaws.com`  
**Used by:** the running DirectRide API container

**Inline policy:** `direct-ride-dev-api-task`

**What it can do:**

- Read configured application secrets from Secrets Manager
- Read non-secret application config from SSM Parameter Store
- Optionally read and write the uploads S3 bucket when `uploads_bucket_arn` is set
- Optionally send email through SES when `enable_ses_permissions = true`

**Default app config path:**

- `/direct-ride-dev/api/config`

**Secrets available to the application:**

- RDS-managed database master user secret
- JWT secret created by Terraform

## Backend GitHub Actions Deploy Role

**Role name:** `direct-ride-dev-github-actions-deploy-role`  
**Assumed by:** GitHub Actions through OIDC  
**Created when:** `backend_github_repository` is set

**Trust relationship:**

- OIDC provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Subject: `repo:<backend_github_repository>:ref:refs/heads/<github_branch>`
- Default branch value: `main`

**Inline policy:** `direct-ride-dev-github-actions-deploy`

**What it can do:**

- Authenticate to ECR with `ecr:GetAuthorizationToken`
- Push backend Docker images to the configured ECR repository
- Describe ECS clusters, services, task definitions, and tasks
- Register new ECS task definitions
- Update the backend ECS service
- Pass the ECS task execution role and ECS task application role to ECS tasks

## Frontend GitHub Actions Deploy Role

**Role name:** `direct-ride-dev-frontend-deploy-role`  
**Assumed by:** GitHub Actions through OIDC  
**Created by:** `modules/github-oidc-deploy-role`

**Required repository settings:**

- `frontend_github_repository`, or both `github_org` and `github_repo`
- `github_branch`, which defaults to `main`

**OIDC provider behavior:**

- Reuses `frontend_github_oidc_provider_arn` when provided
- Reuses the backend OIDC provider when `backend_github_repository` is set
- Creates a frontend OIDC provider only when no frontend provider ARN is supplied and no backend repository is configured

**Trust relationship:**

- OIDC provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Subject: `repo:<frontend repository>:ref:refs/heads/<github_branch>`

**Inline policy:** `direct-ride-dev-frontend-deploy-role-policy`

**What it can do:**

- Read bucket location and list the frontend website bucket
- Upload, read, and delete frontend website objects in S3
- Create invalidations for the frontend CloudFront distribution
