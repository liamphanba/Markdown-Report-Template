# Swiss Markdown Report Template

Minimalist, strict-grid report template inspired by Swiss design principles.

## Design Goals

- Neutral typography with Helvetica-first stack
- Strong hierarchy with consistent baseline rhythm
- High contrast and restrained palette
- Print-safe A4 defaults
- Minimal dependencies and simple export flow

## Repository Layout

- `report.md`: write your report content here
- `styles/swiss-report.css`: visual system for web and print
- `scripts/export.sh`: export script (HTML always, PDF optional)
- `Makefile`: short commands for day-to-day use
- `dist/`: generated output

## Requirements

Only one required dependency:

- [Pandoc](https://pandoc.org/installing.html)

Optional dependency for direct PDF export from command line:

- [WeasyPrint](https://weasyprint.org/)
- Chrome/Chromium (headless print mode)

## Quick Start

1. Edit `report.md`.
2. Export HTML:

```bash
make html
```

3. Export PDF (if a PDF engine is available):

```bash
make pdf
```

Output files:

- `dist/report.html`
- `dist/report.pdf` (if PDF engine available)

## Content Rules (Swiss Spirit)

- Keep section titles short and informative.
- Prefer one idea per paragraph.
- Use lists for decisions and actions.
- Use one accent color sparingly.
- Avoid decorative elements that do not carry meaning.

## Customization

Adjust tokens in `styles/swiss-report.css`:

- `--accent` for brand color
- `--max-width` for text measure
- `--baseline` for vertical rhythm

## Notes

If command-line PDF export is unavailable, open `dist/report.html` in your browser and use Print > Save as PDF.
