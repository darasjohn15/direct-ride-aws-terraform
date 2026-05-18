data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  generated_website_bucket_name = lower("${var.name_prefix}-frontend-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}")
  website_bucket_name           = coalesce(var.website_bucket_name, local.generated_website_bucket_name)
}

resource "aws_s3_bucket" "frontend_website" {
  bucket = local.website_bucket_name

  tags = merge(var.tags, {
    Name = local.website_bucket_name
  })
}

resource "aws_s3_bucket_ownership_controls" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id

  index_document {
    suffix = var.website_index_document
  }

  error_document {
    key = var.website_error_document
  }
}

data "aws_iam_policy_document" "frontend_website" {
  statement {
    sid = "AllowPublicReadForWebsite"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.frontend_website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "frontend_website" {
  bucket = aws_s3_bucket.frontend_website.id
  policy = data.aws_iam_policy_document.frontend_website.json

  depends_on = [
    aws_s3_bucket_public_access_block.frontend_website,
  ]
}
