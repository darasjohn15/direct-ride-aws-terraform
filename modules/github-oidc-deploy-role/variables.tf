variable "name_prefix" {
  description = "Prefix used when naming shared GitHub OIDC resources."
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role GitHub Actions can assume."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume this role, in owner/name format."
  type        = string
  default     = null
}

variable "github_org" {
  description = "GitHub organization or username that owns the repository."
  type        = string
  default     = null
}

variable "github_repo" {
  description = "GitHub repository name allowed to assume this role."
  type        = string
  default     = null
}

variable "github_branch" {
  description = "Git branch allowed to assume this role."
  type        = string
  default     = "main"
}

variable "github_oidc_provider_arn" {
  description = "Existing GitHub Actions OIDC provider ARN to reuse when create_github_oidc_provider is false."
  type        = string
  default     = null
}

variable "create_github_oidc_provider" {
  description = "Whether this module should create a GitHub Actions OIDC provider instead of reusing one."
  type        = bool
  default     = true
}

variable "github_oidc_thumbprints" {
  description = "TLS thumbprints for the GitHub Actions OIDC provider."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket GitHub Actions can deploy to."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "Optional ARN of the CloudFront distribution GitHub Actions can invalidate."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to GitHub OIDC role resources."
  type        = map(string)
  default     = {}
}
