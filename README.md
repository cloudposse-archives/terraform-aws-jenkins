# terraform-aws-jenkins [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-jenkins.svg)](https://travis-ci.org/cloudposse/terraform-aws-jenkins)

## Introduction

`terraform-aws-jenkins` is a Terraform module to build a Docker image with [Jenkins](https://jenkins.io/), save it to an [ECR](https://aws.amazon.com/ecr/) repo,
and deploy to [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) running [Docker](https://www.docker.com/).

This is an enterprise-ready, scalable and highly-available architecture and the CI/CD pattern to build and deploy Jenkins.


The module uses these open-source Cloud Posse modules:

* https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application
* https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment
* https://github.com/cloudposse/terraform-aws-ecr
* https://github.com/cloudposse/terraform-aws-efs
* https://github.com/cloudposse/terraform-aws-efs-backup
* https://github.com/cloudposse/terraform-aws-cicd
* https://github.com/cloudposse/terraform-aws-codebuild


## Features

The module will create the following AWS resources:

   * Elastic Beanstalk Application
   * Elastic Beanstalk Environment with Docker stack to run the Jenkins master
   * ECR repository to store the Jenkins Docker image
   * EFS filesystem to store Jenkins config and jobs (it will be mounted to a directory on the EC2 host, and then to the Docker container)
   * CodePipeline with CodeBuild to build and deploy Jenkins so even Jenkins itself follows the CI/CD pattern
   * CloudFormation stack to run a DataPipeline to automatically backup the EFS to S3
   * CloudFormation stack for SNS notifications about the status of each backup


After all of the AWS resources are created,

__CodePipeline__ will:

  * Get the specified Jenkins repo from GitHub, _e.g._ https://github.com/cloudposse/jenkins
  * Build a Docker image from it
  * Save the Docker image to the ECR repo
  * Deploy the Docker image from the ECR repo to Elastic Beanstalk running Docker stack
  * Monitor the GitHub repo for changes and re-run the steps above if new commits are pushed into it


__DataPipeline__ will run on the specified schedule and will backup all Jenkins files to an S3 bucket by doing the following:

  * Spawn an EC2 instance
  * Mount the EFS filesystem to a directory on the EC2 instance
  * Backup the directory to an S3 bucket
  * Notify about the status of the backup (Success or Failure) via email
  * Destroy the EC2 instance


![jenkins build server architecture](https://user-images.githubusercontent.com/52489/30888694-d07d68c8-a2d6-11e7-90b2-d8275ef94f39.png)


## Usage

For complete examples, see [examples](examples).


### Deploy Jenkins into an existing VPC with existing subnets

```hcl
data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "git::https://github.com/cloudposse/terraform-aws-jenkins.git?ref=master"
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
```

### Deploy Jenkins into an existing VPC and new subnets

```hcl
data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "git::https://github.com/cloudposse/terraform-aws-jenkins.git?ref=master"
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
  public_subnets               = "${module.subnets.public_subnet_ids}"
  private_subnets              = "${module.subnets.private_subnet_ids}"
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

module "subnets" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones         = ["${data.aws_availability_zones.available.names}"]
  namespace                  = "cp"
  name                       = "jenkins"
  stage                      = "prod"
  region                     = "us-west-2"
  vpc_id                     = "vpc-a22222ee"
  igw_id                     = "igw-s32321vd"
  cidr_block                 = "10.0.0.0/16"
  nat_gateway_enabled        = "true"
  vpc_default_route_table_id = "ZXXXXXXXXXXX"
  public_network_acl_id      = "ZXXXXXXXXXXX"
  private_network_acl_id     = "ZXXXXXXXXXXX"
  delimiter                  = "-"
  attributes                 = ["subnet"]

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
```

### Deploy Jenkins into a new VPC and new subnets

```hcl
data "aws_availability_zones" "available" {}

module "jenkins" {
  source      = "git::https://github.com/cloudposse/terraform-aws-jenkins.git?ref=master"
  namespace   = "cp"
  name        = "jenkins"
  stage       = "prod"
  description = "Jenkins server as Docker container running on Elastic Beanstalk"

  master_instance_type         = "t2.medium"
  aws_account_id               = "000111222333"
  aws_region                   = "us-west-2"
  availability_zones           = ["${data.aws_availability_zones.available.names}"]
  solution_stack_name          = "64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce"
  vpc_id                       = "${module.vpc.vpc_id}"
  zone_id                      = "ZXXXXXXXXXXX"
  public_subnets               = "${module.subnets.public_subnet_ids}"
  private_subnets              = "${module.subnets.private_subnet_ids}"
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

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "cp"
  name       = "jenkins"
  stage      = "prod"
  cidr_block = "10.0.0.0/16"
  delimiter  = "-"
  attributes = ["vpc"]

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}

module "subnets" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones         = ["${data.aws_availability_zones.available.names}"]
  namespace                  = "cp"
  name                       = "jenkins"
  stage                      = "prod"
  region                     = "us-west-2"
  vpc_id                     = "${module.vpc.vpc_id}"
  igw_id                     = "${module.vpc.igw_id}"
  cidr_block                 = "10.0.0.0/16"
  nat_gateway_enabled        = "true"
  vpc_default_route_table_id = "${module.vpc.vpc_default_route_table_id}"
  public_network_acl_id      = "${module.vpc.vpc_default_network_acl_id}"
  private_network_acl_id     = "${module.vpc.vpc_default_network_acl_id}"
  delimiter                  = "-"
  attributes                 = ["subnet"]

  tags = {
    BusinessUnit = "ABC"
    Department   = "XYZ"
  }
}
```


## Input

|  Name                              |  Default                       |  Description                                                                                                                         | Required |
|:-----------------------------------|:------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| namespace                          |                                | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                              | Yes      |
| stage                              |                                | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                              | Yes      |
| name                               | jenkins                        | Name of the application                                                                                                              | Yes      |
| description                        |                                | Used as Elastic Beanstalk application description                                                                                    | Yes      |
| aws_region                         | us-west-2                      | AWS Region to provision all the AWS resources in                                                                                     | Yes      |
| solution_stack_name                | 64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce | Elastic Beanstalk stack                                                                                 | Yes      |
| master_instance_type               | t2.medium                      | EC2 instance type for Jenkins master                                                                                                 | Yes      |
| vpc_id                             |                                | AWS VPC ID where module should operate (_e.g._ `vpc-a22222ee`)                                                                       | Yes      |
| availability_zones                 |                                | List of Availability Zones for EFS                                                                                                   | Yes      |
| healthcheck_url                    | /login                         | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances   | Yes      |
| loadbalancer_type                  | application                    | Load Balancer type, e.g. `application` or `classic`                                                                                  | Yes      |
| loadbalancer_certificate_arn       |                                | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager                                        | Yes      |
| public_subnets                     |                                | List of public subnets to place Elastic Load Balancer                                                                                | Yes      |
| private_subnets                    |                                | List of private subnets to place EC2 instances and EFS                                                                               | Yes      |
| zone_id                            |                                | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS              | Yes      |
| security_groups                    | []                             | List of security groups to be allowed to connect to the EC2 instances                                                                | No       |
| ssh_key_pair                       | ""                             | Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instances. The key should be present in AWS              | No       |
| github_oauth_token                 | ""                             | GitHub Oauth Token for accessing private repositories. Leave it empty when deploying a public Jenkins repository                     | No       |
| github_organization                | cloudposse                     | GitHub organization, _e.g._ `cloudposse`. By default, this module will deploy https://github.com/cloudposse/jenkins repository       | Yes      |
| github_repo_name                   | jenkins                        | GitHub repository name, _e.g._ `jenkins`. By default, this module will deploy https://github.com/cloudposse/jenkins repository       | Yes      |
| github_branch                      | master                         | GitHub repository branch, _e.g._ `master`. By default, this module will deploy https://github.com/cloudposse/jenkins master branch   | Yes      |
| build_image                        | aws/codebuild/docker:1.12.1    | CodeBuild build image                                                                                                                | Yes      |
| build_compute_type                 | BUILD_GENERAL1_SMALL           | CodeBuild compute type (instance type)                                                                                               | Yes      |
| aws_account_id                     |                                | AWS Account ID. Used as CodeBuild ENV variable $AWS_ACCOUNT_ID when building Docker images                                           | Yes      |
| image_tag                          | latest                         | Docker image tag in the ECR repository, _e.g._ `latest`. Used as CodeBuild ENV variable $IMAGE_TAG when building Docker images       | Yes      |
| env_default_key                    | DEFAULT_ENV_%d                 | Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting                                | No       |
| env_default_value                  | UNSET                          | Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting                              | No       |
| env_vars                           | {}                             | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk                                   | No       |
| noncurrent_version_expiration_days | 35                             | S3 object versions expiration period (days) for backups                                                                              | No       |
| datapipeline_config                | ${map("instance_type", "t2.micro", "email", "", "period", "24 hours", "timeout", "60 Minutes")}" | DataPipeline configuration options                                 | Yes      |
| attributes                         | []                             | Additional attributes (_e.g._ `vpc`)                                                                                                 | No       |
| tags                               | {}                             | Additional tags (_e.g._ `map("BusinessUnit","ABC")`                                                                                  | No       |
| delimiter                          | -                              | Delimiter to be used between `name`, `namespace`, `stage` and `attributes`                                                           | No       |


### `datapipeline_config` variables

|  Name               |  Default     |  Description                                                               | Required |
|:--------------------|:------------:|:---------------------------------------------------------------------------|:--------:|
| instance_type       | t2.micro     | Instance type to use in DataPipeline                                       | Yes      |
| email               | ""           | Email to use in SNS. Needs to be provided, otherwise the module will fail  | Yes      |
| period              | 24 hours     | Frequency of pipeline execution (frequency of backups)                     | Yes      |
| timeout             | 60 Minutes   | Pipeline execution timeout                                                 | Yes      |



## References

* http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-jenkins/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-jenkins/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-jenkins`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-jenkins` is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud-platform.

  [website]: http://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: http://cloudposse.com/contact/

### Contributors


| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
  [andriy_web]: https://github.com/aknysh/


