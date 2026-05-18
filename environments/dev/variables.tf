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

variable "backend_api_container_image" {
  description = "Container image used by the backend API ECS task."
  type        = string
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
