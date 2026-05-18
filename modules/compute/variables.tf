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

variable "secret_access_arns" {
  description = "Secrets Manager secret ARNs that the task execution role can read for container secrets."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to all compute resources."
  type        = map(string)
  default     = {}
}
