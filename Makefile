.DEFAULT_GOAL := pdf
.PHONY: pdf clean

SRC     ?= report.md
METADATA_FILE ?= pandoc-pdf-render-parameters.yaml
FORMAT  ?= A4
MAINFONT ?=
DIST_DIR ?= dist

# Supported FORMAT values: A1..A6, with optional orientation suffix P/L
# Examples: A4, A3L, A5P

pdf:
	FORMAT=$(FORMAT) MAINFONT=$(MAINFONT) METADATA_FILE=$(METADATA_FILE) bash scripts/export.sh $(SRC)

clean:
	rm -rf dist
