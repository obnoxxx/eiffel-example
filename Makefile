
HELLO_BASE := hello
ARGS_BASE := args_application

ARGS_TARGET := $(ARGS_BASE)
HELLO_TARGET := $(HELLO_BASE)
ARGS_SOURCE := $(ARGS_BASE).e
HELLO_SOURCE := $(HELLO_BASE).e

ARGS_GEN := $(ARGS_TARGET) $(ARGS_BASE).ecf
EIFFEL_CACHE_GEN := EIFGENs
HELLO_GEN := $(HELLO_TARGET) $(HELLO_BASE).ecf

EC ?= ec

CHECKMAKE_VERSION := v0.3.2
ACTIONLINT_VERSION := v1.7.12
CHECKMAKE := $(shell command -v checkmake 2>/dev/null || echo go run github.com/checkmake/checkmake/cmd/checkmake@$(CHECKMAKE_VERSION))
ACTIONLINT := $(shell command -v actionlint 2>/dev/null || echo go run github.com/rhysd/actionlint/cmd/actionlint@$(ACTIONLINT_VERSION))

.PHONY: all
all: build

.PHONY: build
build: build.args build.hello

.PHONY: build.hello
build.hello: $(HELLO_TARGET)

$(HELLO_TARGET): $(HELLO_SOURCE) Makefile
	@$(EC) $(HELLO_SOURCE)
	@chmod +x $(HELLO_TARGET)


.PHONY: build.args
build.args: $(ARGS_TARGET)

$(ARGS_TARGET): $(ARGS_SOURCE) Makefile
	@$(EC) $(ARGS_SOURCE)
	@chmod +x $(ARGS_TARGET)

.PHONY: run.hello
run.hello: build.hello
	@echo running the hello application...
	@./$(HELLO_TARGET)
	@echo done.

.PHONY: run.args
run.args: build.args
	@echo running the args application...
	@./$(ARGS_TARGET) -n Eiffel
	@echo done.

.PHONY: run
run: run.hello run.args

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
test: test.args test.hello
.PHONY: test.hello
test.hello: build.hello
	@echo "testing the hello application..."
	@test "$$(./$(HELLO_TARGET))" = "Hello, Eiffel!"
	@echo "The args sapplication works correctly."

.PHONY: test.args
test.args: build.args
	@echo "testing the  args application..."
	@test "$$(./$(ARGS_TARGET) -n Eiffel)" = "Hello, Eiffel!"
	@test "$$(./$(ARGS_TARGET) -n world)" = "Hello, world!"
	@echo "The arg sapplication works correctly."

.PHONY: check
check: lint test


.PHONY: clean
clean: clean.args clean.hello clean.eiffel-cache
.PHONY: clean.args
clean.args:
	@$(RM) -r $(ARGS_GEN)
.PHONY: clean.hello
clean.hello:
	@$(RM) -r $(HELLO_GEN)

.PHONY: clean.eiffel-cache
clean.eiffel-cache:
	@$(RM) -r $(EIFFEL_CACHE_GEN)
