# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: FAIL — 4 of 5 channel legs evaluated and all 4 mismatch the spec equality (Facebook, Instagram, Twitter, TikTok); LinkedIn leg not evaluable (0 posts in the date range).**

- Run: 2026-10-26 (Monday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view (default `perspective=extended`)
- Account / brand (Monday rotation, first row): **HBO Max** (account_id=657) / **HBO Max** (brand_id=155614), brand picked from the typeahead Results via exact title match `.lfm-ta-option[title="HBO Max"]` (Rule 1). Account reached through the profile-menu account switcher (real mouse click on the option).
- Date range (app default): Oct. 18 – Oct. 24, 2026 (compare Oct. 11 – Oct. 17); Mode Lifetime (Content); Data set Public; "Data Last Updated (PT): 10-25-2026 04:46 PM".
- Scope note: only the first Monday row (HBO Max) was run, same scoping as the 2026-10-20 run. The Description table also lists Amazon Prime Video/Amazon Prime Video and Conde Nast/Vogue-US for Monday; these were not run.
- Earlier attempt today timed out at 900 s without a report (results.tsv: TIMEOUT); this report supersedes it.

## Steps executed (per channel, spec order)
1. Brand (top nav hover) > Content.
2. Add brand: opened the brand picker, typed "HBO Max", clicked the exact Results row "HBO Max" (the list also had "HBO Max (ANZ)", "HBO Max Family", etc.; none used).
3. Channels: clicked channel icons so ONLY the channel under test was enabled (verified `.channel-ghost.enabled` set == {channel}), clicked **Apply**. Channel selection resets to defaults whenever Content/Insights is opened from the nav, so it was redone each time.
4. Table View: noted **Engagements** and **Response Rate** of Rank 1 (grid sort is Response/Engagements desc, Rank 1 = first post).
5. Brand (top nav hover) > Insights.
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`), noted the tooltip **Value**.
8. Computed Engagements / Total Followers x 100 and compared with the first post's Response Rate.

Order of channels run: Facebook, Instagram, Twitter, TikTok, LinkedIn. Each page was reached via the Brand nav menu, not a URL.

## Data captured
| Channel | First post (Content, Table View) | Engagements | Response Rate (UI) | Total Followers (Insights tooltip Value) | Calculated Eng / TF x 100 | Implied denominator (Eng / UI RR) |
|---|---|---|---|---|---|---|
| Facebook | Tue Oct 20, 01:25 PM PDT (28 posts) | 1,325,829 | 7.17% | 18,542,916 (comparison 18,419,755, +123,161) | 7.1503% -> 7.15% | ~18.49 M |
| Instagram | Tue Oct 20, 01:18 PM PDT (40 posts) | 247,861 | 4.65% | 5,343,768 (comparison 5,329,425, +14,343) | 4.6385% -> 4.64% | ~5.33 M |
| Twitter | Fri Oct 23, 10:04 AM PDT (14 posts) | 3,711 | 0.19% | 3,329,453 (comparison 3,333,550, -4,097) | 0.1115% -> 0.11% | ~1.95 M |
| TikTok | Sun Oct 18, 01:54 PM PDT (126 posts) | 400,339 | 6.16% | 6,600,000 (comparison 6,500,000, +100,000) | 6.0657% -> 6.07% | ~6.5 M |
| LinkedIn | none — Posts (0) | n/a | n/a | 73,330 (comparison 73,334, -4) | n/a | n/a |

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng/TF x 100 == first post Response Rate | 7.15% calculated vs 7.17% UI (delta 0.02 pp) | FAIL |
| A8-IG | 8 | match | 4.64% calculated vs 4.65% UI (delta 0.01 pp) | FAIL |
| A8-TW | 8 | match | 0.11% calculated vs 0.19% UI (delta 0.08 pp, ~70% relative) | FAIL |
| A8-TT | 8 | match | 6.07% calculated vs 6.16% UI (delta 0.09 pp) | FAIL |
| A8-LI | 8 | match | LinkedIn has 0 posts for Oct 18-24 (HBO Max LinkedIn has no posts in the default week; same as QA-24276/24278 note) — no first post to compare | N/A (no data) |

## Analysis (evidence for the mismatches)
- The deltas are not rounding: each calculated value differs from the UI beyond the 2-decimal display rounding.
- Facebook / Instagram / TikTok are consistent with the UI dividing by a follower count from an earlier point in the week rather than the period-end Total Followers: TikTok 400,339 / 6,500,000 (the Insights comparison value) = 6.159% -> 6.16% matches the UI exactly; Instagram 247,861 / 5,329,425 (comparison value) = 4.651% -> 4.65% matches; Facebook needs ~18.49 M, between the comparison (18.42 M) and period-end (18.54 M) values, consistent with a follower count as of the Oct 20 post date.
- Cross-check on Facebook Rank 2 (Sat Oct 24, 32,606 Eng, UI 0.18%): 32,606 / 18,542,916 = 0.176% -> 0.18% matches — the later post lines up with the period-end figure.
- Twitter is NOT explained by a timing difference: Total Followers moved only -4,097 over the week, yet the UI rate implies a denominator of ~1.95 M versus 3.33 M shown on Insights (Rank 2: 957 Eng, UI 0.05% implies a similar ~1.9-2.0 M; 957 / 3,329,453 = 0.029%). Either Twitter Response Rate uses a different follower datapoint than the Insights Total Followers tile, or one of the two is wrong. Not resolved in this run.
- The 2026-10-20 UCLA run matched on 4 of 4 legs because UCLA follower counts barely moved within the week; the HBO Max run exposes the dependency on the follower snapshot.

## Evidence (screenshots in .playwright-out/QA-21874/)
- mon-01-content-landing.png, mon-02-fb-applied.png, mon-03-fb-content-table.png, mon-04-fb-followers-hover.png
- mon-instagram-content-table.png, mon-instagram-insights-followers-hover.png
- mon-twitter-content-table.png, mon-twitter-insights-followers-hover.png
- mon-tiktok-content-table.png, mon-tiktok-insights-followers-hover.png
- mon-linkedin-content-table.png, mon-linkedin-insights-followers-hover.png
- mon-tw-nav-stuck.png (transient "Loading..." shell, recovered by one reload)

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `results/open-bugs-2026-10-26.json` has no entry for QA-21874. bug-history.md has no QA-21874 entry; known-quirks.md has no accepted-behavior entry for Response Rate vs Total Followers timing.
- No documented open bug accounts for these mismatches, so they are recorded as new findings in this report only (not attributed to a known bug).

## Environment notes (not product verdicts)
- After the account switch the app sat on "Loading..." for >60 s; one reload recovered it (account HBO Max, account_id=657).
- Facebook Content showed "Loading" tiles for ~3 minutes after Apply, then rendered (Posts (28)) without a reload — inside the 5-minute step budget.
- One nav click left the app shell on "Loading..." (title "Brand Explorer"); one reload recovered it.

## Bugs filed
None filed in Jira (markdown-only). Candidate defects for review:
1. Brand > Content Response Rate (Twitter) does not equal Engagements / Brand Insights Total Followers (HBO Max, Oct 18-24: 3,711 / 3,329,453 = 0.11% vs UI 0.19%).
2. Response Rate on Facebook/Instagram/TikTok first posts differs from the spec formula by 0.01-0.09 pp when follower counts change during the week (denominator appears to be a post-date or period-start snapshot rather than the Insights Total Followers value). May be intended behavior; spec/product owner to confirm.
