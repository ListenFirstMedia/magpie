#!/usr/bin/env python3
"""Generate a self-contained HTML report for a magpie run from results/<date>/summary.json
plus the per-case markdown reports. Published per-build via publishHTML in the Jenkinsfile.

magpie doesn't run `playwright test`, so there's no native Playwright HTML report — this is
the equivalent: a browsable summary + each case's full report, color-coded by verdict.

Usage: gen_report.py <summary.json> <out.html> [label] [build_url]
"""
import html, json, os, sys

BADGE = {"PASS": "#1a7f37", "FAIL": "#cf222e", "BLOCKED": "#bc4c00",
         "TIMEOUT": "#9a6700", "SKIPPED": "#6e7781", "UNKNOWN": "#6e7781"}

# Shown in place of the report body when a case produced no report file at all.
NO_REPORT = ("(no report file — the case produced no verdict. It was killed at the CASE_TIMEOUT cap "
             "or crashed before writing its report; see the run's _batch-*.log for its console "
             "output. Re-run the case, raising CASE_TIMEOUT if it was a timeout.)")

def esc(s): return html.escape(str(s or ""))

def main():
    summary_path, out_path = sys.argv[1], sys.argv[2]
    label = sys.argv[3] if len(sys.argv) > 3 else "run"
    build_url = sys.argv[4] if len(sys.argv) > 4 else ""
    s = json.load(open(summary_path))
    cases = s.get("cases", [])
    base = os.path.dirname(summary_path)

    rows, blocks = [], []
    for c in cases:
        cid, status = c.get("id", "?"), c.get("status", "UNKNOWN")
        color = BADGE.get(status, "#6e7781")
        jira = f"https://listenfirstmedia.atlassian.net/browse/{cid}"
        # title = first "# ..." line of the case report, if the report exists
        title, body = "", NO_REPORT
        rp = c.get("report", "")
        path = rp if os.path.isabs(rp) else os.path.join(os.getcwd(), rp)
        if rp and os.path.isfile(path):
            body = open(path, encoding="utf-8", errors="ignore").read()
            for ln in body.splitlines():
                if ln.startswith("# "):
                    title = ln[2:].strip(); break
        badge = f'<span style="background:{color};color:#fff;padding:2px 8px;border-radius:10px;font-size:12px">{esc(status)}</span>'
        rows.append(f'<tr><td><a href="{jira}">{esc(cid)}</a></td><td>{badge}</td><td>{esc(title)}</td></tr>')
        blocks.append(f'<details><summary>{esc(cid)} — {esc(status)} — {esc(title)}</summary>'
                      f'<pre>{esc(body)}</pre></details>')

    total = s.get("total", len(cases))
    p, f, b, k = (s.get("passed",0), s.get("failed",0), s.get("blocked",0), s.get("skipped",0))
    t = s.get("timeout", 0)
    run = s.get("run", len(cases))
    rate = f"{(100*p/run):.0f}%" if run else "—"
    build_link = f'<a href="{esc(build_url)}">build</a>' if build_url else ""
    doc = f"""<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>magpie report — {esc(label)} {esc(s.get('date',''))}</title>
<style>
 body{{font:14px/1.5 -apple-system,Segoe UI,Roboto,sans-serif;margin:24px;color:#1f2328}}
 h1{{font-size:20px;margin:0 0 4px}} .meta{{color:#6e7781;margin-bottom:16px}}
 .cards{{display:flex;gap:10px;flex-wrap:wrap;margin:12px 0 20px}}
 .card{{border:1px solid #d0d7de;border-radius:8px;padding:8px 14px;min-width:70px}}
 .card b{{display:block;font-size:20px}}
 table{{border-collapse:collapse;width:100%;margin-bottom:24px}}
 th,td{{text-align:left;padding:6px 10px;border-bottom:1px solid #eaeef2}}
 th{{color:#6e7781;font-weight:600;font-size:12px;text-transform:uppercase}}
 details{{border:1px solid #d0d7de;border-radius:8px;margin:6px 0;padding:6px 12px}}
 summary{{cursor:pointer;font-weight:600}}
 pre{{white-space:pre-wrap;word-wrap:break-word;background:#f6f8fa;padding:12px;border-radius:6px;overflow:auto}}
</style></head><body>
<h1>magpie regression — {esc(label)}</h1>
<div class="meta">{esc(s.get('date',''))} · {build_link} · pass rate {rate}</div>
<div class="cards">
 <div class="card">Total<b>{total}</b></div>
 <div class="card" style="color:#1a7f37">PASS<b>{p}</b></div>
 <div class="card" style="color:#cf222e">FAIL<b>{f}</b></div>
 <div class="card" style="color:#bc4c00">BLOCKED<b>{b}</b></div>
 <div class="card" style="color:#9a6700">TIMEOUT<b>{t}</b></div>
 <div class="card" style="color:#6e7781">SKIPPED<b>{k}</b></div>
</div>
<table><thead><tr><th>Case</th><th>Verdict</th><th>Title</th></tr></thead>
<tbody>{''.join(rows)}</tbody></table>
<h2>Reports</h2>
{''.join(blocks)}
</body></html>"""
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(doc)
    print(f">> wrote {out_path} ({len(cases)} cases)")

if __name__ == "__main__":
    main()
