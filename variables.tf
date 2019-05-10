variable "aws_region" {
  type        = "string"
  default     = "us-west-2"
  description = "AWS region in which to provision the AWS resources"
}

variable "namespace" {
  type        = "string"
  description = "Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse'"
}

variable "name" {
  type        = "string"
  description = "Solution name, e.g. 'app' or 'jenkins'"
  default     = "jenkins"
}

variable "stage" {
  type        = "string"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "description" {
  type        = "string"
  default     = "Jenkins server as Docker container running on Elastic Benastalk"
  description = "Will be used as Elastic Beanstalk application description"
}

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html#concepts.platforms.docker
variable "solution_stack_name" {
  type        = "string"
  default     = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html"
}

variable "master_instance_type" {
  type        = "string"
  default     = "t2.medium"
  description = "EC2 instance type for Jenkins master, e.g. 't2.medium'"
}

variable "vpc_id" {
  type        = "string"
  description = "ID of the VPC in which to provision the AWS resources"
}

variable "availability_zones" {
  type        = "list"
  description = "List of Availability Zones for EFS"
}

variable "healthcheck_url" {
  type        = "string"
  default     = "/login"
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

variable "loadbalancer_type" {
  type        = "string"
  default     = "application"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "loadbalancer_certificate_arn" {
  type        = "string"
  description = "Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager"
}

variable "loadbalancer_ssl_policy" {
  type        = "string"
  default     = "ELBSecurityPolicy-2016-08"
  description = "Load Balancer SSL Security Policy"
}

variable "public_subnets" {
  type        = "list"
  description = "List of public subnets to place Elastic Load Balancer"
}

variable "private_subnets" {
  type        = "list"
  description = "List of private subnets to place EC2 instances and EFS"
}

variable "zone_id" {
  type        = "string"
  description = "Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS"
}

variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups to be allowed to connect to the EC2 instances"
}

variable "ssh_key_pair" {
  type        = "string"
  default     = ""
  description = "Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS"
}

variable "github_oauth_token" {
  type        = "string"
  default     = ""
  description = "GitHub Oauth Token for accessing private repositories. Leave it empty when deploying a public 'Jenkins' repository, e.g. https://github.com/cloudposse/jenkins"
}

variable "github_organization" {
  type        = "string"
  default     = "cloudposse"
  description = "GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository"
}

variable "github_repo_name" {
  type        = "string"
  default     = "jenkins"
  description = "GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository"
}

variable "github_branch" {
  type        = "string"
  default     = "master"
  description = "GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-available
variable "build_image" {
  type        = "string"
  default     = "aws/codebuild/docker:1.12.1"
  description = "CodeBuild build image, e.g. 'aws/codebuild/docker:1.12.1'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-available"
}

# http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-compute-types
variable "build_compute_type" {
  type        = "string"
  default     = "BUILD_GENERAL1_SMALL"
  description = "CodeBuild compute type, e.g. 'BUILD_GENERAL1_SMALL'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-compute-types"
}

variable "aws_account_id" {
  type        = "string"
  description = "AWS Account ID. Used as CodeBuild ENV variable $AWS_ACCOUNT_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
}

variable "image_tag" {
  type        = "string"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
  default     = "latest"
}

variable "env_default_key" {
  type        = "string"
  default     = "DEFAULT_ENV_%d"
  description = "Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_default_value" {
  type        = "string"
  default     = "UNSET"
  description = "Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_vars" {
  type        = "map"
  default     = {}
  description = "Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }"
}

variable "noncurrent_version_expiration_days" {
  type        = "string"
  default     = "35"
  description = "Backup S3 bucket noncurrent version expiration days"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "datapipeline_config" {
  type        = "map"
  description = "DataPipeline configuration options"

  default = {
    instance_type = "t2.small"
    email         = ""
    period        = "24 hours"
    timeout       = "60 Minutes"
  }
}

variable "use_efs_ip_address" {
  default = "false"
}
