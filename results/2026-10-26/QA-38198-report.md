# QA-38198 — Reporting - Data QA - Social Recap Year - Date

**Run date:** 2026-10-26 · **Track:** Playwright MCP, unattended (`claude -p`) · **Account:** Sephora (switched from default via LFQA menu → Search Account → `.lfm-ta-option`; breadcrumb `Account: Sephora`)
**Flow:** Reporting → Social Recap → brand **Sephora** (literal first typeahead result — Rule 1), **Authorized Data** (label `for="0-perspective-toggle"` clicked; `checked` false → true — Rule 2), all 7 channels on (Everything **On** clicked; Facebook/Twitter/Instagram/YouTube/TikTok/LinkedIn/Threads all `aria-checked=true`), default Week interval → story **161748** "Weekly Social Recap (Oct 18, 2026 – Oct 24, 2026)". Target section: **"Social Activity - Year to Date"**.

## Verdict: FAILED (open linked bug APPS-58195) — all 4 data assertions are numerically satisfied

Per the open-bug policy (known-quirks, confirmed by the user 2026-10-22: any open linked bug = FAILED, in the report and in the Xray execution), the case verdict is FAILED, attributed to **APPS-58195** (Code Review as of the 2026-10-20 cache; no Jira access in this headless run to re-check its status). The case was executed in full per the run instructions to gather evidence; the evidence below shows the bug did **not** reproduce and every assertion matches. Re-run picks it up as PASS once APPS-58195 closes and the case cache is refreshed.

Caveat (tooltip): the donut hover tooltip (`.al-donut__tooltip`) renders no text under this Playwright Chrome session (real `mouse.move` over each YTD donut's first arc → no tooltip text anywhere in the DOM; same known limitation as QA-24894 / skill v4). The "data-tooltip total" was therefore derived from the chart's own bound data: each arc's `__data__.data` carries `value` and `share`; `value ÷ share` = the donut total (identical across arcs). It matches the big number at display precision.

## Steps executed
1. Login via Cognito "With existing account" (first Sign in attempt returned a transient `PreAuthentication … Task timed out after 3.00 seconds` error; retried once → success). Account switched to Sephora.
2. Hovered Reporting → clicked Social Recap (`app-reporting.lfmdev.in/#/social_recap`; page sat on "Loading…" ~60 s then rendered — within the 5-min budget).
3. Typed "Sephora", clicked the literal "Sephora" result (first of the Results list), clicked the Authorized toggle label; verified `checked=true`.
4. Everything → On; all 7 channels verified checked.
5. Run Report → "Building Your Story" → View Now → story 161748.
6–13. Read the four "Social Activity - Year to Date" channel tables and the four donuts.

## Assertions (Sephora, Authorized, Social Activity - Year to Date)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 6–7 | Sum of FB + TW + IG + YT + TikTok Paid + LinkedIn Impressions = donut Impressions total | FB 6,411,009,583 + TW 103 + IG 823,663,385 + YT – + TikTok Paid 908,080,577 + LinkedIn – = **8,142,753,648**. Donut big number **8B**; arc `value÷share` = **8,142,753,648** (exact). | Data match ✓ |
| A9 | 8–9 | Sum of FB (Organic+Paid) + IG + TW + YT + TikTok + LinkedIn Video Views = donut Video Views total | FB 441,855,841 (= Organic 32,894,836 + Paid 408,961,005 ✓) + IG 823,663,385 + TW 107,036 + YT 44,160,938 + TikTok 1,005,230,562 + LinkedIn – = **2,315,017,762**. Donut **2B**; arc `value÷share` = **2,315,017,762** (exact). (TikTok Paid 897,645,503 is a sub-row, not re-added.) | Data match ✓ |
| A11 | 10–11 | Sum of FB + IG + TW + YT + TikTok + LinkedIn Engagements = donut Engagements total | 453,602 + 12,419,105 + 0 + 961,364 + 6,813,511 + LinkedIn – (Threads 0) = **20,647,582**. Donut **21M**; arc `value÷share` = **20,647,582** (exact). | Data match ✓ |
| A13 | 12–13 | Sum of **positive** New Followers = donut New Followers total | FB 2,076 + YT 90,000 + TikTok 400,000 + LinkedIn 396,938 = **889,014**; skipped negatives TW −23,827, IG −140,028. Donut **889K**; arc `value÷share` = **889,014** (exact). Including the negatives would give 725,159 ≠ 889K, confirming the spec's exclusion rule. | Data match ✓ |

All four data identities hold. Overall case status: **FAILED** solely because of the open linked bug (policy), not because of any assertion mismatch.

## Evidence
- Screenshots in `.playwright-out/QA-38198/`: `00-login-state.png` (transient Cognito error), `01-home-menu.png`, `02-builder.png` (Loading…), `02-builder-typeahead.png`, `02b-brand-added.png`, `03-authorized.png`, `04-channels.png`, `05-after-run.png`, `06-ytd-donuts.png`.
- Weekly section (Oct 18–24, same story, supplementary): Impressions 148,592,428 → 149M; New Followers positives 6,933 + 12,566 + 12,122 = 31,621 → 32K (TW −665 skipped); Engagements 587,504 → 588K; Video Views 45,130,029 → 45M — identities hold there too.

## Known bugs checked
- **APPS-58195** (Code Review as of 2026-10-20): Social Recap > FB and TW > negative value displayed for Video Views and Engagements — **not reproduced.** YTD: FB Video Views 441,855,841, FB Engagements 453,602, TW Video Views 107,036, TW Engagements 0; weekly: FB VV 6,806,830, FB Eng 3,520, TW VV 0, TW Eng 0 — no negatives. The only negatives on the page are New Followers rows (TW −23,827, IG −140,028 YTD; TW −665 weekly), which is normal follower churn and is what the spec's "don't add −ve followers" note covers. The bug does not touch the assertions, but the open-bug policy still sets the verdict to FAILED. Bug status could not be re-checked (no Jira in headless run) — if it has since closed, this case should be PASS.
- Facebook Organic Impressions deprecated (Dec 15, 2025 precondition): Facebook Impressions row is the page-insight impressions value (donut arc `fbpai_impressions`), "Facebook Paid" shown as a sub-row; consistent with the spec's "Facebook Impressions".
- Linked bugs seen in earlier runs (LFMP-32081 negative Engagements, LFMP-31925 %YOY missing in Video Views donut): not probed beyond the above; all Engagements rows ≥ 0.

## Bugs filed
None. (Markdown-only; nothing created in Jira.)

## Cleanup
None required (read-only). Story 161748 persists like any manually-run report.

## Notes for skill maintenance (deferred to harvest.sh)
- Cognito login can throw a transient `PreAuthentication failed … Task timed out after 3.00 seconds` on the first Sign in; a single retry succeeds. `page.waitForURL(/app\.lfmdev\.in/)` matches the auth URL's `redirect_uri` immediately — use a hostname predicate instead.
- Social Recap builder can sit on "Loading…" ~60 s before the typeahead (`input.al-typeahead__text-input`) appears; typeahead options here are NOT `.lfm-ta-option` — click the literal `getByText('Sephora',{exact:true})` result by bounding box.
- YTD donuts are `svg.donut` indices 4–7 (Impressions, New Followers, Engagements, Video Views); totals via `path.__data__.data.value / .share`.
