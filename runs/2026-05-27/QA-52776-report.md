# QA-52776 — Brand Definition Update - Exclude URL Manager (deferred)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-52776
- **Run date:** 2026-05-27
- **Env:** Dev Radaac (`https://radaac.lfmdev.in/`) — separate app
- **Result:** ⏸ **DEFERRED — multi-app xlsx download/upload/apply chain on Radaac is not feasible without dedicated download-capture tooling. Better suited for LFIQA hands-on.**

## Why deferred (not blocked)
The test is a 3-leg Radaac flow:
1. **Fetch** → download xlsx of Brand Definitions for brand_id 236
2. **Patch** → upload that xlsx → download new xlsx
3. **Apply** → upload patch xlsx → download applied xlsx

At each leg the assertion is: "the 'url managers' column is not displayed in the xlsx file" — meaning we need to:
- Capture each downloaded xlsx (3 separate downloads)
- Open each in Excel/LibreOffice
- Verify column header row does NOT contain `url managers`

Chrome MCP can trigger downloads but capturing the saved file content from automation is fragile. Per Rule 6 (`pdf-end-to-end-verification` skill philosophy), the right pattern is: LFIQA performs the downloads, uploads them via Cowork, then I run column inspection.

## Recommended next run

LFIQA: please walk through the Radaac flow manually and upload all 3 xlsx files (fetch / patch / apply). Once uploaded I can:

```bash
unzip -p file.xlsx xl/sharedStrings.xml | grep -ic 'url managers'  # should return 0
# OR
python3 -c "import openpyxl; wb=openpyxl.load_workbook('file.xlsx'); print([c.value for c in wb.active[1]])"
```

…and confirm `url managers` is absent from the header row of all 3.

## Assertion results
All 3 marked ⏸ DEFERRED.

## Bugs filed
None.
