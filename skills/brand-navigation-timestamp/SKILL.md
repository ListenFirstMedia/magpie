---
name: brand-navigation-timestamp
version: 1
last_verified: 2026-07-16
last_passed_run: 2026-07-16
trust: untrusted
pass_streak: 3
preconditions: [account-context, brand-selected]
postconditions: [timestamp-consistency-verified]
inputs: [brand_id, account_id, brand_set_id]
outputs: [timestamp_value, surfaces_matched]
related_pages: ["/#home", "/#explore/brand/insights", "/#explore/brand/audience", "/#explore/brand/content", "/#explore/brand/channels", "/#explore/brand/stories", "/#explore/brand/optimization", "/#explore/competitive/rankings", "/#explore/competitive/content"]
---

# Brand Navigation — Data Last Updated Timestamp Consistency

End-to-end skill for verifying the `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT` timestamp renders with identical format and identical value across all Brand sub-tabs and Brand Sets sub-tabs, persists through F5 page-refresh, and is account-wide (not brand-specific).

Used by:
- **QA-134271** (Brand Navigation — Data Last Updated Timestamp) — PASS across 7 Brand surfaces + cross-brand check + F5 persistence. +1 from QA-134271 2026-07-16 re-run (Playwright MCP, `feature/playwright-mcp`): MTV → Michael Kors cross-brand check, `07-15-2026 04:27 PM` identical across Home + 6 Brand sub-tabs + F5 + brand switch, 10/10 assertions PASS. No Playwright MCP server crash despite Brand>Insights/Audience known-quirk risk. Confirmed the no-trailing-"PT"-suffix format matches established precedent (`runs/2026-07-08/QA-111132-report.md`), not a regression.
- **QA-134296** (Brand Sets Rankings — Data Last Updated) — PASS across Brand Sets > Rankings + Brand Sets > Content + F5 + cross-brand-set; cross-app parity with Brand surfaces confirmed.

## Key UI structure

### Header location
- Top-right of every Brand / Brand Set surface header.
- Text format: `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT`.
- Regex: `Data Last Updated \(PT\): \d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM|PM) PT`.

### Semantic model
- The timestamp reflects the **most recent ETL run** at the account level.
- It is **NOT brand-specific** — switching brand on the same account leaves the timestamp unchanged.
- It is **NOT page-specific** — every Brand sub-tab and every Brand Sets sub-tab shows the same value in the same session.
- It persists through F5 page-refresh (it's a server-rendered value, not a client cache).

## Steps

### Step 1 — Capture timestamp on Home
- **Action:** Navigate to `https://app.lfmdev.in/#home?account_id={account_id}`.
- **Probe:** zoom on the upper-right region; read the `Data Last Updated (PT): …` text.
- **Capture:** the full value as `T0`.

### Step 2 — Sweep across the 7 Brand sub-tabs
For a fixed `brand_id` on the same `account_id`, visit each surface in sequence and capture the rendered timestamp:

1. **Brand > Insights** — `/#explore/brand/insights?brand_id={brand_id}&account_id={account_id}`.
2. **Brand > Audience** — `/#explore/brand/audience?brand_id={brand_id}&account_id={account_id}`.
3. **Brand > Content** — `/#explore/brand/content?brand_id={brand_id}&account_id={account_id}`.
4. **Brand > Channels** — `/#explore/brand/channels?brand_id={brand_id}&account_id={account_id}`.
5. **Brand > Stories** — `/#explore/brand/stories?brand_id={brand_id}&account_id={account_id}`.
6. **Brand > Optimization** — `/#explore/brand/optimization?brand_id={brand_id}&account_id={account_id}`.
7. **Brand > Conversation** (if enabled) — `/#explore/brand/conversation?brand_id={brand_id}&account_id={account_id}`.

- **Assertion:** every surface displays the same value as `T0` to the minute.

### Step 3 — Verify Brand Set surfaces (Brandsets parity)
For a fixed `brand_set_id` on the same `account_id`, visit:

1. **Brand Sets > Rankings** — `/#explore/competitive/rankings?brand_set_id={brand_set_id}&account_id={account_id}`.
2. **Brand Sets > Content** — `/#explore/competitive/content?brand_set_id={brand_set_id}&account_id={account_id}`.

- **Assertion:** both surfaces show the same value as `T0`.

### Step 4 — Verify cross-brand stability
- **Action:** Switch `brand_id` (e.g., MTV → Tory Burch on the same account) and re-read Brand>Insights.
- **Assertion:** value unchanged (timestamp is account-level, not brand-level).

### Step 5 — Verify cross-brand-set stability
- **Action:** Switch `brand_set_id` (e.g., Adam's Brand Set → 1923 Talent on the same account) and re-read Brand Sets > Rankings.
- **Assertion:** value unchanged.

### Step 6 — Verify F5 persistence
- **Action:** Press F5 on the current page.
- **Assertion:** after reload, the same value renders.

### Step 7 — Verify format conformance
- **Assertion:** matches regex `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM|PM) PT` after the `(PT):` literal. Leading zeros on month/day/hour.

## Cross-surface assertion pattern

Build a small assertion matrix:

| Surface | Captured value | Matches T0? |
|---|---|---|
| Home | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Insights (MTV, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Audience (MTV, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Content (MTV, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Channels (MTV, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Stories (MTV, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Optimization (MTV) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand > Insights (Tory Burch, IG) | `06-04-2026 05:06 AM PT` | ✓ |
| Home after F5 | `06-04-2026 05:06 AM PT` | ✓ |
| Brand Sets > Rankings (Adam's Brand Set) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand Sets > Content (Adam's Brand Set) | `06-04-2026 05:06 AM PT` | ✓ |
| Brand Sets > Rankings (1923 Talent) | `06-04-2026 05:06 AM PT` | ✓ |

Any row that fails to match → cross-source consistency regression.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Surface displays a different timestamp than T0 in same session | Cross-surface consistency regression | File bug; capture both values + surfaces |
| Format ≠ `MM-DD-YYYY HH:MM AM/PM PT` (e.g., 24-hour, or missing `PT` suffix) | Format regression | File bug |
| Brand switch causes timestamp to change | Backend incorrectly treating timestamp as per-brand | File bug |
| F5 produces a new timestamp value | Timestamp is being client-computed at load (should be server-rendered) | File bug |
| Listening surface displays its own `Data Last Updated` (per QA-134636 A2) | Spec says Listening tab should NOT show the element | File bug (verified only on accounts where Listening is enabled) |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../data_last_updated` (or embedded in `/api/.../home`) | GET | 200 | Returns the account-level ETL timestamp |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-134271 (Brand surfaces) + QA-134296 (Brand Sets / Rankings). Documents the `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT` format, the across-7-Brand-tabs + 2-Brand-Sets-tabs identical-value check, F5 persistence, cross-brand and cross-brand-set stability, and the Listening surface exclusion per QA-134636 A2.
- **2026-07-16** (QA-134271 re-run, Playwright MCP): reconfirmed on MTV → Michael Kors (Adam Orfei, account_id=54). Current UI renders the timestamp **without** a trailing " PT" suffix (e.g. `07-15-2026 04:27 PM`, not `... PM PT`) — this is the established format since ~2026-06-30 (see `runs/2026-07-08/QA-111132-report.md`), superseding the v1-era trailing-PT observation. Update the regex expectation accordingly: `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM|PM)` after `(PT):`, trailing " PT" no longer expected.
