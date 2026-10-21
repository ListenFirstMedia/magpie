# QA-29128 — Brand Content - Impressions - Data Test - (Twitter and Instagram)

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**) — interactive re-run; the unattended runner had skipped this case under its open-bug rule (APPS-60871)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, skill `brand-content-grid-math`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Data set: Impressions · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Channels: Instagram, then Twitter
**Verdict: PASS — Instagram 13/13 posts satisfy all four identities; Twitter 32/32 Organic + Paid Impressions = Impressions and 31/31 Engagements ÷ Impressions = Engagement Rate (Reach, Organic/Paid Reach and Engaged User Rate are structurally "–" on Twitter)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → UCLA brand → data set **Impressions** | ✅ `table_data_set=impressions` |
| 3–7 | Instagram only → Table View → per post: Organic + Paid Impressions vs Impressions; Organic + Paid Reach vs Reach; Engagements ÷ Impressions vs Engagement Rate; Engagements ÷ Reach vs Engaged User Rate | ✅ 13 posts, 13/13 on each identity (e.g. #1: 161,069 + – = 161,069; 47,180 + – = 47,180; 2,145/161,069 = 1.33%; 2,145/47,180 = 4.55%). Aggregate: Impressions 1,107,722 = Organic 1,107,722 + Paid – |
| 8–11 | Twitter only → same identities | ✅ 32 tweets: Organic + Paid Impressions = Impressions 32/32 (Paid "–" treated as 0); Engagements ÷ Impressions = Engagement Rate 31/31 (one tweet with no rate skipped); Reach / Organic Reach / Paid Reach / Engaged User Rate are "–" on every tweet (not available for Twitter) → identity not evaluable, not a failure. Aggregate Impressions 72,082 = Organic 72,082 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4/A9 | Organic Impressions + Paid Impressions = Impressions | IG 13/13 · TW 32/32 | ✅ PASS |
| A5/A10 | Organic Reach + Paid Reach = Reach | IG 13/13 · TW n/a (Reach "–" for Twitter) | ✅ PASS (IG) · n/a (TW) |
| A6–7/A11 | Engagements ÷ Impressions = Engagement Rate; Engagements ÷ Reach = Engaged User Rate | IG 13/13 both · TW 31/31 Engagement Rate, Engaged User Rate n/a | ✅ PASS |

## Evidence
- Session result `ctx._rerun.q29128` (identity counts, sample rows, aggregate rows).

## Known bugs checked
- **APPS-60871 (Open)** en-dash rendering across Twitter/Instagram/YouTube data sets: the only en-dashes seen are the structural ones (Paid Impressions/Reach on an account with no paid posts, Twitter Reach); every identity that has data reconciles, so the bug did not interfere.

## Bugs filed
None.

## Cleanup
None (read-only).
