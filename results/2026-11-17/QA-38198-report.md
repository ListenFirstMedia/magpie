# QA-38198 — Reporting - Data QA - Social Recap Year - Date

**Run date:** 2026-11-17 · **Track:** Playwright MCP, unattended (`claude -p`) · **Env:** dev (`app-reporting.lfmdev.in`) · **Account:** Sephora (switched from Adam Orfei via LFQA menu → Search Account → `.lfm-ta-option` "Sephora"; breadcrumb `ACCOUNT: SEPHORA`)
**Flow:** Reporting (hover) → Social Recap → brand **Sephora** (literal first typeahead option `div.al-typeahead__option` "Sephora", Rule 1; not the Sephora-<store> variants), **Authorized Data** (label `for="0-perspective-toggle"` clicked; `checked` false → true, Rule 2), Everything **On** (Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads all checked), default Week interval → Run Report → story **162866** "Weekly Social Recap (Nov 9, 2026 – Nov 15, 2026)". Target section: **"Social Activity - Year to Date"**.

## Verdict: FAILED (open linked bug APPS-58195) — all 4 data assertions are numerically satisfied

Per the open-bug policy (known-quirks; confirmed by the user 2026-10-22: any open linked bug = FAILED in the report and the Xray execution), the case verdict is FAILED, attributed to **APPS-58195** ("Social Recap > FB and TW > Negative value displayed for the Video Views and Engagements", Code Review as of the 2026-10-20 case cache; no Jira access in this headless run to re-check its status). The case was run in full to gather evidence. The bug did **not** reproduce and every identity holds. Once APPS-58195 closes and the case cache is refreshed, this case should be PASS.

**Caveat (tooltip):** the donut hover tooltip (`.al-donut__tooltip`) renders no text under headless Playwright Chrome. A real `mouse.move` over the first arc of each YTD donut (indices 4–7) left no tooltip text anywhere in the DOM; this is the known limitation (skill v4). The "data-tooltip total" was therefore derived from the chart's own bound data: each arc's `__data__.data` carries `value` and `share`, and `value ÷ share` = the donut total. That total matches the big number at its display precision, and the share ratios match the page data to full float precision.

## Steps executed
1. Login via Cognito "With existing account" (succeeded first try). Account switched to Sephora (breadcrumb verified).
2. Hovered Reporting → clicked Social Recap (`app-reporting.lfmdev.in/#/social_recap`).
3. Typed "Sephora" into `input.al-typeahead__text-input` (first attempt showed no list; retyping with slower keystrokes opened it), clicked the literal "Sephora" option by bounding box, clicked the Authorized label; verified `#0-perspective-toggle` checked = true.
4. Everything → On; all 7 channels checked.
5. Run Report. **Incident:** my first Run Report click landed on the Zendesk "Contact us" help widget (iframe `#webWidget`) that overlaps the button, so no report started. The following bounded-wait loop then sat idle; the session also logged `ERR_NETWORK_CHANGED` / `ERR_NAME_NOT_RESOLVED` (a local network change), and the MCP call aborted after ~2109 s. This was a tooling and environment problem, not an app render hang: the app itself never started building. After hiding the widget and re-clicking Run Report, the story rendered within ~15 s (162866; 8 `svg.donut` charts).
6–13. Read the four "Social Activity - Year to Date" channel tables and the four donuts.

## Assertions (Sephora, Authorized, Social Activity - Year to Date, story 162866)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 6–7 | Sum of FB + TW + IG + YT + TikTok Paid + LinkedIn Impressions = donut Impressions total | FB 7,278,533,880 + TW 103 + IG 887,634,821 + YT – + TikTok Paid 950,122,357 + LinkedIn – = **9,116,291,161**. Donut big number **9B**; FB arc share 0.7984095452258011 = 7,278,533,880 ÷ 9,116,291,161 exactly, so the donut total is 9,116,291,161. | Data match ✓ |
| A9 | 8–9 | Sum of FB (Organic+Paid) + IG + TW + YT + TikTok + LinkedIn Video Views = donut Video Views total | FB 502,909,945 (= Organic 34,889,211 + Paid 468,020,734 ✓) + IG 887,634,821 + TW 107,036 + YT 46,950,284 + TikTok 1,042,150,756 + LinkedIn – = **2,479,752,842**. Donut **2B** (2.48B at display precision); TikTok arc share 0.42026396274213845 matches exactly. (TikTok Paid 939,204,955 is a sub-row, not re-added.) | Data match ✓ |
| A11 | 10–11 | Sum of FB + IG + TW + YT + TikTok + LinkedIn Engagements = donut Engagements total | 461,475 + 13,557,169 + 0 + 993,591 + 7,083,065 + LinkedIn – (Threads 0) = **22,095,300**. Donut **22M**; YouTube arc share 0.044968432200513234 matches exactly. | Data match ✓ |
| A13 | 12–13 | Sum of **positive** New Followers = donut New Followers total | YT 90,000 + TikTok 500,000 + LinkedIn 427,414 = **1,017,414**; skipped negatives FB −12,231, TW −25,629, IG −112,329. Donut **1M**; LinkedIn arc share 0.4200984063517899 matches exactly. Including the negatives would give 867,225, which does not match (1M), confirming the spec's exclusion rule. | Data match ✓ |

All four data identities hold. Overall case status: **FAILED** solely because of the open linked bug (policy), not because of any assertion mismatch. The tooltip text itself could not be read (see caveat), so "data-tooltip" equality is verified through the chart's bound data.

## Evidence
- Screenshots in `.playwright-out/QA-38198/`: `01-home.png`, `02-acct-search.png`, `03-sephora.png`, `04-builder.png`, `05-typeahead.png` / `05-typeahead2.png`, `06-brand-added.png`, `07-authorized.png`, `08-channels.png`, `09-state-after-hang.png` (Contact-us widget covering Run Report), `10-after-run-click.png`, `11-after-run.png`, `12-story.png`, `13-ytd-donut-hover.png`, `14-ytd-donuts.png`.
- Same story, weekly section "Social Activity - November 09, 2026 - November 15, 2026" (supplementary): Impressions 155M (121,671,082 + 23,008,051 + 10,297,052 = 154,976,185 ✓); Engagements 414K (3,342 + 355,518 + 9,901 + 45,114 = 413,875 ✓); New Followers 17K (positives 8,902 + 8,433 = 17,335 ✓, FB −24,094 and TW −427 skipped); Video Views 40M (10,347,395 + 23,008,051 + 719,518 + 6,286,833 = 40,361,797 ✓). The identities hold there too.

## Known bugs checked
- **APPS-58195** (Code Review as of 2026-10-20): Social Recap > FB and TW > negative value displayed for Video Views and Engagements — **not reproduced.** YTD: FB Video Views 502,909,945, FB Engagements 461,475, TW Video Views 107,036, TW Engagements 0; weekly: FB VV 10,347,395, FB Eng 3,342, TW VV 0, TW Eng 0 — no negatives. The only negatives on the page are New Followers rows (YTD FB −12,231, TW −25,629, IG −112,329; weekly FB −24,094, TW −427), which are normal follower churn and are what the spec's "don't add −ve followers" note covers. The bug does not touch the assertions, but the open-bug policy still sets the verdict to FAILED. Its current status could not be re-checked (no Jira in headless run); if it has since closed, this case should be PASS.
- Facebook Organic Impressions deprecated (Dec 15, 2025 precondition): the Facebook Impressions row is the page-level value and "Facebook Paid" is a sub-row (3,043,218,139, not re-added), consistent with the spec's "Facebook Impressions".
- LFMP-31925 (%YOY missing in Video Views donut): not reproduced; the Video Views donuts show "5% YOY" (YTD) and "-56% YOY" (weekly).
- No bug-history entries or other linked bugs for QA-38198.

## Bugs filed
None. (Markdown-only; nothing created in Jira.)

## Cleanup
None required (read-only). Story 162866 persists like any manually-run report.

## Notes for skill maintenance (deferred to harvest.sh)
- The **Zendesk "Contact us" widget iframe (`iframe#webWidget`, ~374×572 at the bottom-right) can cover the Run Report button**. A bounding-box mouse click then lands on the widget and nothing runs. Minimize or hide it first (`document.getElementById('webWidget').style.display='none'`), or click Run Report via its locator, and never wait on "View Now" without first confirming the run started (URL → `#story/social_recap/<id>`).
- The Social Recap typeahead needs slow keystrokes (≥200 ms) and sometimes a re-type before `div.al-typeahead__option` rows appear. The option class here is `al-typeahead__option`, not `.lfm-ta-option`.
- YTD donuts are `svg.donut` indices 4–7 (Impressions, New Followers, Engagements, Video Views). Totals come from `path.__data__.data.value / .share`.
- `browser_run_code_unsafe` has no `require`/`fs`, so read credentials with Bash. Use bounded loops with a hard time cap, because a hung call can burn the whole idle timeout (~2109 s here).
