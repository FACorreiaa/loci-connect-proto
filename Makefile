.PHONY: lint generate push ontology bruno tag push-tag release

GO ?= go
GOFLAGS ?= -mod=mod
REMOTE ?= origin
ONTOLOGY_TTL ?= ontology/generated.ttl
ONTOLOGY_CONTEXT ?= ontology/generated.context.jsonld

lint: ## Run proto lint checks
	buf lint

generate: ## Generate Go + Connect code
	buf generate

push: ## Push module to Buf Schema Registry
	buf push

bruno: ## Regenerate the Bruno collection from the generated OpenAPI spec
	npx -y @usebruno/cli@latest import openapi \
		--source gen/openapi/loci.openapi.yaml \
		--output ../loci-collection-generated \
		--collection-format bru --group-by tags --collection-name loci

insomnia:
	buf build -o /Users/fernando_idwell/Projects/Loci/loci-connect-proto/loci-protos.bin

ontology: ## Generate ontology artifacts from the latest proto descriptors
	GOFLAGS="$(GOFLAGS)" $(GO) run ./ontology/cmd/generate \
		--module-path=. \
		--out="$(ONTOLOGY_TTL)" \
		--context-out="$(ONTOLOGY_CONTEXT)"

tag: ## Create a git tag: make tag VERSION=v1.0.0
	@test -n "$(VERSION)" || (echo "VERSION is required, e.g. make tag VERSION=v1.0.0" && exit 1)
	git tag $(VERSION)

push-tag: ## Push a git tag to the remote: make push-tag VERSION=v1.0.0
	@test -n "$(VERSION)" || (echo "VERSION is required, e.g. make push-tag VERSION=v1.0.0" && exit 1)
	git push $(REMOTE) $(VERSION)

release: tag push-tag push ## Tag, push the tag, and publish to the Buf Schema Registry: make release VERSION=v1.0.0
