# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances[*].public_ip
}

################################################################################
# DB Subnet Group
################################################################################

output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = module.aurora.db_subnet_group_name
}

################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora.cluster_id
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.aurora.cluster_resource_id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = module.aurora.cluster_members
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora.cluster_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.aurora.cluster_engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.aurora.cluster_database_name
}

output "cluster_port" {
  description = "The database port"
  value       = module.aurora.cluster_port
}

output "cluster_master_user_secret" {
  description = "The generated database master user secret when `manage_master_user_password` is set to `true`"
  value       = module.aurora.cluster_master_user_secret
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = module.aurora.cluster_hosted_zone_id
}

################################################################################
# Cluster Instance(s)
################################################################################

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.aurora.cluster_instances
}
