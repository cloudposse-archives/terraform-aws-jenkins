# Elastic Beanstalk Application
module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=tags/0.1.2"
  namespace   = "${var.namespace}"
  name        = "${var.name}"
  stage       = "${var.stage}"
  description = "${var.description}"
}

# Elastic Beanstalk Environment
module "elastic_beanstalk_environment" {
  source        = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=tags/0.2.3"
  attributes    = ["eb"]
  namespace     = "${var.namespace}"
  name          = "${var.name}"
  stage         = "${var.stage}"
  zone_id       = "${var.zone_id}"
  app           = "${module.elastic_beanstalk_application.app_name}"
  instance_type = "${var.master_instance_type}"

  # Set `min` nad `max` number of running EC2 instances to `1` since we want only one Jenkins master running at any time
  autoscale_min = 1
  autoscale_max = 1

  # Since we set `autoscale_min = autoscale_max`, we need to set `updating_min_in_service` to 0 for the AutoScaling Group to work.
  # Elastic Beanstalk will terminate the master instance and replace it with a new one in case of any issues with it.
  # But it's OK since we store all Jenkins state (settings, jobs, etc.) on the EFS.
  # If the instance gets replaced or rebooted, Jenkins will find all the data on EFS after restart.
  updating_min_in_service = 0

  updating_max_batch = 1

  healthcheck_url     = "${var.healthcheck_url}"
  loadbalancer_type   = "${var.loadbalancer_type}"
  vpc_id              = "${var.vpc_id}"
  public_subnets      = "${var.public_subnets}"
  private_subnets     = "${var.private_subnets}"
  security_groups     = "${var.security_groups}"
  keypair             = "${var.keypair}"
  solution_stack_name = "${var.solution_stack_name}"
  env_default_key     = "${var.env_default_key}"
  env_default_value   = "${var.env_default_value}"

  env_vars = "${
      merge(
        map(
          "EFS_HOST", "${module.efs.dns_name}"
        ), var.env_vars
      )
    }"
}

# Elastic Container Registry Docker Repository
module "ecr" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.2.1"
  attributes = ["ecr"]
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
}

# EFS to store Jenkins state (settings, jobs, etc.)
module "efs" {
  source             = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=tags/0.3.0"
  attributes         = ["efs"]
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  aws_region         = "${var.aws_region}"
  vpc_id             = "${var.vpc_id}"
  subnets            = "${var.private_subnets}"
  availability_zones = "${var.availability_zones}"
  security_groups    = ["${module.elastic_beanstalk_environment.security_group_id}"]             # EB/EC2 instances are allowed to connect to the EFS
  zone_id            = "${var.zone_id}"
}

# CodePipeline/CodeBuild
module "cicd" {
  source             = "git::https://github.com/cloudposse/terraform-aws-cicd.git?ref=tags/0.4.1"
  attributes         = ["cicd"]
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  app                = "${module.elastic_beanstalk_application.app_name}"
  env                = "${module.elastic_beanstalk_environment.name}"
  enabled            = "true"
  github_oauth_token = "${var.github_oauth_token}"
  repo_owner         = "${var.github_organization}"
  repo_name          = "${var.github_repo_name}"
  branch             = "${var.github_branch}"
  build_image        = "${var.build_image}"
  build_compute_type = "${var.build_compute_type}"
  privileged_mode    = "true"
  aws_region         = "${var.aws_region}"
  aws_account_id     = "${var.aws_account_id}"
  image_repo_name    = "${module.ecr.repository_name}"
  image_tag          = "${var.image_tag}"
}
