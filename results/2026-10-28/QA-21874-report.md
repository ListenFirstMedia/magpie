# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: PASS — Facebook, Instagram, Twitter and TikTok each satisfy Engagements / Total Followers x 100 == first post Response Rate (2-decimal rounding). LinkedIn is N/A: Apple Music has no LinkedIn data (channel disabled on Insights, 0 posts on Content).**

- Run: 2026-10-28 (Wednesday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view (default `perspective=extended`), Data set Public.
- Account / brand (Wednesday rotation, first row of the Description table): **Apple Services** (account_id=409) / **Apple Music** (brand_id=31783). Account reached via the profile-menu account switcher (real mouse click on the option, confirmed `ACCOUNT: APPLE SERVICES`). The brand picker already showed Apple Music, but it was re-selected from the typeahead Results via exact-title match (Rule 1).
- Date range (app default): Oct. 20 – Oct. 26, 2026 (compare Oct. 13 – Oct. 19); Mode Lifetime (Content); grid sort = `responses_mixed` desc; "first post" = Rank 1 / first table row.
- Scope note: only the first Wednesday row (Apple Services / Apple Music) was run, same scoping as earlier runs of this case. The Description table also lists NBCU Enterprises with CNBC and NBC News for Wednesday; not run. The case Notes map Wednesday to "Apple Services/Wasserman", which conflicts with the Description table; the table (Apple Services, NBCU EnterPrises) was treated as authoritative and Apple Services is common to both.

## Steps executed (per channel, spec order)
1. Brand (top nav hover) > Content.
2. Add brand: opened the brand picker, typed "Apple Music", clicked the exact Results row.
3. Channels: clicked channel icons so ONLY the channel under test was enabled (verified `.channel-ghost.enabled` set == {channel}), clicked **Apply**. Channel selection resets whenever Content/Insights is opened from the nav, so it was redone on each page.
4. Table View: noted **Engagements** and **Response Rate** of Rank 1.
5. Brand (top nav hover) > Insights (reached via nav menu, not URL).
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`) and read the tooltip **Value** (`big-number-tooltip__table`; also equals the element `title`).
8. Computed Engagements / Total Followers x 100 and compared with the first post's Response Rate.

Channel order: Facebook, Instagram, Twitter, TikTok, LinkedIn.

## Data captured
| Channel | Posts in range | First post (Rank 1) | Engagements | Response Rate (UI) | Total Followers (tooltip Value) | Tooltip comparison / change | Calculated Eng / TF x 100 |
|---|---|---|---|---|---|---|---|
| Facebook | 7 | Mon Oct 26, 06:51 PM PDT | 11,341 | 0.24% | 4,682,184 | 4,675,055 / +7,129 | 0.2422% -> 0.24% |
| Instagram | 23 | Mon Oct 26, 06:52 PM PDT | 572,195 | 9.77% | 5,856,736 | 5,825,541 / +31,195 | 9.7694% -> 9.77% |
| Twitter | 8 | Wed Oct 21, 08:01 AM PDT | 32,414 | 0.27% | 11,797,721 | 11,798,509 / -788 | 0.2748% -> 0.27% |
| TikTok | 22 | Mon Oct 26, 06:52 PM PDT | 127,051 | 6.05% | 2,100,000 | 2,000,000 / +100,000 | 6.0501% -> 6.05% |
| LinkedIn | 0 | none | – | – | n/a (channel disabled on Insights) | n/a | n/a |

Rank 2 spot-check (Eng / RR; informational only, the assertion is on the first post): Facebook 6,499 / 0.14% (calc 0.139%, match), Twitter 21,428 / 0.18% (calc 0.182%, match), TikTok 70,382 / 3.35% (calc 3.352%, match). **Instagram does not match at 2 decimals:** 283,288 / 5,856,736 = 4.837% (4.84%) vs UI 4.85%, a 0.013-point gap. It is outside the spec's first-post assertion, so it does not change the verdict. It is consistent with the Response Rate denominator being a follower snapshot taken at a different time than the period-end Total Followers, the same pattern seen on HBO Max on 2026-10-26.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng / TF x 100 == first post Response Rate | 11,341 / 4,682,184 = 0.2422% -> 0.24% == 0.24% | PASS |
| A8-IG | 8 | match | 572,195 / 5,856,736 = 9.7694% -> 9.77% == 9.77% | PASS |
| A8-TW | 8 | match | 32,414 / 11,797,721 = 0.2748% -> 0.27% == 0.27% | PASS |
| A8-TT | 8 | match | 127,051 / 2,100,000 = 6.0501% -> 6.05% == 6.05% | PASS |
| A8-LI | 8 | match | Apple Music has no LinkedIn data: Content shows "Posts (0)" / "There is no data available", and the LinkedIn icon is `disabled` on Insights. Nothing to compare. | N/A (not a failure) |

Note on A8-IG: the unrounded calculation (9.7694%) rounds to 9.77%, so the first-post display matches. The Instagram and TikTok legs have large Response Rates, so they discriminate between denominators better than the low-percentage legs do; see the Instagram Rank 2 gap above.

## Evidence (screenshots in .playwright-out/QA-21874/)
- wed-01-content-landing.png (Content landing, Apple Music)
- wed-02-fb-content-table.png, wed-{instagram,twitter,tiktok}-content-table.png (Table View, Rank 1 row)
- wed-03-fb-insights.png, wed-03-fb-followers-hover.png, wed-{instagram,twitter,tiktok}-followers-hover.png (Total Followers tooltip)
- wed-linkedin-content-empty.png (LinkedIn on Content: Posts (0)), wed-linkedin-insights-state.png (LinkedIn icon disabled on Insights)
- Values above were read from the DOM (table cells, tooltip text, `title` attribute); tooltip text and `title` agreed on every channel. Screenshots were saved but not visually inspected, since every assertion was read from the DOM.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md has no QA-21874 entry; no bug reproduced.
- Context from known-quirks: this case failed on HBO Max on 2026-10-26 and passed on UCLA on 2026-10-20 and 2026-10-27, which points to brand-specific follower drift rather than the formula. Apple Music passes on all four channels with data. This run does not contradict the HBO Max finding; the Apple Music follower changes were small (Facebook +0.15%, Instagram +0.54%, Twitter -0.01%) except TikTok (+5%), and TikTok still matched at the displayed denominator.

## Environment notes (not product verdicts)
- Login, account switch, Content and Insights all loaded without reloads or render hangs. The brand-picker typeahead returned results within the polling window.
- The browser started on about:blank. The helper library was loaded without the prod bootstrap, and only the dev tab was used.
- The LinkedIn leg is a data-absence N/A, not a skipped step: the spec's channel list is generic and Apple Music has no LinkedIn presence.

## Bugs filed
None.
