#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-report.md}"
MODE="${2:---pdf-latex}"
DIST_DIR="dist"
DIST_CSS_DIR="${DIST_DIR}/styles"
HTML_OUT="${DIST_DIR}/report.html"
PDF_OUT="${DIST_DIR}/report.pdf"
CSS_SRC="styles/swiss-report.css"
CSS_DIST="styles/swiss-report.css"
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
FORMAT_CSS="styles/formats/a${A_INDEX}-${ORIENTATION_NAME}.css"

usage() {
  echo "Usage: FORMAT=A4|A3L|A5P bash scripts/export.sh <source.md> [--pdf-latex|--pdf-css|--html]"
}

build_html() {
  mkdir -p "$DIST_DIR"
  mkdir -p "$DIST_CSS_DIR"

  cp "$CSS_SRC" "${DIST_CSS_DIR}/swiss-report.css"
  rm -f "${DIST_CSS_DIR}"/format-*.css

  local extra_css_arg=""
  if [[ -n "$FORMAT_CSS" && -f "$FORMAT_CSS" ]]; then
    local format_file="format-$(echo "$FORMAT" | tr '[:upper:]' '[:lower:]').css"
    cp "$FORMAT_CSS" "${DIST_CSS_DIR}/${format_file}"
    extra_css_arg="--css styles/${format_file}"
  fi

  pandoc "$SRC" \
    --standalone \
    --css "$CSS_DIST" \
    ${extra_css_arg} \
    --metadata pagetitle="Swiss Report" \
    --output "$HTML_OUT"

  echo "HTML exported: $HTML_OUT"
}

build_pdf_latex() {
  local engine

  if command -v xelatex >/dev/null 2>&1; then
    engine="xelatex"
  elif command -v lualatex >/dev/null 2>&1; then
    engine="lualatex"
  else
    echo "Error: xelatex or lualatex is required for --pdf-latex mode."
    echo ""
    echo "Install a TeX distribution on macOS:"
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
    --pdf-engine "$engine" \
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

  echo "PDF exported with $engine ($FORMAT_UPPER, ${PAPERSIZE}, ${ORIENTATION_NAME}): $PDF_OUT"
}

build_pdf_css() {
  build_html

  if command -v weasyprint >/dev/null 2>&1; then
    weasyprint "$HTML_OUT" "$PDF_OUT"
    echo "PDF exported with weasyprint: $PDF_OUT"
  elif command -v google-chrome >/dev/null 2>&1; then
    google-chrome --headless --disable-gpu --print-to-pdf="$PDF_OUT" "file://$PWD/$HTML_OUT"
    echo "PDF exported with chrome: $PDF_OUT"
  elif command -v chromium >/dev/null 2>&1; then
    chromium --headless --disable-gpu --print-to-pdf="$PDF_OUT" "file://$PWD/$HTML_OUT"
    echo "PDF exported with chromium: $PDF_OUT"
  else
    echo "Error: no CSS PDF engine found. Install weasyprint or chrome/chromium."
    exit 1
  fi
}

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is required. Install from https://pandoc.org/installing.html"
  exit 1
fi

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file '$SRC' not found."
  exit 1
fi

case "$MODE" in
  --pdf-latex)
    build_pdf_latex
    ;;
  --pdf-css)
    build_pdf_css
    ;;
  --html)
    build_html
    ;;
  *)
    usage
    exit 1
    ;;
esac
