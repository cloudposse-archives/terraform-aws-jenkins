export TF_WARN_OUTPUT_ERRORS=1

.PHONY: all subnets jenkins

all:
	jenkins

subnets:
	terraform plan -target=module.subnets -out=terraform.tfplan
	terraform apply terraform.tfplan

jenkins: subnets
	terraform plan -target=module.jenkins -out=terraform.tfplan
	terraform apply terraform.tfplan

clean:
	terraform destroy -target=module.jenkins -force || true
	terraform destroy -target=module.subnets -force || true
