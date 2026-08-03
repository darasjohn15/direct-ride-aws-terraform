# Security Groups

## Overview

DirectRide uses separate security groups for the Application Load Balancer, ECS tasks, and PostgreSQL database. This layered approach restricts communication so that each component accepts traffic only from the resources that require access.

## Application Load Balancer Security Group

**Purpose:** Allows public web traffic to reach the DirectRide API load balancer.

Security group name: `direct-ride-dev-api-alb-sg`

### Inbound Rules

| Protocol | Port | Source | Reason |
|---|---:|---|---|
| TCP | 80 | `0.0.0.0/0` | Optional public HTTP API traffic when `backend_api_enable_http_ingress = true` |
| TCP | 443 | `0.0.0.0/0` | HTTPS ingress allowed by the security group |

Note: the security group allows port `443`, but the compute module currently creates only an HTTP listener on port `80`.

### Outbound Rules

| Protocol | Port | Destination | Reason |
|---|---:|---|---|
| TCP | 8080 | ECS Security Group | Forward traffic to ECS tasks |

## ECS Security Group

**Purpose:** Protects the DirectRide API containers.

Security group name: `direct-ride-dev-api-ecs-sg`

### Inbound Rules

| Protocol | Port | Source | Reason |
|---|---:|---|---|
| TCP | 8080 | ALB Security Group | API traffic from the load balancer |

### Outbound Rules

| Protocol | Port | Destination | Reason |
|---|---:|---|---|
| All | All | `0.0.0.0/0` | All outbound traffic from ECS tasks, including database and AWS service access |

## RDS Security Group

**Purpose:** Restricts PostgreSQL access to the DirectRide API.

Security group name: `direct-ride-dev-postgresql-sg`

### Inbound Rules

| Protocol | Port | Source | Reason |
|---|---:|---|---|
| TCP | 5432 | ECS Security Group | Database traffic from the API |

### Outbound Rules

| Protocol | Port | Destination | Reason |
|---|---:|---|---|
| All | All | `0.0.0.0/0` | Default outbound traffic allowed by the database security group |
