# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: PASS — all 5 channel legs (Facebook, Instagram, Twitter, TikTok, LinkedIn) satisfy Engagements / Total Followers x 100 == first post Response Rate (2-decimal rounding).**

- Run: 2026-10-27 (Tuesday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view (default `perspective=extended`)
- Account / brand (Tuesday rotation, first row): **UCLA** (account_id=799) / **University of California, Los Angeles** (brand_id=127756). Account reached via the profile-menu account switcher (real mouse click on the option); brand re-selected from the typeahead Results via exact-title match (Rule 1) even though the page had remembered it.
- Date range (app default): Oct. 19 – Oct. 25, 2026 (compare Oct. 12 – Oct. 18); Mode Lifetime (Content); Data set Public. Grid sort = `responses_mixed` desc; "first post" = Rank 1 / first table row.
- Scope note: only the first Tuesday row (UCLA) was run, same scoping as the 2026-10-20 run. The Description table also lists Viacom/MTV and Wasserman/Gatorade for Tuesday; not run.
- Case Notes Tuesday mapping says "UCLA/Sony Pictures"; the Description table (UCLA, Viacom, Wasserman) was treated as authoritative and UCLA is common to both.

## Steps executed (per channel, spec order)
1. Brand (top nav hover) > Content.
2. Add brand: opened the brand picker, typed the full name, clicked the exact Results row "University of California, Los Angeles".
3. Channels: clicked channel icons so ONLY the channel under test was enabled (verified `.channel-ghost.enabled` set == {channel}), clicked **Apply**. Channel selection resets whenever Content/Insights is opened from the nav, so it was redone for each page.
4. Table View: noted **Engagements** and **Response Rate** of Rank 1.
5. Brand (top nav hover) > Insights (reached via nav menu, not URL).
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`), read the tooltip **Value** (also equals the element `title`).
8. Computed Engagements / Total Followers x 100 and compared with the first post's Response Rate.

Order of channels: Facebook, Instagram, Twitter, TikTok, LinkedIn.

## Data captured
| Channel | Posts in range | First post (Rank 1) | Engagements | Response Rate (UI) | Total Followers (tooltip Value) | Tooltip comparison / change | Calculated Eng / TF x 100 |
|---|---|---|---|---|---|---|---|
| Facebook | 33 | Sat Oct 24, 07:00 AM PDT | 1,485 | 0.27% | 557,017 | 556,791 / +226 | 0.2666% -> 0.27% |
| Instagram | 11 | Sat Oct 24, 11:52 AM PDT | 5,028 | 0.92% | 545,767 | 544,768 / +999 | 0.9213% -> 0.92% |
| Twitter | 32 | Sat Oct 24, 11:52 AM PDT | 271 | 0.10% | 259,370 | 259,449 / -79 | 0.1045% -> 0.10% |
| TikTok | 9 | Mon Oct 19, 05:15 PM PDT | 375 | 0.16% | 235,300 | 233,400 / +1,900 | 0.1594% -> 0.16% |
| LinkedIn | 32 | Sat Oct 24, 11:52 AM PDT | 1,270 | 0.12% | 1,023,333 | 1,022,615 / +718 | 0.1241% -> 0.12% |

Rank 2 spot-check (Eng / RR): Facebook 851 / 0.15%, Instagram 3,232 / 0.59%, Twitter 201 / 0.08%, TikTok 336 / 0.14%, LinkedIn 870 / 0.09% — consistent with the same denominators.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng / TF x 100 == first post Response Rate | 1,485 / 557,017 = 0.2666% -> 0.27% == 0.27% | PASS |
| A8-IG | 8 | match | 5,028 / 545,767 = 0.9213% -> 0.92% == 0.92% | PASS |
| A8-TW | 8 | match | 271 / 259,370 = 0.1045% -> 0.10% == 0.10% | PASS |
| A8-TT | 8 | match | 375 / 235,300 = 0.1594% -> 0.16% == 0.16% | PASS |
| A8-LI | 8 | match | 1,270 / 1,023,333 = 0.1241% -> 0.12% == 0.12% | PASS |

## Evidence (screenshots in .playwright-out/QA-21874/)
- tue-01-content-brand.png (Content landing, UCLA brand)
- tue-{facebook,instagram,twitter,tiktok,linkedin}-content-table.png (Table View, Rank 1 row)
- tue-{facebook,instagram,twitter,tiktok,linkedin}-insights-followers-hover.png (Total Followers tooltip)
- Values above were read from the DOM (table cells, tooltip text, `title` attribute); tooltip text and `title` agreed on every channel.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md has no QA-21874 entry; no bug reproduced.
- Note for context: on Monday 2026-10-26 (HBO Max) this case FAILED on 4 legs because the Response Rate denominator appeared to be a snapshot other than the period-end Total Followers (largest on Twitter). UCLA's follower counts moved little over the week (all changes < 0.4%), and every leg matched to the 2-decimal display here, so the UCLA result is consistent with the 2026-10-20 PASS and does not contradict the Monday finding (the UCLA data cannot discriminate between denominators at 2-decimal precision).

## Environment notes (not product verdicts)
- First sign-in redirect landed after the helper's first check; a second `login` call completed it. Account switch, Content and Insights pages loaded without reloads or render hangs.
- Account at login was Amazon Prime Video; switched to UCLA via the account menu.

## Bugs filed
None.
