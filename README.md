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
- `scripts/export.sh`: export script with mode-based PDF/HTML workflows
- `Makefile`: short commands for day-to-day use
- `dist/`: generated output

## Requirements

Only one required dependency:

- [Pandoc](https://pandoc.org/installing.html)

Default PDF engine (recommended for stable report pagination):

- LaTeX engine via Pandoc (`xelatex` preferred, `lualatex` fallback)

Optional dependency for CSS-based PDF export:

- [WeasyPrint](https://weasyprint.org/)
- Chrome/Chromium (headless print mode)

## macOS Setup

- Install Pandoc: brew install pandoc
- Install LaTeX engine for default PDF mode: brew install --cask mactex-no-gui
- Optional CSS PDF mode: brew install weasyprint

## Quick Start

1. Edit `report.md`.
2. Export PDF (default, LaTeX mode):

```bash
make
```

3. Export PDF using CSS mode (optional):

```bash
make pdf-css
```

4. Export HTML only (optional):

```bash
make html
```

5. Switch paper format and orientation:

```bash
FORMAT=A3L make       # A3 landscape PDF
FORMAT=A5P make       # A5 portrait PDF
FORMAT=A1L make html  # A1 landscape HTML preview
```

Supported values: `A1` to `A6` with optional `P` (portrait) or `L` (landscape).
Examples: `A4` (default portrait), `A4L`, `A2P`.

Output files:

- `dist/report.pdf`
- `dist/report.html` (only in HTML/CSS mode)

## Content Rules (Swiss Spirit)

- Keep section titles short and informative.
- Prefer one idea per paragraph.
- Use lists for decisions and actions.
- Use one accent color sparingly.
- Avoid decorative elements that do not carry meaning.
- Remove any section that does not support a decision, explanation, or evidence.

## Customization

Adjust tokens in `styles/swiss-report.css`:

- `--accent` for brand color
- `--content-w` for active format content width
- `--s1` to `--s8` for spacing scale
- `--t-body` to `--t-h1` for type scale
- `--measure` for readable line length

## Practical Checklist Before Export

- Does every section answer a real user question?
- Is the heading hierarchy unambiguous (H1 > H2 > H3)?
- Is accent color used only for meaningful emphasis?
- Can the page be scanned in under 20 seconds?
- Does print preview remain readable in the selected A-format?

## Notes

Set a custom LaTeX font at runtime if needed:

```bash
MAINFONT="Helvetica Neue" make pdf
```

If LaTeX is unavailable, use CSS mode with WeasyPrint:

```bash
make pdf-css
```
