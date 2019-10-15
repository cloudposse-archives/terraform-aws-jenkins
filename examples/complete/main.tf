provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  tags       = var.tags
  delimiter  = var.delimiter
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  tags                 = var.tags
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "jenkins" {
  source      = "../../"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  description = var.description

  master_instance_type = var.master_instance_type
  aws_account_id       = var.aws_account_id
  region               = var.region
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  dns_zone_id          = var.dns_zone_id
  loadbalancer_subnets = module.subnets.public_subnet_ids
  application_subnets  = module.subnets.private_subnet_ids

  environment_type                       = var.environment_type
  loadbalancer_type                      = var.loadbalancer_type
  loadbalancer_certificate_arn           = var.loadbalancer_certificate_arn
  availability_zone_selector             = var.availability_zone_selector
  rolling_update_type                    = var.rolling_update_type
  loadbalancer_logs_bucket_force_destroy = var.loadbalancer_logs_bucket_force_destroy
  cicd_bucket_force_destroy              = var.cicd_bucket_force_destroy

  github_oauth_token  = var.github_oauth_token
  github_organization = var.github_organization
  github_repo_name    = var.github_repo_name
  github_branch       = var.github_branch

  image_tag = var.image_tag

  healthcheck_url = var.healthcheck_url

  build_image        = var.build_image
  build_compute_type = var.build_compute_type

  efs_backup_schedule           = var.efs_backup_schedule
  efs_backup_start_window       = var.efs_backup_start_window
  efs_backup_completion_window  = var.efs_backup_completion_window
  efs_backup_cold_storage_after = var.efs_backup_cold_storage_after
  efs_backup_delete_after       = var.efs_backup_delete_after

  env_vars = {
    "JENKINS_USER"          = var.jenkins_username
    "JENKINS_PASS"          = var.jenkins_password
    "JENKINS_NUM_EXECUTORS" = var.jenkins_num_executors
  }
}
