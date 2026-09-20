
TARGET := application
SOURCE := application.e

GENERATED := application application.ecf EIFGENs

EC ?= ec

CHECKMAKE_VERSION := v0.3.2
ACTIONLINT_VERSION := v1.7.12
CHECKMAKE := go run github.com/checkmake/checkmake/cmd/checkmake@$(CHECKMAKE_VERSION)
ACTIONLINT := go run github.com/rhysd/actionlint/cmd/actionlint@$(ACTIONLINT_VERSION)

.PHONY: all
all: build

.PHONY: build
build: $(TARGET)

$(TARGET): $(SOURCE) Makefile
	@$(EC) $(SOURCE)
	@chmod +x $(TARGET)

.PHONY: run
run: build
	@echo running the application...
	@./$(TARGET) -n Eiffel
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
test: build
	@echo "testing the eapplication..."
	@test "$$(./application -n Eiffel)" = "Hello, Eiffel!"
	@echo "The application works correctly."

.PHONY: check
check: lint test


.PHONY: clean
clean:
	@$(RM) -r $(GENERATED)

