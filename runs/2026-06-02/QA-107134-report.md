# QA-107134 — Settings > Audit - Deep Linking (re-run 2026-06-04 batch-8)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-107134
- **Account:** Adam Orfei
- **Page:** Settings > Audit
- **Skill:** settings-audit-logs

## Result: PASS — APPS-54603 REPRODUCED

## Steps executed

1. Navigated Settings → Audit (default URL `https://app.lfmdev.in/#audit?account_id=54`).
2. Default date range loaded as May 10, 2026 – May 20, 2026 (default relative).
3. Audit table populated with rows (e.g., Sony Pictures Motion Picture Group / Sony / Gabrielle Cohen / Brand Edited / Instagram added to S.W.A.T. HQ).
4. Applied Filter → Activity → checked **Brand Edited** → Or → Apply Filter.
5. URL updated to: `https://app.lfmdev.in/#audit?account_id=54&from=2026-05-10&to=2026-05-20&compare_from=2026-04-29&compare_to=2026-05-09&filters=%257B%2522activity%2522%253A%255B%257B%2522values%2522%253A%255B%2522Brand%2520Edited%2522%255D%252C%2522not%2522%253Afalse%252C%2522operator%2522%253A%2522or%2522%257D%255D%257D`
6. Filter chip pill renders: `Activity: Brand Edited Include`.
7. Table displays only Brand Edited rows (Sony Pictures Instagram added/removed; NBC News David Charns metadata edited; ListenFirst Wikipedia added to Filana Therapeutics).
8. Opened the captured URL in a **fresh new tab** (tabId 1804438045).
9. Verified deep-link load: Date Range chip = May 10, 2026 – May 20, 2026; Activity chip = Brand Edited Include; table rendered identical Brand Edited rows.
10. **APPS-54603 probe**: in same fresh tab, replaced URL with `?from=2026-04-01&to=2026-04-30&filters=...User Created...` (changed both date range and filter).
11. Page re-rendered: URL bar shows `User%2520Created` in query — but the page UI still displays **Brand Edited** chip and **May 10, 2026 – May 20, 2026** date range. Table still shows Brand Edited rows.

## Bug reproduction outcomes

### APPS-54603 (Bug, Minor, Open) — Global Deep Linking issue when replacing URL on current page; pasted URL not updated with selected parameters except date range
**Verdict: REPRODUCED**

When the URL is replaced in the same tab (step 10), neither the `filters` JSON nor the date range took effect: the UI continued to show the original `Brand Edited` filter and `May 10 – May 20` date range. The probe spec actually said "all parameters except date range fail to update"; in this run BOTH failed (the date range also didn't update). This is consistent with — and slightly broader than — the documented bug. Suggests engineering may have widened the issue beyond filters-only.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Fresh-tab deep-link loads with same filter+date | All params (account_id=54, from/to dates, filters JSON) preserved; chip + rows match originating page | PASS |
| A2 | 8 | All deep-link parameters preserved on full reload | filters JSON decoded into `Activity: Brand Edited Include` chip; Date Range pill matches | PASS |
| A3 (probe) | 10 | Same-tab URL replace: only date range updates (per APPS-54603) | Same-tab URL replace: NOTHING updates (broader regression than documented). The URL bar shows new params but UI state stuck on old filter+date | **REPRODUCED — APPS-54603 STILL OPEN (broader scope)** |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-107134-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-107134.md`

## Notes
- Audit deep-link via fresh tab works correctly — covers the spec's primary "ensure the page loads correctly" requirement.
- APPS-54603 remains open and the regression scope on dev as of 2026-06-04 may be broader than the original Jira description.
- Skill `settings-audit-logs` reused; filter chip pattern (`Activity: <Value> Include`) and filters JSON URL encoding documented.
