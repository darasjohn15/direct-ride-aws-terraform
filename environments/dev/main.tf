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

module "storage" {
  source = "../../modules/storage"

  name_prefix         = local.name_prefix
  website_bucket_name = var.frontend_website_bucket_name

  tags = local.common_tags
}

module "database" {
  source = "../../modules/database"

  name_prefix          = local.name_prefix
  vpc_id               = module.networking.vpc_id
  db_subnet_group_name = module.networking.db_subnet_group_name
  allowed_cidr_blocks  = module.networking.private_app_subnet_cidrs

  db_name               = var.db_name
  db_username           = var.db_username
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  deletion_protection   = var.db_deletion_protection
  skip_final_snapshot   = var.db_skip_final_snapshot

  tags = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  name_prefix            = local.name_prefix
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  container_image   = var.backend_api_container_image
  container_port    = var.backend_api_container_port
  desired_count     = var.backend_api_desired_count
  task_cpu          = var.backend_api_task_cpu
  task_memory       = var.backend_api_task_memory
  health_check_path = var.backend_api_health_check_path

  environment_variables = {
    DB_HOST = module.database.db_address
    DB_NAME = module.database.db_name
    DB_PORT = tostring(module.database.db_port)
    DB_USER = module.database.db_username
  }

  secrets = {
    DB_PASSWORD = "${module.database.db_master_user_secret_arn}:password::"
  }

  secret_access_arns = [
    module.database.db_master_user_secret_arn,
  ]

  tags = local.common_tags
}
