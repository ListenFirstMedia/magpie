---
name: csv-export-capture
version: 1
last_verified: 2026-06-10
trust: untrusted
pass_streak: 3
preconditions: [browser-js-execution]
postconditions: [csv-content-captured-in-page]
related_pages: ["any LFM page with CSV/TSV/XLS export"]
---

# Capture CSV/TSV exports in-page (no Downloads-folder access needed)

LFM CSV exports are client-generated: blob via `URL.createObjectURL` + anchor `download` click. Hook both BEFORE clicking Export:

```javascript
window.__dl = [];
const oC = URL.createObjectURL.bind(URL);
URL.createObjectURL = function(b){
  try { if (b instanceof Blob) { const fr = new FileReader();
    fr.onload = () => window.__dl.push({type:'blob', size:b.size, text:String(fr.result)});
    fr.readAsText(b); } } catch(e){}
  return oC(b);
};
const ho = HTMLAnchorElement.prototype.click;
HTMLAnchorElement.prototype.click = function(){
  if (this.download) window.__dl.push({type:'anchor', name:this.download});
  return ho.apply(this, arguments);
};
```

Then click Export → CSV and read `window.__dl` (anchor entry = filename; blob entry = full file text). Re-install after every page navigation.

## Verified on
- Brand Insights tile CSV: `Michael Kors-Insights-Total Followers-2026-06-03-2026-06-09.csv` (`Brand-Tab-Tile-Start-End.csv` pattern; headers Brand Name/Channel/metric).
- TWC CSV: `Hulu - Time Window Comparison - Jun 3, 2026 - Jun 9, 2026.csv` (Perspective/Brand/Date/metrics; `Display Name,Key` appendix when Show Metrics on; no timestamp).
- Follower Demographics CSV: `Michael Kors - Followers-Demographics_MM-DD-YYYY.csv` (transposed Channel/Data Point matrix).

## Notes
- Google Sheets exports do NOT pass through this path (window.open instead).
- Avoid returning full URLs from javascript_tool (response gets blocked for query strings); slice/strip before stringifying.
