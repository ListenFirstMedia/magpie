# QA-144819 — Settings > Brands - Channel and Data Collection Status Dev vs Prod Parity (APPS-61918)

**Run date:** 2026-11-18 (Wednesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab (user from `config/.env`) + prod tab (prod QA user from `config/.env.prod`), both switched to **Adam Orfei**
**Account:** Adam Orfei (account_id=54) · Surface: Settings > Brands (`#brands`) and Settings > Data Collection
**Verdict: FAIL — brand count differs for the second day running: Dev lists 6,108 brands and Prod 6,103 (last page 123 holds 8 rows on Dev vs 3 on Prod). Channels and Data Collection Status are identical for the 50 brands of page 1 and for the last 53 brands of the list, and the feed-level statuses agree.**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Settings → Brands, scrape page 1 (brand, channel icons, status badge counts) | ✅ 50 rows, e.g. "#1 Happy Family USA" IMDb / Metacritic / Twitter / Wikipedia / YouTube, status red 2 · green 4 |
| 4–6 | Prod: same | ✅ 50 rows (the first load sat on "Loading" for more than 3 minutes; one reload rendered the table) |
| 7 | Compare brand by brand (page 1) | ✅ 50/50 matched, only-dev 0, only-prod 0, differences 0; 220 channel icons on each; 20 of 50 rows carry status badges on each; badge totals identical (red 19 · blue 31 · yellow 41 · green 166) |
| 7 | Brand count | ❌ pager "Page: 1 … 123" on both, but page 123 holds 8 rows on Dev (Z: The Beginning of Everything, Zoo, Zoofari, Zookeeper, Zorro, द व्हील ऑफ़ टाइम - Hindi, த வீல் ஆஃப் டைம் - Tamil, ద వీల్ ఆఫ్ టైమ్ - Telugu) and 3 on Prod (the three non-Latin titles). The list request the page itself makes reports `total_records` 6,108 on Dev and 6,103 on Prod. Settings > Data Collection shows "My Brands (5,355)" on Dev vs "My Brands (5,354)" on Prod |
| 7 | Tail comparison (Dev pages 118–123, Prod pages 122–123) | ✅ the last 53 brands are the same 53 on both, in the same order; Prod's brand at position 6,051 ("You Don't Know Where I'm From, Dawg") sits at position 6,056 on Dev, so all 5 extra Dev brands sort before it |
| 8 | Settings > Data Collection for "#1 Happy Family USA" on both | ✅ brand row badge red 2 on both (matches the red 2 on Settings > Brands); YouTube page "Prime Video · 2" on both; feeds identical: YouTube Page (Authorized): Oct 15, 2018 / Sep 1, 2024 / Not Collecting; YouTube Posts & Audience (Authorized): Apr 6, 2019 / Sep 1, 2024 / Not Collecting; YouTube Page (Public): Dec 2, 2013 / Nov 17, 2026 / Collecting; YouTube Posts (Public): Mar 26, 2014 / Nov 17, 2026 / Collecting |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7a | Channel values match between Dev and Prod for every brand listed | page 1: 50/50 identical; last 53 brands: 53/53 identical | ✅ PASS (103-brand sample of ~6,100) |
| A7b | Data Collection Status matches for every brand listed | page 1: 50/50 identical (badges fully loaded on both) | ✅ PASS (page-1 sample) |
| A7c | Brand count is the same across both environments | Dev 6,108 vs Prod 6,103 | ❌ FAIL |
| A8 | Settings > Brands status agrees with the feed-level status on Settings > Data Collection within each environment | "#1 Happy Family USA": 2 failing items on both surfaces, on both environments; the two YouTube Authorized feeds are "Not Collecting" | ✅ PASS |

## Evidence
- `results/2026-11-18/_brands-QA-144819.json` (page-1 rows for both environments, comparison, tail pages, list-request totals, Data Collection feeds, last-page rows).

## Known bugs checked
- No open linked bug on the case (APPS-60937 Closed); APPS-62439 (named in the precondition) did not surface on page 1.

## Notes
- The 5 extra Dev brands were **not individually identified**. They sort before "You Don't Know Where I'm From, Dawg" (position 6,051 on Prod). A full walk of all 123 pages on both environments was started but each page takes about a minute to load, so it was stopped after Dev pages 118–123 and Prod pages 122–123. Dev-only brands added by testing are the likely cause, but that is not confirmed.
- Status badges on the tail pages were captured before they finished loading on Prod (they load after the rows), so the status comparison is reported for page 1 only, where badges were settled on both.
- The Export → XLSX option was clicked once on each environment to obtain the full brand list; no file was downloaded within 150 s on either (the export appears to be delivered by email, which is out of scope). Nothing else was triggered.

## Bugs filed
- (markdown only) Settings > Brands — Adam Orfei account lists 5 more brands on Dev than on Prod (Dev 6,108 vs Prod 6,103; same on 2026-11-17); Data Collection "My Brands" 5,355 vs 5,354.

## Cleanup
None (read-only on both environments — Add a Brand and the row actions were not touched).
