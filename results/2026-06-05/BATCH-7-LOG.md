# QA-22296 batch 7 — log

Date: 2026-06-08
Operator: magpie
Browser: Work Browser (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5)
Account: Adam Orfei (account_id=54)
User: Yash (lfiqa@listenfirstmedia.com)
Data Last Updated (PT): 06-08-2026 04:29 AM PT

## Tickets

| # | Ticket | Title | Result | Skill exercised |
|---|---|---|---|---|
| 1 | QA-109749 | Brand Audience > Threads - Hovering Functionality | PARTIAL (no-data) | audience-metrics-export, chart-hover-tooltip (n/a) |
| 2 | QA-109919 | Brand > Content - Sentiment Comments limit - CSV | RECONFIRM (carry-forward) | export-csv +1 |
| 3 | QA-112583 | Reporting > Follower Demographics Vs Threads Audience - Export - Data QA | BLOCKED (no Threads data + sibling) | n/a |
| 4 | QA-113594 | Settings > Audit - External User View | BLOCKED (Admin-gated) | n/a |
| 5 | QA-113723 | Admin - Brand Set Creation and Settings > Audit screen | BLOCKED (Admin-gated) | n/a |

## Per-ticket notes

### QA-109749
- MTV Brand>Audience Threads channel shows "There is no data available" on all 5 tiles (Followers By Country, By City, Geo Country, Geo City, Gender Breakdown) across both default and extended date windows. Spec hover assertions on Country/City/Gender unreachable.
- Probed Michael Kors (brand_id=12597) → Brand>Audience Threads renderer-hang reproduced, recovered via tabs_close + new tab. Tab `1804438521` and `1804438523` cycled during recovery.

### QA-109919
- Sentiment Export tab confirmed visible on Big Hero 6 (brand_id=10613) FB Apr 1-7 2025 sentiment_mode=true session. Underlying CSV pipeline already verified end-to-end in batch-8 (QA-109920) + QA-4325 batch-8 (QA-111242/111243). The 2,000-message limit per spec appears to be exceeded by current builds (APV Positive donut → 6,160 rows). Documented as finding-carry-forward.

### QA-112583
- Cross-source compare requires Threads Audience data which is absent for MTV today. Sibling of QA-109749 — same blocker.

### QA-113594 + QA-113723
- Admin page (admin.lfmdev.in) Cognito SSO challenge; magpie cannot enter password per safety policy. Per QA-4325 batch-9 (QA-113595, QA-113722), same blocker holds. LFIQA executes manually.

## Skill registry bumps

- `export-csv`: +1 (QA-109919 RECONFIRM via carry-forward — Sentiment Export Comments CSV pipeline verified end-to-end in prior batches).

## Quirks updates
- 2026-06-08 entry "Brand>Insights Threads multi-channel renderer freeze" extended to Brand>Audience Threads channel (single-channel Threads filter also hangs the renderer on Michael Kors brand_id=12597 in this session). Added quirk note.

## Chrome state for batch 8
- Tab group auto-removed twice during recovery. Final state at batch end: empty group.
- Batch 8 should `tabs_context_mcp createIfEmpty=true` to open fresh.
- Active brand context in account: Adam Orfei (account_id=54); last brand viewed = Big Hero 6 (brand_id=10613) on Brand>Content Sentiment mode (Apr 2025 window).

## Next-batch pick (batch 8)
- Next 5 net-new ascending QA-IDs after 113723: QA-114840, QA-116140, QA-116173, QA-121158, QA-121217.
