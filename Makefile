
ARGS_BASE := args_application

ARGS_TARGET := $(ARGS_BASE)
ARGS_SOURCE := $(ARGS_BASE).e

ARGS_GENERATED := $(ARGS_TARGET) $(ARGS_BASE).ecf EIFGENs

EC ?= ec

CHECKMAKE_VERSION := v0.3.2
ACTIONLINT_VERSION := v1.7.12
CHECKMAKE := $(shell command -v checkmake 2>/dev/null || echo go run github.com/checkmake/checkmake/cmd/checkmake@$(CHECKMAKE_VERSION))
ACTIONLINT := $(shell command -v actionlint 2>/dev/null || echo go run github.com/rhysd/actionlint/cmd/actionlint@$(ACTIONLINT_VERSION))

.PHONY: all
all: build

.PHONY: build
build: build.args

.PHONY: build.args
build.args: $(ARGS_TARGET)

$(ARGS_TARGET): $(ARGS_SOURCE) Makefile
	@$(EC) $(ARGS_SOURCE)
	@chmod +x $(ARGS_TARGET)

.PHONY: run.args
run.args: build.args
	@echo running the application...
	@./$(ARGS_TARGET) -n Eiffel
	@echo done.

.PHONY: lint.make
lint.make:
	@echo linting the Makefile...
	@$(CHECKMAKE) Makefile
	@echo Makefile is good.

.PHONY: lint.workflows
lint.workflows:
	@echo " Linting GitHub workflows..."
	@$(ACTIONLINT) --color
	@echo "All workflows are good."

.PHONY: lint
lint: lint.make lint.workflows

.PHONY: test
test: test.args
.PHONY: test.args
test.args: build.args
	@echo "testing the e args application..."
	@test "$$(./$(ARGS_TARGET) -n Eiffel)" = "Hello, Eiffel!"
	@test "$$(./$(ARGS_TARGET) -n world)" = "Hello, world!"
	@echo "The arg sapplication works correctly."

.PHONY: check
check: lint test


.PHONY: clean
clean: clean.args
.PHONY: clean.args
clean.args:
	@$(RM) -r $(ARGS_GENERATED)
