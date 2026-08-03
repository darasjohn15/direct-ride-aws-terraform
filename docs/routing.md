# Routing

## Overview 

The DirectRide VPC uses separate route tables for the public, application, and database subnet tiers. Each route table is configured to allow only the network access required by the resources in that tier, helping isolate internal services while still allowing outbound connectivity where needed.

## Public Route Table

Used by internet-facing resources such as the Application Load Balancer and NAT Gateway.

| Destination | Target | Purpose |
|---|---|---|
| `10.0.0.0/16` | Local | Internal VPC communication |
| `0.0.0.0/0` | Internet Gateway (`direct-ride-dev-igw`) | Public internet access |

Associated subnets:

- Public Subnet 1 (`10.0.1.0/24`)
- Public Subnet 2 (`10.0.2.0/24`)

## Private App Route Table

Used by ECS Fargate tasks that require outbound internet connectivity but should not receive inbound internet traffic.

| Destination | Target | Purpose |
|---|---|---|
| `10.0.0.0/16` | Local | Internal VPC communication |
| `0.0.0.0/0` | NAT Gateway (`direct-ride-dev-nat`) | Outbound internet access for private ECS tasks |

**Associated subnets:**

- Private App Subnet 1 (`10.0.11.0/24`)
- Private App Subnet 2 (`10.0.12.0/24`)

## Private Database Route Table

Used exclusively by the PostgreSQL database to keep database traffic internal to the VPC.

| Destination | Target | Purpose |
|---|---|---|
| `10.0.0.0/16` | Local | Internal VPC communication |

Associated subnets:

- Private DB Subnet 1 (`10.0.21.0/24`)
- Private DB Subnet 2 (`10.0.22.0/24`)