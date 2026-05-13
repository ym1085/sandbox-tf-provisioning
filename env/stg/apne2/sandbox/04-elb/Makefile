# env/stg/apne2/sandbox/04-elb/Makefile

.PHONY: init plan

init:
	terraform init

plan:
	terraform plan -out=tfplan > /dev/null
	tf-summarize -separate-tree tfplan
	rm tfplan
