locals {
  generated_website_bucket_name = lower("${var.name_prefix}-frontend")
  website_bucket_name           = coalesce(var.website_bucket_name, local.generated_website_bucket_name)
  website_origin_id             = "${local.website_bucket_name}-website-origin"
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

resource "aws_wafv2_web_acl" "frontend_website" {
  provider = aws.us_east_1

  name        = "${var.name_prefix}-frontend-web-acl"
  description = "Managed protections for the ${var.name_prefix} frontend CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-frontend-common"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-frontend-known-bad-inputs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-frontend-web-acl"
    sampled_requests_enabled   = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-frontend-web-acl"
  })
}

resource "aws_cloudfront_distribution" "frontend_website" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Frontend website distribution for ${var.name_prefix}"
  default_root_object = var.website_index_document
  price_class         = var.cloudfront_price_class
  web_acl_id          = aws_wafv2_web_acl.frontend_website.arn

  origin {
    domain_name = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
    origin_id   = local.website_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = local.website_origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/${var.website_error_document}"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/${var.website_error_document}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-frontend"
  })
}
