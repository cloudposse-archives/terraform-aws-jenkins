<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
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
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
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
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
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
