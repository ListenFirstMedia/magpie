# QA-22296 Batch 11/12 Log — 2026-06-08

## Tickets (next 5 net-new after batch 10's QA-134296)

- QA-134445 — Brand > Partnerships layered tag filtering — PASS
- QA-134446 — Brand > Stories layered tag filtering — PASS
- QA-134447 — Brand > Paid layered tag filtering — PASS
- QA-134636 — Listening "Data Last Updated" Timestamp — PARTIAL (A1 PASS / A2 INCONCLUSIVE — Listening tab not surfaced on Adam Orfei)
- QA-135429 — Settings > Custom Metrics Edit functionality — PARTIAL (A1+A2 PASS / A3+A4 DEFERRED — safety on cross-user mutation)

## Skills exercised

- brand-content-filter (+3 PASSes — Partnerships, Stories, Paid)
- settings-custom-metrics (+1 PARTIAL — Edit flow A1+A2)
- brand-insights-interval-picker — DLU timestamp carry-forward on Brand>Insights (A1)

## Bugs filed

_None._

## Findings

- Layered tag filter shared widget now confirmed on 7 surfaces: Brand > Content / Partnerships / Stories / Optimization / Paid + Brand Sets > Content / Optimization / Partnerships. Same URL `filters` JSON encoding pattern across all.
- Brand>Partnerships Filter dropdown list: Collaborated / Collaborated Total / Collaborator Name / Content Type / Publish Day / Publish Time / Publish Type / Sponsor Name / Tag / Text Search.
- Brand>Stories Filter dropdown list: Branded Content / Collaborated / Collaborated Total / Collaborator Name / Content Type / Live Stream / Paid / Publish Day / Publish Time / Sponsor Name / Tag / Text Search.
- Brand>Paid Filter dropdown list: Ad Name / Ads Account ID / Campaign / Delivery Type / Publish Day / Publish Time / Tag / Text Search.
- Listening tab not accessible on Adam Orfei account (direct URL nav redirects to Brand>Insights). Test data gap for QA-134636 A2.
- Custom Metrics Edit form prefills Name + Description + Formula chips on `#custom-metrics/edit?report_id=N`.

## Chrome state (for batch 12)

- Tab 1804438550: Brand>Paid MTV with layered filter applied (browser-renderer hung once mid-batch on Brand>Conversation nav, recovered via new-tab create).
- Tab 1804438552: Settings>Custom Metrics list.
- Recommend close both stale tabs before batch 12 starts.
