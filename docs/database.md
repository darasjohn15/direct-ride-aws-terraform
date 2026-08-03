# RDS PostgreSQL

## Overview 

The DirectRide application stores its relational data in Amazon RDS for PostgreSQL. The database is deployed into private database subnets, encrypted at rest, and accessible only by the backend API running on Amazon ECS.

## Database Instance

| Property | Value |
|---|---|
| Identifier | `direct-ride-dev-postgresql` |
| Engine | PostgreSQL |
| Initial Database Name | `direct_ride` |
| Master Username | `directrideadmin` |
| Instance Class | `db.t4g.micro` |
| Deployment | Single RDS instance |
| Publicly Accessible | No |
| DB Subnet Group | `direct-ride-dev-db-subnet-group` |
| Subnets | Private database subnets |
| Port | `5432` |
| Storage Type | `gp3` |
| Allocated Storage | `20` GiB |
| Maximum Storage | `100` GiB |
| Storage Encryption | Enabled |
| Master Password | Managed by RDS in Secrets Manager |
| Backup Retention | `7` days |
| Deletion Protection | Disabled |
| Final Snapshot on Destroy | Skipped |
| Auto Minor Version Upgrade | Enabled |
| Copy Tags to Snapshots | Enabled |

## Networking and Security

| Property | Value |
|---|---|
| VPC | `direct-ride-dev-vpc` |
| Security Group | `direct-ride-dev-postgresql-sg` |
| Inbound Access | PostgreSQL `5432` from the ECS task security group |
| Outbound Access | All outbound traffic to `0.0.0.0/0` |

## Terraform Outputs

- `db_instance_id`
- `db_instance_arn`
- `db_endpoint`
- `db_address`
- `db_port`
- `db_name`
- `db_username`
- `db_master_user_secret_arn`
- `db_security_group_id`
