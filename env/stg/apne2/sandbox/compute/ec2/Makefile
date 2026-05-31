# env/stg/apne2/sandbox/05-compute/ec2/Makefile

.PHONY: init plan

init:
	terraform init

plan:
	terraform plan -out=tfplan > /dev/null
	tf-summarize -separate-tree tfplan
	rm tfplan
