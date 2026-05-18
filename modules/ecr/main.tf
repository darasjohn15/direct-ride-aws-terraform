locals {
  repository_name = coalesce(var.repository_name, "${var.name_prefix}-api")
}

resource "aws_ecr_repository" "api" {
  name                 = local.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.tags, {
    Name = local.repository_name
  })
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after ${var.untagged_image_retention_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_retention_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep the last ${var.tagged_image_retention_count} tagged images"
        selection = {
          tagStatus = "tagged"
          tagPatternList = [
            "*",
          ]
          countType   = "imageCountMoreThan"
          countNumber = var.tagged_image_retention_count
        }
        action = {
          type = "expire"
        }
      },
    ]
  })
}
