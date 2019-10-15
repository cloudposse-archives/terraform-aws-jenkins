## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_security_groups | List of security groups to be allowed to connect to Jenkins master EC2 instances | list(string) | `<list>` | no |
| application_subnets | List of subnets to place EC2 instances and EFS | list(string) | - | yes |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| availability_zone_selector | Availability Zone selector | string | `Any` | no |
| availability_zones | List of Availability Zones for EFS | list(string) | - | yes |
| aws_account_id | AWS Account ID. Used as CodeBuild ENV variable $AWS_ACCOUNT_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | - | yes |
| build_compute_type | CodeBuild compute type, e.g. 'BUILD_GENERAL1_SMALL'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | string | `BUILD_GENERAL1_SMALL` | no |
| build_image | CodeBuild build image, e.g. 'aws/codebuild/amazonlinux2-x86_64-standard:1.0'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html | string | `aws/codebuild/docker:1.12.1` | no |
| cicd_bucket_force_destroy | Force destroy the CI/CD S3 bucket even if it's not empty | bool | `false` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| description | Will be used as Elastic Beanstalk application description | string | `Jenkins server as Docker container running on Elastic Benastalk` | no |
| dns_zone_id | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS | string | - | yes |
| efs_backup_cold_storage_after | Specifies the number of days after creation that a recovery point is moved to cold storage | number | `null` | no |
| efs_backup_completion_window | The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window` | number | `null` | no |
| efs_backup_delete_after | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | number | `null` | no |
| efs_backup_schedule | A CRON expression specifying when AWS Backup initiates a backup job | string | `null` | no |
| efs_backup_start_window | The amount of time in minutes before beginning a backup. Minimum value is 60 minutes | number | `null` | no |
| env_vars | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' } | map(string) | `<map>` | no |
| environment_type | Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time' or `Immutable`, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments) | string | `LoadBalanced` | no |
| github_branch | GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch | string | `master` | no |
| github_oauth_token | GitHub Oauth Token | string | - | yes |
| github_organization | GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | string | `cloudposse` | no |
| github_repo_name | GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | string | `jenkins` | no |
| healthcheck_url | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | string | `/login` | no |
| image_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `latest` | no |
| loadbalancer_certificate_arn | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | string | `` | no |
| loadbalancer_logs_bucket_force_destroy | Force destroy the S3 bucket for load balancer logs even if it's not empty | bool | `false` | no |
| loadbalancer_subnets | List of subnets to place Elastic Load Balancer | list(string) | - | yes |
| loadbalancer_type | Load Balancer type, e.g. 'application' or 'classic' | string | `application` | no |
| master_instance_type | EC2 instance type for Jenkins master, e.g. 't2.medium' | string | `t2.medium` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| region | AWS region in which to provision the AWS resources | string | - | yes |
| rolling_update_type | `Health`, `Time` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances. For more details, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate | string | `Health` | no |
| solution_stack_name | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html | string | `64bit Amazon Linux 2018.03 v2.12.17 running Docker 18.06.1-ce` | no |
| ssh_key_pair | Name of SSH key that will be deployed on Elastic Beanstalk instances. The key should be present in AWS | string | `` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |
| use_efs_ip_address | If set to `true`, will provide the EFS IP address instead of DNS name to Jenkins as ENV var | bool | `false` | no |
| vpc_id | ID of the VPC in which to provision the AWS resources | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| codebuild_badge_url | The URL of the build badge when badge_enabled is enabled |
| codebuild_cache_bucket_arn | CodeBuild cache S3 bucket ARN |
| codebuild_cache_bucket_name | CodeBuild cache S3 bucket name |
| codebuild_project_id | CodeBuild project ID |
| codebuild_project_name | CodeBuild project name |
| codebuild_role_arn | CodeBuild IAM Role ARN |
| codebuild_role_id | CodeBuild IAM Role ID |
| codepipeline_arn | CodePipeline ARN |
| codepipeline_id | CodePipeline ID |
| ecr_registry_id | Registry ID |
| ecr_registry_url | Registry URL |
| ecr_repository_name | Registry name |
| efs_arn | EFS ARN |
| efs_backup_plan_arn | Backup Plan ARN |
| efs_backup_plan_version | Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan |
| efs_backup_selection_id | Backup Selection ID |
| efs_backup_vault_arn | Backup Vault ARN |
| efs_backup_vault_id | Backup Vault ID |
| efs_backup_vault_recovery_points | Backup Vault recovery points |
| efs_dns_name | EFS DNS name |
| efs_host | Route53 DNS hostname for the EFS |
| efs_id | EFS ID |
| efs_mount_target_dns_names | List of EFS mount target DNS names |
| efs_mount_target_ids | List of EFS mount target IDs (one per Availability Zone) |
| efs_mount_target_ips | List of EFS mount target IPs (one per Availability Zone) |
| efs_network_interface_ids | List of mount target network interface IDs |
| elastic_beanstalk_application_name | Elastic Beanstalk Application name |
| elastic_beanstalk_environment_all_settings | List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration |
| elastic_beanstalk_environment_application | The Elastic Beanstalk Application specified for this environment |
| elastic_beanstalk_environment_autoscaling_groups | The autoscaling groups used by this environment |
| elastic_beanstalk_environment_ec2_instance_profile_role_name | Instance IAM role name |
| elastic_beanstalk_environment_elb_zone_id | ELB zone id |
| elastic_beanstalk_environment_endpoint | Fully qualified DNS name for the environment |
| elastic_beanstalk_environment_hostname | DNS hostname |
| elastic_beanstalk_environment_id | ID of the Elastic Beanstalk environment |
| elastic_beanstalk_environment_instances | Instances used by this environment |
| elastic_beanstalk_environment_launch_configurations | Launch configurations in use by this environment |
| elastic_beanstalk_environment_load_balancers | Elastic Load Balancers in use by this environment |
| elastic_beanstalk_environment_name | Name |
| elastic_beanstalk_environment_queues | SQS queues in use by this environment |
| elastic_beanstalk_environment_security_group_id | Security group id |
| elastic_beanstalk_environment_setting | Settings specifically set for this environment |
| elastic_beanstalk_environment_tier | The environment tier |
| elastic_beanstalk_environment_triggers | Autoscaling triggers in use by this environment |

