# QA-13903 — Embedded Post Tooltip - LinkedIn — Report

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Verdict:** **PASS** (7/7 assertions)
- **Skill reused:** `embedded-post-tooltip` (v1, untrusted) — LinkedIn variant of the QA-929 Pinterest flow
- **Account / Brand:** UCLA (account_id=799) / University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only · **Date range:** Jan 01 2025 – Dec 31 2025 · **Mode:** Lifetime · **View:** Authorized (`perspective=extended`)
- **Posts:** 1,415 LinkedIn posts

## Brand selection note (Rule 1)
Spec precondition names the brand as a *suggestion* only — "a brand with LinkedIn data (e.g., MTV / Adam Orfei)". Adam Orfei has zero LinkedIn brands (per KB); the confirmed LinkedIn-bearing brand on dev is UCLA (used on the 2026-06-02 PASS run, 1,415 LinkedIn posts). No hard-named brand was substituted — the precondition is "any brand with LinkedIn data", satisfied by UCLA.

## Steps executed
1. Logged in (programmatic email/password, lfiqa) → `#home` (account 336). ✅
2. Switched account to **UCLA** via profile menu → Search Account → clicked "UCLA" under **Results** (not Recent Searches). ✅
3. Navigated Brand → Content (brand auto-resolved to University of California, Los Angeles, brand_id=127756). ✅
4. Selected **only LinkedIn** channel: deselected Facebook/Twitter/Instagram/TikTok/Threads (verified via DOM — LinkedIn icon `rgb(10,102,194)` active, all others grey `rgb(165,165,165)`), then **Apply** → URL `channels=linkedin`. ✅
5. Switched to **Table View** (`[title="Table View"]`). ✅ (Posts (1,415))
6. Hovered Type-column links (`.label-blob[data-ui-name="type_column"] > a`) — embedded LinkedIn post tooltip opened. ✅

Type-column anchors (200 on first page) all point to well-formed **UCLA-owned** LinkedIn URLs
(`linkedin.com/feed/update/urn:li:share:…` / `urn:li:ugcPost:…`), `target="_blank"`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Post tooltip displays on hover | Hovering row 1 Type link → exactly 1 `div.embedded-post-tooltip` (398×698), containing LinkedIn embed `iframe src=…/embed/feed/update/urn:li:share:7390711711109906432/` matching the row's post. Rendered UCLA header, text, thumbnail. | **PASS** |
| A2 | 6b | Only one tooltip visible at a time | After hovering a 2nd Type link (row 3), `.embedded-post-tooltip` count stayed **1**. | **PASS** |
| A3 | 6c | Tooltip closes on X click OR clicking elsewhere | Click `i.close-embed` → count 0. Reopened, clicked neutral "Posts" header → count 0. Both close paths work. | **PASS** |
| A4 | 6d | Hovering other Type links doesn't open additional tooltips | Hovering row 3 replaced content in the single tooltip (iframe src → `urn:li:ugcPost:7385451384378331136`); no stacking, count remained 1. | **PASS** |
| A5 | 6e | Clicking post type opens correct LinkedIn post in a new tab matching tooltip | Click row 1 Type `<a>` → new tab `https://www.linkedin.com/feed/update/urn:li:share:7390711711109906432/`, title "#worldseries \| UCLA \| 149 comments" — exact post id + brand + comment count match the tooltip. | **PASS** |
| A6 | 6f | Post image (thumbnail) + Post text match the tooltip content | Row 1: tooltip text "Last night, UCLA alum Dave Roberts led the Los Angeles Dodgers… #WorldSeries" + Dodger-Stadium thumbnail = row Text "Last night, UCLA alu…". Row 3 gallery: "Powell Cat, forever part of campus…" + statue image gallery = row Text "Powell Cat, forever…". Thumbnails render correctly in both. | **PASS** |
| A7 | — | No external/non-brand LinkedIn post appears | All 200 Type-column hrefs are UCLA-owned `linkedin.com/feed/update/…` posts; opened post is UCLA's own. No third-party/external post surfaced. | **PASS** |

## Evidence (screenshots under `.playwright-out/QA-13903/`)
- `01-channels-all-selected.png` — channel row before isolating LinkedIn
- `02-channels-linkedin-only.png` — LinkedIn-only selection (Posts (1,415))
- `03-table-view.png` — Table View, LinkedIn channel, Type column links
- `04-tooltip-row1.png` — A1/A6: World Series post tooltip (text + thumbnail + 3,201 reactions / 149 comments)
- `05-tooltip-row3.png` — A4/A6: "Powell Cat" gallery tooltip (replaced content, thumbnails render)

Live-embed counts (3,201 reactions / 149 comments) differ marginally from the LFM table's collected values (3,204 / 148) — expected divergence between LinkedIn's live embed widget and platform-collected data; both clearly reference the same post. Not a defect.

## Known bugs checked
- **bug-history.md (grep QA-13903):** 1 open bug listed — **APPS-57985 (Bug, High, QA Ready) — LinkedIn Posts Thumbnail Issue**. Prior 2026-06-02 run: "Could not reproduce — may be fixed."
- **Probe outcome (this run):** APPS-57985 **NOT REPRODUCED**. Thumbnails render correctly in the embedded tooltip for both an image post (Dave Roberts / Dodger Stadium) and a gallery post (Powell Cat statue + 2 sub-images). Recommend eng re-confirm before closing the Jira; the high-priority thumbnail defect does not manifest on UCLA LinkedIn embeds.
- The probe touches A6 only; since thumbnails render, A6 passes and the bug does not interfere with any assertion → verdict remains PASS. (Treated as a probe per the case's "## Probes (open bugs)" framing, not a Rule 7 auto-fail blocker.)

## Bugs filed
None. (No new defects; APPS-57985 did not reproduce.)
