# Compute

## Overview

The DirectRide backend runs as a containerized .NET application on Amazon ECS using AWS Fargate. Incoming requests are routed through an Application Load Balancer to ECS tasks running in private application subnets, while application logs are centralized in CloudWatch Logs.

## ECS Cluster

| Property | Value |
|---|---|
| Name | `direct-ride-dev-api-cluster` |
| Launch Type | AWS Fargate |
| Region | `us-east-1` |
| Container Insights | Enabled |

## ECS Service

| Property | Value |
|---|---|
| Name | `direct-ride-dev-api-service` |
| Launch Type | `FARGATE` |
| Desired Tasks | `1` |
| Deployment Minimum Healthy Percent | `50` |
| Deployment Maximum Percent | `200` |
| Network Placement | Private app subnets |
| Public IP | Disabled |
| Security Group | `direct-ride-dev-api-ecs-sg` |
| Load Balancer | `direct-ride-dev-api-alb` |
| Target Group | `direct-ride-dev-api-tg` |

## Task Definition

| Property | Value |
|---|---|
| Family | `direct-ride-dev-api` |
| Container Name | `api` |
| Container Image | `<backend_api_ecr_repository_url>:<backend_api_image_tag>` |
| Default Image Tag | `latest` |
| Container Port | `8080` |
| Host Port | `8080` |
| Protocol | `tcp` |
| CPU | `256` |
| Memory | `512` MiB |
| Network Mode | `awsvpc` |
| Required Compatibility | `FARGATE` |
| Execution Role | `direct-ride-dev-api-task-execution-role` |
| Task Role | `direct-ride-dev-api-task-role` |

## Container Configuration

Plain environment variables:

- `DB_HOST`
- `DB_NAME`
- `DB_PORT`
- `DB_USER`

Injected ECS secrets:

- `DB_PASSWORD`
- `JWT_SECRET`

## Application Load Balancer

| Property | Value |
|---|---|
| Name | `direct-ride-dev-api-alb` |
| Type | Application Load Balancer |
| Scheme | Internet-facing |
| Subnets | Public subnets |
| Security Group | `direct-ride-dev-api-alb-sg` |
| Listener | HTTP on port `80` |
| Default Action | Forward to `direct-ride-dev-api-tg` |

Note: the ALB security group allows HTTPS ingress on port `443`, but this module currently creates only the HTTP listener on port `80`.

## Target Group

| Property | Value |
|---|---|
| Name | `direct-ride-dev-api-tg` |
| Protocol | HTTP |
| Port | `8080` |
| Target Type | `ip` |
| Health Check Path | `/health` |
| Health Check Matcher | `200-399` |
| Health Check Interval | `30` seconds |
| Health Check Timeout | `5` seconds |
| Healthy Threshold | `2` |
| Unhealthy Threshold | `3` |

## CloudWatch Logs

| Property | Value |
|---|---|
| Log Group | `/ecs/direct-ride-dev/api` |
| Retention | `14` days |
| Log Driver | `awslogs` |
| Stream Prefix | `api` |
