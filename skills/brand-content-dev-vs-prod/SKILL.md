---
name: brand-content-dev-vs-prod
version: 1
last_verified: 2026-10-20
last_passed_run: 2026-10-20
trust: untrusted
pass_streak: 9
preconditions: [dev-logged-in, prod-logged-in, account-set-on-both]
postconditions: [dev-prod-table-diff-evaluated]
inputs: [account_name, brand_name, data_set, channels, from_date, to_date]
outputs: [matched posts, only-dev / only-prod posts, per-column mismatch counts, aggregate-row diff]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content — Dev vs Prod table diff (Data Test sets QA-27628 / QA-26183 / QA-21686)

Compare every post's metrics between **dev** (`app.lfmdev.in`) and **prod** (`app.listenfirstmedia.com`) for one brand / data set / channel by scraping Table View on both environments and joining rows by post permalink. Verified 2026-10-20 on UCLA (9 cases, all PASS, 2–35 posts each).

## Mechanics
1. **Two tabs, one browser context.** Open the prod tab first (`page.goto('https://app.listenfirstmedia.com')`), then `context.newPage()` for dev. Cookies are per host, so both Cognito sessions coexist. Both hosts use the same "With existing account" email/password form; credentials: `config/.env` (dev) and `config/.env.prod` (prod). Prod uses the same hash routes, selectors and default date week as dev (Mon–Sun of last week, e.g. `from=2026-10-12&to=2026-10-18`).
2. **Account switch on BOTH tabs** (profile menu trigger is `.navigation-controls-user .navigation-menu-header`; hover, then click if `[placeholder="Search Account"]` is not visible). Type the name with `pressSequentially`; poll for the visible `Results` header (retype the last character if it does not appear); then click the matching `.lfm-ta-option` **with a real mouse click at its bounding box** — `element.click()` dispatched from page JS is ignored. Verify `ACCOUNT: <NAME>` in the body text and `account_id=` in the URL (UCLA = 799 on both environments).
3. **Brand > Content:** hover `.navigation-menus .navigation-menu-header-label` "Brand" → click the "Content" text. The account's default brand loads (UCLA → brand_id 127756 on both).
4. **Data set BEFORE channel** (`brand-content-grid-math` rule): visible `.lfm-dropdown-select-box` → visible `.lfm-dropdown-option` with the exact label. Labels used here: Public, Clicks, Video Views, Impressions, Engagements Breakdown, Facebook Only: …, Twitter Only: …, YouTube Only: …, Instagram Only: …, Pinterest Only: Basic, Threads Only: Insights.
5. **Channels:** enable the wanted `.channel-ghost.<c>` first (class contains `disabled`), then disable the rest (class contains `enabled`), click `Apply`, then poll body text for `Posts (N)` up to 90 s; on "failed to load" click `.error-data-link a` once.
6. **Table View:** `[title="Table View"]` unless a visible `table.lfm-table` with a `Rank` header already exists. Scrape `thead th` + `tbody tr` → `{header: text}` plus every `a[href]` in the row.
7. **Join key = post permalink** (the row's last link that is not the brand handle: `instagram.com/p/...`, `x.com/.../status/...`, `facebook.com/.../posts/...`, `tiktok.com/@brand/video/...`, `linkedin.com/feed/update/...`, `youtube.com/watch?v=...`); fallback `Date|Text[0:60]`. Compare every shared column except Rank/Text/Actions, numerically when both parse (commas, %, K/M, `–` = null), else as strings. Also diff the `Sum Average` aggregate row.
8. **Verdict:** PASS when matched == devPosts == prodPosts and 0 column mismatches and 0 aggregate diffs; FAIL otherwise (report per-column mismatch counts and a sample); BLOCKED-NODATA when both environments show 0 posts for the selection.

## Timing
- Each (data set, channel) comparison on both environments takes ~45–90 s on dev; batch 5–8 comparisons per `browser_run_code_unsafe` call and keep helper functions on `page.context()` (`ctx._m`) so later calls reuse them.

## Failure signatures
| Signature | Interpretation | Action |
|---|---|---|
| `ACCOUNT:` unchanged after clicking the option | dispatched click, not a real mouse click | use `mouse.click(bbox centre)` |
| `Posts (N)` differs between environments and only-dev / only-prod > 0 | ETL lag or a dev-only data gap | FAIL, list the sample permalinks; re-check after the next ETL |
| Same post set, numeric mismatches concentrated in one column | metric pipeline difference between environments | FAIL, cite the column and the mismatch count |
| 0 posts on both | no data for the brand/channel in the default week | BLOCKED-NODATA, name the selection |

## Changelog
- **v1** (2026-10-20): initial from the Dev-vs-Prod run (QA-20534, 20533, 20268, 20536, 20537, 20535, 21031, 21032, 20269 all PASS on UCLA).
