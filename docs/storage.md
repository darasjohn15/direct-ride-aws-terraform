# Storage

## Overview

DirectRide currently uses Amazon S3 to host the React frontend as a static website. The storage layer is intentionally minimal in the development environment but is structured to accommodate additional storage resources, such as uploads or application assets, as the platform evolves.

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

### Terraform Outputs

- `frontend_website_bucket_id`
- `frontend_website_bucket_arn`
- `frontend_website_bucket_regional_domain_name`
- `frontend_website_endpoint`
- `frontend_website_url`
