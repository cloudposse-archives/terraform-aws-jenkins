output "elastic_beanstalk_application_name" {
  value       = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  description = "Elastic Beanstalk Application name"
}

output "elastic_beanstalk_environment_hostname" {
  value       = module.elastic_beanstalk_environment.hostname
  description = "DNS hostname"
}

output "elastic_beanstalk_environment_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk_environment.id
}

output "elastic_beanstalk_environment_name" {
  value       = module.elastic_beanstalk_environment.name
  description = "Name"
}

output "elastic_beanstalk_environment_security_group_id" {
  value       = module.elastic_beanstalk_environment.security_group_id
  description = "Security group id"
}

output "elastic_beanstalk_environment_elb_zone_id" {
  value       = module.elastic_beanstalk_environment.elb_zone_id
  description = "ELB zone id"
}

output "elastic_beanstalk_environment_ec2_instance_profile_role_name" {
  value       = module.elastic_beanstalk_environment.ec2_instance_profile_role_name
  description = "Instance IAM role name"
}

output "elastic_beanstalk_environment_tier" {
  description = "The environment tier"
  value       = module.elastic_beanstalk_environment.tier
}

output "elastic_beanstalk_environment_application" {
  description = "The Elastic Beanstalk Application specified for this environment"
  value       = module.elastic_beanstalk_environment.application
}

output "elastic_beanstalk_environment_setting" {
  description = "Settings specifically set for this environment"
  value       = module.elastic_beanstalk_environment.setting
}

output "elastic_beanstalk_environment_all_settings" {
  description = "List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration"
  value       = module.elastic_beanstalk_environment.all_settings
}

output "elastic_beanstalk_environment_endpoint" {
  description = "Fully qualified DNS name for the environment"
  value       = module.elastic_beanstalk_environment.endpoint
}

output "elastic_beanstalk_environment_autoscaling_groups" {
  description = "The autoscaling groups used by this environment"
  value       = module.elastic_beanstalk_environment.autoscaling_groups
}

output "elastic_beanstalk_environment_instances" {
  description = "Instances used by this environment"
  value       = module.elastic_beanstalk_environment.instances
}

output "elastic_beanstalk_environment_launch_configurations" {
  description = "Launch configurations in use by this environment"
  value       = module.elastic_beanstalk_environment.launch_configurations
}

output "elastic_beanstalk_environment_load_balancers" {
  description = "Elastic Load Balancers in use by this environment"
  value       = module.elastic_beanstalk_environment.load_balancers
}

output "elastic_beanstalk_environment_queues" {
  description = "SQS queues in use by this environment"
  value       = module.elastic_beanstalk_environment.queues
}

output "elastic_beanstalk_environment_triggers" {
  description = "Autoscaling triggers in use by this environment"
  value       = module.elastic_beanstalk_environment.triggers
}

output "ecr_registry_id" {
  value       = module.ecr.registry_id
  description = "Registry ID"
}

output "ecr_registry_url" {
  value       = module.ecr.registry_url
  description = "Registry URL"
}

output "ecr_repository_name" {
  value       = module.ecr.repository_name
  description = "Registry name"
}

output "efs_arn" {
  value       = module.efs.arn
  description = "EFS ARN"
}

output "efs_id" {
  value       = module.efs.id
  description = "EFS ID"
}

output "efs_host" {
  value       = module.efs.host
  description = "Route53 DNS hostname for the EFS"
}

output "efs_dns_name" {
  value       = module.efs.dns_name
  description = "EFS DNS name"
}

output "efs_mount_target_dns_names" {
  value       = module.efs.mount_target_dns_names
  description = "List of EFS mount target DNS names"
}

output "efs_mount_target_ids" {
  value       = module.efs.mount_target_ids
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "efs_mount_target_ips" {
  value       = module.efs.mount_target_ips
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "efs_network_interface_ids" {
  value       = module.efs.network_interface_ids
  description = "List of mount target network interface IDs"
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.cicd.codebuild_project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.cicd.codebuild_project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.cicd.codebuild_role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.cicd.codebuild_role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.cicd.codebuild_cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.cicd.codebuild_cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.cicd.codebuild_badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = module.cicd.codepipeline_id
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = module.cicd.codepipeline_arn
}

output "efs_backup_vault_id" {
  value       = module.efs_backup.backup_vault_id
  description = "Backup Vault ID"
}

output "efs_backup_vault_arn" {
  value       = module.efs_backup.backup_vault_arn
  description = "Backup Vault ARN"
}

output "efs_backup_vault_recovery_points" {
  value       = module.efs_backup.backup_vault_recovery_points
  description = "Backup Vault recovery points"
}

output "efs_backup_plan_arn" {
  value       = module.efs_backup.backup_plan_arn
  description = "Backup Plan ARN"
}

output "efs_backup_plan_version" {
  value       = module.efs_backup.backup_plan_version
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan"
}

output "efs_backup_selection_id" {
  value       = module.efs_backup.backup_selection_id
  description = "Backup Selection ID"
}
