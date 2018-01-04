provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "../../"
  namespace   = "cp"
  name        = "jenkins"
  stage       = "prod"
  description = "Jenkins server as Docker container running on Elastic Beanstalk"

  aws_account_id               = "000111222333"
  aws_region                   = "us-west-2"
  availability_zones           = ["${data.aws_availability_zones.available.names}"]
  solution_stack_name          = "64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce"
  vpc_id                       = "${module.vpc.vpc_id}"
  zone_id                      = "ZXXXXXXXXXXX"
  public_subnets               = "${module.vpc.public_subnet_ids}"
  private_subnets              = "${module.vpc.private_subnet_ids}"
  loadbalancer_type            = "application"
  loadbalancer_certificate_arn = "XXXXXXXXXXXXXXXXX"
  ssh_key_pair                 = "key-test-1"

  github_oauth_token  = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  github_organization = "cloudposse"
  github_repo_name    = "jenkins"
  github_branch       = "master"

  build_image        = "aws/codebuild/docker:1.12.1"
  build_compute_type = "BUILD_GENERAL1_SMALL"
  image_tag          = "latest"

  datapipeline_config = {
    instance_type = "t2.micro"
    email         = "me@mycompany.com"
    period        = "12 hours"
    timeout       = "60 Minutes"
  }

  env_vars = {
    JENKINS_USER          = "admin"
    JENKINS_PASS          = "123456"
    JENKINS_NUM_EXECUTORS = 4
  }

  delimiter  = "-"
  attributes = []

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}

# Terraform module to create a VPC with public and private subnets
module "vpc" {
  source             = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  availability_zones = "${data.aws_availability_zones.available.names}"
  namespace          = "cp"
  name               = "jenkins"
  stage              = "prod"
  region             = "us-west-2"
  cidr_block         = "10.0.0.0/16"
  delimiter          = "-"
  attributes         = ["vpc"]

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
