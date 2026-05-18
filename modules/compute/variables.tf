variable "name_prefix" {
  description = "Prefix used when naming compute resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where compute resources are created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the application load balancer."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by ECS tasks."
  type        = list(string)
}

variable "container_image" {
  description = "Container image used by the backend API task."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the backend API container."
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Desired number of backend API tasks."
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "CPU units allocated to the Fargate task."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory in MiB allocated to the Fargate task."
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "HTTP path used by the target group health check."
  type        = string
  default     = "/health"
}

variable "enable_http_ingress" {
  description = "Whether to allow public HTTP traffic to the API load balancer. Keep enabled when HTTP will redirect to HTTPS."
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Plain environment variables passed to the backend API container."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret environment variables passed to the backend API container. Values should be Secrets Manager or SSM Parameter Store valueFrom references."
  type        = map(string)
  default     = {}
}

variable "task_execution_role_arn" {
  description = "IAM role ARN used by ECS to pull images, write logs, and resolve container secrets."
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the backend API container at runtime."
  type        = string
}

variable "tags" {
  description = "Tags applied to all compute resources."
  type        = map(string)
  default     = {}
}
