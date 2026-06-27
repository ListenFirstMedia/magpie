# Manual QA Test Run — Dev (app.lfmdev.in) — Jun 10, 2026

**Tester:** Claude (driving Kratika's LFIQA Chrome profile) · **User:** LFQA · **Account context:** Adam Orfei (switched to Hulu for QA-329)
**Data Last Updated (PT):** 06-10-2026 04:24 AM · **Env:** Dev

## Summary

| # | Case | Title | Result |
|---|------|-------|--------|
| 1 | QA-20337 | Settings > Audit - Logs | ✅ PASS |
| 2 | QA-106221 | Custom Data Sets - Edit | ✅ PASS (1 observation) |
| 3 | QA-106218 | Custom Data Sets - Create (precondition, bonus-verified) | ✅ PASS |
| 4 | QA-109059 | Custom Data Sets on Brand > Content | ❌ FAIL (2 assertions) |
| 5 | QA-533 | Brand Content - full text on hover | ✅ PASS |
| 6 | QA-726 | Content Tagging - character limit | ✅ PASS (stale description) |
| 7 | QA-110071 | Brand > Audience - Threads - Metrics export | ✅ PASS |
| 8 | QA-127567 | Data Collection - Ad Account level status | ✅ PASS (single-AA case N/A) |
| 9 | QA-84084 | Data Studio Post Level - YT Engagements calc | ✅ PASS |
| 10 | QA-458 | TWC Relative Date Rates - dev vs stage | ⚠️ PARTIAL (dev done; stage needs login) |
| 11 | QA-5757 | TWC Google Sheets export | ❌ FAIL (export hangs) |
| 12 | QA-126530 | TWC Cohort/Competitive Avg as line | ✅ PASS (1 cosmetic observation) |
| 13 | QA-329 | Historical reports load | ✅ PASS |
| 14 | QA-16782 | Share Dashboard w/ permissions | ⚠️ PARTIAL (read-only steps PASS; share/sign-in handed off) |
| 15 | QA-52779 | Create new user (External admin) | 🚫 BLOCKED (needs external acct login + user creation) |
| 16 | QA-4922 | FullStory event properties | 🚫 BLOCKED (needs FullStory dashboard session; app-side FS instrumentation verified) |
| — | QA-18866, QA-40815 | Mixpanel | ⏭ SKIPPED per instruction |

## Bugs / Failed assertions

### BUG 1 — QA-5757: TWC Google Sheets export hangs indefinitely (Critical)
- Report: The Walking Dead TWC (story 154359), Export → Google Sheets.
- Export button spinner stuck **>90 s** (benchmark from May 13 run: <15 s). `window.open` never fired, no sheet tab appeared, no console errors. Dropdown options correct (Google Sheets, CSV, TSV, XLS).
- Note: Audience "Metrics" export (QA-110071) produced its Google Sheet within seconds, so Google integration itself works. Repro once; retest to confirm.

### BUG 2 — QA-109059 A7: unselected metric still displayed (Major)
- Grid View → Metric Display → unchecked **Engagements** ("10 Selected", checkbox confirmed unchecked) → Engagements column still rendered in the summary grid (Sum 315,780).
- Possible interaction: Sort was set to "Engagements" — even so, the assertion "engagements metric is not shown on the page" fails.

### BUG 3 — QA-109059 A3b: custom data sets not in created order (Minor, known)
- Data Set dropdown lists custom sets **alphabetically (case-sensitive)**, not by creation date — e.g. "LFQA Edit Test 0610" (Jun 10 2026) appears 3rd, "Some new data set name" (Apr 18 2025) 4th. Same order on Settings > Custom Data Sets listing. Related: APPS-61234 (closed — regressed or resolved as won't-fix?).

### Intermittent / transient (log, monitor)
- **Brand > Content "This table failed to load. Please try again."** on first apply of custom data set (MTV). Reload recovered; data-api request then 200. (QA-109059)
- **Brand > Audience "The application has encountered an unknown error."** on first direct-URL load with carried-over channel params; page reload recovered. (QA-110071)

### Observations (not test assertions)
- **QA-106221:** breadcrumb on the *Edit* Custom Data Set page still reads "… > **New** Custom Data Set". Header is correct ("Edit Custom Data Set").
- **QA-106221:** drag-and-drop reorder is imprecise under automation (overshoots/snap-back); the rank number input works (requires React-style input+blur events).
- **QA-726:** Jira *description* says 20-char limit; steps/assertions and actual behavior are 100 chars ("Please enter up to 100 characters", maxlength=100). Update the description.
- **QA-458:** test says "avg responses per post" — metric is now named **"Average Engagements per Post"** (filter for "Average Responses" returns nothing). Update test wording.
- **QA-126530:** with Cohort+Competitor averages enabled, the channel section header icons (Facebook/Twitter) rendered as empty squares on the story page (cosmetic).
- **QA-20337:** Activity Type enum is wider than older notes: Brand Created/Deleted/Edited, Brand Set Created/Deleted/Edited, User Activated/Created/Deactivated/Edited. Description also has "…'s metadata was edited." variant.

## Key evidence per passed case
- **QA-20337:** 7 columns; date format `Tue Jun. 09, 2026 04:42 PM PDT`; Filter → Activity=User Edited applied (chip "Include"), rows filtered, URL gains `filters` param; Clear All works.
- **QA-106218 (precondition):** breadcrumb/header/timestamp/placeholder asserted; metric category order Public→…→Pinterest; lock icons exactly on Comments, Shares, Engagement Rate, Impressions; Selected Metrics (7); created row listed with metrics in added order.
- **QA-106221:** Edit header ✓; Engagements moved to #3 ✓; #7 Impressions deleted ✓; Twitter "Views" added showing only X icon ✓; saved order = "Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views" ✓ (exact match).
- **QA-109059 (passing parts):** Custom Data Set section under Channel-Specific w/ singular header ✓; channel order FB, X, IG, YT, TikTok, LinkedIn, Threads | Pinterest crossed-out after divider ✓; only data-set metrics shown (incl. Organic/Paid breakdowns for locked composites) ✓; Table View sums identical to Grid (Reactions 309,833 / Engagements 315,780 / Comments 3,408) ✓; Metric Display container lists only the set's metrics ✓.
- **QA-533:** Text cells ellipsed; full post text in `title` attr (visible text is prefix of title); headers fully visible.
- **QA-726:** typed 120 chars → value clamps at exactly 100; placeholder correct.
- **QA-110071:** Threads-only via Apply (URL channels=threads); Export → Metrics opened Google Sheet titled **Brand-Audience-Metrics**; A1="Display Name", B1="Key"; 8 metric rows incl. `threads.page.followers_m`. *(Note: catalog includes all channels' metrics, not Threads-only — matches expected metadata-catalog behavior.)*
- **QA-127567:** "Facebook & Instagram Ads (Authorized)" parent Status EMPTY w/ chevron; expanded Ad Account rows: act_246150802260022 → Not Collecting; act_104851869627522 → Not Collecting. Per-row status only ✓. Single-AA assertion not exercisable with Scorpion fixture.
- **QA-84084:** MTV, Post Level, Aggregate, 3 metrics → Engagements 71 = Likes 69 + Comments 2 ✓ (report_id 295526).
- **QA-458 (dev half):** TWD, Relative 3-before/1-after, keydate S9E16 auto-set to **Mar 31, 2019**; all rate metrics + Average Engagements per Post (incl. FB w/ Clicks); graphs off; Change/Change %/Brand Share tables rendered. Dev data captured (story 154359): AEPP 23,817 / 23,943 / 24,072 / 35,871 / 42,136; Response Rate 0.15/0.15/0.15/0.45/0.46%. **Stage repeat pending stage login.**
- **QA-126530:** story 154362 — Cohort Average solid line + right-edge label, tooltip "Cohort Average: 6,871"; Competitor Average dashed line, tooltip "Competitor Average: 15,814"; both lines, not bars; legend swatches correct.
- **QA-329:** Hulu acct, story 119501 loads fully; TWD; Absolute Dates selected; Fan Growth (4/8) = FB New Fans, TW New Followers, IG New Followers, YT New Subscribers all aria-checked=true (TikTok false); Show Metrics Graphs + Tables aria-checked=true.
- **QA-16782 (read-only part):** Options menu = Edit/Share/Delete exactly ✓; Share modal renders (People input + Add, Owner row LFQA Testing, Copy Link / Bulk Share, Share disabled until recipient added).

## Handed off to you (safety-restricted steps)
1. **QA-16782 steps 3–19:** add `lfm-qa@drylogics.com`, Share, sign in as that user, verify shared dashboard, then Remove. (I don't modify sharing permissions or enter credentials.)
2. **QA-52779:** requires External acct login (testing@drylogics.com) + user creation (+ Mixpanel half excluded anyway).
3. **QA-458 stage half:** sign in at app-reporting.stage.lfmprod.in and I can repeat the flow and diff against the dev numbers above.
4. **QA-4922:** sign in at app.fullstory.com and I can drive the Segment filter steps.
5. **QA-5757:** please confirm no "The Walking Dead - Time Window Comparison …" Google Sheets tab opened in another window (would downgrade BUG 1 to an MCP-visibility quirk).

## Cleanup
- Created custom data set **"LFQA Edit Test 0610"** (Adam Orfei acct) for QA-106218/106221/109059 — delete when done (I don't hard-delete data).
- No tags added (QA-726 modal cancelled), no users created, no dashboards shared.

## Skill file updates needed (read-only cache here — apply via Settings > Capabilities)
1. **audience-metrics-export (major rewrite):** Export → Metrics does NOT download a file — it opens a **Google Sheet** ("Brand-Audience-Metrics") in a new tab, often within the MCP group. Remove Downloads-folder/fetch-hook guidance; verify via the new tab title + cells A1/B1. Channel ghost toggles: element-targeted clicks on the channel option DO work (coordinate clicks unreliable); audience ghosts behave radio-like (selecting Threads deselected others).
2. **time-window-comparison-run:** banner reads **4,565** days (skill says 4,564). Interval dropdown is `.interval__dropdown .lfm-dropdown-select-box` + `.lfm-dropdown-option` (custom, not <select>). Metric tree checkboxes: click `span.controlled-check-box > label`; nodes are `<details>` — set `.open=true` to expand; leaf state via `aria-checked`. Add the Cohort/Competitor flow detail: enabling via Options *before first run* can silently not apply if clicked as raw span — use label click and verify legend post-run. Keydate picker: Auto-Select → Season N → second Auto-Select → Episode N; TWD S9E16 resolves to Mar 31, 2019.
3. **export-google-sheets:** add failure signature observed: spinner >90 s with zero `window.open` capture = export-stuck bug (don't wait for the 15 s heuristic only). Confirm Export dropdown order is Google Sheets, CSV, TSV, XLS (matches).
4. **brand-content-data-set-selector:** known-finding confirmed again (alphabetical, not created order) — keep flag, reference APPS-61234.
5. **settings-audit-logs:** broaden Activity Type enum + Description regex (see observations); filter flow (Select → Activity → checkbox → Apply) and URL `filters` param worth documenting.
6. **data-studio-post-level-run:** confirmed; add that Aggregate rows read `Metric|Brand|P|Sum|Avg` concatenated (e.g. "…MTVP7110" = Sum 71, Avg 10).
7. **brand-content-table-view:** confirmed as written.
8. **data-collection-ad-account-status:** confirmed as written (2 AAs, both Not Collecting).
9. **historical-twc-story-load:** confirmed; note metric leaves live inside collapsed `<details>` — set `.open=true` before reading `aria-checked`.
10. **New skill candidates:** custom-data-sets-create/edit (lock-icon rules, rank-input reorder w/ React setter, breadcrumb quirk), brand-content-tagging (Tag link on post card, 100-char limit), dashboard-share-modal (read-only assertions).
