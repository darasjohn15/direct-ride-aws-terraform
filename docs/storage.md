# Storage

## Overview

DirectRide uses Amazon S3 to store the React frontend static website and Amazon CloudFront to serve it over HTTPS. The storage layer is intentionally focused in the development environment but is structured to accommodate additional storage resources, such as uploads or application assets, as the platform evolves.

## Frontend Website S3 Bucket

### Bucket Configuration

| Property | Value |
|---|---|
| Purpose | Hosts the static React frontend website |
| Default Dev Bucket Name | `direct-ride-frontend-dev` |
| Module Fallback Name | `direct-ride-dev-frontend` |
| Website Index Document | `index.html` |
| Website Error Document | `index.html` |
| Website URL Output | `frontend_website_url` |
| Website Endpoint Output | `frontend_website_endpoint` |

The dev environment sets `frontend_website_bucket_name` to `direct-ride-frontend-dev` by default. If that value is changed to `null`, the storage module falls back to the generated name `direct-ride-dev-frontend`.

### Access and Ownership

| Property | Value |
|---|---|
| Object Ownership | `BucketOwnerEnforced` |
| Public ACLs | Blocked |
| Public Bucket Policy | Allowed |
| Public Object Reads | Allowed with `s3:GetObject` on bucket objects |
| ACL Handling | Public ACLs are ignored |
| Restrict Public Buckets | Disabled |

The bucket is intentionally public-readable because it is configured for S3 static website hosting.

### Data Protection

| Property | Value |
|---|---|
| Server-Side Encryption | Enabled |
| Encryption Algorithm | `AES256` |
| Versioning | Enabled |

### Frontend CloudFront Distribution

CloudFront sits in front of the S3 website endpoint and is the preferred public URL for the frontend.

| Property | Value |
|---|---|
| Origin | S3 website endpoint |
| Viewer Protocol Policy | Redirect HTTP to HTTPS |
| Default Root Object | `index.html` |
| IPv6 | Enabled |
| Compression | Enabled |
| Price Class | `PriceClass_100` |
| Viewer Certificate | CloudFront default certificate |
| Attached WAF | `direct-ride-dev-frontend-web-acl` |
| HTTPS URL Output | `frontend_cloudfront_url` |
| Distribution ID Output | `frontend_cloudfront_distribution_id` |

The distribution uses the S3 website endpoint as a custom origin so the existing website configuration and single-page app fallback behavior remain intact. Custom error responses map `403` and `404` responses back to `index.html`.

### Frontend WAF Web ACL

The frontend CloudFront distribution has an AWS WAFv2 web ACL attached for edge request inspection.

| Property | Value |
|---|---|
| Scope | `CLOUDFRONT` |
| Default Action | Allow |
| Managed Rule Group | `AWSManagedRulesCommonRuleSet` |
| Managed Rule Group | `AWSManagedRulesKnownBadInputsRuleSet` |
| Metrics | CloudWatch metrics and sampled requests enabled |
| Region Provider | `aws.us_east_1` |

CloudFront-scoped WAF web ACLs are managed through `us-east-1`, even when the rest of the environment uses another AWS region.

### Terraform Outputs

- `frontend_website_bucket_id`
- `frontend_website_bucket_arn`
- `frontend_website_bucket_regional_domain_name`
- `frontend_website_endpoint`
- `frontend_website_url`
- `frontend_cloudfront_distribution_id`
- `frontend_cloudfront_distribution_arn`
- `frontend_cloudfront_domain_name`
- `frontend_cloudfront_hosted_zone_id`
- `frontend_cloudfront_url`
- `frontend_waf_web_acl_arn`
- `frontend_waf_web_acl_id`
- `frontend_waf_web_acl_name`
