# QA-38198 — Reporting - Data QA - Social Recap Year - Date

**Run date:** 2026-10-22 · **Track:** Playwright MCP, unattended/headless (`claude -p`) · **Account:** Sephora (switched from FX Networks via LFQA menu → Search Account → Results row; breadcrumb `ACCOUNT: SEPHORA`)
**Flow:** Reporting → Social Recap → brand **Sephora** (typeahead, literal "Sephora" first result — Rule 1), **Authorized Data** (toggle `0-perspective-toggle` clicked via its label; `checked` false → true — Rule 2), all 7 channels on (Everything **On** clicked; Facebook/Twitter/Instagram/YouTube/TikTok/LinkedIn/Threads all `aria-checked=true`), default Week interval → story **161558** "Weekly Social Recap (Oct 14, 2026 – Oct 20, 2026)". Target section: **"3 Social Activity - Year to Date"**.

**Verdict: PASS (4/4) — each channel-table sum equals the donut total exactly. Caveat: the donut hover tooltip (`.al-donut__tooltip`) moves with the pointer but renders no text under headless Chrome (known limitation, same as QA-24894), so the literal tooltip string was NOT read. The "tooltip value" was instead derived from the chart's own bound data: each arc's `__data__` carries `value` and `share`, so `value ÷ share` = the donut total (identical for every arc), and the big number matches it at display precision.**

## Steps executed
1. Hovered Reporting nav → clicked Social Recap (lands on `app-reporting.lfmdev.in/#/social_recap`).
2. (Account precondition) Switched account FX Networks → Sephora.
3. Added Sephora, set Authorized perspective (toggle state verified before/after).
4. Selected all channels (Everything On; all 7 verified checked).
5. Run Report → "Building Your Story" → View Now (the Zendesk Help iframe overlapped Run Report; set `pointer-events:none` on page iframes, then real mouse click).
6–13. Read the "Social Activity - Year to Date" channel tables and four donuts (screenshots `06`–`08`).

## Section 3 — Social Activity, Year to Date (Sephora, Authorized)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 6–7 | Sum of FB + TW + IG + YT + TikTok Paid + LinkedIn Impressions = donut Impressions total | FB 6,330,255,604 + TW 103 + IG 813,340,363 + YT – + TikTok Paid 902,022,997 + LinkedIn – = **8,045,619,067**. Donut big number **8B**; arc `value÷share` total = **8,045,619,067** (exact). Shares: FB 78.7%→79%, IG 10.1%→10%, TikTok 11.2%→11% (table agrees). | PASS |
| A9 | 8–9 | Sum of FB (Organic+Paid) + IG + TW + YT + TikTok + LinkedIn Video Views = donut Video Views total | FB 437,198,476 (= Organic 32,696,927 + Paid 404,501,549 ✓) + IG 813,340,363 + TW 107,036 + YT 43,756,812 + TikTok 996,166,366 + LinkedIn – = **2,290,569,053**. Donut **2B**; arc `value÷share` = **2,290,569,053** (exact). (TikTok Paid 891,641,009 is a sub-row of TikTok, not added again.) | PASS |
| A11 | 10–11 | Sum of FB + IG + TW + YT + TikTok + LinkedIn Engagements = donut Engagements total | 452,664 + 12,254,216 + 0 + 953,381 + 6,738,349 + LinkedIn – (Threads 0) = **20,398,610**. Donut **20M**; arc `value÷share` = **20,398,610** (exact). | PASS |
| A13 | 12–13 | Sum of **positive** New Followers = donut New Followers total | FB −1,666 (skipped) · TW −23,445 (skipped) · IG −146,670 (skipped) · YT 90,000 + TikTok 400,000 + LinkedIn 390,789 = **880,789**. Donut **881K**; arc `value÷share` = **880,789** (exact). Including the negatives would give 709,008 (≈709K ≠ 881K), confirming the spec's exclusion rule. | PASS |

## Evidence
- Screenshots: `.playwright-out/QA-38198/01-home-menu.png`, `02-builder-typeahead.png`, `03-authorized.png`, `04-channels.png`, `05-after-run-click.png` (shows the Help widget overlap), `06-ytd-donut-hover.png` (YTD donuts 8B / 881K / 20M / 2B with YOY: +40% / −4% / +4% / +7%), `07-ytd-tables-a.png`, `08-ytd-tables-b.png`.
- Tooltip attempt: real mouse moves over the donut centre and over arc edges of the YTD Impressions donut; `.al-donut__tooltip` position updated (`translate3d(194px,283px…)`) but `innerText` was empty and nothing was visible in `06-…png`.
- Supplementary (weekly section 2, Oct 14–20, same story, not part of the case): the same identities hold at display precision — Impressions 152,436,298 → 152M; Video Views 46,367,027 → 46M; Engagements 611,639 → 612K; positive New Followers 31,985 → 32K.

## Known bugs checked
- **APPS-58195** (Code Review): Social Recap > FB and TW > negative value displayed for Video Views and Engagements — **not reproduced.** In the YTD section FB Video Views 437,198,476, FB Engagements 452,664, TW Video Views 107,036, TW Engagements 0 (no negatives); the weekly section is likewise non-negative for those two metrics. The only negatives on the page are New Followers rows (FB −1,666, TW −23,445, IG −146,670), which is normal follower churn and is what the spec's "don't add −ve followers" note covers. The bug does not touch assertions 9/11, so it does not change the verdict. (Rule 7 would auto-fail this case on the open-bug list; this run executed it per the run instructions and the interactive policy in known-quirks — the bug does not interfere.)
- LFMP-32081 (Social Recap – Negative Engagements, Sephora) — not reproduced (all Engagements rows ≥ 0).
- LFMP-31925 (%YOY missing in Video Views donut) — not reproduced: YTD Video Views shows "7% YOY".
- Facebook Organic Impressions deprecated (Dec 15, 2025 precondition): Facebook Impressions row is the page-insight impressions value and "Facebook Paid" is a sub-row; the donut's Facebook arc uses the Facebook row (6,330,255,604) — consistent with the spec's "Facebook Impressions".

## Bugs filed
None. (Markdown-only; nothing created in Jira.)

## Cleanup
None required (read-only). Story 161558 persists like any manually-run report.

## Notes for skill maintenance (deferred to harvest.sh)
- Donut exact totals are obtainable without the tooltip: `document.querySelectorAll('svg.donut')[i].querySelectorAll('path')` → `path.__data__.data.{value,share,dataPoint}`; total = `value/share`. Sections are `svg.donut` indices 0–3 = weekly, 4–7 = Year to Date (order Impressions, New Followers, Engagements, Video Views).
- Account precondition: dev login lands on FX Networks; switch via LFQA hover menu → `Search Account` → mouse-click the `.lfm-ta-option`.
- Social Recap builder: the Zendesk Help iframe overlaps Run Report at default viewport — set `pointer-events:none` on page iframes (or minimise) before clicking; the Authorized toggle input is not visible, so click `label[for="0-perspective-toggle"]` by bounding box.
