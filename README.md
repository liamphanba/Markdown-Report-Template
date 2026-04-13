# Swiss Markdown Report Template

Minimalist, strict-grid report template inspired by Swiss design principles.

## Design Goals

- Neutral typography with Helvetica-first stack
- Strong hierarchy with consistent baseline rhythm
- High contrast and restrained palette
- Print-safe A-format defaults (A1 to A6)
- Minimal dependencies and simple export flow

## Swiss Principles Embedded

- Grid systems: constrained structure with optional 12-column utility classes
- Typography: one main sans-serif family and a strict type scale
- White space: fixed spacing scale (4/8 system) for rhythm and calm
- Objectivity: decorative elements are minimized and content stays primary
- Reduction: one accent color, minimal visual noise, no unnecessary UI artifacts
- Clarity: hierarchy and spacing are designed for fast scanning and comprehension

## Repository Layout

- `pandoc-pdf-render-parameters.yaml`: all metadata, cover content, colors, and style tokens
- `report.md`: write your report content here
- `templates/pandoc-xelatex-pdf-render-template.tex`: single Pandoc+LaTeX template for PDF styling
- `scripts/export.sh`: PDF export script (Pandoc + XeLaTeX)
- `Makefile`: short commands for day-to-day use
- `dist/`: generated output

## Requirements

Only one required dependency:

- [Pandoc](https://pandoc.org/installing.html)

PDF engine:

- XeLaTeX only

## macOS Setup

- Install Pandoc: brew install pandoc
- Install MacTeX (provides xelatex): brew install --cask mactex-no-gui

## Quick Start

1. Edit `pandoc-pdf-render-parameters.yaml` for title, covers, fonts, colors, and style.
2. Edit `report.md` for report content.
3. Export PDF:

```bash
make
```

4. Switch paper format and orientation:

```bash
FORMAT=A3L make       # A3 landscape PDF
FORMAT=A5P make       # A5 portrait PDF
FORMAT=A1L make       # A1 landscape PDF
```

Supported values: `A1` to `A6` with optional `P` (portrait) or `L` (landscape).
Examples: `A4` (default portrait), `A4L`, `A2P`.

Output file:

- `dist/report.pdf`

## Content Rules (Swiss Spirit)

- Keep section titles short and informative.
- Prefer one idea per paragraph.
- Use lists for decisions and actions.
- Use one accent color sparingly.
- Avoid decorative elements that do not carry meaning.
- Remove any section that does not support a decision, explanation, or evidence.

## Customization

All user-facing customization is centralized in `pandoc-pdf-render-parameters.yaml`. No LaTeX edits are required.

### Typography

```yaml
mainfont: "Helvetica Neue"        # any font name recognised by XeLaTeX/fontspec

# Math font — use any unicode-math compatible OTF in your TeX distribution
header-includes:
  - \setmathfont{texgyretermes-math.otf}
```

Override `mainfont` at build time without editing the file:

```bash
MAINFONT="Inter" make
MAINFONT="Times New Roman" make
```

Use local font files that are not system-installed:

```bash
MAINFONT="AvenirNext" \
FONT_PATH="/absolute/path/to/fonts" \
FONT_EXTENSION=.otf \
FONT_UPRIGHT="*-Regular" \
FONT_BOLD="*-Bold" \
FONT_ITALIC="*-Italic" \
FONT_BOLDITALIC="*-BoldItalic" \
make
```

### Colours

Set hex values (no leading `#`) in `pandoc-pdf-render-parameters.yaml`:

```yaml
pdf_body_text_color_hex: "111111"                  # body text, footer page number
pdf_secondary_text_color_hex: "545454"             # blockquotes and secondary text
pdf_heading_text_color_hex: "1A1A2E"               # h1-h4
pdf_front_cover_background_color_hex: "111111"     # front cover background
pdf_front_cover_text_color_hex: "FFFFFF"           # front cover text
pdf_back_cover_background_color_hex: "D9D9D9"      # back cover background
```

All color keys are explicit render parameters and should be set directly.

`pandoc-pdf-render-parameters.yaml` is also where front and back cover content lives:

```yaml
pdf_front_cover_title_text: 2026 Annual Financial Report
pdf_front_cover_subtitle_text: Nexora Technologies Group — Full Year & Quarterly Review
pdf_front_cover_author_text: Group Finance & Investor Relations
pdf_front_cover_date_text: 2026-12-31

pdf_back_cover_title_text: ""
pdf_back_cover_subtitle_text: ""
pdf_back_cover_author_text: Nexora Technologies Group — Full Year & Quarterly Review
pdf_back_cover_date_text: Group Finance & Investor Relations
```

Style tokens are in the same file too:

```yaml
pdf_footer_page_number_font_size_command: "\\normalsize"
pdf_footer_vertical_offset: "100pt"
pdf_footer_chapter_opening_page_number_font_size_command: "\\Large"
pdf_footer_chapter_opening_vertical_offset: "90pt"

pdf_heading_level_1_font_size: "40pt"
pdf_heading_level_1_line_height: "40pt"
pdf_heading_level_1_spacing_after: "24pt"

pdf_heading_level_2_font_size: "18pt"
pdf_heading_level_2_line_height: "22pt"
pdf_heading_level_2_spacing_before: "18pt"
pdf_heading_level_2_spacing_after: "10pt"

pdf_heading_level_3_font_size: "13pt"
pdf_heading_level_3_line_height: "16pt"
pdf_heading_level_3_spacing_before: "14pt"
pdf_heading_level_3_spacing_after: "8pt"

pdf_heading_level_4_font_size: "11pt"
pdf_heading_level_4_line_height: "13pt"
pdf_heading_level_4_spacing_before: "10pt"
pdf_heading_level_4_spacing_after: "8pt"

pdf_body_paragraph_spacing: "6pt plus 1pt minus 0.5pt"
```

Example brand override (navy + white covers, teal headings):

```yaml
pdf_body_text_color_hex: "0D1B2A"
pdf_heading_text_color_hex: "0A7EA4"
pdf_front_cover_background_color_hex: "0D1B2A"
pdf_front_cover_text_color_hex: "FFFFFF"
pdf_back_cover_background_color_hex: "E8F4F8"
```

## Practical Checklist Before Export

- Is the heading hierarchy unambiguous (H1 > H2 > H3)?
- Is accent color used only for meaningful emphasis?
- Can the page be scanned in under 20 seconds?
- Does print preview remain readable in the selected A-format?

## Notes

This project is PDF-first.

- `make` and `make pdf` produce the same PDF output.
- All styling logic lives in `templates/pandoc-xelatex-pdf-render-template.tex`.
- `pandoc-pdf-render-parameters.yaml` is the only user-facing configuration file.
