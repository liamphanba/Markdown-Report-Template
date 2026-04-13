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

- `report.md`: write your report content here
- `styles/swiss-report.css`: visual system for web and print
- `scripts/export.sh`: XeLaTeX-only PDF export script
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

1. Edit `report.md`.
2. Export PDF (default, LaTeX mode):

```bash
make
```

3. Switch paper format and orientation:

```bash
FORMAT=A3L make       # A3 landscape PDF
FORMAT=A5P make       # A5 portrait PDF
FORMAT=A1L make       # A1 landscape PDF
```

Supported values: `A1` to `A6` with optional `P` (portrait) or `L` (landscape).
Examples: `A4` (default portrait), `A4L`, `A2P`.

Output files:

- `dist/report.pdf`

## Content Rules (Swiss Spirit)

- Keep section titles short and informative.
- Prefer one idea per paragraph.
- Use lists for decisions and actions.
- Use one accent color sparingly.
- Avoid decorative elements that do not carry meaning.
- Remove any section that does not support a decision, explanation, or evidence.

## Customization

All visual settings are controlled from the YAML front matter in `report.md`. No LaTeX knowledge needed.

### Typography

```yaml
mainfont: "Helvetica Neue"        # any font name recognised by XeLaTeX/fontspec

# Math font — use any unicode-math compatible OTF in your TeX distribution
header-includes:
  - \setmathfont{TeX Gyre Termes Math}
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

Set hex values (no leading `#`) in `report.md` YAML:

```yaml
color-ink:      "111111"   # body text, footer page number
color-muted:    "545454"   # blockquotes and secondary text
color-heading:  "1A1A2E"   # h1–h4 (omit to inherit color-ink)
color-front-bg: "111111"   # front cover background
color-front-fg: "FFFFFF"   # front cover text
color-back-bg:  "D9D9D9"   # back cover background
```

All colour keys are optional — defaults match the above values.

Example brand override (navy + white covers, teal headings):

```yaml
color-ink:      "0D1B2A"
color-heading:  "0A7EA4"
color-front-bg: "0D1B2A"
color-front-fg: "FFFFFF"
color-back-bg:  "E8F4F8"
```

## Practical Checklist Before Export

- Does every section answer a real user question?
- Is the heading hierarchy unambiguous (H1 > H2 > H3)?
- Is accent color used only for meaningful emphasis?
- Can the page be scanned in under 20 seconds?
- Does print preview remain readable in the selected A-format?
