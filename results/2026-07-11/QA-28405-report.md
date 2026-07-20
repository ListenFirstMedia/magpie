# QA-28405 — Brand Content · CSV · Video Views Data Set

- **Verdict:** **PASS** (6/6 assertions)
- **Run:** 2026-07-11, unattended headless Playwright MCP (`feature/playwright-mcp`)
- **Account / Brand:** Hulu (account_id=336) / **Hulu** brand_id=5670 · Brand > Content
- **Config:** Date Range Jul 03–09, 2026 · View = Authorized (perspective=extended, app default) · Channels FB/Twitter/IG/LinkedIn/TikTok · Mode Lifetime
- **Skills reused:** `brand-content-data-set-selector` (stable), `export-csv` v2 (queued/async variant), `switch-account` (Hulu via profile-menu Search Account)

## Known bugs checked
- **bug-history.md → QA-28405:** Open bugs (0) — _None._ Case file has no "## Open linked bugs" section; bug-history is the authority → **screen passed (Rule 7)**, ran normally.
- Prior run of record: 2026-06-04 QA-4325 batch-4 — PASS (Hulu). No open defects tied to `brand-content-data-set-selector` or `export-csv` that interfere with these assertions.
- No bug reproduced this run.

## Steps executed
1. Logged in programmatically (config/.env, "With existing account") → `#home`.
2. Navigated Brand > Content `brand_id=5670&account_id=336`. **First attempt redirected to brand_id=11003 / account_id=54 (Adam Orfei)** — the known Hulu-5670→11003 + favorite-brand/account carryover quirk. On Adam Orfei the Data Set dropdown's Cross-Channel Metrics offered **only `Public`** (no standalone `Video Views` data set); custom sets shown were Adam Orfei's. Per Rule 1/3 (no substitution) I switched to the **spec account (Hulu)** via profile-menu → Search Account (typed "Hulu" with real keystrokes → clicked the `Results` `.lfm-ta-option`), then re-navigated Brand > Content → stayed on `brand_id=5670&account_id=336` (Hulu).
3. Confirmed default channel selection (all available channels; header "Account: Hulu | Brand > Content", Hulu logo).
4. Opened the **Data Set** dropdown → full Cross-Channel Metrics list present → selected **`Video Views`** (trusted click; URL `table_data_set=video_views`, trigger label = "Video Views").
5. Confirmed **Posts (62)** rendered (no skeleton-hang) with Video-Views metric columns.
6. Installed `HTMLAnchorElement.prototype.click` hook → clicked **Export** → "Export Select Data Sets" modal (View = **CSV**, only **Video Views** pre-checked) → **Ok** → "queued" (modal dismissed).
7. Export auto-downloaded ~within 25s; Playwright `download` event saved the file to disk. Verified Recent-Activity bell entry. Inspected CSV on disk (row 1 preamble, row 2 headers, 62 data rows) and summed the Video Views column vs the on-screen aggregate.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Data Set dropdown contents | Contains `Video Views` + generic `Public`/default | Cross-Channel Metrics = Public, Engagements Breakdown, Impressions, **Video Views**, Clicks, Reels (+ channel-specific + custom sets). Default trigger = `Public`. | **PASS** |
| A2 | Select Video Views → Posts tile loads | Posts(N) loads, no skeleton-hang | **Posts (62)** rendered in <15s, 0 skeletons | **PASS** |
| A3 | Export CSV enabled; queued export completes; bell entry | Enabled → queues → completes → bell shows entry | Export enabled; queued; **auto-downloaded** (completed); bell card "Select Data Sets Export · Jul 11, 2026 05:39 pm · _Your Content Export with Select Data Sets for Hulu from Jul. 03, 2026 to Jul. 09, 2026 is now ready. Download file._" | **PASS** |
| A4 | Filename pattern `{Brand}-Brand Content-{from}-{to}-{…}.csv` | Brand + tab + date range + suffix | Playwright download-event (real Content-Disposition) name = **`Hulu-Brand Content-2026-07-03-2026-07-09-posts.csv`** (on-disk slugified to `Hulu-Brand-Content-…`). CDN object = `302161-b702aa218c289d76c66018a13357ff3f.csv`; anchor `download` attr = generic `my-downloaded-file` (per BC-2 caveat — filename verified via the real download event, Rule 6). | **PASS** |
| A5 | CSV contains Video Views metric columns | Video Views metric set | Row 2 headers include: **Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts)** (+ Engagements, Video Response Rate) | **PASS** |
| A6 | Row 1 labels the active data set | Row 1 = data-set label row | Row 1 = `Data Set,…,,Video Views ×10,` — the 10 metric columns (idx 19–28) labeled **Video Views** | **PASS** |

## Evidence

**CSV on disk:** `.playwright-out/Hulu-Brand-Content-2026-07-03-2026-07-09-posts.csv` — 21,157 bytes, 64 lines (row1 Data Set + row2 headers + **62 data rows** = Posts(62)), 32 columns.

- **Row 1 (Data Set preamble):** `Data Set,"" ×18,Video Views,Video Views,Video Views,Video Views,Video Views,Video Views,Video Views,Video Views,Video Views,Video Views,""`
- **Row 2 (headers):** `Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Video Response Rate,Video Views,Organic Views,Paid Views,Unclassified Views,Viewers,Video Duration,Watch Time (Minutes),Video Views (with Cross-Posts),divanshu,test-tag-4,test-tag-5,yash`
- **Row 3 (sample):** Rank 1 · 07/04/2026 · TikTok · Hulu · Video · Engagements 280,500 · Video Views 1,600,000 · Paid 97,384 · Unclassified 1,502,616.

**CSV ↔ UI aggregate cross-check (Σ over 62 rows == on-screen Sum row):**

| Metric | CSV Σ (on disk) | UI Sum | Match |
|--------|-----------------|--------|-------|
| Video Views | 12,713,359 | 12,713,359 | ✓ exact |
| Engagements | 829,467 | 829,467 | ✓ exact |
| Organic Views | 8,605,229 | 8,605,229 | ✓ exact |
| Paid Views | 348,206 | 348,206 | ✓ exact |
| Unclassified Views | 3,759,924 | 3,759,924 | ✓ exact |
| Viewers | 3,697,993 | 3,697,993 | ✓ exact |
| Watch Time (Minutes) | 1,484,233.67 | 1,484,233.68 | ✓ (rounding) |

Channels present in data: Facebook, Instagram, TikTok, Twitter (multi-channel Video Views — LinkedIn selected but no video posts in window).

**Screenshots** (`.playwright-out/QA-28405/`): `01-dataset-area.png` (Adam-Orfei dropdown, Public-only), `02-video-views-applied.png` (Hulu, Video Views applied), `03-export-modal.png` (Export modal, Video Views checked, CSV), `04-bell-notification.png` (Recent Activity entry).

## Notes / findings (not bugs)
- **Account-context gates the Cross-Channel Metrics list.** On the Adam Orfei account the Data Set dropdown exposed only `Public` under Cross-Channel Metrics; the standalone `Video Views` data set appears only on the **Hulu** account (336). Reaching the spec account was required — resolved via profile-menu Search Account (Hulu is not in the LFQA quick-switcher, consistent with the 2026-07-10 known-quirk). No substitution made (Rule 1/3).
- **A4 filename** verified strictly via the Playwright `download` event (authenticated Content-Disposition), NOT the anchor `download` attribute (which is the generic `my-downloaded-file`) nor the CDN object key — the long-standing BC-2 caveat still holds and is honored here (Rule 6).

## Bugs filed
_None._
