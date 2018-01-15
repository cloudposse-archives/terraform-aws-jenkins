export TF_WARN_OUTPUT_ERRORS=1

.PHONY: all jenkins

all:
	jenkins

jenkins:
	terraform plan -target=module.jenkins -out=terraform.tfplan
	terraform apply terraform.tfplan

clean:
	terraform destroy -target=module.jenkins -force || true
