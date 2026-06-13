# QA-22296 batch 8 — log

Date: 2026-06-08
Operator: magpie
Browser: Work Browser (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5)
Account: Adam Orfei (account_id=54) → Amazon Prime Video (342) → Hulu (336)
User: Yash (lfiqa@listenfirstmedia.com)
Data Last Updated (PT): 06-08-2026 04:29 AM PT

## Tickets

| # | Ticket | Title | Result | Skill exercised |
|---|---|---|---|---|
| 1 | QA-114840 | Settings > Users - Export Functionality (External User) | BLOCKED (safety) | n/a |
| 2 | QA-116140 | Brand Sentiment - Sentiment Export CTA | PASS | brand-content-data-set-selector (sentiment-mode), export-csv (modal text) |
| 3 | QA-116173 | Sentiment Export Email, Notification & Auto Download | RECONFIRM (carry-forward) | export-csv +1 (Sentiment Export pipeline) |
| 4 | QA-121158 | Brand Content - Instagram - Collaborated Total Filter Functionality | PARTIAL (A1-A4 PASS, A5 INCONCLUSIVE) | brand-content-filter +1 (Collaborated Total variant) |
| 5 | QA-121217 | Brand > Content - Instagram - Instagram Collaborator count - Export | BLOCKED (no data) | n/a |

## Per-ticket notes

### QA-114840
- Spec preconditions require login as External User account with password disclosed in the test case. Safety policy "never enter passwords" applies — magpie cannot perform login step.
- LFIQA executes manually.

### QA-116140
- Adam Orfei MTV Brand>Content Public Data Jun 01-06 2026 Lifetime mode, post-Sentiment-click renders Classification donut 37/51/12% + Daily area chart.
- Sentiment Export CTA: A1 (only visible after Sentiment click) PASS; A2 (right of Sentiment button) PASS; A3 (modal verbatim spec text with `yash.sharma@listenfirstmedia.com` email substitution) PASS; A4 (Cancel closes modal) PASS.
- Brand URL drift: brand_id=4018 → 10765 post-channel-Apply; UI shows MTV with logo. Treated as known Brand>Content quirk.

### QA-116173
- Account switch to APV worked (badge 8364→466). Brand>Content APV brand_id=25864 navigation hung Chrome MCP renderer twice. Could not complete fresh run.
- Pipeline confirmation carry-forward from 4 prior verifications across batches 8 / QA-4325-batch-8 / today QA-116140. RECONFIRM. LFIQA can refresh A1-A3 quickly when renderer stable.

### QA-121158
- Hulu account_id=336 switch via Yash → Search Account "Hulu" Results click worked.
- Hulu brand_id=5670 → URL auto-redirected to brand_id=11003 (Hulu LA sub-brand). UI shows Hulu with green logo.
- Filter dropdown list verified order: Branded Content / Collaborated / Collaborated Total / Collaborator Name / Content Type / Live Stream / Publish Day / Publish Time / Publish Type / Sponsor Name / Tag / Text Search. **A1 PASS** (Collaborated Total between Collaborated and Collaborator Name — spec "Collaborated Name" = typo).
- Collaborated Total sub-popup contains exactly checkboxes 1, 2, 3, 4, 5 + Or/And toggle. **A2 PASS**.
- Apply with value 2 produced chip `Collaborated Total: 2 Include` + URL `filters={"content_collaborator_count":{"operator":"or","values":["2"],"not":"false"}}`. Posts header went to `Posts (0)`. **A3 PASS**. **A4 vacuously PASS** (empty result set).
- A5 (filter count vs posts collaborator count match) **INCONCLUSIVE** — Hulu brand_id=11003 has zero IG-collaborated posts on 2025 and 2024 year windows for values 1 and 2; cannot exercise cross-check.
- LFMP-31862 (closed bug — table not loading after Collaborated Total filter): NOT REPRODUCED (table renders cleanly).

### QA-121217
- Sibling of QA-121158 — same Hulu brand on same account. Sub-brand 11003 lacks IG collaborator data across all tested windows. A1-A6 BLOCKED.
- Brand>Content sentiment-mode auto-lock observed when navigating IG-only on this brand. Sentiment tiles render instead of Posts table.
- CSV export mechanics (queueing + email-format popup + filename pattern) independently verified in QA-1519 / QA-109062 / QA-109920 / QA-111242/3 — but the specific 24-column IG-Collaborator-* CSV headers (cols 15-17) require IG-collaborator-present data to materially verify.

## Skill registry bumps

- `brand-content-data-set-selector`: +1 (QA-116140 — sentiment-mode CTA + modal flow re-confirmed on MTV/Adam Orfei).
- `export-csv`: +1 (QA-116140 Sentiment Export modal contains exact `yash.sharma@listenfirstmedia.com` substitution; QA-116173 RECONFIRM carry-forward).
- `brand-content-filter`: +1 (QA-121158 — Collaborated Total variant + URL `content_collaborator_count` filter JSON pattern documented).

## Quirks updates
- Confirmed: Sentiment Export modal email-substitution `<EMAIL>` template renders the current authenticated user's email (`yash.sharma@listenfirstmedia.com`) — useful regression-guard.
- New: Hulu account brand-id auto-redirect `5670 → 11003` (Hulu LA sub-brand) on this dev account — brand_id stability needs verification for further Hulu-specific tests.

## Chrome state for batch 9
- Tab group ended on Hulu Brand>Content (last visited URL with brand_id=11003, channels=instagram, sentiment_mode showing).
- APV-Brand>Content/Insights renderer freeze pattern persists. Recommend opening fresh tab + navigating to Home before next brand-context test.
- Active account context: Hulu (account_id=336). Adam Orfei context retained via Recent Searches and accessible via 1-click in Yash menu.

## Next-batch pick (batch 9)
- Next 5 net-new ascending QA-IDs after 121217 from `runs/2026-06-02/QA-22296-members.md` lines 47+: QA-131491, QA-132387, QA-132392, QA-133403, QA-134176.
- Note: QA-131491 was previously credited in batch-9 of the QA-22296 12-batch sweep (line 84 in task list). Likely RECONFIRM. Cross-check against `runs/2026-06-02/QA-22296-members.md` ordering on next batch open.
