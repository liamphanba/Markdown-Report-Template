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

- XeLaTeX via MacTeX only

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
