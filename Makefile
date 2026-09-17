
TARGET := application
SOURCE := application.e

GENERATED := application application.ecf EIFGENs



.PHONY: all
all: build

.PHONY: build
build: $(TARGET)

$(TARGET): $(SOURCE) Makefile
	@ec $(SOURCE)
	@chmod +x $(TARGET)

.PHONY: run
run: build
	@echo running application...
	@./$(TARGET)
	@echo doine.

.PHONY: lint.make
lint.make:
	@echo linting the Makefile...
	@checkmake Makefile
	@echo Makefile is good.

.PHONY: test
test: lint.make run

.PHONY: clean
clean:
	@$(RM) -r $(GENERATED)

