#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-report.md}"
DIST_DIR="dist"
HTML_OUT="${DIST_DIR}/report.html"
PDF_OUT="${DIST_DIR}/report.pdf"
CSS="styles/swiss-report.css"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is required. Install from https://pandoc.org/installing.html"
  exit 1
fi

if [[ ! -f "$SRC" ]]; then
  echo "Error: source file '$SRC' not found."
  exit 1
fi

mkdir -p "$DIST_DIR"

pandoc "$SRC" \
  --standalone \
  --css "$CSS" \
  --metadata pagetitle="Swiss Report" \
  --output "$HTML_OUT"

echo "HTML exported: $HTML_OUT"

if [[ "${2:-}" == "--pdf" ]]; then
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
    echo "No PDF engine found. Open $HTML_OUT in a browser and use Print > Save as PDF."
  fi
fi
