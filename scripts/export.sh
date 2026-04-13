#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-report.md}"
METADATA_FILE="${METADATA_FILE:-pandoc-pdf-render-parameters.yaml}"
DIST_DIR="dist"
PDF_OUT="${DIST_DIR}/report.pdf"
MAINFONT="${MAINFONT:-}"
FONT_PATH="${FONT_PATH:-}"
FONT_EXTENSION="${FONT_EXTENSION:-}"
FONT_UPRIGHT="${FONT_UPRIGHT:-}"
FONT_BOLD="${FONT_BOLD:-}"
FONT_ITALIC="${FONT_ITALIC:-}"
FONT_BOLDITALIC="${FONT_BOLDITALIC:-}"
FORMAT="${FORMAT:-A4}"
LATEX_TEMPLATE="templates/pandoc-xelatex-pdf-render-template.tex"

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

# Standard symmetric margins for single-sided document (no inner/outer swap).
# left = right = W/9, top = W/9, bottom = W/9 × 2.
GEOM_LEFT="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9}")"
GEOM_RIGHT="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9}")"
GEOM_TOP="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9}")"
GEOM_BOTTOM="$(awk "BEGIN{printf \"%.1fmm\", $PAGE_W_MM/9*2}")"

PAPERSIZE="a${A_INDEX}"

usage() {
  echo "Usage: FORMAT=A4|A3L|A5P bash scripts/export.sh <source.md>"
  echo ""
  echo "Font options:"
  echo "  MAINFONT=\"Helvetica Neue\""
  echo "  FONT_PATH=/absolute/path/to/fonts"
  echo "  FONT_EXTENSION=.otf"
  echo "  FONT_UPRIGHT=*-Regular FONT_BOLD=*-Bold FONT_ITALIC=*-Italic FONT_BOLDITALIC=*-BoldItalic"
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

  local mainfontopts=""
  if [[ -n "$FONT_PATH" ]]; then
    if [[ ! -d "$FONT_PATH" ]]; then
      echo "Error: FONT_PATH '$FONT_PATH' is not a valid directory."
      exit 1
    fi

    local path_value="${FONT_PATH%/}/"
    mainfontopts="Path=${path_value}"

    if [[ -n "$FONT_EXTENSION" ]]; then
      mainfontopts+=";Extension=${FONT_EXTENSION}"
    fi
    if [[ -n "$FONT_UPRIGHT" ]]; then
      mainfontopts+=";UprightFont=${FONT_UPRIGHT}"
    fi
    if [[ -n "$FONT_BOLD" ]]; then
      mainfontopts+=";BoldFont=${FONT_BOLD}"
    fi
    if [[ -n "$FONT_ITALIC" ]]; then
      mainfontopts+=";ItalicFont=${FONT_ITALIC}"
    fi
    if [[ -n "$FONT_BOLDITALIC" ]]; then
      mainfontopts+=";BoldItalicFont=${FONT_BOLDITALIC}"
    fi
  fi

  local pandoc_args=(
    "$SRC"
    --metadata-file "$METADATA_FILE"
    --pdf-engine "xelatex"
    --table-of-contents
    --toc-depth=3
    --top-level-division=chapter
    -V "papersize=$PAPERSIZE"
    -V "geometry:top=$GEOM_TOP"
    -V "geometry:bottom=$GEOM_BOTTOM"
    -V "geometry:left=$GEOM_LEFT"
    -V "geometry:right=$GEOM_RIGHT"
  )

  if [[ -n "$MAINFONT" ]]; then
    pandoc_args+=( -V "mainfont=$MAINFONT" )
  fi

  if [[ -n "$mainfontopts" ]]; then
    pandoc_args+=( -V "mainfontoptions=$mainfontopts" )
  fi

  if [[ -n "$GEOM_ORIENTATION_ARG" ]]; then
    pandoc_args+=( $GEOM_ORIENTATION_ARG )
  fi

  if [[ -f "$LATEX_TEMPLATE" ]]; then
    pandoc_args+=( --template "$LATEX_TEMPLATE" )
  fi

  pandoc_args+=( --output "$PDF_OUT" )

  pandoc "${pandoc_args[@]}"

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

if [[ ! -f "$METADATA_FILE" ]]; then
  echo "Error: metadata file '$METADATA_FILE' not found."
  usage
  exit 1
fi

build_pdf
