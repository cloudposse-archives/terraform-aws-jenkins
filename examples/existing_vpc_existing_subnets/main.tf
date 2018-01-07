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

  master_instance_type         = "t2.medium"
  aws_account_id               = "000111222333"
  aws_region                   = "us-west-2"
  availability_zones           = ["${data.aws_availability_zones.available.names}"]
  solution_stack_name          = "64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce"
  vpc_id                       = "vpc-a22222ee"
  zone_id                      = "ZXXXXXXXXXXX"
  public_subnets               = ["subnet-e63f82cb", "subnet-e66f44ab", "subnet-e88f42bd"]
  private_subnets              = ["subnet-e99d23eb", "subnet-e77e12bb", "subnet-e58a52bc"]
  loadbalancer_type            = "application"
  loadbalancer_certificate_arn = "XXXXXXXXXXXXXXXXX"
  ssh_key_pair                 = "ssh-key-jenkins"

  github_oauth_token  = ""
  github_organization = "cloudposse"
  github_repo_name    = "jenkins"
  github_branch       = "master"

  build_image        = "aws/codebuild/docker:1.12.1"
  build_compute_type = "BUILD_GENERAL1_SMALL"
  image_tag          = "latest"

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

  delimiter  = "-"
  attributes = []

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
