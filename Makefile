VERSION ?= $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT ?= $(shell git log -1 --format='%H')
BRANCH ?= $(shell git for-each-ref --format='%(objectname) %(refname:short)' refs/heads | awk "/^$$(git rev-parse HEAD)/ {print \$$2}")

#
# ─── GLOBAL VARIABLES ───────────────────────────────────────────────────────────
#
PROTO_FILES := $(shell find ./ -name "*.proto")

#
# ────────────────────────────────────────────────  ──────────
#   :::::: H E L P : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────
#
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

#
# ──────────────────────────────────────────────────────── I ──────────
#   :::::: C O M M A N D S : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────
#


build: ## build every things (-out="outputDir")
	$(MAKE) .build.proto-go

version: ## Output the current version
	@echo $(VERSION)

commit: ## Output the current commit
	@echo $(COMMIT)

branch: ## Output the current branch
	@echo $(BRANCH)

clean:  ## remove the generated files
	@$(MAKE) .clean.go

test:	## test the protofiles
	@echo "Start testing the proto files"
	@$(MAKE) .test.lint

analyze:
	@echo "No analyzing available"



#
# ────────────────────────────────────────────────── II ──────────
#   :::::: U T I L S : :  :   :    :     :        :          :
# ────────────────────────────────────────────────────────────
#

#
# ───────────────────────────────────────────────────────────────── BUILD-GO ─────
#
.PHONY: .build-go .build-go.init .build-go.tidy

.build.proto-go: ## build the go files
	@$(MAKE) .build.proto-go.init
	@$(MAKE) .build.proto-go.prototool

.build.proto-go.init:
	@$(MAKE) .clean.go
	-mkdir $(GO_OUT_DIR)
# 	cd $(GO_OUT_DIR) && docker run -v "$(PROTO_DIR):$(PROTO_DIR)" -w "$(PROTO_DIR)/$(GO_OUT_DIR)" golang:latest go mod init $(GO_MODULE)

.build.proto-go.prototool:
	@echo "building using prototool"
	cd . && sudo run -v "$(PWD):/src/app" -w "/src/app" uber/prototool:latest prototool generate . --walk-timeout 15s
# ────────────────────────────────────────────────────────────────────────────────

#
# ──────────────────────────────────────────────────────────────────── CLEAN ─────
#
.PHONY: clean.go

.clean.go: ## remove the go output directory
	-rm -rf $(GO_OUT_DIR)

#
# ──────────────────────────────────────────────────────────── TEST AND LINT ─────
#

.test.lint: ## test the files and lint
	@$(MAKE) .test.lint.proto

#
# ─── PROTOS ─────────────────────────────────────────────────────────────────────
#
.test.lint.proto: ## test the files and lint
	cd . && docker run -v "$(PWD):/app" -w "/app" uber/prototool:latest prototool lint . --walk-timeout 15s


SONAR_TOKEN ?= "SonarScannerToken"
SONAR_HOST_URL ?=http://127.0.0.1:9000
SONAR_PROJECT_KEY ?= $(PROJECT_KEY)_$(BRANCH)

SONAR_WDR ?= /usr/src
SONAR_PROJECT_KEY := $(subst $(subst ,, ),:,$(subst /,--,$(SONAR_PROJECT_KEY)))
.sonar-scanner:
	docker run \
		--rm \
		-e SONAR_HOST_URL="$(SONAR_HOST_URL)" \
		-e SONAR_LOGIN="$(SONAR_TOKEN)" \
		-e SONAR_PROJECTKEY="$(SONAR_PROJECT_KEY)" \
		-v "${CURDIR}:$(SONAR_WDR)" \
		-w $(SONAR_WDR) \
		sonarsource/sonar-scanner-cli \
		-D"sonar.projectKey=saage_oracle" \
		-D"sonar.go.coverage.reportPaths=$(COVERAGE_REPORT)"


