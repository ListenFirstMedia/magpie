# QA-22296 Re-run — Batch 1/12 — 2026-06-13

- **Env:** Dev (app.lfmdev.in / app-reporting.lfmdev.in) · **Account:** Adam Orfei · **User:** LFQA
- **Data Last Updated (PT):** 06-12-2026 04:25 PM
- **Browser:** Work Browser (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5); fresh MCP tab 1804439354, closed at batch end.
- **Members:** QA-199, QA-574, QA-844, QA-923, QA-926 (test-set order 1–5)

| # | QA | Title | Result | Open-bug verdict | New findings |
|---|----|-------|--------|------------------|--------------|
| 1 | QA-199 | TWC - TSV Exports - Relative Dates | ❌ FAIL-with-finding | n/a | Date column = relative labels ("3 Days Out"…"1 Day Post") NOT absolute dates — TSV **and** CSV. Reproduces 2026-06-05. |
| 2 | QA-574 | Instagram Lifetime Private Data QA | ✅ PASS (proxy) | n/a | No "Recent" tab in build; Public(10765)↔Authorized(4018) IG Sum identical (3,841,956 / 66,043,280), Posts(75). |
| 3 | QA-844 | TikTok Content - Exporting Tags | ✅ PASS | n/a | **Upgrades prior PARTIAL/NOT-VERIFIED** — export queue surfaced; tags export as named columns ("hi" col), rank-3 row populated, 162 blank. |
| 4 | QA-923 | Brand Content - Embedded Post Tooltip (APV) | ✅ PASS-with-observations | **LFMP-31915 NOT reproduced; LFMP-31857 signal present** | **Upgrades prior BLOCKED.** Twitter embed renders empty (likely X restriction). A5/A7 deferred. |
| 5 | QA-926 | Embedded Post Tooltip - YouTube | ✅ PASS (6/6) | n/a | YT embed tooltip clean; 11 watch links valid; X closes. |

## Headline
- 4 PASS (incl. 2 upgrades vs 2026-06-05: QA-844, QA-923), 1 FAIL-with-finding (QA-199 — re-confirmed relative-vs-absolute date export finding).
- Open-bug movement: **LFMP-31915** (IG image tooltip empty) NOT reproduced → recommend close. **LFMP-31857** (Twitter text link) signal present → stays open.

## New findings / quirks
- **TWC Relative-Dates export emits relative labels in Date column** (TSV+CSV) — candidate Bug or QA-199 spec rewrite (re-confirmed from 2026-06-05).
- **Tag export mechanic:** Brand>Content exports each applied tag as its own column (header = tag name; cell = tag name on tagged rows, blank otherwise) — fold into export-csv skill.
- **APV Brand>Content renderer transient:** post table skeleton >15-20s on first paint per channel; recovered via `location.reload()`. Twitter/IG both needed a reload.
- **Twitter embedded tooltip empty** (no oEmbed) on APV — monitor; likely X-platform restriction.

## Cleanup
- No mutations. TWC story 154573 created (QA-199, harmless). Pre-existing `hi` tag on one MTV TikTok post left as-is (not created this run).
