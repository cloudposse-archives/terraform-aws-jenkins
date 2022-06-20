provider "aws" {
  region = "us-east-2"
}

variable "max_availability_zones" {
  default = 2
}

data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "../../"
  namespace   = "eg"
  stage       = "test"
  name        = "jenkins"
  description = "Jenkins server as Docker container running on Elastic Beanstalk"

  master_instance_type         = "t2.medium"
  aws_account_id               = "000111222333"
  region                       = "us-east-2"
  availability_zones           = slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)
  vpc_id                       = "vpc-a22222ee"
  dns_zone_id                  = "ZXXXXXXXXXXX"
  loadbalancer_subnets         = module.subnets.public_subnet_ids
  application_subnets          = module.subnets.private_subnet_ids
  loadbalancer_certificate_arn = "XXXXXXXXXXXXXXXXX"
  ssh_key_pair                 = "ssh-key-jenkins"

  github_oauth_token  = ""
  github_organization = "cloudposse"
  github_repo_name    = "jenkins"
  github_branch       = "master"

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

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)
  namespace           = "eg"
  stage               = "test"
  name                = "jenkins"
  region              = "us-west-2"
  vpc_id              = "vpc-a22222ee"
  igw_id              = "igw-s32321vd"
  cidr_block          = "10.0.0.0/16"
  nat_gateway_enabled = "true"

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
