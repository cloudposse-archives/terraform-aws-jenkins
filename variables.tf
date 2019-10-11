variable "region" {
  type        = string
  description = "AWS region in which to provision the AWS resources"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
  default     = ""
}

variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "description" {
  type        = string
  default     = "Jenkins server as Docker container running on Elastic Benastalk"
  description = "Will be used as Elastic Beanstalk application description"
}

// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
variable "solution_stack_name" {
  type        = string
  default     = "64bit Amazon Linux 2018.03 v2.12.17 running Docker 18.06.1-ce"
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html"
}

variable "master_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "EC2 instance type for Jenkins master, e.g. 't2.medium'"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which to provision the AWS resources"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for EFS"
}

variable "healthcheck_url" {
  type        = string
  default     = "/login"
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

variable "loadbalancer_type" {
  type        = string
  default     = "application"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "loadbalancer_certificate_arn" {
  type        = string
  description = "Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager"
  default     = ""
}

variable "loadbalancer_subnets" {
  type        = list(string)
  description = "List of subnets to place Elastic Load Balancer"
}

variable "application_subnets" {
  type        = list(string)
  description = "List of subnets to place EC2 instances and EFS"
}

variable "dns_zone_id" {
  type        = string
  description = "Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to Jenkins master EC2 instances"
}

variable "ssh_key_pair" {
  type        = string
  default     = ""
  description = "Name of SSH key that will be deployed on Elastic Beanstalk instances. The key should be present in AWS"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub Oauth Token"
}

variable "github_organization" {
  type        = string
  default     = "cloudposse"
  description = "GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository"
}

variable "github_repo_name" {
  type        = string
  default     = "jenkins"
  description = "GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository"
}

variable "github_branch" {
  type        = string
  default     = "master"
  description = "GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch"
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
variable "build_image" {
  type        = string
  default     = "aws/codebuild/docker:1.12.1"
  description = "CodeBuild build image, e.g. 'aws/codebuild/amazonlinux2-x86_64-standard:1.0'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "CodeBuild compute type, e.g. 'BUILD_GENERAL1_SMALL'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID. Used as CodeBuild ENV variable $AWS_ACCOUNT_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
}

variable "availability_zone_selector" {
  type        = string
  default     = "Any"
  description = "Availability Zone selector"
}

variable "environment_type" {
  type        = string
  default     = "LoadBalanced"
  description = "Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time' or `Immutable`, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments)"
}

# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate
variable "rolling_update_type" {
  type        = string
  default     = "Health"
  description = "`Health`, `Time` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances. For more details, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html"
  default     = "latest"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }"
}

variable "use_efs_ip_address" {
  type        = bool
  default     = false
  description = "If set to `true`, will provide the EFS IP address instead of DNS name to Jenkins as ENV var"
}

variable "efs_backup_schedule" {
  type        = string
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
  default     = null
}

variable "efs_backup_start_window" {
  type        = number
  description = "The amount of time in minutes before beginning a backup. Minimum value is 60 minutes"
  default     = null
}

variable "efs_backup_completion_window" {
  type        = number
  description = "The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window`"
  default     = null
}

variable "efs_backup_cold_storage_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
  default     = null
}

variable "efs_backup_delete_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after`"
  default     = null
}

variable "loadbalancer_logs_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy the S3 bucket for load balancer logs even if it's not empty"
}

variable "cicd_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy the CI/CD S3 bucket even if it's not empty"
}
