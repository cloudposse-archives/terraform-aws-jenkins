provider "aws" {
  region = "us-west-2"
}

variable "max_availability_zones" {
  default = "2"
}

data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "../../"
  namespace   = "cp"
  name        = "jenkins"
  stage       = "prod"
  description = "Jenkins server as Docker container running on Elastic Beanstalk"

  master_instance_type         = "t2.medium"
  aws_account_id               = "000111222333"
  aws_region                   = "us-west-2"
  availability_zones           = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  vpc_id                       = "${module.vpc.vpc_id}"
  zone_id                      = "ZXXXXXXXXXXX"
  public_subnets               = "${module.subnets.public_subnet_ids}"
  private_subnets              = "${module.subnets.private_subnet_ids}"
  loadbalancer_certificate_arn = "XXXXXXXXXXXXXXXXX"
  ssh_key_pair                 = "ssh-key-jenkins"

  github_oauth_token  = ""
  github_organization = "cloudposse"
  github_repo_name    = "jenkins"
  github_branch       = "master"

  datapipeline_config = {
    instance_type = "t2.medium"
    email         = "me@mycompany.com"
    period        = "12 hours"
    timeout       = "60 Minutes"
  }

  env_vars = {
    JENKINS_USER          = "admin"
    JENKINS_PASS          = "123456"
    JENKINS_NUM_EXECUTORS = 4
  }

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "cp"
  name       = "jenkins"
  stage      = "prod"
  cidr_block = "10.0.0.0/16"

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "cp"
  name                = "jenkins"
  stage               = "prod"
  region              = "us-west-2"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
