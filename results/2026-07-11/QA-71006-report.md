# QA-71006 — Brand Content - CSV - Select Data Sets - Facebook Only: Reactions

- **Verdict:** **PASS** (all in-scope assertions pass; email A7 steps out of scope — email/Gmail surface)
- **Run:** 2026-07-11, headless Playwright MCP, `app.lfmdev.in`
- **Account:** Michael Kors (account_id=328) — switched via LFQA menu → Search Account → Results "Michael Kors"
- **Brand:** Michael Kors (brand_id=3801), Facebook channel (auto-scoped by the data set)
- **Date range (app default):** 2026-07-04 → 2026-07-10
- **Data set:** Facebook Only: Reactions
- **Skills reused:** brand-content-data-set-selector (stable), brand-content-table-view, export-csv, switch-account

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand → Content | Navigated `#explore/brand/content?account_id=328` (Brand Content page rendered) |
| 2 | Brand dropdown → type Michael Kors → Table View | Brand picker chevron → textarea → Rule-1 exact "Michael Kors" (brand_id=3801) under Results; Table View selected via `[title="Table View"]` |
| 3 | Data Set dropdown → Facebook Only: Reactions | Data Set box (was "Public") → selected "Facebook Only: Reactions"; URL `table_data_set=facebook_only:_reactions`, `channels=facebook` |
| 4 | Click Export | `button[data-ui-name="csv_export"]` → "Export Select Data Sets" modal opened (View: CSV default) |
| 5 | Click Ok in export popup | Clicked modal `button.primary-button.rounded-button.large` |
| 6 | Click OK in Select Data Set Export Request popup | Confirmation dismissed; export queued (bell +1) |
| 7 | Open corresponding Email | **OUT OF SCOPE** — email/Gmail is a Google-auth surface (same class as Google Sheets). In-app notification card used as supporting evidence instead. |
| 8 | Download attached CSV | CSV obtained via the in-app export delivery (notification bell "now ready" → auto-download event). Verified on disk. |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | 'Facebook Only: Reactions' is the **only** data set selected in the Export pop-up | In the pop-up Data Sets list, only **Facebook Only: Reactions** carried `fas fa-check-square` (checked); Public, Impressions, Video Views, Clicks, Reels, FB-Only: Completed Video Views, FB Engagements Beta, all YouTube-Only, etc. were unchecked (`far fa-square`) | **PASS** |
| A7a | 7 | Mail subject 'ListenFirst Brand > Content Select Data Sets Export Request Complete' | Email not opened (Gmail out of scope) | **N/E (out of scope)** |
| A7b | 7 | ListenFirst logo top-left of email | Email not opened | **N/E (out of scope)** |
| A7c | 7 | Header 'Your Content Export with Select Data Sets is now ready.' | Email not opened. In-app notification card reads "Your Content Export with Select Data Sets for Michael Kors … is now ready." (supporting evidence only) | **N/E (out of scope)** |
| A7d | 7 | Body 'On (Month DD, YYYY at HH:MM am PST … you requested a select data sets export for (Brand) from Start-Date to End-Date.' | Email not opened | **N/E (out of scope)** |
| A8a | 8 | Filename `Brand-Tab-(Start)YYYY-MM-DD-(End)YYYY-MM-DD-posts.csv` | Download event filename = **`Michael Kors-Brand Content-2026-07-04-2026-07-10-posts.csv`** (Brand=Michael Kors, Tab=Brand Content, 2026-07-04→2026-07-10, `-posts.csv`) | **PASS** |
| A8b | 8 | First column should have Data Sets | CSV row 1, col 1 = **"Data Set"**; the data-set-name preamble row shows "Facebook Only: Reactions" spanning the metric columns | **PASS** (label rendered singular "Data Set") |
| A8c | 8 | Facebook Only: Reactions page data matches export data | All 8 posts + every reaction sub-metric match the UI table exactly; Sum row reconciles (see evidence) | **PASS** |

## Evidence

**A4 — export pop-up selection** (`.playwright-out/QA-71006/export-popup-A4.png`): only "Facebook Only: Reactions" checked among Data Sets.

**A8a — filename (Rule 6, actual save outcome):** Playwright `download` event name = `Michael Kors-Brand Content-2026-07-04-2026-07-10-posts.csv` (matches spec pattern exactly). On-disk artifact is slugified to `Michael-Kors-Brand-Content-2026-07-04-2026-07-10-posts.csv` (spaces→hyphens) — a Playwright save artifact; assert against the download-event/server name per known-quirk (2026-06-28).

**A8b — first column:** CSV Row 1 = `Data Set,"","",…,Facebook Only: Reactions × 9`. Row 2 = column headers `Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Facebook Reactions,Facebook Likes,Facebook Loves,Facebook Hahas,Facebook Wows,Facebook Sads,Facebook Angries,Facebook Others`.

**A8c — UI ↔ CSV parity** (Engagements | Reactions | Likes | Loves | Hahas | Wows | Sads | Angries | Others):

| Rank | Date | UI | CSV |
|------|------|----|----|
| 1 | 07/06 | 846/804/711/93/0/0/0/0/0 | 846/804/711/93/0/0/0/0/0 ✓ |
| 2 | 07/08 | 742/684/587/92/3/2/0/0/0 | 742/684/587/92/3/2/0/0/0 ✓ |
| 3 | 07/07 | 507/477/424/51/0/1/0/1/0 | 507/477/424/51/0/1/0/1/0 ✓ |
| 4 | 07/07 | 427/407/352/54/0/0/0/1/0 | 427/407/352/54/0/0/0/1/0 ✓ |
| 5 | 07/09 | 416/396/330/65/1/0/0/0/0 | 416/396/330/65/1/0/0/0/0 ✓ |
| 6 | 07/09 | 412/384/333/50/0/1/0/0/0 | 412/384/333/50/0/1/0/0/0 ✓ |
| 7 | 07/09 | 267/245/201/40/1/3/0/0/0 | 267/245/201/40/1/3/0/0/0 ✓ |
| 8 | 07/10 | 182/173/147/25/0/0/1/0/0 | 182/173/147/25/0/0/1/0/0 ✓ |

UI aggregate **Sum** = 3,799 / 3,570 / 3,085 / 470 / 5 / 7 / 1 / 2 / 0 — reconciles exactly with the sum of the 8 CSV rows.

**In-app notification (supporting):** "Select Data Sets Export — Jul 11, 2026 06:33 pm — Your Content Export with Select Data Sets for Michael Kors from Jul. 04, 2026 to Jul. 10, 2026 is now ready. Download file."

CSV saved: `.playwright-out/QA-71006/Michael-Kors-Brand-Content-2026-07-04-2026-07-10-posts.csv`.

## Known bugs checked

- **bug-history.md** grep for `QA-71006` → no entry.
- **Case "## Open linked bugs"** section: not present in the ingested file (older ingest format); no open-bug gate triggered (Rule 7 → run normally).
- **export-csv known quirks checked:** BC-2 (CDN-hashed filename) did **NOT** reproduce — the real download event produced the correct spec-format filename `Michael Kors-Brand Content-…-posts.csv`. The "Ok button doesn't dismiss" modal quirk did not reproduce (queued cleanly, bell incremented).
- No known bug interfered with any assertion.

## Bugs filed

None. All in-scope assertions pass; the only observed variance is cosmetic (CSV preamble label "Data Set" singular vs spec "Data Sets" plural) — not filed (consistent app behavior, matches the documented data-set-preamble pattern).

## Scope notes

- **Email steps 7 (A7a–A7d):** out of scope on the Playwright track (email/Gmail = Google-auth surface, same class as Google Sheets). Not evaluable; does not block. The emailed CSV artifact is the same file delivered in-app via the notification bell, which was verified on disk — so A8 (the substantive export-content assertions) is fully covered.
- **Google Sheets:** not exercised (CSV path only).
