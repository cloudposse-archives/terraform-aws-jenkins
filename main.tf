# Elastic Beanstalk Application
module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=tags/0.1.4"
  namespace   = "${var.namespace}"
  name        = "${var.name}"
  stage       = "${var.stage}"
  description = "${var.description}"
  delimiter   = "${var.delimiter}"
  attributes  = ["${compact(concat(var.attributes, list("eb-app")))}"]
  tags        = "${var.tags}"
}

# Elastic Beanstalk Environment
module "elastic_beanstalk_environment" {
  source        = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=tags/0.3.4"
  namespace     = "${var.namespace}"
  name          = "${var.name}"
  stage         = "${var.stage}"
  zone_id       = "${var.zone_id}"
  app           = "${module.elastic_beanstalk_application.app_name}"
  instance_type = "${var.master_instance_type}"

  # Set `min` and `max` number of running EC2 instances to `1` since we want only one Jenkins master running at any time
  autoscale_min = 1
  autoscale_max = 1

  # Since we set `autoscale_min = autoscale_max`, we need to set `updating_min_in_service` to 0 for the AutoScaling Group to work.
  # Elastic Beanstalk will terminate the master instance and replace it with a new one in case of any issues with it.
  # But it's OK since we store all Jenkins state (settings, jobs, etc.) on the EFS.
  # If the instance gets replaced or rebooted, Jenkins will find all the data on EFS after restart.
  updating_min_in_service = 0

  updating_max_batch = 1

  healthcheck_url              = "${var.healthcheck_url}"
  loadbalancer_type            = "${var.loadbalancer_type}"
  loadbalancer_certificate_arn = "${var.loadbalancer_certificate_arn}"
  vpc_id                       = "${var.vpc_id}"
  public_subnets               = "${var.public_subnets}"
  private_subnets              = "${var.private_subnets}"
  security_groups              = "${var.security_groups}"
  keypair                      = "${var.ssh_key_pair}"
  solution_stack_name          = "${var.solution_stack_name}"
  env_default_key              = "${var.env_default_key}"
  env_default_value            = "${var.env_default_value}"

  # Provide EFS DNS name to EB in the `EFS_HOST` ENV var. EC2 instance will mount to the EFS filesystem and use it to store Jenkins state
  # Add slaves Security Group `JENKINS_SLAVE_SECURITY_GROUPS` (comma-separated if more than one). Will be used by Jenkins to init the EC2 plugin to launch slaves inside the Security Group
  env_vars = "${
      merge(
        map(
          "EFS_HOST", "${var.use_efs_ip_address ? module.efs.mount_target_ips[0] : module.efs.dns_name}",
          "USE_EFS_IP", "${var.use_efs_ip_address}",
          "JENKINS_SLAVE_SECURITY_GROUPS", "${aws_security_group.slaves.id}"
        ), var.env_vars
      )
    }"

  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("eb-env")))}"]
  tags       = "${var.tags}"
}

# Elastic Container Registry Docker Repository
module "ecr" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.2.4"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("ecr")))}"]
  tags       = "${var.tags}"
}

# EFS to store Jenkins state (settings, jobs, etc.)
module "efs" {
  source             = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=tags/0.3.3"
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  aws_region         = "${var.aws_region}"
  vpc_id             = "${var.vpc_id}"
  subnets            = "${var.private_subnets}"
  availability_zones = "${var.availability_zones}"
  zone_id            = "${var.zone_id}"

  # EC2 instances (from `elastic_beanstalk_environment`) and DataPipeline instances (from `efs_backup`) are allowed to connect to the EFS
  security_groups = ["${module.elastic_beanstalk_environment.security_group_id}", "${module.efs_backup.security_group_id}"]

  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("efs")))}"]
  tags       = "${var.tags}"
}

# EFS backup to S3
module "efs_backup" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-efs-backup.git?ref=tags/0.4.0"
  name                               = "${var.name}"
  stage                              = "${var.stage}"
  namespace                          = "${var.namespace}"
  region                             = "${var.aws_region}"
  vpc_id                             = "${var.vpc_id}"
  efs_mount_target_id                = "${element(module.efs.mount_target_ids, 0)}"
  use_ip_address                     = "${var.use_efs_ip_address}"
  noncurrent_version_expiration_days = "${var.noncurrent_version_expiration_days}"
  ssh_key_pair                       = "${var.ssh_key_pair}"
  modify_security_group              = "false"
  datapipeline_config                = "${var.datapipeline_config}"
  delimiter                          = "${var.delimiter}"
  attributes                         = ["${compact(concat(var.attributes, list("efs-backup")))}"]
  tags                               = "${var.tags}"
}

# CodePipeline/CodeBuild to build Jenkins Docker image, store it to a ECR repo, and deploy it to Elastic Beanstalk running Docker stack
module "cicd" {
  source              = "git::https://github.com/cloudposse/terraform-aws-cicd.git?ref=tags/0.5.1"
  namespace           = "${var.namespace}"
  name                = "${var.name}"
  stage               = "${var.stage}"
  app                 = "${module.elastic_beanstalk_application.app_name}"
  env                 = "${module.elastic_beanstalk_environment.name}"
  enabled             = "true"
  github_oauth_token  = "${var.github_oauth_token}"
  repo_owner          = "${var.github_organization}"
  repo_name           = "${var.github_repo_name}"
  branch              = "${var.github_branch}"
  build_image         = "${var.build_image}"
  build_compute_type  = "${var.build_compute_type}"
  privileged_mode     = "true"
  aws_region          = "${var.aws_region}"
  aws_account_id      = "${var.aws_account_id}"
  image_repo_name     = "${module.ecr.repository_name}"
  image_tag           = "${var.image_tag}"
  poll_source_changes = "true"
  delimiter           = "${var.delimiter}"
  attributes          = ["${compact(concat(var.attributes, list("cicd")))}"]
  tags                = "${var.tags}"
}

# Label for EC2 slaves
module "label_slaves" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("slaves")))}"]
  tags       = "${var.tags}"
}

# Security Group for EC2 slaves
resource "aws_security_group" "slaves" {
  name        = "${module.label_slaves.id}"
  description = "Security Group for Jenkins EC2 slaves"
  vpc_id      = "${var.vpc_id}"

  # Allow the provided Security Groups to connect to Jenkins slave instances
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = ["${var.security_groups}"]
  }

  # Allow Jenkins master instance to communicate with Jenkins slave instances on SSH port 22
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${module.elastic_beanstalk_environment.security_group_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${module.label_slaves.tags}"
}

# Policy document with permissions to launch new EC2 instances
# https://wiki.jenkins.io/display/JENKINS/Amazon+EC2+Plugin
data "aws_iam_policy_document" "slaves" {
  statement {
    sid = "AllowLaunchingEC2Instances"

    actions = [
      "ec2:DescribeSpotInstanceRequests",
      "ec2:CancelSpotInstanceRequests",
      "ec2:GetConsoleOutput",
      "ec2:RequestSpotInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "iam:PassRole",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

# Policy for the EB EC2 instance profile to allow launching Jenkins slaves
resource "aws_iam_policy" "slaves" {
  name        = "${module.label_slaves.id}"
  path        = "/"
  description = "Policy for EC2 instance profile to allow launching Jenkins slaves"
  policy      = "${data.aws_iam_policy_document.slaves.json}"
}

# Attach Policy to the EC2 instance profile to allow Jenkins master to launch and control slave EC2 instances
resource "aws_iam_role_policy_attachment" "slaves" {
  role       = "${module.elastic_beanstalk_environment.ec2_instance_profile_role_name}"
  policy_arn = "${aws_iam_policy.slaves.arn}"
}
