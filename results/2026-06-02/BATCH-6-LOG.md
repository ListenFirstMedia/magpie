# QA-4325 Batch 6 — Run Log (2026-06-04)

Members 21-25 of QA-4325.

## Per-ticket result

| # | QA-ID | Title | Result | Notes |
|---|---|---|---|---|
| 21 | QA-84193 | DS - Brand>Content — Data QA Engagements (parity) | PARTIAL | DS Post Level Hulu In-Window May 27 – Jun 02 2026 Aggregate Sum values captured: FB 167,094; TW 4,306; IG 938,530; TK 44,501. BC side BLOCKED — Hulu Brand>Content URL nav from Adam Orfei (account_id=54) redirects to `/#home`; cross-account verification deferred. New finding: `account-cross-route` carry-forward for Hulu. |
| 22 | QA-84194 | DS - Brand>Content — Data QA Impressions (parity) | PARTIAL | DS Post Level Twitter Impressions blocked by Public-perspective gating (Twitter Post Impressions checkbox disabled until toggle flipped to Authorized); toggle flip-then-rerun path not completed in run window. BC Hulu side BLOCKED — same as QA-84193. |
| 23 | QA-88219 | Dashboards - save filtered Brand>Content tile | PASS (5/5) | Full E2E MUTATION + cleanup: Brand>Content MTV Public + Publish Type=Reel filter → Content Insights tile → Save to Dashboard → Create new `qa-88219-rerun-2026-06-04-b6` dashboard (id=6353) → tile renders with `Filter(1) Publish Type: Reel` chip + Video bar ~228K (matches Sum Engagements 228,847) → DELETED. Dashboards (2)→(1) confirmed. |
| 24 | QA-92735 | Brand>Audience LinkedIn Basic View (re-confirm) | PASS (with APPS-58574 RE-REPRODUCED) | UCLA → LinkedIn Audience Authorized. DOM-measured Job Function tile alone on row 1 (top=327); Industry/Seniority/Staff Count Range together on row 2 (top=726). Same topology as batch-1 finding. APPS-58574 still open. |
| 25 | QA-94977 | Brand>Audience LinkedIn Metric Export | PASS (4/5 + probe FAIL) | Per-tile Export dropdown shows PNG + CSV. CSV downloaded `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` (944 bytes, 27 cols, 1 data row, UI ↔ CSV percentages match within rounding). APPS-58574 RE-REPRODUCED via DOM re-probe. |

## New bugs / findings (filed in this batch's reports)

| Source | Bug / Finding | Severity | Status |
|---|---|---|---|
| QA-84193 / QA-84194 | Hulu Brand>Content URL nav from Adam Orfei account_id=54 consistently redirects to `/#home` — cross-account testing blocker | Test-environment friction | Carry-forward; add to known-quirks |
| QA-94977 | APPS-58574 — LinkedIn Brand>Audience first-row cards misaligned (UCLA) | Trivial (per Jira) | RE-REPRODUCED (already open in Jira) |
| QA-92735 | APPS-58574 — same as above | Trivial | RE-REPRODUCED |

## Chrome state for batch 7

- Active browser: "Work Browser" (same)
- Latest tab in MCP tab group: 1804438022 (last URL: `app.lfmdev.in/#dashboards/6095`)
- Account: Adam Orfei (account_id=54), user yash.sharma@listenfirstmedia.com (returned to Adam Orfei after UCLA → Adam Orfei switch mid-batch)
- Dashboard list: Yash only (cleanup verified)
- Downloads dir `~/Downloads` is mounted into the session
- Recommend fresh tab close + create at start of batch 7 (per protocol)
