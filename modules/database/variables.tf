variable "name_prefix" {
  description = "Prefix used when naming database resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the database security group is created."
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group used by the PostgreSQL instance."
  type        = string
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

variable "allocated_storage" {
  description = "Allocated database storage in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum database storage in GiB for storage autoscaling."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the database."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the database."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to all database resources."
  type        = map(string)
  default     = {}
}
