.DEFAULT_GOAL := pdf
.PHONY: html pdf pdf-latex pdf-css clean

SRC ?= report.md
FORMAT ?= A4

# Supported FORMAT values: A1..A6, with optional orientation suffix P/L
# Examples: A4, A3L, A5P

html:
	bash scripts/export.sh $(SRC) --html

pdf:
	bash scripts/export.sh $(SRC) --pdf-latex

pdf-latex:
	bash scripts/export.sh $(SRC) --pdf-latex

pdf-css:
	bash scripts/export.sh $(SRC) --pdf-css

clean:
	rm -rf dist
