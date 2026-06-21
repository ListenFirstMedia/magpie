# QA-94977 — Brand > Audience - LinkedIn - Metric Export Functionality — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** University of California, Los Angeles (brand_id 127756) · **Channel:** LinkedIn
- **Skills:** audience-metrics-export, export-google-sheets
- **Result:** ✅ PASS

## Steps
1. Brand > Audience for **UCLA** (switched via brand picker Recent Searches), channel **LinkedIn**.
2. Top-right **Export ▾** → **CSV / Google Sheets / Metrics**.
3. Clicked **Metrics** → a Google Sheet opened titled **"Brand-Audience-Metrics"** (`docs.google.com/spreadsheets/d/1g4kj9UDx_G…`), captured via the `window.open` hook.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Metric export option present | Audience Export offers Metrics | CSV / Google Sheets / **Metrics** present | ✅ |
| Metric export produces catalog | "Brand-Audience-Metrics" sheet/catalog | GS tab **"Brand-Audience-Metrics"** opened | ✅ |

## Notes / automation learning
- The Audience **Metrics** export is the metadata catalog (Display Name + Key per metric) and **does not depend on tile data** — so it succeeds even though UCLA's LinkedIn demographic tiles have no data this window. Filename pattern **"Brand-Audience-Metrics"** matches the `audience-metrics-export` skill.

## Cleanup
- GS tab closed. No mutation.

## Bugs filed
_None._
