MOD = dagre-layout

YARN = yarn
ISTANBUL = ./node_modules/.bin/istanbul
KARMA = ./node_modules/.bin/karma
MOCHA = ./node_modules/.bin/_mocha

ISTANBUL_OPTS = --dir $(COVERAGE_DIR) --report html
MOCHA_OPTS = -R dot

COVERAGE_DIR = coverage
DIST_DIR = dist

SRC_FILES = index.js lib/version.js $(shell find lib -type f -name '*.js')
TEST_FILES = $(shell find test -type f -name '*.js' | grep -v 'bundle-test.js')

.PHONY: all bench browser-test unit-test test

all: unit-test

bench: test
	@src/bench.js

lib/version.js: package.json
	@src/release/make-version.js > $@

test: unit-test browser-test

unit-test: $(SRC_FILES) $(TEST_FILES) node_modules
	@$(ISTANBUL) cover $(ISTANBUL_OPTS) $(MOCHA) --dir $(COVERAGE_DIR) -- $(MOCHA_OPTS) $(TEST_FILES) || $(MOCHA) $(MOCHA_OPTS) $(TEST_FILES)

browser-test:
	$(KARMA) start --single-run $(KARMA_OPTS)

release:
	@echo
	@echo Starting release...
	@echo
	@src/release/release.sh $(MOD) dist

node_modules: package.json
	@$(YARN) install
	@touch $@
