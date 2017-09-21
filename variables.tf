variable "aws_region" {
  type    = "string"
  default = "us-west-2"
}

variable "namespace" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "stage" {
  type = "string"
}

variable "description" {
  type    = "string"
  default = ""
}

variable "solution_stack_name" {
  type    = "string"
  default = "64bit Amazon Linux 2017.03 v2.7.3 running Docker 17.03.1-ce"
}

variable "vpc_id" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "zone_id" {
  type = "string"
}

variable "updating_min_in_service" {
  default = "0"
}

variable "updating_max_batch" {
  default = "1"
}

variable "autoscale_lower_bound" {
  default = "20"
}

variable "autoscale_upper_bound" {
  default = "80"
}

variable "healthcheck_url" {
  type    = "string"
  default = "/"
}

variable "loadbalancer_type" {
  type    = "string"
  default = "application"
}

variable "master_instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "autoscale_min" {
  default = "1"
}

variable "autoscale_max" {
  default = "1"
}

variable "security_groups" {
  type    = "list"
  default = []
}

variable "keypair" {
  type    = "string"
  default = ""
}

# CI/CD - CodePipeline/CodeBuild
variable "github_oauth_token" {
  type    = "string"
  default = ""
}

variable "github_organization" {
  type    = "string"
  default = "cloudposse"
}

variable "github_repo_name" {
  type    = "string"
  default = "jenkins"
}

variable "github_branch" {
  type    = "string"
  default = "master"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-available
variable "build_image" {
  type    = "string"
  default = "aws/codebuild/docker:1.12.1"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-compute-types
variable "build_compute_type" {
  type    = "string"
  default = "BUILD_GENERAL1_SMALL"
}

variable "aws_account_id" {
  type        = "string"
  description = "AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
}

variable "image_tag" {
  type        = "string"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
  default     = "latest"
}

variable "env_default_key" {
  default = "DEFAULT_ENV_%d"
}

variable "env_default_value" {
  default = "UNSET"
}

variable "env_vars" {
  default = {}
  type    = "map"
}
