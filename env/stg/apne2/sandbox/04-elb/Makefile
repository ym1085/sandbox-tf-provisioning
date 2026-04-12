# env/stg/apne2/sandbox/01-global/Makefile

.PHONY: plan apply destroy

init:
	terraform init

plan:
	terraform plan -out=tfplan > /dev/null
	tf-summarize -separate-tree tfplan
	rm tfplan

apply:
	terraform apply

destroy:
	terraform destroy