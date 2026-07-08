# QA-134594 — Brand > Video > Instagram > Public Data

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless), `app.lfmdev.in`, programmatic email/password login (lfiqa@listenfirstmedia.com)
- **Account:** Hulu (account_id=336) — switched from HBO Max via profile menu → Search Account → Results → Hulu
- **Brand:** Hulu (Authorized entity brand_id=5670 / Public entity brand_id=11003 — expected entity swap on perspective toggle)
- **Date range:** Jun 26 – Jul 2, 2026 (compare Jun 19 – Jun 25, 2026) — default
- **Skill used:** `view-perspective-toggle` v2 (untrusted)
- **Verdict:** **PASS** (11 assertions PASS, 1 N/A — see 5c)
- **Open linked bugs (cached 2026-07-03):** None open → screen passed, ran normally.

## Pre-flight
- Navigated to app.lfmdev.in → Cognito hosted UI → filled "With existing account" form → Sign in → `#home` rendered (title "Home - ListenFirst"). PASS.

## Steps executed
1. Hover Brand top-nav dropdown → clicked **Video** → landed on Brand>Video, Hulu (brand_id=5670, perspective=extended/Authorized).
2. Brand search: attempted to re-select Hulu via the brand-selector chevron typeahead. The `.brand-select-typeahead` textarea toggled hidden and did not surface Results under Playwright (automation-only widget friction). Brand was **already Hulu** (the exact spec brand, brand_id=5670) from the Video nav — no substitution, step intent satisfied. See Notes.
3. Clicked the perspective toggle `label[for=perspective]` → switched to **Public Data** (verified `input#perspective.checked=false`; URL → brand_id=11003 & perspective=standard). Confirmed via screenshot + DOM.
4. Channel selector: deselected Facebook, Twitter, TikTok (trusted clicks flipping `.channel-ghost enabled`→`disabled`), left **Instagram** enabled → clicked **Apply** (URL → `channels=instagram`). YouTube was already `disabled` (no Public data).
5. Reviewed New Video Posts table tile (2nd row) — columns + sort.
6. Reviewed Best Performing Videos tile — channel content + sort dropdown.
7. Reviewed tiles under Public — confirmed no private "Page Video Views".
8. Clicked perspective toggle → back to **Authorized Data** (verified `checked=true`; URL → brand_id=5670 & perspective=extended); confirmed tile rename.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 3(a) | 3 | Instagram available in channel selector under Public Data | Channel selector icons: Facebook, Twitter, **Instagram**, TikTok, YouTube (YouTube disabled/no-data). Instagram present + selectable. | PASS |
| 3(b) | 3 | Tiles New Video Posts, Public Page Video Views, Video Engagements each show legends Facebook, Twitter, Instagram, TikTok, - Compared To | All three tiles' legend = "Facebook / Twitter / Instagram / TikTok / - Compared To" (verified in DOM). | PASS |
| 4(a) | 4 | Tiles present: New Video Posts (Row1), Public Page Video Views, Video Engagements, New Video Posts (Row2), Top 7 Videos (Daily), Best Performing Videos | All 6 present in DOM order: metric tiles "New Video Posts: 30 (-3%)", "Public Page Video Views: 54.4M (+85%)", "Video Engagements: 1.06M (-14%)"; table "New Video Posts"; "Top 7 Videos (Daily)"; "Best Performing Videos". | PASS |
| 4(b) | 4 | In New Video Posts, Public Page Video Views & Video Engagements only Instagram + - Compared To legends | Each of the 3 tiles: legend = "Instagram - Compared To" only. | PASS |
| 4(c) | 4 | Each tile displays Instagram data only | Legends Instagram-only; Top 7 Videos (Daily) legend = Instagram; Best Performing Videos content all Instagram (@hulu). | PASS |
| 5(a) | 5 | Table columns: Legend, Channel, Type, Text, Video Views | Headers = Legend, Channel, Type, Text, Video Views. | PASS |
| 5(b) | 5 | Video Views column supports sorting | Header carries `sortable-column` + `fa-sort` icon; clicking re-sorted values ascending (12,657 → 13,124 → … → 95,747; previously unsorted). | PASS |
| 5(c) | 5 | If no new video posts → "There is no data available. Please select a different brand, brand set, or date range." | Data present (30 IG posts this window); empty-state condition not met — **N/A** (not triggerable without a no-data brand/date; no substitution per Rule 1). | N/A |
| 6(a) | 6 | Only Instagram video-view content displayed | All Best Performing Videos items are Instagram (`fa-instagram`), @hulu Reels/Video with Video Views metric. | PASS |
| 6(b) | 6 | Video Views sort dropdown selected by default | Sort dropdown reads "Sort: Video Views" by default. | PASS |
| 7 | 7 | "Page Video Views" does NOT display (Public) | Under Public: only "Public Page Video Views" present; plain "Page Video Views" absent (DOM title scan hasPlain=false, hasPublic=true). | PASS |
| 8 | 8 | "Public Page Video Views" does NOT display (Authorized) | After toggling to Authorized: tile renamed to "Page Video Views: 105M (+15%)"; "Public Page Video Views" absent (hasPublic=false, hasPlain=true). | PASS |

## Evidence
- `.playwright-out/QA-134594/01-video-loaded.png` — Brand>Video Hulu, Authorized (initial load; middle/right tiles transiently showed "This tile failed to load — RELOAD"; resolved on later re-render).
- `.playwright-out/QA-134594/03-public-data.png` — Public Data, all channels: three metric tiles with FB/Twitter/Instagram/TikTok/- Compared To legends; middle tile "Public Page Video Views".
- `.playwright-out/QA-134594/04-instagram-only.png` — Public Data, Instagram-only: all 6 tiles, Instagram-only legends.
- `.playwright-out/QA-134594/05-authorized-data.png` — Authorized Data: middle tile renamed "Page Video Views: 105M (+15%)", legends include LinkedIn (full channel set restored).
- Key numbers — Public/IG-only: New Video Posts 30 (-3%), Public Page Video Views 54.4M (+85%), Video Engagements 1.06M (-14%). Authorized/all-channels: New Video Posts 90 (-13%), Page Video Views 105M (+15%), Video Engagements 2.7M (-9%).

## Notes / observations (not bugs)
- **Brand-picker widget friction (step 2):** the `.brand-select-typeahead` textarea (placeholder "Current") toggled to a hidden state and did not surface a Results list under Playwright trusted clicks. Brand was already the exact spec brand (Hulu) from the Video nav, so no substitution occurred and the step's intent held. Automation-only; not a product defect. Candidate KB note for the Brand>Video brand selector.
- **Transient tile-render on first Authorized load:** on initial load two Authorized tiles showed "This tile failed to load. Please try again. RELOAD"; after the Public→(work)→Authorized round-trip they rendered full stacked bar charts with data. Transient, self-recovered — not filed.
- **Perspective toggle = brand-entity swap** (Hulu Authorized 5670/extended ↔ Public 11003/standard) and **channel-set change** (LinkedIn/YouTube drop under Public) — both expected per the `view-perspective-toggle` skill; not bugs.
- **Video tile-rename** ("Public Page Video Views" ⇄ "Page Video Views") is a clean confirmation signal for the active perspective — used to evaluate assertions 7 & 8.

## Bugs filed
None. All in-scope assertions passed; 5(c) is a non-triggerable empty-state (data present). No Google Sheets / export steps in this case (nothing out-of-scope skipped).

## Skill credit
- `view-perspective-toggle` (v2, untrusted) — reused successfully on 2026-07-04 (Hulu Brand>Video Public↔Authorized round-trip; alt selector `label.toggle-switch-label[for=perspective]` + brand-entity swap + Video tile-rename all held). Separate-day pass from the 2026-07-03 v2 credit → streak +1 eligible.
