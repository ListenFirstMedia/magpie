# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: PASS (4 of 5 channel legs verified; Facebook leg not evaluable — first post's Response Rate is "–" = no data)**

- Run: 2026-10-20 (Tuesday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view
- Account / brand (Tuesday rotation): **UCLA** (account_id=799) / **University of California, Los Angeles** (brand_id=127756) — brand picked from the typeahead Results via exact title match (Rule 1)
- Date range (default): Oct. 12 – Oct. 18, 2026; Mode Lifetime (Content) / Active Posts (Insights); Data set Public
- Scope note: only the first Tuesday row (UCLA) was run. The Description table also lists Viacom/MTV and Wasserman/Gatorade for Tuesday; the case Notes name only UCLA for Tuesday, so those were not run.

## Steps executed (per channel, spec order)
1. Brand (top nav, hover) > Content.
2. Add brand: opened brand picker, typed "University of California, Los Angeles", clicked exact Results row `.lfm-ta-option[title="University of California, Los Angeles"]`.
3. Channels: clicked the channel icons so ONLY the channel under test was enabled (verified `.channel-ghost.<ch>.enabled` set == {ch}), clicked **Apply**.
4. Table View: noted **Engagements** and **Response Rate** of Rank 1 (the grid sort is Engagements desc, so Rank 1 = first post).
5. Brand (top nav, hover) > Insights.
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`), noted the tooltip Value (also equals the `title` attribute).
8. Calculated Engagements / Total Followers x 100, compared to the first post's Response Rate.

Channels run in order: Facebook, Instagram, Twitter, TikTok, LinkedIn. Each Content/Insights page was reached through the Brand nav menu (hover + click), not a URL.

## Data captured
| Channel | First post (Content, Table View) | Engagements | Response Rate (UI) | Total Followers (Insights tooltip Value) | Calculated Eng / TF x 100 |
|---|---|---|---|---|---|
| Facebook | Wed Oct 14, 09:14 AM PDT | 704 | **–** | 556,791 (comparison 556,749, +42) | 0.1264% |
| Instagram | Fri Oct 16, 04:12 PM PDT | 2,120 | 0.39% | 544,768 (comparison 543,542, +1,226) | 0.3892% |
| Twitter | Thu Oct 15, 04:00 PM PDT | 77 | 0.03% | 259,449 (comparison 259,501, -52) | 0.0297% |
| TikTok | Sat Oct 17, 12:07 PM PDT | 132 | 0.06% | 233,400 (comparison 232,500, +900) | 0.0566% |
| LinkedIn | Wed Oct 14, 09:14 AM PDT | 698 | 0.07% | 1,022,615 (comparison 1,021,615, +1,000) | 0.0683% |

Post counts (Content, default week): Facebook 35, Instagram 13, Twitter 32, TikTok 11, LinkedIn 33.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng/TF x 100 == first post Response Rate (Facebook) | Calculated 0.1264%; first post Response Rate is "–" (no data). Not comparable. Cross-check: for the 16 other Facebook posts that DO have a rate, Eng / 556,791 x 100 rounds to the displayed value on 16/16 (e.g. 236 -> 0.0424 = 0.04%; 24 -> 0.0043 = <0.01%). The "–" posts are exactly the Oct 14, 15, 17, 18 posts; the rated posts are all Oct 12, 13, 16. | N/A (no data) — see note |
| A8-IG | 8 | match | 0.3892% rounds to 0.39% == 0.39% | PASS |
| A8-TW | 8 | match | 0.0297% rounds to 0.03% == 0.03% | PASS |
| A8-TT | 8 | match | 0.0566% rounds to 0.06% == 0.06% | PASS |
| A8-LI | 8 | match | 0.0683% rounds to 0.07% == 0.07% | PASS |

**Facebook note:** the spec assertion cannot be literally satisfied because the first post's rate is "–". This is the documented exclusion behavior (skill `response-rate-math-verifier`: a missing-denominator day renders "–"; `known-quirks.md` "Em-dash = missing day"), and the Facebook Posts Insights Disruption banner was active in the app. It is inferred (not directly confirmed day by day) that Facebook follower data is absent for Oct 14, 15, 17, 18; the Insights Follower Growth chart shows bars only for Oct 12, 13, 16. If the reviewer wants a strict reading, the Facebook leg is the single open item; the formula itself held on every Facebook post that has a rate.

## Evidence (screenshots in .playwright-out/QA-21874/)
- 01-content-landing.png, 02-content-loaded.png, 03-brand-picker.png (brand selection)
- 04-fb-only-applied.png, 05-fb-table-view.png (Facebook only, first post)
- 06-fb-total-followers-hover.png (Facebook tooltip: Value 556,791)
- {instagram,twitter,tiktok,linkedin}-content-table.png and -insights-followers-hover.png (LinkedIn also linkedin-insights.png)

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md has no QA-21874 entry. No bug reproduced that interferes with the assertions.
- Related surface: Facebook Posts Insights Disruption (status banner, 2 incidents) is plausibly why Facebook Response Rate / follower data is missing on some days; it is a platform incident, not filed here.

## Notes / observations
- LinkedIn's Total Followers tile uses a different datapoint (`lfm.audience_ratings.linkedin_audience_footprint`) than the other channels (`...public_audience_footprint_v5`); selectors keyed on the latter miss LinkedIn.
- Rate formula confirmed: Response Rate = Engagements / Total Followers x 100 (period-end Total Followers).
- Channel selection is reset to the default set each time Content/Insights is opened from the nav; the "last enabled channel can't be unticked" order was handled by enabling the target channel first.

## Bugs filed
None.
