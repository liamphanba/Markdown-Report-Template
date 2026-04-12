# Swiss Report Color Palette

This palette follows a restrained Swiss system: neutral base, one functional accent, and high readability.

## Palette Swatches

<table>
  <thead>
    <tr>
      <th>Token</th>
      <th>Hex</th>
      <th>Role</th>
      <th>Swatch</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>--paper</code></td>
      <td><code>#FCFCF9</code></td>
      <td>Page background</td>
      <td><div style="width:120px;height:28px;border:1px solid #bbb;background:#FCFCF9;"></div></td>
    </tr>
    <tr>
      <td><code>--ink</code></td>
      <td><code>#111111</code></td>
      <td>Primary text</td>
      <td><div style="width:120px;height:28px;border:1px solid #bbb;background:#111111;"></div></td>
    </tr>
    <tr>
      <td><code>--muted</code></td>
      <td><code>#565656</code></td>
      <td>Secondary text</td>
      <td><div style="width:120px;height:28px;border:1px solid #bbb;background:#565656;"></div></td>
    </tr>
    <tr>
      <td><code>--line</code></td>
      <td><code>#D6D6D2</code></td>
      <td>Rules, table borders</td>
      <td><div style="width:120px;height:28px;border:1px solid #bbb;background:#D6D6D2;"></div></td>
    </tr>
    <tr>
      <td><code>--accent</code></td>
      <td><code>#C9261C</code></td>
      <td>Highlights, callouts</td>
      <td><div style="width:120px;height:28px;border:1px solid #bbb;background:#C9261C;"></div></td>
    </tr>
  </tbody>
</table>

## Contrast Checks (WCAG)

Standard thresholds:

- Normal text AA: >= 4.5:1
- Large text AA (>= 18pt or 14pt bold): >= 3:1
- Non-text UI/boundaries: >= 3:1

| Pair | Ratio | Use | Result |
|---|---:|---|---|
| Ink on Paper | 18.37:1 | Body text | Pass AA/AAA |
| Muted on Paper | 7.14:1 | Secondary text | Pass AA/AAA |
| Accent on Paper | 5.41:1 | Emphasis text/links | Pass AA |
| White on Accent | 5.56:1 | Reverse text on accent blocks | Pass AA |
| Ink on Accent | 3.40:1 | Dark text on accent fill | Only large text |
| Line on Paper | 1.42:1 | Decorative separators only | Not for text/UI contrast |

## Practical UI Rules

- Use `--ink` for all long-form body text.
- Use `--muted` only for metadata, captions, and low-priority labels.
- Use `--accent` sparingly for links, key figures, and quote bars.
- Never use `--line` for text.
- If using filled accent components, set text to white.

## Markdown Example

```markdown
# Project Report

Primary paragraph text uses ink color by default.

<div style="color:#565656;">Meta note in muted text.</div>

<div style="padding:8px 12px;background:#C9261C;color:#FFFFFF;display:inline-block;">
  Accent callout with accessible reverse text
</div>
```

## CSS Token Source

These values match the tokens in [styles/swiss-report.css](styles/swiss-report.css).
