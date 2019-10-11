package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply`
	_, err := terraform.InitAndApplyE(t, terraformOptions)

	/*
		We need to apply twice because of the current bug with `dynamic` blocks in terraform `aws` provider:

		Error: Provider produced inconsistent final plan
		When expanding the plan for
		module.jenkins.module.elastic_beanstalk_environment.aws_elastic_beanstalk_environment.default
		to include new values learned so far during apply, provider "aws" produced an
		invalid new value for .setting: block set length changed from 72 to 77.
		This is a bug in the provider, which should be reported in the provider's own issue tracker.

		https://github.com/terraform-providers/terraform-provider-aws/issues/10297
		https://github.com/terraform-providers/terraform-provider-aws/issues/7987
		https://github.com/hashicorp/terraform/issues/20517
	*/

	if err != nil {
		terraform.Apply(t, terraformOptions)
	}

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	elasticBeanstalkApplicationName := terraform.Output(t, terraformOptions, "elastic_beanstalk_application_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins-app", elasticBeanstalkApplicationName)

	// Run `terraform output` to get the value of an output variable
	elasticBeanstalkEnvironmentName := terraform.Output(t, terraformOptions, "elastic_beanstalk_environment_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins-env", elasticBeanstalkEnvironmentName)

	// Run `terraform output` to get the value of an output variable
	elasticBeanstalkEnvironmentHostname := terraform.Output(t, terraformOptions, "elastic_beanstalk_environment_hostname")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "jenkins.testing.cloudposse.co", elasticBeanstalkEnvironmentHostname)

	// Run `terraform output` to get the value of an output variable
	ecrRepositoryName := terraform.Output(t, terraformOptions, "ecr_repository_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins", ecrRepositoryName)

	// Run `terraform output` to get the value of an output variable
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins-cicd-build", codebuildProjectName)

	// Run `terraform output` to get the value of an output variable
	codebuildCacheBucketName := terraform.Output(t, terraformOptions, "codebuild_cache_bucket_name")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, codebuildCacheBucketName, "eg-test-jenkins-cicd-build")

	// Run `terraform output` to get the value of an output variable
	codepipelineId := terraform.Output(t, terraformOptions, "codepipeline_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins-cicd", codepipelineId)

	// Run `terraform output` to get the value of an output variable
	efsArn := terraform.Output(t, terraformOptions, "efs_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, efsArn, "arn:aws:elasticfilesystem:us-east-2:126450723953:file-system")

	// Run `terraform output` to get the value of an output variable
	efsBackupPlanArn := terraform.Output(t, terraformOptions, "efs_backup_plan_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, efsBackupPlanArn, "arn:aws:backup:us-east-2:126450723953:backup-plan")

	// Run `terraform output` to get the value of an output variable
	efsBackupVaultArn := terraform.Output(t, terraformOptions, "efs_backup_vault_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:backup:us-east-2:126450723953:backup-vault:eg-test-jenkins-efs", efsBackupVaultArn)

	// Run `terraform output` to get the value of an output variable
	efsBackupVaultId := terraform.Output(t, terraformOptions, "efs_backup_vault_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-jenkins-efs", efsBackupVaultId)
}
