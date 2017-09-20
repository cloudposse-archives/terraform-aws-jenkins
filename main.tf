# Elastic Beanstalk Application
module "eb_application" {
  source      = "git::https://github.com/cloudposse/tf_eb_application.git?ref=tags/0.1.1"
  namespace   = "${var.namespace}"
  name        = "${var.name}"
  stage       = "${var.stage}"
  description = "${var.description}"
}

# Elastic Beanstalk Environment
module "eb_environment" {
  source                  = "git::https://github.com/cloudposse/tf_eb_environment.git?ref=tags/0.3.0"
  attributes              = ["eb"]
  namespace               = "${var.namespace}"
  name                    = "${var.name}"
  stage                   = "${var.stage}"
  zone_id                 = "${var.zone_id}"
  app                     = "${module.eb_application.app_name}"
  autoscale_lower_bound   = "${var.autoscale_lower_bound}"
  autoscale_upper_bound   = "${var.autoscale_upper_bound}"
  autoscale_min           = "${var.autoscale_min}"
  autoscale_max           = "${var.autoscale_max}"
  instance_type           = "${var.eb_instance_type}"
  updating_min_in_service = "${var.updating_min_in_service}"
  updating_max_batch      = "${var.updating_max_batch}"
  healthcheck_url         = "${var.healthcheck_url}"
  loadbalancer_type       = "${var.loadbalancer_type}"
  vpc_id                  = "${var.vpc_id}"
  public_subnets          = "${var.public_subnets}"
  private_subnets         = "${var.private_subnets}"
  security_groups         = ["${var.security_groups}"]
  keypair                 = "${var.keypair}"
  solution_stack_name     = "${var.solution_stack_name}"
  env_default_key         = "${var.env_default_key}"
  env_default_value       = "${var.env_default_value}"
  env_map                 = "${var.env_map}"
}

# Elastic Container Registry Docker Repository
module "ecr" {
  source     = "git::https://github.com/cloudposse/tf_ecr.git?ref=tags/0.2.0"
  attributes = ["ecr"]
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
}

# CodePipeline/CodeBuild
module "cicd" {
  source             = "git::https://github.com/cloudposse/tf_cicd.git?ref=tags/0.4.0"
  attributes         = ["cicd"]
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  app                = "${module.eb_application.app_name}"
  env                = "${module.eb_environment.name}"
  enabled            = true
  github_oauth_token = "${var.github_oauth_token}"
  repo_owner         = "${var.github_organization}"
  repo_name          = "${var.github_repo_name}"
  branch             = "${var.github_branch}"
  build_image        = "${var.build_image}"
  build_compute_type = "${var.build_compute_type}"
  privileged_mode    = true
  aws_region         = "${var.region}"
  aws_account_id     = "${var.aws_account_id}"
  image_repo_name    = "${module.ecr.repository_name}"
  image_tag          = "${var.image_tag}"
}
