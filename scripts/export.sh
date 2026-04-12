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

usage() {
  echo "Usage: bash scripts/export.sh <source.md> [--pdf-latex|--pdf-css|--html]"
}

build_html() {
  mkdir -p "$DIST_DIR"
  mkdir -p "$DIST_CSS_DIR"

  cp "$CSS_SRC" "${DIST_CSS_DIR}/swiss-report.css"

  pandoc "$SRC" \
    --standalone \
    --css "$CSS_DIST" \
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
    echo "Install a TeX distribution, then retry."
    exit 1
  fi

  mkdir -p "$DIST_DIR"

  pandoc "$SRC" \
    --pdf-engine "$engine" \
    -V geometry:a4paper \
    -V geometry:margin=18mm \
    -V mainfont="$MAINFONT" \
    --output "$PDF_OUT"

  echo "PDF exported with $engine: $PDF_OUT"
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
