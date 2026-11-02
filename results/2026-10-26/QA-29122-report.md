# QA-29122 — Brand Content - Basic Data Set - Data Test (Twitter and Instagram)

**Verdict: PASS** — Monday rotation, all 3 Description-table pairs executed (HBO Max / HBO Max, Amazon Prime Video / Amazon Prime Video, Condé Nast / Vogue - US). 6/6 channel legs pass; 0 failing posts out of 415 evaluated.

- Run: 2026-10-26 (Monday), unattended headless, Playwright MCP on `app.lfmdev.in`, login `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-grid-math` (Table View DOM scrape; identity evaluated in page JS) + `devprod-helpers.js` navigation helpers
- Date range: app default week 2026-10-18 .. 2026-10-24 (unchanged; spec gives no dates)

## Scope note
The Description table lists three Monday accounts. The 2026-10-20 run covered only the first pair of the day; this run covered **all three** Monday pairs. The Notes' rotation line ("Mon HBO Max/Viacom") disagrees with the Description table (Monday = HBO Max, Amazon Prime Video, Conde Nast); the Description table was followed as authoritative.

## Steps executed (per pair)
1. Account switched via the LFIQA account menu (typeahead `Results` section, real mouse click on `.lfm-ta-option`), header confirmed `ACCOUNT: <name>`.
2. Top nav: hovered **Brand** -> clicked **Content** (`#explore/brand/content`).
3. Brand confirmed in the brand selector (Rule 1, see naming notes below).
4. Data set dropdown (visible one) -> **Engagements Breakdown** (URL `table_data_set=engagements_breakdown`; channels auto-reduced to Twitter + Instagram).
5. **Twitter only:** Twitter enabled / Instagram disabled via channel ghosts, **Apply** (URL `channels=twitter`). Table View (`[title="Table View"]`, `Rank` header verified), scraped every row, checked Reactions + Comments + Shares = Engagements per post, and the column sums against the Sum row.
6. **Instagram only:** Instagram enabled before Twitter disabled (last-channel rule), **Apply** (URL `channels=instagram`). Same scrape and per-post identity.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-HBO | 4 — HBO Max, Twitter only | Reactions + Comments + Shares = Engagements for every post | Posts (14): 14/14 satisfy; 0 failures, 0 skipped. Column totals 6,032 + 97 + 702 = 6,831 = Sum-row Engagements 6,831. | PASS |
| A6-HBO | 6 — HBO Max, Instagram only | same | 40 rows scraped: 40/40 satisfy; 0 failures. Shares "–" on all (structurally absent for Instagram, treated as 0). Totals 1,060,203 + 6,499 + 0 = 1,066,702 = Sum-row 1,066,702. | PASS |
| A4-AMZ | 4 — Amazon Prime Video, Twitter only | same | Posts (71): 71/71 satisfy; 0 failures. 78,316 + 1,625 + 13,397 = 93,338 = Sum-row 93,338. | PASS |
| A6-AMZ | 6 — Amazon Prime Video, Instagram only | same | Posts (68): 68/68 satisfy; 0 failures. Shares "–". 2,840,705 + 29,592 + 0 = 2,870,297 = Sum-row 2,870,297. | PASS |
| A4-VOG | 4 — Condé Nast / Vogue - US, Twitter only | same | Posts (171): 171/171 satisfy; 0 failures. 4,654 + 562 + 946 = 6,162 = Sum-row 6,162. | PASS |
| A6-VOG | 6 — Condé Nast / Vogue - US, Instagram only | same | Posts (51): 51/51 satisfy; 0 failures. Shares "–". 10,238,074 + 32,620 + 0 = 10,270,694 = Sum-row 10,270,694. | PASS |

## Evidence
- HBO Max (account_id 657, brand_id 155614): Twitter row 1: 3,711 = 3,341 + 8 + 362; row 2: 957 = 851 + 19 + 87. Instagram row 1: 247,861 = 246,517 + 1,344 + 0.
- Amazon Prime Video (account_id 342, brand_id 25864): Twitter row 1: 14,643 = 11,802 + 152 + 2,689. Instagram row 1: 876,662 = 857,229 + 19,433 + 0.
- Condé Nast (account_id 487, brand_id 328069): Twitter row 1: 1,183 = 980 + 22 + 181. Instagram row 1: 780,615 = 778,853 + 1,762 + 0.
- Screenshots in `.playwright-out/QA-29122/`: `hbomax-dataset.png`, `hbomax-twitter-table.png`, `hbomax-instagram-table.png`, `amazon-twitter-table.png`, `amazon-instagram-table.png`, `conde-account-search.png`, `vogue-brand-search.png`, `vogue-twitter-table.png`, `vogue-instagram-table.png`.
- Browser console showed repeated errors (30-55 per page) throughout; none affected rendering or the assertions.

## Naming notes (Rule 1)
- Spec account "Conde Nast" exists on dev as **"Condé Nast"** (accented é) — the only match for "Conde"; same entity, not a substitute. The shared `switchAccount` helper's exact-match failed ("no option") on the unaccented name; selected manually via real mouse click.
- Spec brand "Vogue-US" exists on dev as **"Vogue - US"** (spaces around hyphen). The "Vogue" typeahead listed 58 results; "Vogue - US" is the only Vogue-US entry (others are Vogue Beauty/Runway/Shopping/Weddings - US, Vogue US - O&O Roll-Up, etc., which were NOT used).

## Run-environment notes
- One combined script (Amazon + Condé Nast in a single `browser_run_code_unsafe` call) hung ~31 min with no response from the MCP server; the MCP call was aborted and the pairs re-run stepwise with bounded `Promise.race` timeouts. No page was stuck on the product side once reloaded; the hang is attributed to the helper chain (account-switch exact-match failure on "Condé Nast" followed by an unbounded wait), not a product defect. Recommend the shared `switchAccount` helper normalise accents (NFD strip) — flagged for harvest.
- HBO Max Instagram `Posts (N)` counter read back null from `waitPosts`, but the table rendered and 40 rows were scraped and fully evaluated.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). Pre-fetched bug-history.md / known-quirks.md: no QA-29122 matches. No known bug reproduced or interfered with any assertion.
- Instagram Shares "–" is documented structural behavior (grid-math skill), not a defect.

## Bugs filed
None.
