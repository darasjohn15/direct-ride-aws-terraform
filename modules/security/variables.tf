variable "name_prefix" {
  description = "Prefix used when naming security resources."
  type        = string
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

variable "github_oidc_thumbprints" {
  description = "TLS thumbprints for the GitHub Actions OIDC provider."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs GitHub Actions can push images to."
  type        = list(string)
  default     = []
}

variable "ecs_cluster_name" {
  description = "ECS cluster name GitHub Actions can deploy to."
  type        = string
  default     = null
}

variable "ecs_service_name" {
  description = "ECS service name GitHub Actions can update."
  type        = string
  default     = null
}

variable "ecs_task_definition_family" {
  description = "ECS task definition family GitHub Actions can register and describe."
  type        = string
  default     = null
}

variable "frontend_website_bucket_arn" {
  description = "Frontend S3 website bucket ARN GitHub Actions can upload files to."
  type        = string
}

variable "cloudfront_distribution_arns" {
  description = "CloudFront distribution ARNs GitHub Actions can invalidate."
  type        = list(string)
  default     = []
}

variable "task_execution_secret_arns" {
  description = "Secrets Manager secret ARNs the ECS task execution role can read to resolve container secrets."
  type        = list(string)
  default     = []
}

variable "jwt_secret_name" {
  description = "Optional explicit name for the JWT Secrets Manager secret."
  type        = string
  default     = null
}

variable "jwt_secret_length" {
  description = "Length of the generated JWT secret value."
  type        = number
  default     = 64
}

variable "application_secret_arns" {
  description = "Secrets Manager secret ARNs the ECS task application role can read at runtime."
  type        = list(string)
  default     = []
}

variable "app_config_parameter_path_prefix" {
  description = "SSM Parameter Store path prefix the ECS task application role can read for app config."
  type        = string
  default     = null
}

variable "app_config_parameters" {
  description = "Non-secret app config values to create in SSM Parameter Store under app_config_parameter_path_prefix. Keys are relative parameter names."
  type        = map(string)
  default     = {}
}

variable "uploads_bucket_arn" {
  description = "Optional uploads S3 bucket ARN the ECS task application role can read and write."
  type        = string
  default     = null
}

variable "enable_ses_permissions" {
  description = "Whether to allow the ECS task application role to send email through SES."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to all security resources."
  type        = map(string)
  default     = {}
}
