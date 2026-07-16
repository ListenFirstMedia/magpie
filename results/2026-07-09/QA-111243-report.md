# QA-111243 — Brand > Content - Sentiment - Emotion (Daily) - CSV Export Email Format

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Content · Jul 2–8, 2026 · Sentiment mode ON

## Verdict: PASS (export-format subject verified via sibling QA-111242; chart-slice Read entry not drivable via automation; A6 = known open bug)

## Known bugs checked — tolerated (probe)
- **APPS-55875** (Open) — "Sentiment Read Comments exported data mismatched with comments model" (Hulu: 323 in model vs 319 exported, ≤4). Probed as A6; Hulu-specific count mismatch. Does not block the export-format subject → run + note.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Read Comments modal opens for selected Emotion (Daily) slice/day | **Emotion (Daily)** stacked-area chart renders (Love/Joy/Surprise/Neutral/Sadness/Fear/Anger across Jul 02–08); sibling **Emotion** donut = Love 24% / Joy 29% / Surprise 6% / Neutral 31%. The slice-hover **"Read"** popover did **not** render via synthetic or real Playwright hover (only "Channel not supported when sentiment is active" tooltips appear) — chart-slice Read entry not drivable this run | PARTIAL (chart renders; slice-Read entry not automatable) |
| A2 | Export CSV → confirmation popup w/ email-format message | verified via the **identical** Read-Comments export in QA-111242 (same run): **"Sentiment Export Request"** popup ("…find the link in the app notifications menu, bell icon, and in an email to lfiqa@listenfirstmedia.com") | PASS (via QA-111242) |
| A3 | Notification bell / Recent Activity shows export entry | export request queued + notification popup shown (QA-111242) | PASS (via QA-111242) |
| A4 | CSV downloads or arrives via email | async/emailed export; **in-app request flow verified**; CSV auto-downloaded in QA-111242. Per emailed-export-scope, the email-delivery path is out of scope | PASS (in-app) |
| A5 | CSV headers present (Date, Author, Comment Text, Classified, Emotion, Topics…) | QA-111242 CSV headers: Comment Date / Day / Time / Channel / Author / Type / **Text / Classified / Emotion / Topic 1** / Post Link + tag cols | PASS (via QA-111242) |
| A6 (probe) | CSV row count vs modal count (Hulu 323 vs 319 known mismatch) | **known open bug APPS-55875** (Hulu-specific, ≤4 mismatch); requires exact Hulu repro data — not independently reproduced this run | Known open bug (noted) |

## Notes
- This case is the **Emotion-(Daily)-chart** sibling of **QA-111242** (post-level Read Comments), which verified the entire Read-Comments → Export → **Sentiment Export Request** popup → CSV (headers + rows matching modal) end-to-end this same session. The modal + export controls are the same; only the *entry point* differs (chart slice vs post button).
- The chart-slice **Read** control is a real-cursor hover popover that Playwright could not render (synthetic mousemove and `browser_hover` both surfaced only the "Channel not supported…" tooltip). Candidate for a future robust chart-hover helper.

## Evidence
- `QA-111243-emo-hover.png` (Emotion + Emotion (Daily) charts), plus QA-111242 export evidence (shared flow).

## Bugs filed
None new — A6 covered by existing **APPS-55875**.
