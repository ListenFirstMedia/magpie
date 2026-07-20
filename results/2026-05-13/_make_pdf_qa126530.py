"""
Renders report.md → report.pdf with WeasyPrint, applying a clean stylesheet.
Run from the runs/<date>/ directory.
"""
from __future__ import annotations

import sys
from pathlib import Path

import markdown
from weasyprint import HTML, CSS

HERE = Path(__file__).parent
SRC = HERE / "QA-126530-report.md"
OUT = HERE / "QA-126530-report.pdf"

CSS_TEXT = """
@page {
  size: Letter;
  margin: 0.6in 0.6in 0.7in 0.6in;
  @bottom-center {
    content: "LF-Regression — QA-126530 Run 2026-05-13   ·   Page " counter(page) " of " counter(pages);
    font-family: -apple-system, "Helvetica Neue", Helvetica, sans-serif;
    font-size: 9pt;
    color: #888;
  }
}

* { box-sizing: border-box; }

body {
  font-family: -apple-system, "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 10.5pt;
  line-height: 1.55;
  color: #1a1a1a;
  margin: 0;
}

h1 {
  font-size: 22pt;
  font-weight: 700;
  color: #111;
  margin: 0 0 6pt 0;
  padding-bottom: 6pt;
  border-bottom: 2pt solid #111;
  page-break-after: avoid;
}

h2 {
  font-size: 14pt;
  font-weight: 700;
  color: #111;
  margin: 18pt 0 6pt 0;
  padding-top: 4pt;
  border-top: 1pt solid #ddd;
  page-break-after: avoid;
}

h3 {
  font-size: 12pt;
  font-weight: 700;
  color: #222;
  margin: 12pt 0 4pt 0;
  page-break-after: avoid;
}

h4 {
  font-size: 11pt;
  font-weight: 700;
  color: #333;
  margin: 10pt 0 4pt 0;
  page-break-after: avoid;
}

p { margin: 4pt 0 6pt 0; }

ul, ol { margin: 4pt 0 8pt 22pt; padding: 0; }
li { margin: 1pt 0; }

blockquote {
  border-left: 3pt solid #ccc;
  margin: 8pt 0;
  padding: 4pt 10pt;
  color: #444;
  background: #f6f6f6;
  font-size: 10pt;
}

code {
  font-family: "SF Mono", "Menlo", "Consolas", monospace;
  font-size: 9pt;
  background: #f0f0f0;
  padding: 1pt 4pt;
  border-radius: 3pt;
  border: 0.5pt solid #e0e0e0;
}

pre {
  font-family: "SF Mono", "Menlo", "Consolas", monospace;
  font-size: 8.5pt;
  background: #f8f8f8;
  border: 0.5pt solid #ddd;
  border-radius: 4pt;
  padding: 8pt 10pt;
  margin: 6pt 0;
  overflow-x: auto;
  page-break-inside: avoid;
  line-height: 1.4;
}
pre code {
  background: none;
  padding: 0;
  border: none;
  border-radius: 0;
}

hr {
  border: 0;
  border-top: 1pt solid #ddd;
  margin: 14pt 0;
}

table {
  border-collapse: collapse;
  width: 100%;
  margin: 6pt 0 10pt 0;
  font-size: 9.5pt;
  page-break-inside: avoid;
}

th, td {
  border: 0.5pt solid #ccc;
  padding: 4pt 7pt;
  vertical-align: top;
  text-align: left;
}

th {
  background: #f0f0f0;
  font-weight: 700;
  color: #111;
}

tr:nth-child(even) td { background: #fafafa; }

a {
  color: #0a58ca;
  text-decoration: none;
}

/* Status emoji highlights */
.passed { color: #198754; font-weight: 700; }
.failed { color: #dc3545; font-weight: 700; }
.info { color: #6c757d; font-weight: 700; }

/* Title block */
header-block {
  background: linear-gradient(180deg, #fafafa 0%, #ffffff 100%);
  padding: 6pt 0;
}
"""

def main() -> int:
    if not SRC.exists():
        print(f"ERROR: {SRC} not found", file=sys.stderr)
        return 1

    md_text = SRC.read_text(encoding="utf-8")

    html_body = markdown.markdown(
        md_text,
        extensions=[
            "extra",          # tables, fenced_code, etc.
            "sane_lists",
            "toc",
            "admonition",
        ],
        output_format="html5",
    )

    html_doc = f"""<!doctype html>
<html>
<head><meta charset="utf-8"><title>LF-Regression QA-126530 Run 2026-05-13</title></head>
<body>{html_body}</body>
</html>"""

    HTML(string=html_doc, base_url=str(HERE)).write_pdf(
        str(OUT),
        stylesheets=[CSS(string=CSS_TEXT)],
    )

    print(f"OK: wrote {OUT} ({OUT.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
