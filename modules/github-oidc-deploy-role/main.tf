locals {
  github_oidc_url  = "https://token.actions.githubusercontent.com"
  github_oidc_host = "token.actions.githubusercontent.com"
  github_sub       = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"

  oidc_provider_arn = coalesce(
    var.github_oidc_provider_arn,
    try(aws_iam_openid_connect_provider.github_actions[0].arn, null)
  )
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  count = var.github_oidc_provider_arn == null ? 1 : 0

  url             = local.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_oidc_thumbprints

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-github-actions-oidc"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
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

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name = var.role_name
  })
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid = "ListFrontendBucket"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [var.frontend_bucket_arn]
  }

  statement {
    sid = "WriteFrontendObjects"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["${var.frontend_bucket_arn}/*"]
  }

  dynamic "statement" {
    for_each = var.cloudfront_distribution_arn == null ? [] : [var.cloudfront_distribution_arn]

    content {
      sid = "InvalidateCloudFrontDistribution"

      actions = [
        "cloudfront:CreateInvalidation",
      ]

      resources = [statement.value]
    }
  }
}

resource "aws_iam_role_policy" "deploy" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.deploy.json
}
