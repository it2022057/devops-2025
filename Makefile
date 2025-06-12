# Load variables from .env (user must create it first)
include .env
export

VAULT_PASS_FILE=.vault_pass.txt

.PHONY: vault-pass
vault-pass:
ifndef VAULT_PASSWORD
	$(error VAULT_PASSWORD is not set. Copy .env.template to .env and fill it in.)
endif
	@echo "Creating $(VAULT_PASS_FILE)..."
	@echo "$$VAULT_PASSWORD" > $(VAULT_PASS_FILE)
	@chmod 600 $(VAULT_PASS_FILE)
	@echo "Done: $(VAULT_PASS_FILE) created."

.PHONY: env-init
env-init:
	@test -f .env || cp .env.template .env && echo ".env created from template"
