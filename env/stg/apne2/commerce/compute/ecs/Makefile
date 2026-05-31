# env/stg/apne2/commerce/compute/ecs/Makefile

.PHONY: init plan

init:
	terraform init

plan:
	terraform plan -out=tfplan > /dev/null
	tf-summarize -separate-tree tfplan
	rm tfplan
