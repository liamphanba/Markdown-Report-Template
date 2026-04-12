.DEFAULT_GOAL := pdf
.PHONY: pdf clean

SRC ?= report.md
FORMAT ?= A4

# Supported FORMAT values: A1..A6, with optional orientation suffix P/L
# Examples: A4, A3L, A5P

pdf:
	bash scripts/export.sh $(SRC)

clean:
	rm -rf dist
