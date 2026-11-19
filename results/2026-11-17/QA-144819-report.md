# QA-144819 — Settings > Brands - Channel and Data Collection Status Dev vs Prod Parity (APPS-61918)

**Run date:** 2026-11-17 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab (user from `config/.env`) + prod tab (prod QA user from `config/.env.prod`), both switched to **Adam Orfei**
**Account:** Adam Orfei (account_id=54) · Surface: Settings > Brands (`#brands`) and Settings > Data Collection
**Verdict: FAIL — brand count differs: the last page (123) of Settings > Brands lists 8 brands on Dev and 3 on Prod, i.e. Dev has 5 more brands (122×50+8 = 6,108 vs 6,103). Channels and Data Collection Status are identical for the 50 brands of page 1, and the feed-level statuses agree.**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Settings → Brands, scrape page 1 (brand, channel icons, status badge counts) | ✅ 50 rows, e.g. "#1 Happy Family USA" IMDb / Metacritic / Twitter / Wikipedia / YouTube, status red 2 · green 4 |
| 4–6 | Prod: same | ✅ 50 rows |
| 7 | Compare brand by brand (page 1) | ✅ 50/50 matched, only-dev 0, only-prod 0, differences 0; 20 of 50 rows carry status badges on each environment |
| 7 | Brand count | ❌ pager "Page: 1 … 123" on both, but page 123 holds 8 rows on Dev (Z: The Beginning of Everything, Zoo, Zoofari, Zookeeper, Zorro, द व्हील ऑफ़ टाइम - Hindi, த வீல் ஆஃப் டைம் - Tamil, ద వీల్ ఆఫ్ టైమ్ - Telugu) and 3 on Prod (द व्हील ऑफ़ टाइम - Hindi, த வீல் ஆஃப் டைம் - Tamil, ద వీల్ ఆఫ్ టైమ్ - Telugu). Settings > Data Collection also shows "My Brands (5,355)" on Dev vs "My Brands (5,354)" on Prod |
| 8 | Settings > Data Collection for "#1 Happy Family USA" on both | ✅ brand row badge 2 on both (matches the red 2 on Settings > Brands); channel list identical (YouTube 1 page · 2, Wikipedia 2 pages, others 0 pages); YouTube page "Prime Video" feeds identical: YouTube Page (Authorized): Oct 15, 2018 / Sep 1, 2024 / Not Collecting; YouTube Posts & Audience (Authorized): Apr 6, 2019 / Sep 1, 2024 / Not Collecting; YouTube Page (Public): Dec 2, 2013 / Nov 16, 2026 / Collecting; YouTube Posts (Public): Mar 26, 2014 / Nov 16, 2026 / Collecting |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7a | Channel values match between Dev and Prod for every brand listed | page 1: 50/50 identical | ✅ PASS (page-1 sample) |
| A7b | Data Collection Status matches for every brand listed | page 1: 50/50 identical | ✅ PASS (page-1 sample) |
| A7c | Brand count is the same across both environments | Dev 6,108 vs Prod 6,103 (last page 8 vs 3 rows) | ❌ FAIL |
| A8 | Settings > Brands status agrees with the feed-level status on Settings > Data Collection within each environment | "#1 Happy Family USA": 2 failing items on both surfaces, on both environments; the two YouTube Authorized feeds are "Not Collecting" | ✅ PASS |

## Evidence
- `results/2026-11-17/_brands-QA-144819.json` (page-1 rows for both environments, comparison, Data Collection feeds, last-page rows).

## Known bugs checked
- No open linked bug on the case; APPS-62439 (named in the precondition) did not surface on page 1.

## Notes
- The 5 extra Dev brands sort before "द व्हील ऑफ़ टाइम - Hindi" (page 123 on Dev starts 5 rows earlier: Z: The Beginning of Everything, Zoo, Zoofari, Zookeeper, Zorro), so the extra brands sit somewhere earlier in the alphabet; they were not individually identified (123 pages). Likely Dev-only brands added by testing, but that is not confirmed.
- Earlier runs compared page 1 and the page count only; the last-page row count check is new today.

## Bugs filed
- (markdown only) Settings > Brands — Adam Orfei account lists 5 more brands on Dev than on Prod (Dev 6,108 vs Prod 6,103); Data Collection "My Brands" 5,355 vs 5,354.

## Cleanup
None (read-only on both environments).
