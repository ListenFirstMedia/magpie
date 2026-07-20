# QA-107134 — Settings > Audit - Deep Linking — Report

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP track)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-107134
- **Skill:** settings-audit-logs (v2, untrusted) — Deep Linking flow
- **Account:** Adam Orfei (`account_id=54`) — default logged-in context, matches precondition ("User logged in")
- **Verdict:** **PASS** (A1, A2 PASS; A3 probe reproduces known open bug APPS-54603, which does not interfere with the deep-linking assertions)

## Known bugs checked (step 2 / step 5)

- `knowledge-base/bug-history.md` (QA-107134): **APPS-54603** (Bug, Minor, **Open**) — Global Deep Linking issue when replacing URL on current page; pasted URL not updated with selected parameters except date range. Prior runs (2026-06-04 batch-8, 2026-06-13) both PASSED, treating APPS-54603 as the A3 probe target.
- `knowledge-base/known-quirks.md`: 2026-06-13 note flagged a possible fix (deep-link opening a new tab); this run re-probes.
- Case-file "Probes (open bugs)" section lists APPS-54603 as the A3 probe. It is intrinsic to the test design (A3 exists to observe it) and does **not** interfere with the primary deep-link assertions A1/A2 → per open-bug discipline, the case is run and the probe outcome noted, not auto-failed.

## Steps executed

1. Logged in via Cognito "With existing account" form (`config/.env` creds); landed on `#home`.
2. Navigated to Settings → Audit (`#audit`). Page auto-populated default params: `account_id=54&from=2026-07-04&to=2026-07-10&compare_from=2026-06-27&compare_to=2026-07-03`; Date Range chip "Jul. 05, 2026 - Jul. 11, 2026"; ~170 unfiltered rows. (evidence: `01-audit-baseline.png`)
3. Applied an **Activity = Brand Edited** filter via the Filter "Select" → Activity → Brand Edited → **Apply Filter**. URL updated to include `from=2026-07-05&to=2026-07-11` + `filters=` (double-URL-encoded JSON). Filtered table = **51 rows, all "Brand Edited"**; chips "Date Range: Jul. 05, 2026 - Jul. 11, 2026" + "Activity: Brand Edited". (evidence: `02-filtered-baseline.png`)
   - Captured baseline deep-link URL:
     `https://app.lfmdev.in/#audit?account_id=54&from=2026-07-05&to=2026-07-11&compare_from=2026-06-28&compare_to=2026-07-04&filters=%257B%2522activity%2522%253A%255B%257B%2522values%2522%253A%255B%2522Brand%2520Edited%2522%255D%252C%2522not%2522%253Afalse%252C%2522operator%2522%253A%2522or%2522%257D%255D%257D`
   - Decoded `filters`: `{"activity":[{"values":["Brand Edited"],"not":false,"operator":"or"}]}`
4. **Step 3+4 (fresh tab):** Opened the captured URL in a **new tab**. Page loaded Audit with identical state: Account **Adam Orfei**, Date Range **Jul. 05, 2026 - Jul. 11, 2026**, Activity chip **Brand Edited**, **51 rows all Brand Edited**, first row (Family Guy metadata edited) and last row (Search Term 72810_20260706055241) byte-identical to baseline. (evidence: `03-freshtab-deeplink.png`)
5. **Step 5 (same-tab replace — A3 probe):** In the same (fresh) tab, replaced the URL with a **different date range (June 2026: from=2026-06-01&to=2026-06-30)** AND a **different filter (Brand Set Created)**. URL bar updated (soft hashchange, no full reload) but the **UI did NOT update**: Date Range chip stayed "Jul. 05, 2026 - Jul. 11, 2026", Activity chip stayed "Brand Edited", table stayed at 51 Brand-Edited rows. (evidence: `04-sametab-replace-apps54603.png`)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Open deep-link URL in fresh tab | Audit page loads with same date range / filters | Fresh tab loaded with Date Range "Jul. 05, 2026 - Jul. 11, 2026" + Activity "Brand Edited" chip; 51 rows all Brand Edited | **PASS** |
| A2 | Verify all deep-link parameters preserved | account + date range + filters all preserved | account_id=54 (Adam Orfei), from/to (Jul 05–11), filters JSON (Brand Edited) all preserved; first/last rows identical to source | **PASS** |
| A3 (probe) | Replace URL in same tab | APPS-54603 — params except date range may not be applied | Same-tab replace applied **neither** filter **nor** date range — UI stayed on Jul 05–11 + Brand Edited despite URL showing June + Brand Set Created. **APPS-54603 REPRODUCED (broader scope: both filter AND date range stuck)** | PROBE — reproduced (expected) |

## Evidence

- `.playwright-out/QA-107134/01-audit-baseline.png` — Audit page, unfiltered default state
- `.playwright-out/QA-107134/02-filtered-baseline.png` — Activity=Brand Edited filter applied (51 rows)
- `.playwright-out/QA-107134/03-freshtab-deeplink.png` — fresh-tab deep-link loads identical state (A1/A2)
- `.playwright-out/QA-107134/04-sametab-replace-apps54603.png` — same-tab URL replace; UI stuck on prior state (A3 / APPS-54603)
- Baseline filtered row count: 51, activity type distribution `{"Brand Edited": 51}` (verified programmatically on both source and fresh tab)

## Bugs filed

- **APPS-54603** (existing, Open, Minor) — **REPRODUCED**. Same-tab URL replacement on the Audit page does not apply the pasted parameters. This run reproduces the **broader scope** first noted 2026-06-04: **both** the `filters` JSON **and** the date range failed to update (the original Jira description states only filters fail, date range should update). The 2026-06-13 "possible fix / new-tab" behavior was **not** observed this run — same-tab replace is still stuck. Recommend eng re-confirm scope before closing. No new bug filed (existing ticket covers it).
- No other defects observed. A1/A2 deep-linking (fresh tab) works correctly.
