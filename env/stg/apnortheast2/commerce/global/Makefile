# env/stg/apnortheast2/commerce/global/Makefile

.PHONY: init plan

init:
	terraform init

plan:
	terraform plan -out=tfplan > /dev/null
	tf-summarize -separate-tree tfplan
	rm tfplan
