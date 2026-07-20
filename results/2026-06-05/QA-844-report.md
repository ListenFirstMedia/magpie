# QA-844 — TikTok Content - Exporting Tags (re-run 2026-06-05 batch-2)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-844
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018 — URL rewrote to 10765 on Brand>Content load; the page header still showed "MTV" so we proceeded). Channel: TikTok only.
- **Date window:** May 25 – May 31 2026.

## Result: PARTIAL / NOT VERIFIED — Brand>Content page rendered with Posts(74) TikTok posts and Export modal opened with the standard "Public + per-channel + Custom Data Sets" tree; Export → CSV (Public) submission accepted by UI ("We're hard at work preparing your export..." message); however the queued CSV did NOT surface in the Settings → Notifications page list nor land in ~/Downloads within 60+ seconds. Newest notification entry on the page remains from May 21, 2026. The `Tags` column verification cannot be completed without an on-disk CSV.

## Steps executed
1. Navigated `#explore/brand/content?brand_id=4018&account_id=54&channels=tiktok&from=2026-05-25&to=2026-05-31&perspective=standard&table_data_set=public&sentiment_mode=false&sort_key=lfm.content.engagements`.
2. Page rendered MTV TikTok, Mode: Lifetime, View: Public Data. URL rewrote `brand_id` to 10765 (hash router behavior) but page-header brand stayed MTV.
3. Waited 20s — Posts(74) loaded. Sum row: Engagements 2,786,408 / Reactions 2,673,233 / Comments 25,362 / Shares 87,813 / Response Rate N/A / Video Views 16,293,547 / Video Response Rate N/A.
4. Clicked Export → Modal "Export Select Data Sets" opened with Public checkbox auto-selected.
5. Clicked Ok → submission accepted, modal closed, no error toast.
6. Waited 10s + 8s + 10s (totaling ~30s after submit). Navigated to `#notifications`.
7. Inspected Notifications list — only stale May 21 / May 7 MTV-prior-export rows visible. No new "Your Content Export … is now ready" entry for the just-submitted run.
8. Refreshed `#notifications` twice (additional 10s waits between) — same stale rows.
9. Direct-fetched the prior May 21 1409926 CSV URL from in-page (CORS blocked) and via navigate (403 Access Denied — server requires browser session cookie + same-origin context to issue file).
10. Time elapsed > 60s; queued export did not arrive in this session.

## Findings
- Brand>Content page loads cleanly for MTV TikTok with valid Sum row.
- Export modal opens and accepts submission. Submission queued state visible in modal body text ("Once it's ready, your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to yash.sharma@listenfirstmedia.com").
- However, the new export does NOT surface in the Notifications list within the 60s observation window. Possible explanations:
  - Hash-router URL-rewrite to brand_id=10765 means the export was queued for that other brand and may surface later under a different brand name.
  - Background-queued exports on this dev environment may have a longer cycle time today.
  - The notification list may not auto-refresh; a full page reload is needed which I did execute.
- No "Tags" column verification possible without an on-disk CSV. Pinning A4/A5/A6 as NOT VERIFIED.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | TikTok-only filter active; channel ghost shows TikTok enabled only | Channels row in URL = `tiktok`; UI shows TikTok highlighted in channel-ghost row | PASS |
| A2 | 3 | Posts(N>0) for TikTok in chosen window | Posts(74) for MTV TikTok May 25–31 2026 | PASS |
| A3 | 6 | CSV downloads with 200 OK + comma-separated payload | CSV submission accepted but queued export did not appear in Notifications nor on disk within 60s | NOT VERIFIED |
| A4 | 7 | CSV header row includes `Tags` (or `Content Tags`) | Cannot verify without CSV | NOT VERIFIED |
| A5 | 7 | For spot-check TikTok row, `Tags` cell contains non-empty value | Cannot verify without CSV | NOT VERIFIED |
| A6 | 7 | For non-tagged rows, `Tags` cell is empty | Cannot verify without CSV | NOT VERIFIED |

## Bug history
- 4 closed bugs in this area (APPS-56565, APPS-51167, LFMP-30048 "tag column missing", APPS-32423).
- LFMP-30048 was specifically about TikTok tag column not appearing in export — without an on-disk CSV, that regression cannot be re-checked this session.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-844-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-844.md`

## Notes (carry-forward to known-quirks candidate)
- **Brand>Content queued CSV exports may not always surface in Notifications within 60s on Adam Orfei dev.** Observed during QA-844 batch 2 — submission accepted by UI but no new notification entry within ~90s. Newest list entry was May 21 2026. Re-test recommended on a different session; if this becomes systemic, candidate for a new knowledge-base quirk: "Queued export lag/silent-drop on Adam Orfei dev".
- Brand_id hash-router rewrite from 4018 → 10765 occurred on page load — also worth noting, may be a separate URL-hash bug on Brand>Content TikTok-only loads.
