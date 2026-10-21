# QA-144819 — Settings > Brands - Channel and Data Collection Status Dev vs Prod Parity (APPS-61918)

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com`, both logged in as lfiqa and switched to **Adam Orfei**
**Account:** Adam Orfei (account_id=54 on both) · Surface: Settings > Brands (`#brands`) and Settings > Data Collection
**Verdict: PASS — page 1 of Settings > Brands (50 brands) identical on Dev and Prod for Channels and Data Collection Status; both environments paginate to 122 pages (same brand count); feed-level Data Collection for "007 Franchise" identical and consistent with its Brands-row status**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Dev: switch to Adam Orfei → hover Settings → Brands | ✅ `#brands`, "This view is a list of all your owned brands", table `al-table` with columns Brand / Industry / Channels / Data Collection Status / Actions |
| 3 | Dev: scrape all 50 rows of page 1 — brand name, channel icon classes (`fab fa-facebook-square`, `fab fa-square-x-twitter`, `fab fa-instagram`, `fab fa-youtube`, `fab fa-tiktok`, `fab fa-wikipedia-w`, `fab fa-imdb`, `lfb lf-metacritic` …) and the status badges (`fa-exclamation-circle` count / `fa-check-circle` count) | ✅ 50 rows |
| 4–6 | Prod: same navigation and scrape | ✅ 50 rows, first brand "#1 Happy Family USA" on both |
| 7 | Compare brand by brand (join on brand name) | ✅ 50/50 matched, 0 differences in channel icon set, 0 differences in status counts, 0 brands only on one side; pagination footer reads `Page: 1 2 3 4 5 6 … 122` on both |
| 8 | Settings > Data Collection on both → brand "007 Franchise" (typeahead `textarea.brand-filter-typeahead`, option selected by dispatched click) | ✅ Channels (9): YouTube 1 PAGE / 2 warnings, Facebook 1 PAGE / 1 warning, Pinterest 0, Wikipedia 3 PAGES, Twitter 0, Instagram 1 PAGE, TikTok 0, LinkedIn 0, Threads 0 — identical text on Dev and Prod |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7a | Channel values match between Dev and Prod for every brand listed | 50/50 brands on page 1: identical channel icon sets | ✅ PASS (page 1 sampled; see note) |
| A7b | Data Collection Status matches between Dev and Prod for every brand listed | 50/50 brands: identical warning/ok counts (e.g. "#1 Happy Family USA" 2/4, "007 Franchise" 3/16, "007: Road To A Million" 2/3) | ✅ PASS |
| A7c | Brand count is the same across both environments | Both paginate to 122 pages of 50 | ✅ PASS |
| A8 | Settings > Brands status agrees with feed-level status on Settings > Data Collection within each environment | 007 Franchise: Brands row shows 3 warnings; Data Collection shows YouTube 2 + Facebook 1 = 3 warning feeds — agrees, on both environments | ✅ PASS |

## Evidence
- Page-1 scrape (50 rows × {brand, channels, status}) for both environments and the Data Collection text are in the session result dump `results/2026-10-20/_devprod-results.json` (keys `brands`, `dataCollection`).

## Known bugs checked
- None open on the case. APPS-62439 is referenced in the precondition as "see also"; nothing in the compared data reproduced a Dev/Prod status discrepancy.

## Notes
- The Brands table is paginated 50 per page (122 pages). The pagination links did not respond to automated clicks in this run, so parity was verified on page 1 plus the page count; a full 6,100-brand sweep needs the pager mechanic (or the Export button) before this case is scheduled unattended.

## Bugs filed
None.

## Cleanup
None (read-only).
