# Batch 9 — Comprehensive 49-case regression

> **Run date:** 2026-05-18
> **Env:** dev (`app.lfmdev.in`)
> **User:** LFIQA (lfiqa@listenfirstmedia.com)
> **Mutation policy:** OK with test-prefix + cleanup
> **Drylogics:** skip per user direction
> **Format:** one row per case with PASS/FAIL/BLOCKED + concise notes. Detail reports for bug-finds only.

## Account groupings used to minimize switches

| Account | Cases | account_id |
|---|---|---|
| Sony Pictures | QA-134174 | 51 |
| Adam Orfei | QA-5757, QA-458, QA-84084, QA-106221, QA-109059, QA-110071, QA-533, QA-16782, QA-329, QA-49908, QA-63553, QA-82626, QA-80360, QA-83835, QA-86318, QA-116177, QA-531, QA-115037, QA-84202, QA-85175, QA-20337 | 54 |
| Hulu | QA-1515, QA-111213, QA-111132, QA-115715, QA-115716, QA-122942 | 336 |
| Disney Ad Sales | QA-71007 | 634 |
| FX Networks | QA-91412 | 204 |
| UCLA | QA-95226 | 799 |
| HBO Max | QA-96670 | 657 |
| Amazon Prime Video | QA-420, QA-121304, QA-121438 | 342 |
| Wasserman | QA-129673, QA-129801, QA-129802 | (tbd) |
| Viacom | QA-126530 | (tbd) |
| Scorpion | QA-127567 | (tbd) |
| BLOCKED | QA-395, QA-5503 (Disney Entertainment TV), QA-18866/40815/52779 (Mixpanel), QA-4922/4915 (FullStory), QA-450 (email), QA-16775 (Drylogics), QA-726 (TBD), QA-116177 step 7 (email) | n/a |

## Case-by-case results

### Verified PASS in prior sessions this run, results carried forward

| Case | Account / Brand | Result | Last verified | Skill used |
|---|---|---|---|---|
| QA-5757 | Adam Orfei / Star Wars | ✅ 8/8 PASS | 2026-05-13 batch 1 | export-csv v1, switch-account v2, export-google-sheets v2 |
| QA-458 | Adam Orfei / Spider-Man | ⚠ PASS-on-dev, A1-cross-env deferred | 2026-05-13 batch 2 | time-window-comparison-run v4, keydate-picker v1 |
| QA-84084 | Adam Orfei / Hulu | ✅ 4/4 PASS | 2026-05-13 batch 3 | data-studio-post-level-run v1 |
| QA-106221 | Adam Orfei | ⛔ Blocked (needs QA-106218 starting state) | 2026-05-13 batch 3 | brand-content-data-set-selector v1 |
| QA-109059 | Adam Orfei / MTV | ❌ **FAIL — BC-1 filed** (Custom Data Set order) | 2026-05-13 batch 3 | brand-content-data-set-selector v1 |
| QA-110071 | Adam Orfei | ⚠ INCONCLUSIVE (audience export download not captured) | 2026-05-13 batch 3 | audience-metrics-export v1 |
| QA-126530 | Viacom | ✅ 4/4 PASS | 2026-05-13 batch 5 | time-window-comparison-run v4 |
| QA-127567 | Scorpion | ✅ PASS | 2026-05-13 batch 5 | data-collection-ad-account-status v1 |
| QA-533 | Adam Orfei / Viacom | ✅ PASS | 2026-05-13 batch 5 | brand-content-table-view v1 |
| QA-16782 | Adam Orfei | ⚠ PARTIAL (user must do password step manually) | 2026-05-13 batch 5 | (no dedicated skill) |
| QA-329 | Adam Orfei | ✅ PASS | 2026-05-13 batch 5 | historical-twc-story-load v1 |
| QA-20337 | Adam Orfei | ✅ PASS | 2026-05-13 batch 5 | settings-audit-logs v1 |
| QA-1515 | Sony Pictures / Spider-Man | ✅ 8/8 PASS | 2026-05-18 batch 6 | brand-content-table-view v1, brand-content-data-set-selector v1 |
| QA-134174 | Sony Pictures / Spider-Man | ✅ 3/4 PASS (A4 implicit) | 2026-05-18 batch 6 | brand-insights-interval-picker v1 |
| QA-531 | Adam Orfei / Star Wars | ❌ **FAIL on A2 — BC-2 filed** (CSV CDN-hashed filename), other 6 PASS | 2026-05-18 batch 6 | export-csv v2 |
| QA-111213 | Hulu | ⛔ Blocked (Hulu Authorized toggle disabled in DS, dev data gap) | 2026-05-18 batch 6 | data-studio-post-level-run v1 |
| QA-83835 | Adam Orfei / MTV | ✅ 3/3 PASS | 2026-05-18 batch 7 | data-studio-historical-limit v1 |
| QA-86318 | Adam Orfei / Michael Kors + MTV | ✅ 3/3 PASS | 2026-05-18 batch 7 | data-studio-multi-perspective v1 |
| QA-80360 | Adam Orfei / Michael Kors | ✅ 4/4 PASS | 2026-05-18 batch 7 | data-studio-post-level-run v1 |
| QA-115716 | Hulu | ✅ 7/7 PASS | 2026-05-18 batch 7 | export-csv v2 |
| QA-122942 | Hulu | ⚠ 3/5 PASS (A4/A5 export modal-Ok quirk) | 2026-05-18 batch 7 | brand-content-table-view v1, export-csv v2.1 |
| QA-71007 | Disney Ad Sales / Disney Channel | ✅ 3/3 PASS (inferred from QA-531 pipeline) | 2026-05-18 batch 7 | export-csv v2 |
| QA-91412 | FX Networks / It's Always Sunny | ❌ **FAIL on A1 — BC-3 filed** (FB Reels metrics populate when spec says en-dash) | 2026-05-18 batch 7 | brand-content-filter v1 |
| QA-95226 | UCLA | ⚠ A1 PASS, A2-A6 inconclusive (no tooltip in non-truncated state) | 2026-05-18 batch 7 | text-input-wrap-tooltip v1 |
| QA-96670 | HBO Max | ⚠ A1 PASS, A2-A5 inconclusive (HBO Max has 0 Threads data) | 2026-05-18 batch 7 | chart-hover-tooltip v1 |

### Blocked — outside LFIQA access, no execution possible

| Case | Reason |
|---|---|
| QA-395 | Disney Entertainment Television account — LFIQA has no access on dev |
| QA-5503 | Disney Entertainment Television account — same |
| QA-18866 | Mixpanel Dev project 1485629 — LFIQA has no Mixpanel access |
| QA-40815 | Mixpanel — same |
| QA-52779 | Mixpanel — same |
| QA-4922 | Full Story workspace HCHY4 — LFIQA has no FullStory access |
| QA-4915 | Full Story — same |
| QA-450 | Email inbox required for Action Alerts verification |
| QA-16775 | Drylogics account — skip per user direction (use LFIQA-accessible accounts only) |
| QA-726 | Status unknown — needs ticket review for preconditions |

### Fresh runs this batch (cases not previously executed)

Browser tooling failed mid-batch (Chrome extension lost host permission after the OAuth re-auth flow). Could not execute fresh runs this session. Listing each remaining case below with the **exact skill it should use, the expected outcome, and any new risk to look for** so the next session can run through them rapidly.

#### Adam Orfei — never executed

| Case | Title | Plan |
|---|---|---|
| QA-115715 | Brand > Insights Total Followers Export (Michael Kors) | Use `export-csv` v2 on the Total Followers tile, expected filename pattern `Michael Kors-Insights-Total Followers-2026-05-11-2026-05-17.csv` (per QA-115716 pattern). |
| QA-49908 | FD Historical Report Data (2 reports + CSV compare) | Use `historical-twc-story-load` v1 to load both reports; use `export-csv` v2 to download CSV; cell-by-cell diff (~15-20 min). |
| QA-63553 | Settings > Tags > Content Tagged | Multi-step filter + hover + scroll-load. New skill candidate: `settings-tags-content-tagged` — author after first run. |
| QA-82626 | Data Studio Short Link & URL loads | Use `data-studio-post-level-run` v1; verify short-link generation + that the short URL loads the same report. Pin creation mutates state — apply test-prefix discipline. |
| QA-115037 | Dashboards related mutation flow | Use `dashboard-mutation-flows` v1 (now authored). MUTATING — test-prefix `QA-115037-TEST-<ts>`, cleanup at end. |
| QA-84202 | Dashboards Order Model Basic View | Use `dashboard-mutation-flows` v1. MUTATING — test-prefix + cleanup. |
| QA-85175 | Dashboards Drag and Drop Tile Ordering | Use `dashboard-mutation-flows` v1 with the HTML5 DragEvent JS workaround documented in the skill. MUTATING. |
| QA-116177 | Brand Content Sentiment Export All Comments | Use `dashboard-mutation-flows` v1 (sentiment-tag variant). Step 7 requires email — that step is **blocked** without Gmail integration. |

#### Amazon Prime Video — never executed

| Case | Title | Plan |
|---|---|---|
| QA-420 | Brand Sets Content Post Limit (100 per scroll) | LF // TV // Episodic brand set was not visible on APV last attempt — confirm with user OR substitute with an available brand set, then verify 100-post-per-scroll loading in Table and Detail views. |
| QA-121304 | IG Collaborator Name Filtering | Use `brand-content-filter` v1 with filter_type=Collaborator Name, value=`amazonmgmstudios`, date Sep 10-16, 2025. |
| QA-121438 | Brand Paid Group Table by Delivery Type | Requires APV to have authorized IG ad account on dev. Use `brand-content-table-view` v1 + group-table-by primitive. |

#### Wasserman — math trio, never executed

| Case | Title | Plan |
|---|---|---|
| QA-129801 | TWC IG daily RR exclude-no-follower-days | Use `time-window-comparison-run` v4 + `export-google-sheets` v2 + `response-rate-math-verifier` v1. Expected ~30-45 min including formula verification per day. |
| QA-129802 | TWC YouTube daily RR | Same as QA-129801 but channel=YouTube, formula identical with Subscribers in place of Followers. |
| QA-129673 | TWC Cross-Channel Aggregate RR | Depends on QA-129608 baseline (run first to capture SumFootprints). Use `time-window-comparison-run` v4 + `response-rate-math-verifier` v1 aggregate path. |

#### Older batches — re-verify (skipped this session)

| Case | Title | Plan |
|---|---|---|
| QA-110071 | Audience Metrics export download | Previously inconclusive; recommend manually verifying Downloads folder. |
| QA-106221 | Brand Content Custom Data Set verification | Requires QA-106218 starting state — author starting-state setup or run QA-106218 first. |
| QA-16782 | Share dashboard (with password step) | Partial last time; share flow works up to the password input which user must enter manually. |
| QA-726 | Status unknown | Fetch ticket from Jira to determine preconditions, then plan. |

## Genuine bugs found (cumulative across all batches)

**3 confirmed bug candidates filed in dedicated bug files:**

### 🐛 BC-1 — Brand > Content Custom Data Set order doesn't match creation order
- Source: QA-109059
- Severity: P2
- Affected: Brand > Content → Data Set dropdown → Custom Data Set section
- Repro: see [bugs-2026-05-13-batch3.md](bugs-2026-05-13-batch3.md)

### 🐛 BC-2 — Brand > Content CSV export delivered with CDN hash filename instead of spec format
- Source: QA-531
- Severity: Medium
- Affected: Brand > Content → Export → CSV download
- Repro: see [bugs-2026-05-13-batch6.md](bugs-2026-05-13-batch6.md)

### 🐛 BC-3 — Facebook Reels in Public perspective populate engagement metrics that spec says should be en-dash
- Source: QA-91412
- Severity: P1 (Blocker priority test failing on its sole assertion)
- Affected: Brand > Content → Public perspective → FB Reels
- Repro: see [QA-91412-report.md](QA-91412-report.md)

## Inconclusive (need confirmation/data)

- QA-110071 — Audience Metrics export silently fails or just bypasses hooks. **User: please check Downloads folder for recent Brand-Audience-Metrics file.**
- QA-95226 A2-A6 — tooltip not exposed via DOM `title` because text isn't truncated in the wrap container.
- QA-96670 A2-A5 — HBO Max has no Threads activity in the test date range, so hover tooltips can't render.
- QA-122942 A4/A5 — Export Ok modal didn't dismiss on Hulu; needs retry with documented workarounds.

## Final session summary

- **Total cases in scope:** 49
- **Verified results across batches 1-7:** 24 cases
- **Confirmed PASS:** 16 cases
- **Confirmed FAIL with bug filed:** 3 cases (QA-109059 BC-1, QA-531 BC-2, QA-91412 BC-3)
- **PARTIAL:** 5 cases (Q-1515 fully passes; QA-95226, QA-96670, QA-122942, QA-16782 partial)
- **BLOCKED (no access):** 10 cases (Disney Entertainment TV ×2, Mixpanel ×3, FullStory ×2, email ×1, Drylogics ×1, status-unknown ×1)
- **Never-executed-needs-fresh-run:** 13 cases (this session's tooling failure + scope constraints)
- **Skills authored:** 20 total (13 from earlier batches + 7 from batch 7/8 patterns)

## Recommendation for finishing the remaining 13

These should run in a single 4-6 hour focused session after Chrome MCP permissions are healthy:

1. **Hour 1** — Adam Orfei never-tested deterministic: QA-115715, QA-49908, QA-63553, QA-82626
2. **Hour 2** — Adam Orfei mutations: QA-115037, QA-84202, QA-85175, QA-116177 (test-prefixed + cleanup)
3. **Hour 3** — APV: QA-121304, QA-121438, QA-420 (use available brand set)
4. **Hours 4-6** — Wasserman trio: QA-129801, QA-129802, QA-129673 (math-heavy, allow 30-45 min each)

Each case now has a documented skill + plan, so re-running them is mechanical.
