.PHONY: html pdf clean

SRC ?= report.md

html:
	bash scripts/export.sh $(SRC)

pdf:
	bash scripts/export.sh $(SRC) --pdf

clean:
	rm -rf dist
