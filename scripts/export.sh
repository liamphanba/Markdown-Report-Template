#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-report.md}"
DIST_DIR="dist"
PDF_OUT="${DIST_DIR}/report.pdf"
MAINFONT="${MAINFONT:-TeX Gyre Heros}"
FORMAT="${FORMAT:-A4}"
LATEX_HEADER="templates/swiss-header.tex"

# FORMAT syntax: A1..A6, optional P/L suffix.
# Examples: A4, A4P, A4L, A3L, A6P
FORMAT_UPPER="$(echo "$FORMAT" | tr '[:lower:]' '[:upper:]')"
if [[ "$FORMAT_UPPER" =~ ^A([1-6])([PL])?$ ]]; then
  A_INDEX="${BASH_REMATCH[1]}"
  ORIENTATION="${BASH_REMATCH[2]:-P}"
else
  echo "Error: FORMAT must be A1..A6 with optional P or L (e.g., A4, A3L, A5P)."
  exit 1
fi

case "$A_INDEX" in
  1) BASE_W="594"; BASE_H="841" ;;
  2) BASE_W="420"; BASE_H="594" ;;
  3) BASE_W="297"; BASE_H="420" ;;
  4) BASE_W="210"; BASE_H="297" ;;
  5) BASE_W="148"; BASE_H="210" ;;
  6) BASE_W="105"; BASE_H="148" ;;
esac

if [[ "$ORIENTATION" == "L" ]]; then
  PAGE_W_MM="$BASE_H"
  PAGE_H_MM="$BASE_W"
  ORIENTATION_NAME="landscape"
  GEOM_ORIENTATION_ARG="-V geometry:landscape"
else
  PAGE_W_MM="$BASE_W"
  PAGE_H_MM="$BASE_H"
  ORIENTATION_NAME="portrait"
  GEOM_ORIENTATION_ARG=""
fi

# 9-unit margin canon: unit = page_width / 9
# top=1u  bottom=2u  inner=1u  outer=1.5u
GEOM_TOP="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9}")"
GEOM_BOTTOM="$(awk "BEGIN{printf \"%.1fmm\", 2*$PAGE_W_MM/9}")"
GEOM_INNER="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9}")"
GEOM_OUTER="$(awk "BEGIN{printf \"%.1fmm\", 1.5*$PAGE_W_MM/9}")"

PAPERSIZE="a${A_INDEX}paper"

usage() {
  echo "Usage: FORMAT=A4|A3L|A5P bash scripts/export.sh <source.md>"
}

build_pdf() {
  if ! command -v xelatex >/dev/null 2>&1; then
    echo "Error: xelatex is required for PDF export."
    echo ""
    echo "Install MacTeX on macOS:"
    echo "  brew install --cask mactex-no-gui"
    echo ""
    echo "Then retry: make pdf"
    exit 1
  fi

  mkdir -p "$DIST_DIR"

  local header_arg=""
  if [[ -f "$LATEX_HEADER" ]]; then
    header_arg="--include-in-header $LATEX_HEADER"
  fi

  pandoc "$SRC" \
    --pdf-engine "xelatex" \
    -V "papersize=$PAPERSIZE" \
    -V "geometry:top=$GEOM_TOP" \
    -V "geometry:bottom=$GEOM_BOTTOM" \
    -V "geometry:inner=$GEOM_INNER" \
    -V "geometry:outer=$GEOM_OUTER" \
    -V "mainfont=$MAINFONT" \
    -V "fontsize=10.5pt" \
    ${GEOM_ORIENTATION_ARG} \
    ${header_arg} \
    --output "$PDF_OUT"

  echo "PDF exported with xelatex ($FORMAT_UPPER, ${PAPERSIZE}, ${ORIENTATION_NAME}): $PDF_OUT"
}

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is required. Install from https://pandoc.org/installing.html"
  exit 1
fi

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file '$SRC' not found."
  usage
  exit 1
fi

build_pdf
