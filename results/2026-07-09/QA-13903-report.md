# QA-13903 — Embedded Post Tooltip - LinkedIn

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** **UCLA** (account_id=799, brand_id=127756) — *not* the suggested MTV (see finding)
- **Channel:** LinkedIn only · Table view · date Jul 1–7 2026 (24 posts)

## Verdict: PASS

## Known bugs checked
- Compact open-bug screen → empty. Case-file probe **APPS-57985** ("Thumbnail Issue for LinkedIn Posts") verified **Closed** now — checked for regression during the run: the LinkedIn embed rendered its image, so the thumbnail defect does **not** reproduce.

## Finding — brand/account for LinkedIn data
The case suggests "MTV / Adam Orfei", but **MTV has zero LinkedIn posts** (verified 0 across Jul 2026, Jan–Jul 2026, and all 2024). LinkedIn is served by the **UCLA** account (`account_id=799`), which is its own account (not under Adam Orfei). UCLA LinkedIn has 24 posts in the current week. This also unblocks the set's LinkedIn Audience cases (QA-92735/94977/94978/95067).

## Evidence
Hovered the first row's Type-column link (`[data-ui-name=type_column] a`, "gallery"). A single `div.embedded-post-tooltip` (398×698, `i.close-embed` X) opened, containing the official LinkedIn embed iframe `https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:74…` — the post image + caption + "University of California, Los Angeles" byline render inside it (`.playwright-out/QA-13903-tooltip.png`). The Type link href = `https://www.linkedin.com/feed/update/urn:li:ugcPost:7479202462604693504/`.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Tooltip displays on hover | `embedded-post-tooltip` with LinkedIn embed iframe opened | PASS |
| A2 | Only one tooltip visible at a time | exactly 1 visible | PASS |
| A3 | Closes on X click / click elsewhere | `i.close-embed` click → tooltips 0 | PASS |
| A4 | Hovering other Type links doesn't stack | hovered 2nd row → still exactly 1 | PASS |
| A5 | Clicking post type opens correct LinkedIn post (new tab) | Type link href = ugcPost URL matching the embed | PASS |
| A6 | Post image + text match tooltip | LinkedIn embed iframe renders the post image + caption + byline | PASS |
| A7 | No external/non-brand post | embed is UCLA's own ugcPost | PASS |

## Skill note
Reuses `embedded-post-tooltip` (validated on Pinterest/QA-929). LinkedIn variant: tooltip content is the **LinkedIn embed widget** (`linkedin.com/embed/feed/update/urn:li:ugcPost:<id>` iframe) — DOM text/img queries inside the tooltip return empty (cross-origin iframe); verify via screenshot + iframe `src`. Tooltip is **sticky** (persists on hover-away; close only via `i.close-embed`).

## Bugs filed
None.
