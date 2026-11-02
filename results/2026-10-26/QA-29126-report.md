# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Verdict: PASS** — Monday rotation, all 3 Description-table pairs executed (HBO Max / HBO Max, Amazon Prime Video / Amazon Prime Video, Condé Nast / Vogue - US). 3/3 TikTok legs pass: 172 posts with Video Views data evaluated (59 + 35 + 78), 0 failures on either identity; the Sum row reconciles on every leg. 67 HBO Max posts carry no Video Views ("–") and were skipped as no-data.

- Run: 2026-10-26 (Monday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com` (Cognito "With existing account")
- Skill used: `brand-content-grid-math` (Table View DOM scrape, identities evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-18 .. 2026-10-24 (unchanged; spec gives no dates)
- Data set: **Video Views** (`table_data_set=video_views`), selected from the data-set dropdown before the channel filter
- Channel: **TikTok only** (`channels=tiktok`; ghost state verified `enabled: ["tiktok"]` before and after Apply)

## Scope note
The Description table lists three Monday accounts; all three pairs were run, matching the QA-29122 / QA-29123 runs of the same day. The case Notes' rotation line ("Mon HBO Max/Viacom") disagrees with the Description table (Monday = HBO Max, Amazon Prime Video, Conde Nast); the Description table was followed as authoritative.

## Steps executed (per pair)
1. Account switched via the account menu (typeahead `Results`, real mouse click on the `.lfm-ta-option`); header confirmed `ACCOUNT: <name>`.
2. Step 1 — hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
3. Step 2 — brand confirmed in the brand selector (Rule 1, see naming notes); data set **Video Views** chosen from the dropdown.
4. Step 3 — TikTok only: other channel ghosts clicked off, TikTok enabled, **Apply** clicked.
5. Steps 4/5 — **Table View** (`Rank` header verified) scraped for every row: Organic Views, Unclassified Views, Paid Views, Video Views, Engagements, Video Response Rate.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-HBO | 4 — HBO Max (acct 657, brand 155614), TikTok | Organic + Unclassified + Paid Views = Video Views per post | Posts (126): 59 have Video Views and all 59 satisfy the sum (0 failures); 67 have Video Views "–" and were skipped. Column totals 0 + 46,411,992 + 0 = 46,411,992 = Sum-row Video Views 46,411,992. | PASS |
| A5-HBO | 5 — HBO Max, TikTok | Engagements / Video Views = Video Response Rate per post | 58 posts evaluated, 58 within rounding (max diff 0.0047 pp); 68 skipped (67 no Video Views, 1 with a "–" component). Sum row: Engagements 1,060,950 / 46,411,992 = 2.286%; the Sum-row VRR cell itself reads "N/A". | PASS |
| A4-AMZ | 4 — Amazon Prime Video (acct 342, brand 25864), TikTok | same sum identity | Posts (35): 35/35 satisfy; 0 failures. Column totals 0 + 22,565,300 + 0 = 22,565,300 = Sum-row Video Views 22,565,300. | PASS |
| A5-AMZ | 5 — Amazon Prime Video, TikTok | same rate identity | 35/35 within rounding (max diff 0.0047 pp). Sum row: 854,204 / 22,565,300 = 3.785%; Sum-row VRR cell "N/A". | PASS |
| A4-VOG | 4 — Condé Nast / Vogue - US (acct 487, brand 328069), TikTok | same sum identity | Posts (78): 78/78 satisfy; 0 failures. Column totals 0 + 55,072,780 + 0 = 55,072,780 = Sum-row Video Views 55,072,780. | PASS |
| A5-VOG | 5 — Vogue - US, TikTok | same rate identity | 77 evaluated, 77 within rounding (max diff 0.005 pp); 1 skipped (a "–" in a component). Sum row: 7,405,051 / 55,072,780 = 13.446%; Sum-row VRR cell "N/A". | PASS |

## Evidence
- HBO Max row 1: Engagements 400,339; Video Views 9,117,452 = Unclassified 9,117,452 (Organic "–", Paid "–"); VRR 4.39% (400,339 / 9,117,452 = 4.391%). Row 2: 72,750 / 748,357 = 9.72%. Row 3: 70,141 / 2,014,611 = 3.48%.
- Amazon Prime Video row 1: 314,488 / 15,200,000 = 2.07%, Video Views 15,200,000 = Unclassified 15,200,000. Row 2: 108,055 / 816,000 = 13.24%.
- Vogue - US row 1: 995,248 / 9,800,000 = 10.16%, Video Views 9,800,000 = Unclassified. Row 2: 886,168 / 4,900,000 = 18.09%.
- On TikTok all views land in **Unclassified Views**; Organic Views and Paid Views are "–" on every row, treated as 0 (structurally absent for TikTok). The sum identity therefore holds as Unclassified = Video Views. Video Views (with Cross-Posts) equals Video Views.
- Cross-reference with the QA-29123 run (Basic data set, same day): post counts are 126 / 37 / 85 there vs 126 / 35 / 78 here for HBO Max / Amazon / Vogue, and Sum-row Engagements are 1,060,950 / 917,373 / 7,496,922 vs 1,060,950 / 854,204 / 7,405,051. HBO Max matches; Amazon and Vogue show fewer posts in the Video Views data set. Not part of this case's assertions; the cause was not investigated.
- Screenshots in `.playwright-out/QA-29126/`: `hbomax-tiktok-videoviews-table.png`, `amazon-tiktok-videoviews-table.png`, `conde-account-search.png`, `vogue-tiktok-videoviews-table.png`.
- Browser console showed repeated errors (39-52 per page) throughout; none affected rendering or the assertions.

## Observations (not assertion failures)
- HBO Max: 67 of 126 TikTok posts show Video Views "–" (and Organic/Unclassified/Paid "–") while still carrying Engagements. Per the grid-math skill a "–" total is no-data and was skipped and counted, so these posts are not evaluable; worth a data-collection look if HBO Max TikTok view coverage is expected to be complete.
- The Sum-row Video Response Rate cell reads "N/A" on all three legs, so the aggregate-level rate could not be compared against a displayed value; the aggregate was recomputed from the Sum-row Engagements / Video Views for reference only.

## Naming notes (Rule 1)
- Spec account "Conde Nast" exists on dev as **"Condé Nast"** (accented é), the only result for "Conde"; same entity, not a substitute. The shared `switchAccount` exact-match does not handle the accent, so the option was clicked with a real mouse click on the exact `Condé Nast` row; header read back `ACCOUNT: CONDÉ NAST`.
- Spec brand "Vogue-US" exists on dev as **"Vogue - US"** (spaces around the hyphen); it was the brand already selected for the account and matches the brand selector exactly. Other Vogue entries were not used.
- Amazon: `switchAccount` returned `ok:false` (no `ACCOUNT:` text at its 8 s mark), but the header was then read back as `ACCOUNT: AMAZON PRIME VIDEO`, brand `Amazon Prime Video`, URL `account_id=342&brand_id=25864`; verified before scraping.

## Run-environment notes
- The unattended run cannot read `config/.env` from inside the Playwright sandbox, so the login credentials were read in this session and passed into `ctx._creds` for `m.login`; the dev tab only was logged in (no prod comparison is needed for this case).
- Pages loaded within the bounded waits on all three legs; no reload or render-hang handling was needed.

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-20)": None open (Rule 7 screen passed). `results/open-bugs-2026-10-26.json` was not re-read; the pre-fetched bug-history.md / known-quirks.md greps had no QA-29126 matches. No known bug reproduced or interfered with any assertion.

## Bugs filed
None.
