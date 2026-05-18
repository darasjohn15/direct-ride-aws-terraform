variable "name_prefix" {
  description = "Prefix used when naming ECR resources."
  type        = string
}

variable "repository_name" {
  description = "Optional explicit ECR repository name for the backend API image."
  type        = string
  default     = null
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the backend API ECR repository."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Whether ECR scans images when they are pushed."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Whether Terraform can delete the repository even when it contains images."
  type        = bool
  default     = false
}

variable "untagged_image_retention_days" {
  description = "Number of days to retain untagged images."
  type        = number
  default     = 14
}

variable "tagged_image_retention_count" {
  description = "Number of tagged images to retain."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to all ECR resources."
  type        = map(string)
  default     = {}
}
