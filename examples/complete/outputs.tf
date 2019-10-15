output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "Public subnet CIDRs"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDRs"
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC ID"
}

output "elastic_beanstalk_application_name" {
  value       = module.jenkins.elastic_beanstalk_application_name
  description = "Elastic Beanstalk Application name"
}

output "elastic_beanstalk_environment_hostname" {
  value       = module.jenkins.elastic_beanstalk_environment_hostname
  description = "DNS hostname"
}

output "elastic_beanstalk_environment_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = module.jenkins.elastic_beanstalk_environment_id
}

output "elastic_beanstalk_environment_name" {
  value       = module.jenkins.elastic_beanstalk_environment_name
  description = "Name"
}

output "elastic_beanstalk_environment_security_group_id" {
  value       = module.jenkins.elastic_beanstalk_environment_security_group_id
  description = "Security group id"
}

output "elastic_beanstalk_environment_elb_zone_id" {
  value       = module.jenkins.elastic_beanstalk_environment_elb_zone_id
  description = "ELB zone id"
}

output "elastic_beanstalk_environment_ec2_instance_profile_role_name" {
  value       = module.jenkins.elastic_beanstalk_environment_ec2_instance_profile_role_name
  description = "Instance IAM role name"
}

output "elastic_beanstalk_environment_tier" {
  description = "The environment tier"
  value       = module.jenkins.elastic_beanstalk_environment_tier
}

output "elastic_beanstalk_environment_setting" {
  description = "Settings specifically set for this environment"
  value       = module.jenkins.elastic_beanstalk_environment_setting
}

output "elastic_beanstalk_environment_all_settings" {
  description = "List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration"
  value       = module.jenkins.elastic_beanstalk_environment_all_settings
}

output "elastic_beanstalk_environment_endpoint" {
  description = "Fully qualified DNS name for the environment"
  value       = module.jenkins.elastic_beanstalk_environment_endpoint
}

output "elastic_beanstalk_environment_autoscaling_groups" {
  description = "The autoscaling groups used by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_autoscaling_groups
}

output "elastic_beanstalk_environment_instances" {
  description = "Instances used by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_instances
}

output "elastic_beanstalk_environment_launch_configurations" {
  description = "Launch configurations in use by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_launch_configurations
}

output "elastic_beanstalk_environment_load_balancers" {
  description = "Elastic Load Balancers in use by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_load_balancers
}

output "elastic_beanstalk_environment_queues" {
  description = "SQS queues in use by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_queues
}

output "elastic_beanstalk_environment_triggers" {
  description = "Autoscaling triggers in use by this environment"
  value       = module.jenkins.elastic_beanstalk_environment_triggers
}

output "ecr_registry_id" {
  value       = module.jenkins.ecr_registry_id
  description = "Registry ID"
}

output "ecr_registry_url" {
  value       = module.jenkins.ecr_registry_url
  description = "Registry URL"
}

output "ecr_repository_name" {
  value       = module.jenkins.ecr_repository_name
  description = "Registry name"
}

output "efs_arn" {
  value       = module.jenkins.efs_arn
  description = "EFS ARN"
}

output "efs_id" {
  value       = module.jenkins.efs_id
  description = "EFS ID"
}

output "efs_host" {
  value       = module.jenkins.efs_host
  description = "Route53 DNS hostname for the EFS"
}

output "efs_dns_name" {
  value       = module.jenkins.efs_dns_name
  description = "EFS DNS name"
}

output "efs_mount_target_dns_names" {
  value       = module.jenkins.efs_mount_target_dns_names
  description = "List of EFS mount target DNS names"
}

output "efs_mount_target_ids" {
  value       = module.jenkins.efs_mount_target_ids
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "efs_mount_target_ips" {
  value       = module.jenkins.efs_mount_target_ips
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "efs_network_interface_ids" {
  value       = module.jenkins.efs_network_interface_ids
  description = "List of mount target network interface IDs"
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.jenkins.codebuild_project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.jenkins.codebuild_project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.jenkins.codebuild_role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.jenkins.codebuild_role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.jenkins.codebuild_cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.jenkins.codebuild_cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.jenkins.codebuild_badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = module.jenkins.codepipeline_id
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = module.jenkins.codepipeline_arn
}

output "efs_backup_vault_id" {
  value       = module.jenkins.efs_backup_vault_id
  description = "Backup Vault ID"
}

output "efs_backup_vault_arn" {
  value       = module.jenkins.efs_backup_vault_arn
  description = "Backup Vault ARN"
}

output "efs_backup_vault_recovery_points" {
  value       = module.jenkins.efs_backup_vault_recovery_points
  description = "Backup Vault recovery points"
}

output "efs_backup_plan_arn" {
  value       = module.jenkins.efs_backup_plan_arn
  description = "Backup Plan ARN"
}

output "efs_backup_plan_version" {
  value       = module.jenkins.efs_backup_plan_version
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan"
}

output "efs_backup_selection_id" {
  value       = module.jenkins.efs_backup_selection_id
  description = "Backup Selection ID"
}
