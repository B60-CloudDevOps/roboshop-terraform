TOKEN ?=

test-init:
	rm -rf .terraform* || true
	terraform init --backend-config=./env/test/state.tfvars

test-plan: test-init
	terraform plan --var-file=env/test/test.tfvars $(if $(TOKEN),-var="vault_token=$(TOKEN)","")

test-apply: test-plan
	terraform apply -auto-approve --var-file=./env/test/test.tfvars $(if $(TOKEN),-var="vault_token=$(TOKEN)","")

test-destroy-plan: test-init
	terraform plan -destroy -out=destroy.tfplan --var-file=./env/test/test.tfvars $(if $(TOKEN),-var="vault_token=$(TOKEN)","")

test-destroy: test-init
	terraform destroy -auto-approve --var-file=./env/test/test.tfvars $(if $(TOKEN),-var="vault_token=$(TOKEN)","")