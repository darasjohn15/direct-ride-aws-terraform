variable "name_prefix" {
  description = "Prefix used when naming storage resources."
  type        = string
}

variable "website_bucket_name" {
  description = "Optional explicit name for the frontend website bucket. Leave null to generate an account-scoped name."
  type        = string
  default     = null
}

variable "website_index_document" {
  description = "Index document for the frontend website bucket."
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "Error document for the frontend website bucket."
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Tags applied to all storage resources."
  type        = map(string)
  default     = {}
}
