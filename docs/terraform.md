<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cicd"></a> [cicd](#module\_cicd) | cloudposse/cicd/aws | 0.12.0 |
| <a name="module_ecr"></a> [ecr](#module\_ecr) | cloudposse/ecr/aws | 0.32.2 |
| <a name="module_efs"></a> [efs](#module\_efs) | cloudposse/efs/aws | 0.25.0 |
| <a name="module_efs_backup"></a> [efs\_backup](#module\_efs\_backup) | cloudposse/backup/aws | 0.6.1 |
| <a name="module_elastic_beanstalk_application"></a> [elastic\_beanstalk\_application](#module\_elastic\_beanstalk\_application) | cloudposse/elastic-beanstalk-application/aws | 0.11.0 |
| <a name="module_elastic_beanstalk_environment"></a> [elastic\_beanstalk\_environment](#module\_elastic\_beanstalk\_environment) | cloudposse/elastic-beanstalk-environment/aws | 0.36.1 |
| <a name="module_label_slaves"></a> [label\_slaves](#module\_label\_slaves) | cloudposse/label/null | 0.24.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.slaves](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.slaves](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.slaves](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.slaves](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | List of security groups to be allowed to connect to Jenkins master EC2 instances | `list(string)` | `[]` | no |
| <a name="input_application_subnets"></a> [application\_subnets](#input\_application\_subnets) | List of subnets to place EC2 instances and EFS | `list(string)` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_availability_zone_selector"></a> [availability\_zone\_selector](#input\_availability\_zone\_selector) | Availability Zone selector | `string` | `"Any"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of Availability Zones for EFS | `list(string)` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID. Used as CodeBuild ENV variable $AWS\_ACCOUNT\_ID when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | CodeBuild compute type, e.g. 'BUILD\_GENERAL1\_SMALL'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | CodeBuild build image, e.g. 'aws/codebuild/amazonlinux2-x86\_64-standard:1.0'. For more info: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html | `string` | `"aws/codebuild/docker:1.12.1"` | no |
| <a name="input_cicd_bucket_force_destroy"></a> [cicd\_bucket\_force\_destroy](#input\_cicd\_bucket\_force\_destroy) | Force destroy the CI/CD S3 bucket even if it's not empty | `bool` | `false` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Will be used as Elastic Beanstalk application description | `string` | `"Jenkins server as Docker container running on Elastic Benastalk"` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the EB environment and EFS | `string` | n/a | yes |
| <a name="input_efs_backup_cold_storage_after"></a> [efs\_backup\_cold\_storage\_after](#input\_efs\_backup\_cold\_storage\_after) | Specifies the number of days after creation that a recovery point is moved to cold storage | `number` | `null` | no |
| <a name="input_efs_backup_completion_window"></a> [efs\_backup\_completion\_window](#input\_efs\_backup\_completion\_window) | The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window` | `number` | `null` | no |
| <a name="input_efs_backup_delete_after"></a> [efs\_backup\_delete\_after](#input\_efs\_backup\_delete\_after) | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | `number` | `null` | no |
| <a name="input_efs_backup_schedule"></a> [efs\_backup\_schedule](#input\_efs\_backup\_schedule) | A CRON expression specifying when AWS Backup initiates a backup job | `string` | `null` | no |
| <a name="input_efs_backup_start_window"></a> [efs\_backup\_start\_window](#input\_efs\_backup\_start\_window) | The amount of time in minutes before beginning a backup. Minimum value is 60 minutes | `number` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. env\_vars = { JENKINS\_USER = 'admin' JENKINS\_PASS = 'xxxxxx' } | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time' or `Immutable`, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments) | `string` | `"LoadBalanced"` | no |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | GitHub repository branch, e.g. 'master'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' master branch | `string` | `"master"` | no |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | GitHub Oauth Token | `string` | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization, e.g. 'cloudposse'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | `string` | `"cloudposse"` | no |
| <a name="input_github_repo_name"></a> [github\_repo\_name](#input\_github\_repo\_name) | GitHub repository name, e.g. 'jenkins'. By default, this module will deploy 'https://github.com/cloudposse/jenkins' repository | `string` | `"jenkins"` | no |
| <a name="input_healthcheck_url"></a> [healthcheck\_url](#input\_healthcheck\_url) | Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances | `string` | `"/login"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable $IMAGE\_TAG when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `"latest"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_loadbalancer_certificate_arn"></a> [loadbalancer\_certificate\_arn](#input\_loadbalancer\_certificate\_arn) | Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager | `string` | `""` | no |
| <a name="input_loadbalancer_logs_bucket_force_destroy"></a> [loadbalancer\_logs\_bucket\_force\_destroy](#input\_loadbalancer\_logs\_bucket\_force\_destroy) | Force destroy the S3 bucket for load balancer logs even if it's not empty | `bool` | `false` | no |
| <a name="input_loadbalancer_subnets"></a> [loadbalancer\_subnets](#input\_loadbalancer\_subnets) | List of subnets to place Elastic Load Balancer | `list(string)` | n/a | yes |
| <a name="input_loadbalancer_type"></a> [loadbalancer\_type](#input\_loadbalancer\_type) | Load Balancer type, e.g. 'application' or 'classic' | `string` | `"application"` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | EC2 instance type for Jenkins master, e.g. 't2.medium' | `string` | `"t2.medium"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region in which to provision the AWS resources | `string` | n/a | yes |
| <a name="input_rolling_update_type"></a> [rolling\_update\_type](#input\_rolling\_update\_type) | `Health`, `Time` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances. For more details, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate | `string` | `"Health"` | no |
| <a name="input_solution_stack_name"></a> [solution\_stack\_name](#input\_solution\_stack\_name) | Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html | `string` | `"64bit Amazon Linux 2018.03 v2.12.17 running Docker 18.06.1-ce"` | no |
| <a name="input_ssh_key_pair"></a> [ssh\_key\_pair](#input\_ssh\_key\_pair) | Name of SSH key that will be deployed on Elastic Beanstalk instances. The key should be present in AWS | `string` | `""` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_use_efs_ip_address"></a> [use\_efs\_ip\_address](#input\_use\_efs\_ip\_address) | If set to `true`, will provide the EFS IP address instead of DNS name to Jenkins as ENV var | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which to provision the AWS resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_badge_url"></a> [codebuild\_badge\_url](#output\_codebuild\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_codebuild_cache_bucket_arn"></a> [codebuild\_cache\_bucket\_arn](#output\_codebuild\_cache\_bucket\_arn) | CodeBuild cache S3 bucket ARN |
| <a name="output_codebuild_cache_bucket_name"></a> [codebuild\_cache\_bucket\_name](#output\_codebuild\_cache\_bucket\_name) | CodeBuild cache S3 bucket name |
| <a name="output_codebuild_project_id"></a> [codebuild\_project\_id](#output\_codebuild\_project\_id) | CodeBuild project ID |
| <a name="output_codebuild_project_name"></a> [codebuild\_project\_name](#output\_codebuild\_project\_name) | CodeBuild project name |
| <a name="output_codebuild_role_arn"></a> [codebuild\_role\_arn](#output\_codebuild\_role\_arn) | CodeBuild IAM Role ARN |
| <a name="output_codebuild_role_id"></a> [codebuild\_role\_id](#output\_codebuild\_role\_id) | CodeBuild IAM Role ID |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | CodePipeline ARN |
| <a name="output_codepipeline_id"></a> [codepipeline\_id](#output\_codepipeline\_id) | CodePipeline ID |
| <a name="output_ecr_registry_id"></a> [ecr\_registry\_id](#output\_ecr\_registry\_id) | Registry ID |
| <a name="output_ecr_repository_name"></a> [ecr\_repository\_name](#output\_ecr\_repository\_name) | Repository name |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | Repository URL |
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | EFS ARN |
| <a name="output_efs_backup_plan_arn"></a> [efs\_backup\_plan\_arn](#output\_efs\_backup\_plan\_arn) | Backup Plan ARN |
| <a name="output_efs_backup_plan_version"></a> [efs\_backup\_plan\_version](#output\_efs\_backup\_plan\_version) | Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan |
| <a name="output_efs_backup_selection_id"></a> [efs\_backup\_selection\_id](#output\_efs\_backup\_selection\_id) | Backup Selection ID |
| <a name="output_efs_backup_vault_arn"></a> [efs\_backup\_vault\_arn](#output\_efs\_backup\_vault\_arn) | Backup Vault ARN |
| <a name="output_efs_backup_vault_id"></a> [efs\_backup\_vault\_id](#output\_efs\_backup\_vault\_id) | Backup Vault ID |
| <a name="output_efs_backup_vault_recovery_points"></a> [efs\_backup\_vault\_recovery\_points](#output\_efs\_backup\_vault\_recovery\_points) | Backup Vault recovery points |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | EFS DNS name |
| <a name="output_efs_host"></a> [efs\_host](#output\_efs\_host) | Route53 DNS hostname for the EFS |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | EFS ID |
| <a name="output_efs_mount_target_dns_names"></a> [efs\_mount\_target\_dns\_names](#output\_efs\_mount\_target\_dns\_names) | List of EFS mount target DNS names |
| <a name="output_efs_mount_target_ids"></a> [efs\_mount\_target\_ids](#output\_efs\_mount\_target\_ids) | List of EFS mount target IDs (one per Availability Zone) |
| <a name="output_efs_mount_target_ips"></a> [efs\_mount\_target\_ips](#output\_efs\_mount\_target\_ips) | List of EFS mount target IPs (one per Availability Zone) |
| <a name="output_efs_network_interface_ids"></a> [efs\_network\_interface\_ids](#output\_efs\_network\_interface\_ids) | List of mount target network interface IDs |
| <a name="output_elastic_beanstalk_application_name"></a> [elastic\_beanstalk\_application\_name](#output\_elastic\_beanstalk\_application\_name) | Elastic Beanstalk Application name |
| <a name="output_elastic_beanstalk_environment_all_settings"></a> [elastic\_beanstalk\_environment\_all\_settings](#output\_elastic\_beanstalk\_environment\_all\_settings) | List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration |
| <a name="output_elastic_beanstalk_environment_application"></a> [elastic\_beanstalk\_environment\_application](#output\_elastic\_beanstalk\_environment\_application) | The Elastic Beanstalk Application specified for this environment |
| <a name="output_elastic_beanstalk_environment_autoscaling_groups"></a> [elastic\_beanstalk\_environment\_autoscaling\_groups](#output\_elastic\_beanstalk\_environment\_autoscaling\_groups) | The autoscaling groups used by this environment |
| <a name="output_elastic_beanstalk_environment_ec2_instance_profile_role_name"></a> [elastic\_beanstalk\_environment\_ec2\_instance\_profile\_role\_name](#output\_elastic\_beanstalk\_environment\_ec2\_instance\_profile\_role\_name) | Instance IAM role name |
| <a name="output_elastic_beanstalk_environment_elb_zone_id"></a> [elastic\_beanstalk\_environment\_elb\_zone\_id](#output\_elastic\_beanstalk\_environment\_elb\_zone\_id) | ELB zone id |
| <a name="output_elastic_beanstalk_environment_endpoint"></a> [elastic\_beanstalk\_environment\_endpoint](#output\_elastic\_beanstalk\_environment\_endpoint) | Fully qualified DNS name for the environment |
| <a name="output_elastic_beanstalk_environment_hostname"></a> [elastic\_beanstalk\_environment\_hostname](#output\_elastic\_beanstalk\_environment\_hostname) | DNS hostname |
| <a name="output_elastic_beanstalk_environment_id"></a> [elastic\_beanstalk\_environment\_id](#output\_elastic\_beanstalk\_environment\_id) | ID of the Elastic Beanstalk environment |
| <a name="output_elastic_beanstalk_environment_instances"></a> [elastic\_beanstalk\_environment\_instances](#output\_elastic\_beanstalk\_environment\_instances) | Instances used by this environment |
| <a name="output_elastic_beanstalk_environment_launch_configurations"></a> [elastic\_beanstalk\_environment\_launch\_configurations](#output\_elastic\_beanstalk\_environment\_launch\_configurations) | Launch configurations in use by this environment |
| <a name="output_elastic_beanstalk_environment_load_balancers"></a> [elastic\_beanstalk\_environment\_load\_balancers](#output\_elastic\_beanstalk\_environment\_load\_balancers) | Elastic Load Balancers in use by this environment |
| <a name="output_elastic_beanstalk_environment_name"></a> [elastic\_beanstalk\_environment\_name](#output\_elastic\_beanstalk\_environment\_name) | Name |
| <a name="output_elastic_beanstalk_environment_queues"></a> [elastic\_beanstalk\_environment\_queues](#output\_elastic\_beanstalk\_environment\_queues) | SQS queues in use by this environment |
| <a name="output_elastic_beanstalk_environment_security_group_id"></a> [elastic\_beanstalk\_environment\_security\_group\_id](#output\_elastic\_beanstalk\_environment\_security\_group\_id) | Security group id |
| <a name="output_elastic_beanstalk_environment_setting"></a> [elastic\_beanstalk\_environment\_setting](#output\_elastic\_beanstalk\_environment\_setting) | Settings specifically set for this environment |
| <a name="output_elastic_beanstalk_environment_tier"></a> [elastic\_beanstalk\_environment\_tier](#output\_elastic\_beanstalk\_environment\_tier) | The environment tier |
| <a name="output_elastic_beanstalk_environment_triggers"></a> [elastic\_beanstalk\_environment\_triggers](#output\_elastic\_beanstalk\_environment\_triggers) | Autoscaling triggers in use by this environment |
<!-- markdownlint-restore -->
