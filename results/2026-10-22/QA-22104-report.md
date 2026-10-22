# QA-22104 — Brand Content > LFM vs Native > Facebook Channel - Past Date

**Run date:** 2026-10-22 (Thursday) — interactive re-run; the unattended runner had skipped it under its open-bug rule (LFMP-32119)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Facebook login), dev `app.lfmdev.in`
**Account:** FX Networks (account_id=204, Thursday rotation) · **Brand:** FX Networks Composite (brand_id=62693; the spec's "FX Networks" does not exist on the account) · Channel: Facebook only · Date range: Jan. 01, 2023 – Dec. 31, 2023
**Verdict: BLOCKED — the first 2023 post opens natively to Facebook's "This content isn't available at the moment" page (logged-out or removed post), so the native values cannot be read; the LFM side rendered 200 cards for 2023, which corrects Tuesday's note that 2023 is outside dev retention (UCLA simply had no 2023 Facebook posts)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → FX Networks Composite → Jan 01 – Dec 31 2023 | ✅ `from=2023-01-01&to=2023-12-31`, 200 grid cards |
| 3 | Facebook only | ✅ |
| 4 | First post metrics | ✅ American Horror Story reel, Thu Jan. 19, 2023 "Things I say on the daily. #1: #AHSDoubleFeature #AHSFX" — Engagements 160,568 · Reactions 126,821 · Comments 5,823 · Shares 27,924 · Response Rate 1.39% |
| 5–6 | Click image → native | ⛔ https://www.facebook.com/3399495940268883 — "This content isn't available at the moment … only shared it with a small group of people or changed who can see it, or it's been deleted" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM values close to native | native post not readable logged-out | ⛔ BLOCKED (native access) |

## Known bugs checked
- LFMP-32119 (Open) "Facebook past-date LFM vs native shows big variations": not evaluable today.

## Notes
- The page-load for this composite brand on dev takes 2–3 minutes; a ListenFirst Status iframe overlay appeared mid-run and intercepted date-picker clicks until hidden.

## Bugs filed
None.

## Cleanup
Native tab closed.
