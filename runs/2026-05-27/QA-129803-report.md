# QA-129803 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Facebook

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-129803
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Wasserman
- **Brand:** FIA World Endurance Championship (FIAWEC)
- **Date Range:** Sep 26, 2025 – Oct 3, 2025
- **Channel:** Facebook
- **Priority:** Critical (P2)
- **Result:** ⏸ **DEFERRED — Same TWC + Google Sheets + day-wise Response Rate math flow as QA-129606 but for Facebook. Not attempted because QA-129606 (preceding test on Twitter+TikTok) already hit the date picker friction and ran out of session budget. Pattern is identical to QA-129606; LFIQA can run all three channels (Twitter, TikTok, Facebook) in a single manual session.**

## Steps the LFIQA manual run should cover

1. Reporting → Time Window Comparison → Wasserman
2. Brand: FIA World Endurance Championship (FIAWEC)
3. Absolute Dates, Days interval, Sep 26 – Oct 3, 2025
4. By Channel → **Facebook**
5. Metrics: Audience & Growth > **Total Fans** (note: different from QA-129606 which uses Total Followers); Content > Engagements, Posts, Response Rate
6. Run Report → review
7. Export → Google Sheets

## Assertion targets
- A1: Report loads with no errors
- A2: Engagements UI = Sheet
- A3: Total Fans UI = Sheet (only days where Total Fans exists)
- A4: Response Rate UI = Sheet (only days where Total Fans exists)
- A5: Day-wise Response Rate = `Engagements / (Total Fans × Posts) × 100` — math holds per day

## Note on dependency
QA-129803 is essentially QA-129606 with Facebook channel + "Total Fans" instead of "Total Followers". When LFIQA runs QA-129606 manually, they can run QA-129803 in parallel by adding Facebook to the channel selector and Total Fans to the metric tree.

## Skill registry impact
Same as QA-129606 — see that report for details.

## Sources
- [QA-129803 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-129803)
- [QA-129606 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-129606) (sibling test)
