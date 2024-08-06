.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## init packer
	packer init -upgrade .

validate: init ## validate packer
	packer validate .

build: init ## build packer
	packer build aws-ollama.pkr.hcl
