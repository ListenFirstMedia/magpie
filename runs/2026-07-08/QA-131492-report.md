# QA-131492 — Social Recap Vs Brand > Content - YouTube Video Views

- **Run date:** 2026-07-08 (headless/unattended, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-131492
- **Verdict:** **PASS** (2/2 assertions)
- **Account:** Adam Orfei (account_id=54) — precondition met (no switch needed; app landed on acct 54 at login)
- **Brand:** MTV (brand_id=10765), Public perspective
- **Window:** Jan 1 – Jan 7, 2026
- **Open linked bugs:** None open (screened per Rule 7) → ran normally.

## Summary

The YouTube Video Views value shown in the Social Recap **Best Performing Content** (BPC)
matches the first (only) YouTube post in Brand → Content for the same brand/window.
Both surfaces report the same post ("Lights, Camera, Debate w/ Tom Blyth & Emily Bader",
Mon Jan 5, 2026 06:00 AM PST) with **Video Views = 68,580**.

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Reporting → Social Recap (top-nav hover → click) | Landed on `app-reporting.lfmdev.in/#/social_recap` |
| 2 | Add Brand: MTV via typeahead Results (exact "MTV", Rule 1) | MTV row added; View toggle = **Public Data** (handle left, `al-toggle__checkbox` checked=false) — confirmed visually (`01-mtv-public-toggle.png`) |
| 3 | Date range Jan 1 – Jan 7, 2026 (Week interval two-calendar picker) | Clicking Jan 1 auto-snapped the full week Jan 1 (range-start) → Jan 7 (range-end); confirmed (`02-daterange-jan1-7.png`) |
| 4 | Run Report (all 7 channels on by default, incl. YouTube) | Navigated to `/#story/social_recap/155747`; title "Social Recap > MTV"; window "Jan 1, 2026 - Jan 7, 2026" |
| 5 | Note YouTube Video Views in Best Performing Content | YouTube BPC card (fab fa-youtube) = **68,580** (`04b-bpc-section-hi.png`, `05-yt-bpc-card.png`) |
| 6 | Navigate Brand → Content (MTV) | Loaded `#explore/brand/content?brand_id=10765`, View: Public Data |
| 7 | Date range Jan 1 – Jan 7, 2026 (two independent calendars + Ok) | URL `from=2026-01-01&to=2026-01-07` applied |
| 8 | Select YouTube channel only, review first post (Table View) | `channels=youtube`, `table_data_set=youtube_only:_basic`; Posts (1); first post surfaced |
| 9 | Note Video Views value | First post Video Views = **68,580** (`07-brandcontent-yt-table.png`) |

## Best Performing Content — per-channel cards (Social Recap, story 155747)

Channel identified by the card's `al-channel-icon` glyph:

| Channel (icon) | Post | Video Views |
|---|---|---|
| Facebook (`fa-facebook-square`) | "Happy Birthday to this pretty lady, Coco Jones" | — (gallery; Engagements 57,403) |
| X/Twitter (`fa-square-x-twitter`) | "Hiiiii, #ConnorStorrie…" | — (Public Impressions 195,931) |
| Instagram (`fa-instagram`) | "Look how this girl in the bubble…" (Reel) | 691,822 |
| **YouTube (`fa-youtube`)** | **"Lights, Camera, Debate w/ Tom Blyth & Emily Bader"** | **68,580** |
| TikTok (`fa-tiktok`) | "Place your bets… on MTV's YouTube channel" | 1,400,000 |

Note: the TikTok card's caption text mentions "MTV's YouTube channel", but its channel icon is TikTok
(`fa-tiktok`) — it is NOT the YouTube card. The YouTube channel's BPC post is the 68,580 one.

## Brand → Content (MTV, YouTube only, Public, Jan 1–7 2026, Table View)

Columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Sponsor, Text, **Video Views**, Likes, Comments, Actions.
Posts (1) — sorted by Video Views desc:

| Rank | Date | Type | Text | Video Views | Likes | Comments |
|---|---|---|---|---|---|---|
| 1 | Mon Jan 5, 2026 06:00 AM PST | video / Original Post | Lights, Camera, Debate w/ Tom Blyth & Emily Bader | **68,580** | 2,066 | 80 |

Only one YouTube post exists in the window, so "first post" is unambiguous. The metrics (VV 68,580 /
Likes 2,066 / Comments 80) are identical to the Social Recap BPC YouTube card.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Report loads successfully | Social Recap story 155747 rendered ("Social Recap > MTV", window Jan 1–7 2026); Brand>Content also loaded | **PASS** |
| A2 | 5 vs 9 | Social Recap BPC YouTube Video Views == Brand→Content first YouTube post Video Views | 68,580 == 68,580 (same post "Lights, Camera, Debate w/ Tom Blyth & Emily Bader", Jan 5 2026) | **PASS** |

## Evidence (screenshots under .playwright-out/QA-131492/)

- `01-mtv-public-toggle.png` — MTV brand row, View toggle on Public Data
- `02-daterange-jan1-7.png` — Week picker showing Jan 1–7 range-start/range-end
- `03-social-recap-full.png` — full report (during build)
- `04-bpc-section.png`, `04b-bpc-section-hi.png` — Best Performing Content per-channel cards
- `05-yt-bpc-card.png` — YouTube BPC card close-up (red YouTube icon, VV 68,580)
- `06-brandcontent-initial.png` — Brand>Content on load
- `07-brandcontent-yt-table.png` — Brand>Content MTV YouTube-only Table View, Posts (1), VV 68,580

## Notes

- Brand identity cross-checked: the Social Recap Instagram BPC card (Engagements 44,227 / VV 691,822)
  matches the documented MTV IG post from QA-131491 for this exact window, confirming brand_id=10765
  "MTV" is the same canonical MTV brand used in both surfaces.
- Both surfaces evaluated on **Public** perspective (Social Recap View=Public Data; Brand>Content
  perspective=standard / View: Public Data), consistent with spec step 2 "MTV (Public)".
- Google Sheets: not applicable to this case (no GS/export step). No export verification required.

## Bugs filed

None. Cross-source YouTube Video Views parity holds exactly (68,580 = 68,580).
