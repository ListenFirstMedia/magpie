# QA-103246 — Brand > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Window:** Jun 1–15 2026
- **Post:** MTV IG Reel, Jun 02 2026
- **Skills:** daily-post-analysis-modal, export-google-sheets, png-export-verify
- **Result:** ✅ PASS

## Steps
1. Brand > Content for MTV → post #1 **Daily Analysis** → DPA modal (5-metric line chart).
2. **Export ▾** → menu shows **PNG / CSV / Google Sheets**.
3. **PNG** → an anchor with a **`blob:https://app.lfmdev.in/…` href** was created and clicked (captured via anchor hook) → PNG download fired (blob revoked post-download, per normal).
4. **Google Sheets** → new tab **"MTV-Jun 02 2026-05-20 AM PDT-Instagram-Daily Content Analysis-2026-06-02-2026-06-15 - Google Sheets"** (`docs.google.com/spreadsheets/d/1zaJQ6…`).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Export menu offers PNG + GS | DPA modal Export has PNG & Google Sheets | **PNG / CSV / Google Sheets** present | ✅ |
| PNG export | PNG file produced | `blob:` PNG anchor download fired (blob URL captured) | ✅ |
| Google Sheets export | GS opens with DPA filename | GS tab opened, filename = **…-Daily Content Analysis-2026-06-02-2026-06-15** | ✅ |

## Notes / automation learning
- DPA modal **PNG export downloads a real `blob:` PNG via an anchor** (the chart-image lib caches `URL.createObjectURL` at bundle init, so the `createObjectURL` hook misses the Blob object; hooking `HTMLAnchorElement.prototype.click`/`dispatchEvent` captures the `blob:` href instead). The blob is revoked immediately after download, so post-hoc `fetch` fails — capture of the href at click time is the evidence.
- GS export filename schema for the DPA modal: **`<Brand>-<PostDate>-<Channel>-Daily Content Analysis-<from>-<to>`**.

## Cleanup
- GS tab closed. No mutation.

## Bugs filed
_None._
