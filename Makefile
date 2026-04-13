.DEFAULT_GOAL := all
.PHONY: all pdf word clean

SRC     ?= report.md
METADATA_FILE ?= report-config.yaml
FORMAT  ?= A4
MAINFONT ?=
DIST_DIR ?= dist
DOCX_OUT ?= $(DIST_DIR)/report.docx

# Supported FORMAT values: A1..A6, with optional orientation suffix P/L
# Examples: A4, A3L, A5P

all: pdf word

pdf:
	FORMAT=$(FORMAT) MAINFONT=$(MAINFONT) METADATA_FILE=$(METADATA_FILE) bash scripts/export.sh $(SRC)

word:
	mkdir -p $(DIST_DIR)
	pandoc $(SRC) --metadata-file=$(METADATA_FILE) -o $(DOCX_OUT) --table-of-contents --toc-depth=3

clean:
	rm -rf dist
