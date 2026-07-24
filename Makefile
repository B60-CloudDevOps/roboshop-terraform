.PHONY: test-init test-plan test-apply test-destroy-plan test-destroy

# Pass the Vault token with:  make test-plan TOKEN=xxxx
# Terraform automatically reads TF_VAR_vault_token, so the token is never
# placed on the command line (no echo/process-list leak) or as a stray arg.
# In CI you can instead set TF_VAR_vault_token as a job/step env var directly.
ifdef TOKEN
export TF_VAR_vault_token = $(TOKEN)
endif

test-init:
	rm -rf .terraform* || true
	terraform init --backend-config=./env/test/state.tfvars

test-plan: test-init
	terraform plan --var-file=./env/test/test.tfvars

test-apply: test-plan
	terraform apply -auto-approve --var-file=./env/test/test.tfvars

test-destroy-plan: test-init
	terraform plan -destroy -out=destroy.tfplan --var-file=./env/test/test.tfvars

test-destroy: test-init
	terraform destroy -auto-approve --var-file=./env/test/test.tfvars
