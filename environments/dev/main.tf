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

  db_name               = var.db_name
  db_username           = var.db_username
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  deletion_protection   = var.db_deletion_protection
  skip_final_snapshot   = var.db_skip_final_snapshot

  tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  name_prefix                   = local.name_prefix
  repository_name               = var.backend_api_ecr_repository_name
  image_tag_mutability          = var.backend_api_ecr_image_tag_mutability
  scan_on_push                  = var.backend_api_ecr_scan_on_push
  force_delete                  = var.backend_api_ecr_force_delete
  untagged_image_retention_days = var.backend_api_ecr_untagged_image_retention_days
  tagged_image_retention_count  = var.backend_api_ecr_tagged_image_retention_count

  tags = local.common_tags
}

resource "aws_security_group_rule" "database_ingress_ecs_tasks" {
  type                     = "ingress"
  description              = "PostgreSQL from ECS tasks"
  security_group_id        = module.database.db_security_group_id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.compute.ecs_security_group_id
}

module "security" {
  source = "../../modules/security"

  name_prefix       = local.name_prefix
  github_repository = var.github_repository
  github_branch     = var.github_branch

  ecr_repository_arns          = concat([module.ecr.repository_arn], var.ecr_repository_arns)
  frontend_website_bucket_arn  = module.storage.frontend_website_bucket_arn
  cloudfront_distribution_arns = var.cloudfront_distribution_arns

  task_execution_secret_arns = [
    module.database.db_master_user_secret_arn,
  ]

  application_secret_arns = [
    module.database.db_master_user_secret_arn,
  ]

  jwt_secret_name   = var.jwt_secret_name
  jwt_secret_length = var.jwt_secret_length

  app_config_parameter_path_prefix = var.app_config_parameter_path_prefix
  app_config_parameters            = var.app_config_parameters

  uploads_bucket_arn     = var.uploads_bucket_arn
  enable_ses_permissions = var.enable_ses_permissions

  tags = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  name_prefix            = local.name_prefix
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  container_image     = "${module.ecr.repository_url}:${var.backend_api_image_tag}"
  container_port      = var.backend_api_container_port
  desired_count       = var.backend_api_desired_count
  task_cpu            = var.backend_api_task_cpu
  task_memory         = var.backend_api_task_memory
  health_check_path   = var.backend_api_health_check_path
  enable_http_ingress = var.backend_api_enable_http_ingress

  task_execution_role_arn = module.security.ecs_task_execution_role_arn
  task_role_arn           = module.security.ecs_task_application_role_arn

  environment_variables = {
    DB_HOST = module.database.db_address
    DB_NAME = module.database.db_name
    DB_PORT = tostring(module.database.db_port)
    DB_USER = module.database.db_username
  }

  secrets = {
    DB_PASSWORD = "${module.database.db_master_user_secret_arn}:password::"
    JWT_SECRET  = module.security.jwt_secret_arn
  }

  tags = local.common_tags

  depends_on = [
    module.security,
  ]
}
