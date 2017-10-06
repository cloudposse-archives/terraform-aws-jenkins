# terraform-aws-jenkins

Terraform module to build Docker image with [`Jenkins`](https://jenkins.io/), save it to an [`ECR`](https://aws.amazon.com/ecr/) repo, and deploy to [`Elastic Beanstalk`](https://aws.amazon.com/elasticbeanstalk/) running [`Docker`](https://www.docker.com/) stack


The module will create the following `AWS` resources:

   * `Elastic Beanstalk Application`
   * `Elastic Beanstalk Environment` for `Jenkins` master
   * `EFS` filesystem (to store `Jenkins` state and jobs), and mount it to a directory on the EC2 host, and then mount the EC2 directory to `Docker` container
   * `DataPipeline` to automatically backup the `EFS` to `S3`
   * `ECR` repository to store the `Jenkins` `Docker` image
   * `CodePipeline` with `CodeBuild` so even `Jenkins` itself follows the `CI/CD` pattern

After all the `AWS` resources are created, the `CodePipeline` will:

  * Get the specified `GitHub` repo for deployment, e.g. `https://github.com/cloudposse/jenkins`
  * Build a `Docker` image from it
  * Save the `Docker` image to the `ECR` repo
  * Deploy the `Docker` image from the `ECR` repo to `EB` running `Docker` stack
  * Monitor the `GitHub` repo for changes and re-run the steps above if new commits are pushed into it

![jenkins build server architecture](https://user-images.githubusercontent.com/52489/30888694-d07d68c8-a2d6-11e7-90b2-d8275ef94f39.png)


The following attributes do not have default values and will be asked for when running `terraform plan` or `terraform apply` command:

* `aws_assume_role_arn`
* `github_oauth_token`
* `jenkins_password`
* `datapipeline_config` value for `email`
* `ssh_key_pair`


## References

* http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html
* http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
