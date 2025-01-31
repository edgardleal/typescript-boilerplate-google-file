#
# Makefile
# edgardleal, 2020-03-12 09:50
#

DONE = echo ✓ $@ done
SOURCES = $(shell find src/ -type f -name '*.ts')
APP_NAME = $(shell cat package.json 2>/dev/null | $(call JSON_GET_VALUE,name))
modules = $(wildcard node_modules/*/*.js)
.PHONY: all clean help run build install lint

all: compile

node_modules/.last_lint: $(SOURCES) node_modules/.bin/tsc
	yarn lint
	@touch $@

lint: node_modules/.last_lint

node_modules/.bin/tsc: package.json
	yarn || npm i
	@touch $@

dist/src/file/file.js: $(SOURCES) node_modules/.last_lint node_modules/.bin/tsc coverage/index.html
	./node_modules/.bin/tsc -p tsconfig.json

build: dist/src/file/file.js

node_modules/.bin/jest: package.json
	yarn || npm i
	@touch $@

install: node_modules/.bin/jest

coverage/index.html: $(SOURCES) node_modules/.bin/jest
	DEBUG=project* yarn test --coverage --coverageReporters html

test: coverage/index.html

compile: dist/src/file/file.js

clean: ## clean: Remove ./node_modules and call clean in all children projects
	git clean -fdX

hel%: ## help: Show this help message.
	@echo "usage: make [target] ..."
	@echo ""
	@echo "targets:"
	@grep -Eh '^.+:\ ##\ .+' ${MAKEFILE_LIST} | cut -d ' ' -f '3-' | column -t -s ':'


# vim:ft=make
#
