data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  create_github_oidc = var.github_repository != null

  github_oidc_url  = "https://token.actions.githubusercontent.com"
  github_oidc_host = "token.actions.githubusercontent.com"
  github_sub       = var.github_repository == null ? null : "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"

  ecs_cluster_name            = coalesce(var.ecs_cluster_name, "${var.name_prefix}-api-cluster")
  ecs_service_name            = coalesce(var.ecs_service_name, "${var.name_prefix}-api-service")
  ecs_task_definition_family  = coalesce(var.ecs_task_definition_family, "${var.name_prefix}-api")
  ecs_cluster_arn             = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.ecs_cluster_name}"
  ecs_service_arn             = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${local.ecs_cluster_name}/${local.ecs_service_name}"
  ecs_task_definition_arn_all = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${local.ecs_task_definition_family}:*"

  app_config_parameter_path = trimsuffix(coalesce(var.app_config_parameter_path_prefix, "/${var.name_prefix}/api/config"), "/")
  app_config_parameter_arns = [
    "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.app_config_parameter_path}",
    "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.app_config_parameter_path}/*",
  ]
  task_execution_secret_arns = concat(var.task_execution_secret_arns, [aws_secretsmanager_secret.jwt.arn])
  application_secret_arns    = concat(var.application_secret_arns, [aws_secretsmanager_secret.jwt.arn])

  ecr_repository_resources = length(var.ecr_repository_arns) > 0 ? var.ecr_repository_arns : ["*"]
  cloudfront_resources     = length(var.cloudfront_distribution_arns) > 0 ? var.cloudfront_distribution_arns : ["*"]
  ses_resources            = ["arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identity/*"]
  create_application_policy = (
    length(local.application_secret_arns) > 0 ||
    local.app_config_parameter_path != null ||
    var.uploads_bucket_arn != null ||
    var.enable_ses_permissions
  )
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  count = local.create_github_oidc ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.github_oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.github_oidc_host}:sub"
      values   = [local.github_sub]
    }
  }
}

data "aws_iam_policy_document" "github_actions_deploy" {
  count = local.create_github_oidc ? 1 : 0

  statement {
    sid = "PushDockerImagesToEcr"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    resources = local.ecr_repository_resources
  }

  statement {
    sid = "AuthenticateToEcr"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    sid = "UpdateEcsService"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
    ]

    resources = [local.ecs_service_arn]
  }

  statement {
    sid = "DescribeEcsDeployments"

    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeTaskDefinition",
      "ecs:ListTasks",
    ]

    resources = [
      local.ecs_cluster_arn,
      local.ecs_task_definition_arn_all,
    ]
  }

  statement {
    sid = "RegisterTaskDefinition"

    actions = [
      "ecs:RegisterTaskDefinition",
    ]

    resources = ["*"]
  }

  statement {
    sid = "PassEcsTaskRoles"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      aws_iam_role.ecs_task_execution.arn,
      aws_iam_role.ecs_task_application.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    sid = "UploadFrontendFiles"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      var.frontend_website_bucket_arn,
      "${var.frontend_website_bucket_arn}/*",
    ]
  }

  statement {
    sid = "InvalidateCloudFrontCache"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetInvalidation",
    ]

    resources = local.cloudfront_resources
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_secrets" {
  count = length(local.task_execution_secret_arns) > 0 ? 1 : 0

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = local.task_execution_secret_arns
  }
}

data "aws_iam_policy_document" "ecs_task_application" {
  count = local.create_application_policy ? 1 : 0

  dynamic "statement" {
    for_each = length(local.application_secret_arns) == 0 ? [] : [local.application_secret_arns]

    content {
      sid = "ReadApplicationSecrets"

      actions = [
        "secretsmanager:GetSecretValue",
      ]

      resources = statement.value
    }
  }

  statement {
    sid = "ReadAppConfigParameters"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = local.app_config_parameter_arns
  }

  dynamic "statement" {
    for_each = var.uploads_bucket_arn == null ? [] : [var.uploads_bucket_arn]

    content {
      sid = "ReadWriteUploadsBucket"

      actions = [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
      ]

      resources = [
        statement.value,
        "${statement.value}/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.enable_ses_permissions ? [1] : []

    content {
      sid = "SendEmailWithSes"

      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail",
      ]

      resources = local.ses_resources
    }
  }
}

resource "random_password" "jwt_secret" {
  length  = var.jwt_secret_length
  special = false
}

resource "aws_secretsmanager_secret" "jwt" {
  name        = coalesce(var.jwt_secret_name, "${var.name_prefix}/api/jwt")
  description = "JWT signing secret for the ${var.name_prefix} backend API"

  tags = merge(var.tags, {
    Name = coalesce(var.jwt_secret_name, "${var.name_prefix}/api/jwt")
  })
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id     = aws_secretsmanager_secret.jwt.id
  secret_string = random_password.jwt_secret.result
}

resource "aws_ssm_parameter" "app_config" {
  for_each = var.app_config_parameters

  name  = "${local.app_config_parameter_path}/${trim(each.key, "/")}"
  type  = "String"
  value = each.value

  tags = merge(var.tags, {
    Name = "${local.app_config_parameter_path}/${trim(each.key, "/")}"
  })
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  count = local.create_github_oidc ? 1 : 0

  url             = local.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_oidc_thumbprints

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-github-actions-oidc"
  })
}

resource "aws_iam_role" "github_actions_deploy" {
  count = local.create_github_oidc ? 1 : 0

  name               = "${var.name_prefix}-github-actions-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role[0].json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-github-actions-deploy-role"
  })
}

resource "aws_iam_role_policy" "github_actions_deploy" {
  count = local.create_github_oidc ? 1 : 0

  name   = "${var.name_prefix}-github-actions-deploy"
  role   = aws_iam_role.github_actions_deploy[0].id
  policy = data.aws_iam_policy_document.github_actions_deploy[0].json
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.name_prefix}-api-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-api-task-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "task_execution_secrets" {
  count = length(local.task_execution_secret_arns) > 0 ? 1 : 0

  name   = "${var.name_prefix}-api-task-execution-secrets"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.task_execution_secrets[0].json
}

resource "aws_iam_role" "ecs_task_application" {
  name               = "${var.name_prefix}-api-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-api-task-role"
  })
}

resource "aws_iam_role_policy" "ecs_task_application" {
  count = local.create_application_policy ? 1 : 0

  name   = "${var.name_prefix}-api-task"
  role   = aws_iam_role.ecs_task_application.id
  policy = data.aws_iam_policy_document.ecs_task_application[0].json
}
