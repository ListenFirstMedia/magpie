---
name: audience-metrics-export
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 0
preconditions: [user-logged-in, account-set, brand-set]
postconditions: [metrics-file-downloaded]
inputs: [brand_id, channel, date_from, date_to]
outputs: [downloaded_filename, downloaded_content_excerpt]
related_pages: ["/#explore/brand/audience"]
---

# Export Metrics from Brand > Audience

The Audience tab's `Export → Metrics` option produces a small metadata catalog (Display Name + Key per metric) rather than the data itself. Filename pattern observed in test cases: `Brand-Audience-Metrics`.

## Steps

### Step 1 — Navigate to Brand > Audience for the target brand
- Direct URL works: `https://app.lfmdev.in/#explore/brand/audience?brand_id={brand_id}&account_id={account_id}&from={YYYY-MM-DD}&to={YYYY-MM-DD}&channels={channel}&perspective=extended`
- **Caveat:** the URL `channels=X` param does NOT override the visible UI toggle state — you must also click the channel ghost(s) AND the `Apply` button to actually scope the data to that channel.

### Step 2 — Select only the desired channel(s)
- The channel ghost row is below the sub-tab navigation. Each ghost (`.channel-ghost`) has classes like `facebook channel-ghost enabled` or `threads channel-ghost disabled`.
- Programmatic `.click()` does NOT toggle them — use real coordinate clicks (Chrome MCP `computer left_click coordinate=[x,y]`).
- Coordinates observed for the channel row at default zoom: Facebook (179, 317), X (208, 317), Instagram (238, 317), YouTube (268, 317), LinkedIn (299, 317), Threads (329, 317).
- After toggling, click `Apply` (around coord 377, 317) to commit and reload data.

### Step 3 — Click Export → Metrics
- Find the `Export` button at top right of the channel row.
- Open the dropdown; options include `CSV`, `Google Sheets`, `Metrics`.
- Click `Metrics`.

### Step 4 — Verify the download

**⚠ Important automation limitation observed during QA-110071:** the Metrics export does NOT route through `URL.createObjectURL` + anchor download, nor does it call `window.open`, nor does it submit a form. Standard blob-interception hooks return zero captures. The click fires telemetry (Mixpanel) but no direct evidence of a download is visible to in-page JS hooks.

Workarounds:
- **Ask the user** to check their Downloads folder for the file (this is the current accepted path).
- **Install a fetch hook** before clicking that wraps `window.fetch` and inspects responses with `content-disposition: attachment`. (Not yet validated — try in a future run.)
- **Use Chrome MCP's `read_network_requests`** with broad filters AFTER the click to catch any backend export endpoint.

## Assertions for cases that use this skill

For QA-110071 specifically:
- Filename should be `Brand-Audience-Metrics` (plus an extension if any).
- Export contains columns `Display Name` and `Key`.

Since the file isn't captured automatically yet, both assertions are currently delivered as "deferred to manual Downloads-folder verification" in the run report.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `Apply` button stays disabled after channel toggle | UI didn't register the change | re-click the channel ghost; verify class change |
| Export dropdown is greyed out | No data loaded yet | wait longer for the page to populate after Apply |
| No file in Downloads after Metrics click | Either silent failure or the export is using a path my hooks miss | report; check console for errors |

## Changelog
- **v1** (2026-05-13): Initial draft from QA-110071. Steps captured; the download-capture problem documented as the primary friction point.
