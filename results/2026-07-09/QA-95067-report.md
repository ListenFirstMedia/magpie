# QA-95067 — Brand Audience > LinkedIn - Followers By Country & Followers By Region tile Hovering Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** UCLA (account_id=799) · University of California, Los Angeles (brand_id=127756) · LinkedIn channel · Jul 2–8, 2026

## Verdict: PASS

## Known bugs checked — tolerated
- **APPS-58574** (Open) — LinkedIn card misalignment. Cosmetic; does not affect the hover functionality under test. Reproduced separately in QA-94977.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Followers By Country tile renders | datamaps world map (177 `datamaps-subunit` paths); US shaded dark red | PASS |
| A2 | Hover country → tooltip (country + value) | hovering US shows tooltip **"United States — Followers — 66%"** (share 66.32%) | PASS |
| A3 | Followers By Region tile renders | datamaps map with **bubble markers** (155 bubbles over the US); legend present | PASS |
| A4 | Hover region → tooltip (region + value) | hovering the largest bubble shows **"Los Angeles Metropolitan Area — Followers — 38%"** (share 38.46%) | PASS |
| A5 | APPS-58574 layout state captured | card misalignment reproduced (per QA-94977); does not affect hover | PASS (noted) |

## Method note
- The **Country** tile colors country subunits (data-info on each path; US fill #B10000, 66.32%).
- The **Region** tile plots regions as **bubbles** (`circle` markers), not colored subunits — each bubble carries `data-info` (name/share/lat/long). LA Metro = largest bubble, 38.46%.
- Tooltips fire on `mouseover` and render a `.datamaps-hoverover` element; verified both show name + "Followers" + rounded share. (Playwright's element-hover on the US path was intercepted by Canada's overlapping bbox — dispatched `mouseover` on the exact target instead.)

## Evidence
- `QA-95067-region-tile.png` (both maps side by side; Country tooltip "United States / Followers 66%" visible; Region bubbles over the US; "Geo Breakdown By Region — Los Angeles Metropolitan Area 38%" below)

## Bugs filed
None new.

## View state note
Account left on UCLA (799); switch back to Adam Orfei (54) for subsequent cases.
