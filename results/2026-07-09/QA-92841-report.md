# QA-92841 — Reporting > Data Studio - Save Breakdown Table to Dashboard - PNG & Google Sheets Exports

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Priority:** Minor (P4)
- **Account:** Adam Orfei (account_id=54) · Data Studio · Brand MTV

## Verdict: BLOCKED-by-open-bugs (both automation blockers now RESOLVED; A2/A3 achievable, but A1/A5 governed by open bugs + A4 out of scope → case cannot fully PASS)

## 2026-07-10 re-run update
The two **automation** limitations that previously blocked A2/A3 are both resolved this session:
- **DS metric-tree selection** — now drivable (see QA-84194 re-run): the tree renders (138 checkboxes + "Search for a Metric"); metrics become selectable with **Window Mode = In-Window + View = Authorized** for Impressions/Video metrics; trusted click on the `.controlled-check-box__icon` toggles them; **Go** runs the report.
- **Save-to-Dashboard** — now drivable (see QA-88219 re-run): `[data-ui-name=save_to_dashboard]` → dropdown → "Create Dashboard" (or check an existing) saves the tile; verified end-to-end.

So **A2 (save breakdown tile to dashboard) and A3 (PNG of the breakdown table) are now achievable** via: DS Post Level → add brand → In-Window + Authorized → Select Metrics (a Video/Impressions metric) + a breakdown dimension → Go → Save to Dashboard → dashboard tile Export → PNG.
**However the case still cannot fully PASS:** **A1** probes open bug **LFMP-31814** (data-fetching popup missing) and **A5** probes open bug **LFMP-31936** (Authorized Video Views lock/endash inconsistency) — both expected to reproduce until fixed; **A4** (Google Sheets) is out of scope for this track. Recommend a focused manual pass for A2/A3 once LFMP-31814/31936 are addressed.

---
### (original 2026-07-09 verdict) BLOCKED (automation + open-bug probes + out-of-scope export)

## Known bugs checked — two OPEN, both probed by this case
- **LFMP-31814** (Open) — "DS Data fetching pop-up is not displayed." This is exactly **A1** ("Data fetching popup visible during Run"). The assertion probes a bug that is currently **open** → A1 is expected to fail (popup absent).
- **LFMP-31936** (Open) — "Authorized Video Views values not consistent (lock vs endash)." This is exactly **A5**. Open → A5 is expected to reproduce the inconsistency.

## Scope
- **A4 (Google Sheets export) is OUT OF SCOPE** for the Playwright MCP track (Google Sheets export was deliberately scoped out of this track). Not exercised.

## What happened
Switched the account back to **Adam Orfei** (it was on UCLA from QA-92735), opened Data Studio, and **added brand MTV** successfully. Building the report then blocked at **Select Metrics**: the DS metric-tree modal would not accept a metric selection via automation — the checkbox is an `i.controlled-check-box__icon[role=checkbox]` inside `span.controlled-check-box`; synthetic pointer+mouse event dispatch did **not** toggle it (`aria-checked` stayed false), and a trusted `browser_click` on the glyph/wrapper was rejected as "element is not visible" (the modal re-renders and an ancestor clips/hides the target). This is the **same DS-metric-tree automation limitation documented in QA-84194**. Without a selectable metric, the report cannot Run, so A1/A2/A3/A5 could not be reached.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Data-fetching popup visible during Run | probe for **open** LFMP-31814 (popup missing); also not reached (report not runnable) | BLOCKED / open-bug probe |
| A2 | Breakdown table tile saves to dashboard | not reached — metric selection blocked; save-to-dashboard also fragile (see QA-88219) | BLOCKED |
| A3 | PNG renders the breakdown table | not reached (depends on A2) | BLOCKED |
| A4 | Google Sheets export matches on-screen | **out of scope** for this track | N/A |
| A5 | Authorized Video Views column consistent (lock vs endash) | probe for **open** LFMP-31936 (inconsistent); not reached | BLOCKED / open-bug probe |

## Why not a product FAIL
No product defect was introduced or newly observed — the two behaviors the case checks (A1, A5) are already tracked as **open** bugs (expected to reproduce), the Google Sheets half is out of scope, and the remaining functional path is blocked by two known automation limitations (DS metric-tree selection + Save-to-Dashboard driving), not by a product problem.

## Recommended manual re-test
Once LFMP-31814 and LFMP-31936 are addressed: build a DS Post Level report (MTV/Disney Channel, Video metrics, Content-Type or Channel breakdown), Run (confirm A1 popup), Save to Dashboard (A2), then from the dashboard tile Export → PNG (A3). Google Sheets (A4) remains out of the automated track. Cross-refs: **QA-84194** (DS metric-tree fragility), **QA-88219** (Save-to-Dashboard fragility).

## Bugs filed
None new.
