locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix
  vpc_cidr    = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  private_app_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]

  private_db_subnet_cidrs = [
    "10.0.21.0/24",
    "10.0.22.0/24",
  ]

  tags = local.common_tags
}
