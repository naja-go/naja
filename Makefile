BIN="./bin"
SRC=$(shell find . -name "*.go")

ifeq (, $(shell which golangci-lint))
$(warning "could not find golangci-lint in $(PATH), run: curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh")
endif

.PHONY: fmt lint test install_deps clean

.PHONY: help
help: ## Displays this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

all: fmt test ## Run all targets

fmt: ## Run Go formatters
	$(info ******************** checking formatting ********************)
	@test -z $(shell gofmt -l $(SRC)) || (gofmt -d $(SRC); exit 1)

lint: ## Run Golangci-lint
	$(info ******************** running lint tools ********************)
	golangci-lint run -v

test: install_deps ## Run tests
	$(info ******************** running tests ********************)
	go test -v $(GO_TEST_FLAGS) ./...

richtest: install_deps ## Run richtest
	$(info ******************** running tests with kyoh86/richgo ********************)
	richgo test -v $(GO_TEST_FLAGS) ./...

install_deps: ## Run go mod download
	$(info ******************** downloading dependencies ********************)
	go mod download

clean: ## Remove binary builds dir
	rm -rf $(BIN)
