output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = [for az in var.availability_zones : aws_subnet.public[az].id]
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = [for az in var.availability_zones : aws_subnet.private_app[az].id]
}

output "private_app_subnet_cidrs" {
  description = "CIDR blocks of the private application subnets."
  value       = [for az in var.availability_zones : aws_subnet.private_app[az].cidr_block]
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets."
  value       = [for az in var.availability_zones : aws_subnet.private_db[az].id]
}

output "internet_gateway_id" {
  description = "ID of the internet gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway."
  value       = aws_nat_gateway.this.id
}

output "nat_eip_id" {
  description = "ID of the Elastic IP allocated for the NAT gateway."
  value       = aws_eip.nat.id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_app_route_table_id" {
  description = "ID of the private application route table."
  value       = aws_route_table.private_app.id
}

output "private_db_route_table_id" {
  description = "ID of the private database route table."
  value       = aws_route_table.private_db.id
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group."
  value       = aws_db_subnet_group.this.name
}
