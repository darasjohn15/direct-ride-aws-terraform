# Network

## Overview

The DirectRide development environment is deployed into a single Amazon VPC spanning two Availability Zones. Resources are separated into public, application, and database subnet tiers to provide high availability while limiting direct access to internal services.

## VPC

| Property | Value |
|---|---|
| Name | `direct-ride-dev-vpc` |
| CIDR Block | `10.0.0.0/16` |
| Region | `us-east-1` |
| DNS Support | Enabled |
| DNS Hostnames | Enabled |

## Subnets

| Subnet | CIDR Block | Availability Zone | Type | Resources |
|---|---|---|---|---|
| Public Subnet 1 | `10.0.1.0/24` | `us-east-1a` | Public | Application Load Balancer, NAT Gateway |
| Public Subnet 2 | `10.0.2.0/24` | `us-east-1b` | Public | Application Load Balancer |
| Private App Subnet 1 | `10.0.11.0/24` | `us-east-1a` | Private app | ECS Fargate tasks |
| Private App Subnet 2 | `10.0.12.0/24` | `us-east-1b` | Private app | ECS Fargate tasks |
| Private DB Subnet 1 | `10.0.21.0/24` | `us-east-1a` | Private database | RDS PostgreSQL |
| Private DB Subnet 2 | `10.0.22.0/24` | `us-east-1b` | Private database | RDS PostgreSQL |

## CIDR Hierarchy

10.0.0.0/16  VPC
│
├── 10.0.1.0/24   Public Subnet (AZ A)
├── 10.0.2.0/24   Public Subnet (AZ B)
│
├── 10.0.11.0/24  Private App (AZ A)
├── 10.0.12.0/24  Private App (AZ B)
│
├── 10.0.21.0/24  Private Database (AZ A)
└── 10.0.22.0/24  Private Database (AZ B)