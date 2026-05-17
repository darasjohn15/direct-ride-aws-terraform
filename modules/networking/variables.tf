variable "name_prefix" {
  description = "Prefix used when naming networking resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for the subnet layout."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDR blocks are required."
  }
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 2
    error_message = "Exactly two private application subnet CIDR blocks are required."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets, ordered to match availability_zones."
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Exactly two private database subnet CIDR blocks are required."
  }
}

variable "tags" {
  description = "Tags applied to all networking resources."
  type        = map(string)
  default     = {}
}
