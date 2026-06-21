# QA-19486 — Reporting - Social Recap - Verify PDF Download — 2026-06-13

- **Env:** Dev (app-reporting.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Data Last Updated (PT):** 06-16-2026 09:26 AM
- **Story:** 154798 — MTV / Weekly Social Recap (Jun 9–15, 2026)
- **Skills:** social-recap-run, pdf-download-verify (blob)
- **Result:** ✅ PASS — consistent with prior

## Steps
1. Reporting → Social Recap builder (`#/social_recap`).
2. Added brand **MTV** (Rule 1 — ref-based focus click on "Search for a Brand", backspace+retype to trigger Results, picked exact "MTV" not a regional variant).
3. Default Weekly interval, date range Jun 9–15 2026. **Run Report** → story 154798 built ("Building Your Story" → full render).
4. Story rendered: Social Footprint – All-Time (104,735,976 Total Fans; FB 45,500,229 / IG 21,128,640 / X 15,807,107 / YT 11,500,000 / TikTok 10,800,000), Social Activity June 9–15 gauges.
5. Installed `URL.createObjectURL` blob hook (Rule 6 — observe the actual file).
6. **Preview & Share Report** → top-right **Download** → captured the generated blob.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Report builds | Social Recap story renders for selected brand/window | Story 154798 rendered fully (footprint + activity sections) | ✅ |
| PDF downloads | A valid PDF file is produced | blob captured: `application/pdf`, **2,157,712 bytes** | ✅ |
| PDF integrity | Valid PDF header + multi-page | header **`%PDF-1.3`**, **pageCount = 2** | ✅ |

## Notes / automation learning
- Social Recap brand typeahead uses the **same ref-focus-click + backspace/retype** trick as TWC/DS (coordinate typing alone leaves the field unfocused → no Results). Reused successfully.
- Blob-hook verification (override `URL.createObjectURL`, then `arrayBuffer()` → `%PDF` header + `/Type /Page` count) is the reliable Rule-6 path for jsPDF downloads here, since `~/Downloads` isn't mounted.

## Bugs filed
_None._
