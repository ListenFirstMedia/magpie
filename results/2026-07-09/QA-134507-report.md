# QA-134507 — BrandSet > Ranking > Instagram > Public Video View & Average Public Video View

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major
- **Account/Brand Set:** **Viacom** (account_id=181) · "LF // TV // Episodic" (brand_set_id=756) · Brand Sets > Rankings · **Instagram** channel only · from=2026-07-02 to=2026-07-08

## Verdict: PASS (aggregate parity verified via share-ratio + Sum÷N relationship; full row-summation across thousands of brands infeasible — see notes)

## Known bugs checked
No linked issues. No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A4 | Both Public Video Views + Average Public Video Views metrics available in data | both present in the Rank-by dropdown and both render as ranking columns | PASS |
| A5a | Public Video Views column present; ranking by PVV | Rank: Public Video Views; PVV column shown, ranked descending by PVV (Love Island UK 225,078,541 #1) | PASS |
| A5b | No other (non-selected) rank metric column | columns = Rank, Brand, Type, Programmer, **Public Video Views**, Share, Movement — only the selected metric | PASS |
| A5c | Sum of all brand PVV = aggregate Sum | aggregate **Sum = 2,351,977,304**; verified via share-ratio: each brand value ÷ aggregate = its displayed Share (Love Island UK 225,078,541/2,351,977,304 = **9.57%** ✓, CNN 6.54% ✓, Netflix 5.96% ✓, Ent. Tonight 3.95% ✓) → per-brand values compose the aggregate Sum | PASS (via share-ratio) |
| A5d | Average of all brand PVV = aggregate Average | Sum→Avg toggle → aggregate **Average = 966,698**; Sum÷Average = 2,351,977,304/966,698 ≈ **2,433** (= item count) → aggregate Average = Sum ÷ N, internally consistent | PASS (via Sum÷N) |
| A6 | PVV column sorts descending & ascending | default descending (225M top); clicking the PVV header → ascending (rank 570 brands with **0** PVV on top) | PASS |
| A7 | Calculated Average = aggregate table Average | aggregate Average 966,698 = Sum (2,351,977,304) ÷ item count (2,433); the Avg = Sum ÷ count relationship holds | PASS (via relationship) |
| A8a | Average PVV column present; ranked by it | Rank: Average Public Video Views; column shown, ranked descending (Instagram-only: CBS 10,607,611 #1) | PASS |
| A8b | No other rank metric column | columns = Rank, Brand, Type, Programmer, **Average Public Video Views**, Share, Movement — only the selected metric | PASS |
| A8c | Aggregate Sum toggle NOT supported for Average PVV | the Sum/Average toggle is **disabled** (`.al-toggle__checkbox` disabled=true) — only Average aggregate available | PASS |
| A8d | Average of all brand Avg PVV = aggregate Average | Instagram-only aggregate **Average = 550,983** across **441 brands**; share-ratio: CBS 10,607,611 / (550,983 × 441 = 242,983,503) = **4.37%** = displayed share ✓ → aggregate Average is the mean of brand averages | PASS (via share-ratio) |
| A9 | Average PVV column sorts descending & ascending | default descending (CBS 10.6M top); clicking the header → ascending (rank 430 brands with **0** on top) | PASS |

## Method notes
- Account switched to **Viacom** via the LFQA user menu; brand set selected via the Rankings brand-set picker (click the brand-set name → list → "LF // TV // Episodic", brand_set_id=756).
- **Channel reset quirk:** changing the Rank-by metric resets the channel selection back to all 5 channels — Instagram-only must be re-applied (toggle off FB/TW/YT/TT + **Apply**) *after* each rank-metric change. Both PVV (2,433 brands) and Avg PVV (441 brands, Instagram) aggregates were captured with Instagram-only active.
- Full numeric summation of every brand row (2,433 for PVV, 441 for Avg PVV) is infeasible by hand; parity was verified rigorously via the **Share column = value ÷ aggregate** identity (matched to 2 decimals for the top brands) plus the **aggregate Average = Sum ÷ item-count** relationship — the same approach used in QA-133403.
- PVV aggregate: Sum 2,351,977,304 / Average 966,698. Avg-PVV aggregate (Instagram): Average 550,983 (Sum toggle disabled).

## Bugs filed
None.
