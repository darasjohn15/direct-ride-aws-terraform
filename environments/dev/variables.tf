variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and resource names."
  type        = string
  default     = "direct-ride"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "frontend_website_bucket_name" {
  description = "Optional explicit S3 bucket name for hosting the frontend website."
  type        = string
  default     = null
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "direct_ride"
}

variable "db_username" {
  description = "PostgreSQL master username."
  type        = string
  default     = "directrideadmin"
}

variable "db_instance_class" {
  description = "Instance class for the PostgreSQL database."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Allocated database storage in GiB."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum database storage in GiB for storage autoscaling."
  type        = number
  default     = 100
}

variable "db_deletion_protection" {
  description = "Whether deletion protection is enabled for the dev database."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the dev database."
  type        = bool
  default     = true
}

variable "backend_api_image_tag" {
  description = "Image tag from the backend API ECR repository used by the ECS task."
  type        = string
  default     = "latest"
}

variable "backend_api_ecr_repository_name" {
  description = "Optional explicit ECR repository name for the backend API image."
  type        = string
  default     = null
}

variable "backend_api_ecr_image_tag_mutability" {
  description = "Tag mutability setting for the backend API ECR repository."
  type        = string
  default     = "MUTABLE"
}

variable "backend_api_ecr_scan_on_push" {
  description = "Whether ECR scans backend API images when they are pushed."
  type        = bool
  default     = true
}

variable "backend_api_ecr_force_delete" {
  description = "Whether Terraform can delete the backend API ECR repository even when it contains images."
  type        = bool
  default     = false
}

variable "backend_api_ecr_untagged_image_retention_days" {
  description = "Number of days to retain untagged backend API images."
  type        = number
  default     = 14
}

variable "backend_api_ecr_tagged_image_retention_count" {
  description = "Number of tagged backend API images to retain."
  type        = number
  default     = 30
}

variable "backend_api_container_port" {
  description = "Port exposed by the backend API container."
  type        = number
  default     = 8080
}

variable "backend_api_desired_count" {
  description = "Desired number of backend API ECS tasks."
  type        = number
  default     = 1
}

variable "backend_api_task_cpu" {
  description = "CPU units allocated to the backend API Fargate task."
  type        = number
  default     = 256
}

variable "backend_api_task_memory" {
  description = "Memory in MiB allocated to the backend API Fargate task."
  type        = number
  default     = 512
}

variable "backend_api_health_check_path" {
  description = "HTTP path used by the backend API target group health check."
  type        = string
  default     = "/health"
}

variable "backend_api_enable_http_ingress" {
  description = "Whether to allow public HTTP traffic to the backend API load balancer. Keep enabled when HTTP will redirect to HTTPS."
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the deploy role, in owner/name format. Leave null to skip GitHub OIDC resources."
  type        = string
  default     = null
}

variable "github_branch" {
  description = "Git branch allowed to assume the GitHub Actions deploy role."
  type        = string
  default     = "main"
}

variable "ecr_repository_arns" {
  description = "Additional ECR repository ARNs GitHub Actions can push images to."
  type        = list(string)
  default     = []
}

variable "cloudfront_distribution_arns" {
  description = "CloudFront distribution ARNs GitHub Actions can invalidate. Defaults to all distributions until CloudFront is added."
  type        = list(string)
  default     = []
}

variable "jwt_secret_name" {
  description = "Optional explicit name for the dev JWT Secrets Manager secret."
  type        = string
  default     = null
}

variable "jwt_secret_length" {
  description = "Length of the generated dev JWT secret value."
  type        = number
  default     = 64
}

variable "app_config_parameter_path_prefix" {
  description = "SSM Parameter Store path prefix for dev backend API app config."
  type        = string
  default     = null
}

variable "app_config_parameters" {
  description = "Non-secret dev backend API config values to create in SSM Parameter Store. Keys are relative parameter names."
  type        = map(string)
  default     = {}
}

variable "uploads_bucket_arn" {
  description = "Optional uploads S3 bucket ARN the backend API task role can read and write."
  type        = string
  default     = null
}

variable "enable_ses_permissions" {
  description = "Whether to allow the backend API task role to send email through SES."
  type        = bool
  default     = false
}
