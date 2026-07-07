variable "name_prefix" {
  description = "Prefix used when naming budget resources."
  type        = string
}

variable "budget_name" {
  description = "Optional explicit name for the monthly cost budget."
  type        = string
  default     = null
}

variable "limit_amount" {
  description = "Monthly budget limit amount."
  type        = number
  default     = 20
}

variable "limit_unit" {
  description = "Unit of measurement for the budget limit."
  type        = string
  default     = "USD"
}

variable "time_unit" {
  description = "Budget reset period."
  type        = string
  default     = "MONTHLY"

  validation {
    condition     = contains(["DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"], var.time_unit)
    error_message = "time_unit must be one of DAILY, MONTHLY, QUARTERLY, or ANNUALLY."
  }
}

variable "warning_threshold_percentage" {
  description = "Actual spend percentage that triggers the warning budget email notification."
  type        = number
  default     = 50
}

variable "critical_threshold_percentage" {
  description = "Actual spend percentage that triggers the critical budget email notification."
  type        = number
  default     = 100
}

variable "notification_email" {
  description = "Email address that receives AWS Budget notifications."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.notification_email))
    error_message = "notification_email must be a valid email address."
  }
}

variable "tags" {
  description = "Tags applied to all budget resources."
  type        = map(string)
  default     = {}
}
