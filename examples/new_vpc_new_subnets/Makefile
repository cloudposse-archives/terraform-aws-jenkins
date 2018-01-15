export TF_WARN_OUTPUT_ERRORS=1

.PHONY: all vpc subnets jenkins

all:
	jenkins

vpc:
	terraform plan -target=module.vpc -out=terraform.tfplan
	terraform apply terraform.tfplan

subnets: vpc
	terraform plan -target=module.subnets -out=terraform.tfplan
	terraform apply terraform.tfplan

jenkins: subnets
	terraform plan -target=module.jenkins -out=terraform.tfplan
	terraform apply terraform.tfplan

clean:
	terraform destroy -target=module.jenkins -force || true
	terraform destroy -target=module.subnets -force || true
	terraform destroy -target=module.vpc -force || true
