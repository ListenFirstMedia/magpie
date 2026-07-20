# QA-52778 — Brand definition update - Include URL Manager

- **Verdict:** **PASS** (7/7 assertions)
- **Run:** 2026-07-11, unattended headless (Playwright MCP, `feature/playwright-mcp`)
- **Component:** Radaac (`radaac.lfmdev.in`) — Brand Definitions Fetch / Patch / Apply trio
- **Brand under test:** Brand ID **236** = **Family Guy** (subscriber tenant strings intact)
- **Skill reused:** [`radaac-report`](../../skills/radaac-report/SKILL.md) v2 (Brand Definitions trio)
- **Login:** Radaac separate-OAuth "With existing account" form, `lfiqa@listenfirstmedia.com`

This is the **Include** variant (checkbox **checked** on all three reports → the `url_managers`
column must be present **and populated**). It is the inverse of QA-52776 (Exclude URL Manager).

## Known bugs checked (step 2 / step 5)

- **Jira issue-links / case "## Open linked bugs":** the ingested case file has no open-bugs section;
  `knowledge-base/bug-history.md` QA-52778 entry lists **Open bugs (0) — None.** Rule 7 screen **passed**.
- **BC-5 (`Include URL Managers` produced empty `url_managers` column):** **RETRACTED 2026-06-05** as a
  false positive. Root cause was a Chrome-MCP-era workaround: the sub-agent could not click the Radaac
  jQuery-UI Submit and fell back to a raw-URL GET (`…?include_url_mgrs=on`), which the backend does
  **not** honor without the form's session state. **This run drove the real trusted Submit button**
  (per the 2026-06-28 Playwright Radaac quirk — trusted `browser_click` submits correctly), so the flag
  was honored and `url_managers` came back **populated** on all three reports. BC-5 did **not** reproduce.
- **Cache-file race (accepted quirk):** the `/cache/<name>.xlsx` link served the
  `text/html` "File is Ready shortly" placeholder on first fetch; re-fetching after a short wait
  returned the real `application/octet-stream` xlsx. Not a product bug.
- **On-disk slugification (accepted quirk):** server filenames use `_<hash>`; the local saved path
  rewrites to `-<hash>`. Assertions taken against the server-emitted name (download event / cache URL).

## Steps executed (all 17, in order)

| # | Step | Result |
|---|------|--------|
| 1 | Radaac → open **Brand Definitions (Fetch)** | Dialog opened |
| 2 | Enter `236` in **Brand IDs (csv)** | `brand_ids=236` set (visible form) |
| 3 | Check **Include URL Managers** | `include_url_mgrs` → checked |
| 4 | Click **Submit** | Navigated `…/brand_definition_report?…&brand_ids=236&include_url_mgrs=true` (trusted click, flag honored) |
| 5 | Open + save the Fetch xlsx | `20260711BrandDefinitionReport_ee2855.xlsx` (5,980 B, 41 cols) → saved `.playwright-out/QA-52778/fetch.xlsx` |
| 6 | Radaac Home | OK |
| 7 | Open **Brand Definitions (Patch)** | Dialog opened |
| 8 | Choose file → upload the saved Fetch xlsx | `fetch.xlsx` attached |
| 9 | Check **Include URL Managers** | checked |
| 10 | Click **Submit** | Navigated `…/patch_brand_definition_report` |
| 11 | Open the Patch xlsx | `20260711PatchBrandDefinitionReport_b4c3b4.xlsx` (7,416 B, 42 cols) → saved `.playwright-out/QA-52778/patch.xlsx` |
| 12 | Radaac Home | OK |
| 13 | Open **Brand Definitions (Apply)** | Dialog opened |
| 14 | Choose file → upload the Patch xlsx | `patch.xlsx` attached |
| 15 | Check **Include URL Managers** | checked |
| 16 | Click **Submit** | Navigated `…/apply_brand_definition_report` — **succeeded first try (no 502)** |
| 17 | Open the Apply xlsx | `20260711ApplyBrandDefinitionReport_9e85f3.xlsx` (7,418 B, 42 cols) → saved `.playwright-out/QA-52778/apply.xlsx` |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | Include URL Manager option unchecked by default | Fetch dialog `input[name=include_url_mgrs].checked === false` on open (also confirmed unchecked by default on the Patch and Apply dialogs) | **PASS** |
| A2 | 5 | `url managers` column displayed in Fetch CSV | Fetch xlsx col index **39** = `url_managers`, **populated** (`youtube|…|FX Networks + Hulu + Disney General Entertainment + Disney Ad Sales + Freeform`, plus instagram/facebook/twitter/tiktok/youtube entries) | **PASS** |
| A3 | 5 | `youtube_channel_company` displays after `youtube_channel_username` | Fetch xlsx col 25 = `youtube_channel_username`, col 26 = `youtube_channel_company` (adjacent, company after) | **PASS** |
| A4 | 11 | `url managers` column displayed in Patch CSV | Patch xlsx col index **40** = `url_managers`, populated (`record_type` prepended at col 0 = `INGESTED`; 42 cols) | **PASS** |
| A5 | 11 | `youtube_channel_company` displays after `youtube_channel_username` | Patch xlsx col 26 = `youtube_channel_username`, col 27 = `youtube_channel_company` (adjacent, company after) | **PASS** |
| A6 | 17 | `url managers` column displayed in Apply CSV | Apply xlsx col index **40** = `url_managers`, populated (same tenant strings; `record_type` = `INGESTED`; 42 cols) | **PASS** |
| A7 | 17 | `youtube_channel_company` displays after `youtube_channel_username` | Apply xlsx col 26 = `youtube_channel_username`, col 27 = `youtube_channel_company` (adjacent, company after) | **PASS** |

## Evidence

Downloaded artifacts (verified on disk by unzipping xlsx → `sharedStrings.xml` + `sheet1.xml`):

- **Fetch** — server name `20260711BrandDefinitionReport_ee2855.xlsx`, 5,980 B, **41 cols**, 1 data row.
  `.playwright-out/QA-52778/fetch.xlsx`
  - brand_id `236`, title `Family Guy`
  - `url_managers` (col 39) = `youtube|http://www.youtube.com/user/ANIMATIONonFOX|FX Networks + Hulu + Disney General Entertainment + Disney Ad Sales + Freeform` (+ instagram `familyguyfox`, facebook, twitter, tiktok, second youtube — all with the 5-tenant manager string)
  - column order around YouTube: `… instagram_user (24), youtube_channel_username (25), youtube_channel_company (26), tiktok_user (27) …`
- **Patch** — server name `20260711PatchBrandDefinitionReport_b4c3b4.xlsx`, 7,416 B, **42 cols** (`record_type=INGESTED` prepended). `.playwright-out/QA-52778/patch.xlsx`
  - `url_managers` at col 40 (populated); `youtube_channel_username (26) → youtube_channel_company (27)`
- **Apply** — server name `20260711ApplyBrandDefinitionReport_9e85f3.xlsx`, 7,418 B, **42 cols** (`record_type=INGESTED`). `.playwright-out/QA-52778/apply.xlsx`
  - `url_managers` at col 40 (populated, same tenant strings); `youtube_channel_username (26) → youtube_channel_company (27)`

All three files carry `url_managers` populated (confirming Include was honored end-to-end) and preserve
the `youtube_channel_company`-immediately-after-`youtube_channel_username` ordering.

## Mutation note (Apply)

Step 13–16 exercise **Brand Definitions (Apply)**, which commits brand-definition changes to real
brand **236** on Dev Radaac. The uploaded Patch xlsx was the **unedited round-trip** of the brand's own
Fetch output, so Apply wrote brand 236's existing values back to itself — an **effective no-op** (no
field values changed; the returned Apply xlsx is identical in structure/values to the Patch input). No
new entity was created, so no teardown is required. The Apply endpoint returned success on the first
submit (the intermittent 502-then-retry noted in the skill did **not** occur this run).

## Bugs filed

None. All 7 assertions passed; BC-5 confirmed non-reproducing (retracted false positive).
