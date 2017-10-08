# terraform-aws-jenkins

Terraform module to build a `Docker` image with [`Jenkins`](https://jenkins.io/), save it to an [`ECR`](https://aws.amazon.com/ecr/) repo, 
and deploy to [`Elastic Beanstalk`](https://aws.amazon.com/elasticbeanstalk/) running [`Docker`](https://www.docker.com/) stack.

This architecture and the `CI/CD` pattern of building and deploying `Jenkins` is enterprise-ready, scalable and highly-available.

This module uses the following CloudPosse `Terraform` modules:

* https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application
* https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment
* https://github.com/cloudposse/terraform-aws-ecr
* https://github.com/cloudposse/terraform-aws-efs
* https://github.com/cloudposse/terraform-aws-efs-backup
* https://github.com/cloudposse/terraform-aws-cicd


The module will create the following `AWS` resources:

   * `Elastic Beanstalk Application`
   * `Elastic Beanstalk Environment` with `Docker` stack to run the `Jenkins` master
   * `ECR` repository to store the `Jenkins` `Docker` image
   * `EFS` filesystem to store `Jenkins` config and jobs (it will be mounted to a directory on the EC2 host, and then to the `Docker` container)
   * `CodePipeline` with `CodeBuild` to build and deploy `Jenkins` so even `Jenkins` itself follows the `CI/CD` pattern
   * `CloudFormation` stack to run a `DataPipeline` to automatically backup the `EFS` to `S3`
   * `CloudFormation` stack for `SNS` notifications about the status of each backup


After all of the `AWS` resources are created, 

`CodePipeline` will:

  * Get the specified `Jenkins` repo from `GitHub`, _e.g._ `https://github.com/cloudposse/jenkins`
  * Build a `Docker` image from it
  * Save the `Docker` image to the `ECR` repo
  * Deploy the `Docker` image from the `ECR` repo to `Elastic Beanstalk` running `Docker` stack
  * Monitor the `GitHub` repo for changes and re-run the steps above if new commits are pushed into it


`DataPipeline` will run on the specified schedule and will backup all `Jenkins` files to an `S3` bucket by doing the following:

  * Spawn an EC2 instance (`t2.micro` in the example below)
  * Mount the `EFS` filesystem to a directory on the `EC2` instance
  * Backup the directory to an `S3` bucket
  * Notify about the status of the backup (`Success` or `Failure`) via email
  * Destroy the EC2 instance


![jenkins build server architecture](https://user-images.githubusercontent.com/52489/30888694-d07d68c8-a2d6-11e7-90b2-d8275ef94f39.png)


## Usage

```hcl
    provider "aws" {
      region = "us-west-2"
    }
    
    data "aws_availability_zones" "available" {}
    
    module "jenkins" {
      source      = "git::https://github.com/cloudposse/terraform-aws-jenkins.git?ref=master"
      namespace   = "cp"
      name        = "jenkins"
      stage       = "prod"
      description = "Jenkins master server as Docker container running on Elastic Beanstalk"
    
      aws_account_id      = "000111222333"
      aws_region          = "us-west-2"
      availability_zones  = ["${data.aws_availability_zones.available.names}"]
      solution_stack_name = "64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce"
      vpc_id              = "vpc-00112233"
      zone_id             = "ZXXXXXXXXXXX"
      public_subnets      = "${module.vpc.public_subnet_ids}"
      private_subnets     = "${module.vpc.private_subnet_ids}"
      loadbalancer_type   = "application"
      ssh_key_pair        = "key-test-1"
    
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
        period        = "24 hours"
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
```

## Input

|  Name                              |  Default                                                          |  Description                                                                                                                            | Required |
|:-----------------------------------|:-----------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| namespace                          |                                                                   | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                                 | Yes      |
| stage                              |                                                                   | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                                 | Yes      |
| name                               | `jenkins`                                                         | Name  of the application                                                                                                                | Yes      |
| description                        |                                                                   | Will be used as `Elastic Beanstalk` application description                                                                             | Yes      |
| aws_region                         | `us-west-2`                                                       | AWS Region to provision all the AWS resources in                                                                                        | Yes      |
| solution_stack_name                | `64bit Amazon Linux 2017.03 v2.7.4 running Docker 17.03.2-ce`     | `Elastic Beanstalk` stack                                                                                                               | Yes      |
| master_instance_type               | `t2.medium`                                                       | `EC2` instance type for `Jenkins` master                                                                                                | Yes      |
| vpc_id                             |                                                                   | AWS `VPC` ID where module should operate (_e.g._ `vpc-a22222ee`)                                                                        | Yes      |
| availability_zones                 |                                                                   | List of Availability Zones for `EFS`                                                                                                    | Yes      |
| healthcheck_url                    | `/login`                                                          | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on `EC2` instances    | Yes      |
| loadbalancer_type                  | `application`                                                     | Load Balancer type, e.g. `application` or `classic`                                                                                     | Yes      |
| loadbalancer_certificate_arn       |                                                                   | Load Balancer SSL certificate ARN. The certificate must be present in `AWS Certificate Manager`                                         | Yes      |
| public_subnets                     |                                                                   | List of public subnets to place `Elastic Load Balancer`                                                                                 | Yes      |
| private_subnets                    |                                                                   | List of private subnets to place `EC2` instances and `EFS`                                                                              | Yes      |
| zone_id                            |                                                                   | `Route53` parent zone ID. The module will create sub-domain DNS records in the parent zone for the `EB` environment and `EFS`           | Yes      |
| security_groups                    | `[]`                                                              | List of security groups to be allowed to connect to the EC2 instances                                                                   | No       |
| ssh_key_pair                       | ""                                                                | Name of `SSH` key that will be deployed on `Elastic Beanstalk` and `DataPipeline` instance. The key should be present in AWS            | No       |
| github_oauth_token                 | ""                                                                | GitHub Oauth Token for accessing private repositories. Leave it empty when deploying a public `Jenkins` repository                      | No       |
| github_organization                | `cloudposse`                                                      | GitHub organization, _e.g._ `cloudposse`. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository        | Yes      |
| github_repo_name                   | `jenkins`                                                         | GitHub repository name, _e.g._ `jenkins`. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository        | Yes      |
| github_branch                      | `master`                                                          | GitHub repository branch, _e.g._ `master`. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch    | Yes      |
| build_image                        | `aws/codebuild/docker:1.12.1`                                     | `CodeBuild` build image                                                                                                                 | Yes      |
| build_compute_type                 | `BUILD_GENERAL1_SMALL`                                            | `CodeBuild` compute type (instance type)                                                                                                | Yes      |
| aws_account_id                     |                                                                   | AWS Account ID. Used as `CodeBuild` ENV variable `$AWS_ACCOUNT_ID` when building `Docker` images                                        | Yes      |
| image_tag                          | `latest`                                                          | Docker image tag in the `ECR` repository, _e.g._ `latest`. Used as `CodeBuild` ENV variable `$IMAGE_TAG` when building `Docker` images  | Yes      |
| env_default_key                    | `DEFAULT_ENV_%d`                                                  | Default ENV variable key for `Elastic Beanstalk` `aws:elasticbeanstalk:application:environment` setting                                 | No       |
| env_default_value                  | `UNSET`                                                           | Default ENV variable value for `Elastic Beanstalk` `aws:elasticbeanstalk:application:environment` setting                               | No       |
| env_vars                           | `{}`                                                              | Map of custom `ENV` variables to be provided to the `Jenkins` application running on `Elastic Beanstalk`                                | No       |
| noncurrent_version_expiration_days | `35`                                                              | `S3` object versions expiration period (days) for backups                                                                               | Yes      |
| datapipeline_config                | `${map("instance_type", "t2.micro", "email", "", "period", "24 hours", "timeout", "60 Minutes")}"`| DataPipeline configuration options                                                                      | Yes      |
| attributes                         | `[]`                                                              | Additional attributes (_e.g._ `vpc`)                                                                                                    | No       |
| tags                               | `{}`                                                              | Additional tags (_e.g._ `map("BusinessUnit","ABC")`                                                                                     | No       |
| delimiter                          | `-`                                                               | Delimiter to be used between `name`, `namespace`, `stage` and `attributes`                                                              | No       |


### `datapipeline_config` variables

|  Name                              |  Default       |  Description                                                                 | Required |
|:-----------------------------------|:--------------:|:-----------------------------------------------------------------------------|:--------:|
| instance_type                      | `t2.micro`     | Instance type to use in `DataPipeline`                                       | Yes      |
| email                              | ""             | Email to use in `SNS`. Needs to be provided, otherwise the module will fail  | Yes      |
| period                             | `24 hours`     | Frequency of pipeline execution (frequency of backups)                       | Yes      |
| timeout                            | `60 Minutes`   | Pipeline execution timeout                                                   | Yes      |



The following attributes do not have default values and will be asked for when running `terraform plan` or `terraform apply` command:

* `aws_account_id`
* `jenkins_password`
* `datapipeline_config` value for `email`
* `zone_id`
* `loadbalancer_certificate_arn`
* `ssh_key_pair`


## References

* http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
