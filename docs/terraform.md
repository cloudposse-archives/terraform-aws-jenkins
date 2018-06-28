
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| availability_zones | List of Availability Zones for EFS | list | - | yes |
| aws_account_id | AWS Account ID. Used as CodeBuild ENV variable $AWS_ACCOUNT_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | - | yes |
| aws_region | AWS region in which to provision the AWS resources | string | `us-west-2` | no |
| build_compute_type | CodeBuild compute type, e.g. 'BUILD_GENERAL1_SMALL'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-compute-types | string | `BUILD_GENERAL1_SMALL` | no |
| build_image | CodeBuild build image, e.g. 'aws/codebuild/docker:1.12.1'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html#build-env-ref-available | string | `aws/codebuild/docker:1.12.1` | no |
| datapipeline_config | DataPipeline configuration options | map | `<map>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| description | Will be used as Elastic Beanstalk application description | string | `Jenkins server as Docker container running on Elastic Benastalk` | no |
| env_default_key | Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting | string | `DEFAULT_ENV_%d` | no |
| env_default_value | Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting | string | `UNSET` | no |
| env_vars | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' } | map | `<map>` | no |
| github_branch | GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch | string | `master` | no |
| github_oauth_token | GitHub Oauth Token for accessing private repositories. Leave it empty when deploying a public 'Jenkins' repository, e.g. https://github.com/cloudposse/jenkins | string | `` | no |
| github_organization | GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | string | `cloudposse` | no |
| github_repo_name | GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | string | `jenkins` | no |
| healthcheck_url | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | string | `/login` | no |
| image_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `latest` | no |
| loadbalancer_certificate_arn | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | string | - | yes |
| loadbalancer_type | Load Balancer type, e.g. 'application' or 'classic' | string | `application` | no |
| master_instance_type | EC2 instance type for Jenkins master, e.g. 't2.medium' | string | `t2.medium` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `jenkins` | no |
| namespace | Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse' | string | - | yes |
| noncurrent_version_expiration_days | Backup S3 bucket noncurrent version expiration days | string | `35` | no |
| private_subnets | List of private subnets to place EC2 instances and EFS | list | - | yes |
| public_subnets | List of public subnets to place Elastic Load Balancer | list | - | yes |
| security_groups | List of security groups to be allowed to connect to the EC2 instances | list | `<list>` | no |
| solution_stack_name | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html | string | `64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce` | no |
| ssh_key_pair | Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS | string | `` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | - | yes |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map | `<map>` | no |
| use_efs_ip_address |  | string | `false` | no |
| vpc_id | ID of the VPC in which to provision the AWS resources | string | - | yes |
| zone_id | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS | string | - | yes |

