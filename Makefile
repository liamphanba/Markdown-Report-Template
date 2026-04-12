.DEFAULT_GOAL := pdf
.PHONY: html pdf pdf-latex pdf-css clean

SRC ?= report.md

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
