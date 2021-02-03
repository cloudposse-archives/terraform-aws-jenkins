<!-- markdownlint-disable -->
# terraform-aws-jenkins [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-jenkins.svg)](https://github.com/cloudposse/terraform-aws-jenkins/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

`terraform-aws-jenkins` is a Terraform module to build a Docker image with [Jenkins](https://jenkins.io/), save it to an [ECR](https://aws.amazon.com/ecr/) repo,
and deploy to [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) running [Docker](https://www.docker.com/).

This is an enterprise-ready, scalable and highly-available architecture and the CI/CD pattern to build and deploy Jenkins.

## Features

The module will create the following AWS resources:

   * Elastic Beanstalk Application
   * Elastic Beanstalk Environment with Docker stack to run the Jenkins master
   * ECR repository to store the Jenkins Docker image
   * EFS filesystem to store Jenkins config and jobs (it will be mounted to a directory on the EC2 host, and then to the Docker container)
   * AWS Backup stack to automatically backup the EFS
   * CodePipeline with CodeBuild to build and deploy Jenkins so even Jenkins itself follows the CI/CD pattern


After all of the AWS resources are created,

__CodePipeline__ will:

  * Get the specified Jenkins repo from GitHub, _e.g._ https://github.com/cloudposse/jenkins
  * Build a Docker image from it
  * Save the Docker image to the ECR repo
  * Deploy the Docker image from the ECR repo to Elastic Beanstalk running Docker stack
  * Monitor the GitHub repo for changes and re-run the steps above if new commits are pushed


![jenkins build server architecture](https://user-images.githubusercontent.com/52489/30888694-d07d68c8-a2d6-11e7-90b2-d8275ef94f39.png)


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out!







## Security & Compliance [<img src="https://cloudposse.com/wp-content/uploads/2020/11/bridgecrew.svg" width="250" align="right" />](https://bridgecrew.io/)

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark | Description |
|--------|---------------|
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=CIS+KUBERNETES+V1.5) | Center for Internet Security, KUBERNETES Compliance |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=CIS+AWS+V1.2) | Center for Internet Security, AWS Compliance |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=CIS+AZURE+V1.1) | Center for Internet Security, AZURE Compliance |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=PCI-DSS+V3.2) | Payment Card Industry Data Security Standards Compliance |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=NIST-800-53) | National Institute of Standards and Technology Compliance |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=ISO27001) | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=SOC2)| Service Organization Control 2 Compliance |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=CIS+GCP+V1.1) | Center for Internet Security, GCP Compliance |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-jenkins/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-jenkins&benchmark=HIPAA) | Health Insurance Portability and Accountability Compliance |



## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.


For a complete example, see [examples/complete](examples/complete).

For automatic tests of the complete example, see [test](test).

```hcl
provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  tags       = var.tags
  delimiter  = var.delimiter
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  tags                 = var.tags
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "jenkins" {
  source = "cloudposse/jenkins/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  description = var.description

  master_instance_type = var.master_instance_type
  aws_account_id       = var.aws_account_id
  region               = var.region
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  dns_zone_id          = var.dns_zone_id
  loadbalancer_subnets = module.subnets.public_subnet_ids
  application_subnets  = module.subnets.private_subnet_ids

  environment_type                       = var.environment_type
  loadbalancer_type                      = var.loadbalancer_type
  loadbalancer_certificate_arn           = var.loadbalancer_certificate_arn
  availability_zone_selector             = var.availability_zone_selector
  rolling_update_type                    = var.rolling_update_type
  loadbalancer_logs_bucket_force_destroy = var.loadbalancer_logs_bucket_force_destroy
  cicd_bucket_force_destroy              = var.cicd_bucket_force_destroy

  github_oauth_token  = var.github_oauth_token
  github_organization = var.github_organization
  github_repo_name    = var.github_repo_name
  github_branch       = var.github_branch

  image_tag = var.image_tag

  healthcheck_url = var.healthcheck_url

  build_image        = var.build_image
  build_compute_type = var.build_compute_type

  efs_backup_schedule           = var.efs_backup_schedule
  efs_backup_start_window       = var.efs_backup_start_window
  efs_backup_completion_window  = var.efs_backup_completion_window
  efs_backup_cold_storage_after = var.efs_backup_cold_storage_after
  efs_backup_delete_after       = var.efs_backup_delete_after

  env_vars = {
    "JENKINS_USER"          = var.jenkins_username
    "JENKINS_PASS"          = var.jenkins_password
    "JENKINS_NUM_EXECUTORS" = var.jenkins_num_executors
  }
}
```






<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| local | >= 1.2 |
| null | >= 2.0 |
| random | >= 2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| allowed\_security\_groups | List of security groups to be allowed to connect to Jenkins master EC2 instances | `list(string)` | `[]` | no |
| application\_subnets | List of subnets to place EC2 instances and EFS | `list(string)` | n/a | yes |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| availability\_zone\_selector | Availability Zone selector | `string` | `"Any"` | no |
| availability\_zones | List of Availability Zones for EFS | `list(string)` | n/a | yes |
| aws\_account\_id | AWS Account ID. Used as CodeBuild ENV variable $AWS\_ACCOUNT\_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | n/a | yes |
| build\_compute\_type | CodeBuild compute type, e.g. 'BUILD\_GENERAL1\_SMALL'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| build\_image | CodeBuild build image, e.g. 'aws/codebuild/amazonlinux2-x86\_64-standard:1.0'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html | `string` | `"aws/codebuild/docker:1.12.1"` | no |
| cicd\_bucket\_force\_destroy | Force destroy the CI/CD S3 bucket even if it's not empty | `bool` | `false` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>    label_key_case      = string<br>    label_value_case    = string<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| description | Will be used as Elastic Beanstalk application description | `string` | `"Jenkins server as Docker container running on Elastic Benastalk"` | no |
| dns\_zone\_id | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS | `string` | n/a | yes |
| efs\_backup\_cold\_storage\_after | Specifies the number of days after creation that a recovery point is moved to cold storage | `number` | `null` | no |
| efs\_backup\_completion\_window | The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window` | `number` | `null` | no |
| efs\_backup\_delete\_after | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | `number` | `null` | no |
| efs\_backup\_schedule | A CRON expression specifying when AWS Backup initiates a backup job | `string` | `null` | no |
| efs\_backup\_start\_window | The amount of time in minutes before beginning a backup. Minimum value is 60 minutes | `number` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| env\_vars | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env\_vars = { JENKINS\_USER = 'admin' JENKINS\_PASS = 'xxxxxx' } | `map(string)` | `{}` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| environment\_type | Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time' or `Immutable`, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments) | `string` | `"LoadBalanced"` | no |
| github\_branch | GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch | `string` | `"master"` | no |
| github\_oauth\_token | GitHub Oauth Token | `string` | n/a | yes |
| github\_organization | GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | `string` | `"cloudposse"` | no |
| github\_repo\_name | GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | `string` | `"jenkins"` | no |
| healthcheck\_url | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | `string` | `"/login"` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| image\_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE\_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `"latest"` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`. <br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation). <br>Default value: `lower`. | `string` | `null` | no |
| loadbalancer\_certificate\_arn | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | `string` | `""` | no |
| loadbalancer\_logs\_bucket\_force\_destroy | Force destroy the S3 bucket for load balancer logs even if it's not empty | `bool` | `false` | no |
| loadbalancer\_subnets | List of subnets to place Elastic Load Balancer | `list(string)` | n/a | yes |
| loadbalancer\_type | Load Balancer type, e.g. 'application' or 'classic' | `string` | `"application"` | no |
| master\_instance\_type | EC2 instance type for Jenkins master, e.g. 't2.medium' | `string` | `"t2.medium"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| region | AWS region in which to provision the AWS resources | `string` | n/a | yes |
| rolling\_update\_type | `Health`, `Time` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances. For more details, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate | `string` | `"Health"` | no |
| solution\_stack\_name | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html | `string` | `"64bit Amazon Linux 2018.03 v2.12.17 running Docker 18.06.1-ce"` | no |
| ssh\_key\_pair | Name of SSH key that will be deployed on Elastic Beanstalk instances. The key should be present in AWS | `string` | `""` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| use\_efs\_ip\_address | If set to `true`, will provide the EFS IP address instead of DNS name to Jenkins as ENV var | `bool` | `false` | no |
| vpc\_id | ID of the VPC in which to provision the AWS resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| codebuild\_badge\_url | The URL of the build badge when badge\_enabled is enabled |
| codebuild\_cache\_bucket\_arn | CodeBuild cache S3 bucket ARN |
| codebuild\_cache\_bucket\_name | CodeBuild cache S3 bucket name |
| codebuild\_project\_id | CodeBuild project ID |
| codebuild\_project\_name | CodeBuild project name |
| codebuild\_role\_arn | CodeBuild IAM Role ARN |
| codebuild\_role\_id | CodeBuild IAM Role ID |
| codepipeline\_arn | CodePipeline ARN |
| codepipeline\_id | CodePipeline ID |
| ecr\_registry\_id | Registry ID |
| ecr\_repository\_name | Repository name |
| ecr\_repository\_url | Repository URL |
| efs\_arn | EFS ARN |
| efs\_backup\_plan\_arn | Backup Plan ARN |
| efs\_backup\_plan\_version | Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan |
| efs\_backup\_selection\_id | Backup Selection ID |
| efs\_backup\_vault\_arn | Backup Vault ARN |
| efs\_backup\_vault\_id | Backup Vault ID |
| efs\_backup\_vault\_recovery\_points | Backup Vault recovery points |
| efs\_dns\_name | EFS DNS name |
| efs\_host | Route53 DNS hostname for the EFS |
| efs\_id | EFS ID |
| efs\_mount\_target\_dns\_names | List of EFS mount target DNS names |
| efs\_mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| efs\_mount\_target\_ips | List of EFS mount target IPs (one per Availability Zone) |
| efs\_network\_interface\_ids | List of mount target network interface IDs |
| elastic\_beanstalk\_application\_name | Elastic Beanstalk Application name |
| elastic\_beanstalk\_environment\_all\_settings | List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration |
| elastic\_beanstalk\_environment\_application | The Elastic Beanstalk Application specified for this environment |
| elastic\_beanstalk\_environment\_autoscaling\_groups | The autoscaling groups used by this environment |
| elastic\_beanstalk\_environment\_ec2\_instance\_profile\_role\_name | Instance IAM role name |
| elastic\_beanstalk\_environment\_elb\_zone\_id | ELB zone id |
| elastic\_beanstalk\_environment\_endpoint | Fully qualified DNS name for the environment |
| elastic\_beanstalk\_environment\_hostname | DNS hostname |
| elastic\_beanstalk\_environment\_id | ID of the Elastic Beanstalk environment |
| elastic\_beanstalk\_environment\_instances | Instances used by this environment |
| elastic\_beanstalk\_environment\_launch\_configurations | Launch configurations in use by this environment |
| elastic\_beanstalk\_environment\_load\_balancers | Elastic Load Balancers in use by this environment |
| elastic\_beanstalk\_environment\_name | Name |
| elastic\_beanstalk\_environment\_queues | SQS queues in use by this environment |
| elastic\_beanstalk\_environment\_security\_group\_id | Security group id |
| elastic\_beanstalk\_environment\_setting | Settings specifically set for this environment |
| elastic\_beanstalk\_environment\_tier | The environment tier |
| elastic\_beanstalk\_environment\_triggers | Autoscaling triggers in use by this environment |

<!-- markdownlint-restore -->



## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-jenkins)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-elastic-beanstalk-application](https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application) - Terraform module to provision AWS Elastic Beanstalk application
- [terraform-aws-elastic-beanstalk-environment](https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment) - Terraform module to provision AWS Elastic Beanstalk environment
- [terraform-aws-ecr](https://github.com/cloudposse/terraform-aws-ecr) - Terraform Module to manage Docker Container Registries on AWS ECR
- [terraform-aws-efs](https://github.com/cloudposse/terraform-aws-efs) - Terraform Module to define an EFS Filesystem (aka NFS)
- [terraform-aws-efs-backup](https://github.com/cloudposse/terraform-aws-efs-backup) - Terraform module designed to easily backup EFS filesystems to S3 using DataPipeline
- [terraform-aws-cicd](https://github.com/cloudposse/terraform-aws-cicd) - Terraform Module for CI/CD with AWS Code Pipeline and Code Build
- [terraform-aws-codebuild](https://github.com/cloudposse/terraform-aws-codebuild) - Terraform Module to easily leverage AWS CodeBuild for Continuous Integration



## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-jenkins/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-jenkins/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2021 [Cloud Posse, LLC](https://cpco.io/copyright)



## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

<!-- markdownlint-disable -->
|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Ivan Pinatti][ivan-pinatti_avatar]][ivan-pinatti_homepage]<br/>[Ivan Pinatti][ivan-pinatti_homepage] | [![Sergey Vasilyev][s2504s_avatar]][s2504s_homepage]<br/>[Sergey Vasilyev][s2504s_homepage] |
|---|---|---|---|---|
<!-- markdownlint-restore -->


  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png

  [aknysh_homepage]: https://github.com/aknysh/
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png

  [goruha_homepage]: https://github.com/goruha/
  [goruha_avatar]: https://img.cloudposse.com/150x150/https://github.com/goruha.png

  [ivan-pinatti_homepage]: https://github.com/ivan-pinatti/
  [ivan-pinatti_avatar]: https://img.cloudposse.com/150x150/https://github.com/ivan-pinatti.png

  [s2504s_homepage]: https://github.com/s2504s/
  [s2504s_avatar]: https://img.cloudposse.com/150x150/https://github.com/s2504s.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-jenkins&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-jenkins&url=https://github.com/cloudposse/terraform-aws-jenkins
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-jenkins&url=https://github.com/cloudposse/terraform-aws-jenkins
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-jenkins
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-jenkins
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-jenkins
  [share_email]: mailto:?subject=terraform-aws-jenkins&body=https://github.com/cloudposse/terraform-aws-jenkins
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-jenkins?pixel&cs=github&cm=readme&an=terraform-aws-jenkins
