# QA-109059 — Settings > Custom Data Sets support on Brand > Content

- **Run date:** 2026-07-07
- **Branch / track:** `feature/playwright-mcp` (Playwright MCP, real Chrome, programmatic Cognito login)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109059
- **Priority:** Blocker (P1)
- **Skill reused:** `settings-custom-data-sets` v4 (create flow) + ad hoc Brand>Content Data Set dropdown navigation (no dedicated `brand-content-data-set-selector` skill exists yet on disk despite the registry TODO note — authored inline this run, formalize as a follow-up)
- **Account:** Adam Orfei (account_id=54)
- **Depends on:** QA-106218 (a CDS must exist) — self-cleaning, so recreated as precondition (same pattern as QA-106221 today)
- **Result:** **PARTIAL — 4/8 assertions verifiable (A1–A4 PASS), A5–A8 BLOCKED by a confirmed backend bug**

---

## Pre-flight

Reused the session from the QA-106221 run earlier today; account context "Account: Adam Orfei" held throughout, no drift.

## Precondition setup

Recreated a 7-metric CDS via the Create flow (same metric set/order as QA-106218): `QA-109059-precondition-20260707` = Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions.

---

## Steps executed

| # | Step | Action taken | Outcome |
|---|------|--------------|---------|
| 1 | Brand → Content | Clicked Brand nav dropdown → Content | ✅ `#explore/brand/content?brand_id=4018` |
| 2 | Brand selector → type → select MTV | Clicked brand picker, typed "MTV" in "Search for a Brand", selected the exact-match "MTV" result (not "MTV (Africa)" etc.) per Rule 1 | ✅ brand_id=4018 confirmed via explicit typeahead, not just URL |
| 3 | Data Set dropdown → scroll | Clicked "Data Set: Public" dropdown | ✅ opened; 3 groups visible: Cross-Channel Metrics, Channel-Specific Metrics, Custom Data Set |
| 4 | Click the QA-106218-created data set | Clicked `QA-109059-precondition-20260707` in the Custom Data Set group | ✅ URL updated `table_data_set=QA-109059-precondition-20260707`; **but see Problem below — table failed to load** |
| 5 | Change view to Table View | **Not reached** — blocked by Problem below | ⛔ BLOCKED |
| 6 | Change to Grid View, click All Metrics container | **Not reached** | ⛔ BLOCKED |
| 7 | Unselect Engagements | **Not reached** | ⛔ BLOCKED |
| — | Cleanup | Actions → Delete → Ok on the precondition CDS, verified gone via F5 | ✅ |

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | "Custom Data Sets" section appears below Channel-Specific metrics, header "Custom Data Set" | Confirmed: dropdown groups in order Cross-Channel Metrics → Channel-Specific Metrics → **Custom Data Set** (singular, exact text). No literal `<hr>`/border divider distinguishes this group from the others in the DOM — all 3 option-groups share identical `padding-top: 10px` styling with no border. If "divider" in the spec means the group-label header itself (consistent with the other 2 groups), this passes; if it means a visually distinct separator line specific to this group, that element does not exist. | ✅ PASS (with note above) |
| A2 | 3 | Custom data sets displayed in creation order | **FAIL — reproduces the F1 bug candidate from the 2026-05-13 run of this same case.** Actual order: `Main Test 1, QA-109059-precondition-20260707, Test, Test 3 Dupes, Test Data 123, create-103, performance test, performance test 2`. This is exact case-sensitive ASCII alphabetical order (uppercase before lowercase: M, Q, T, T, T, c, p, p), **not** creation-date order — e.g. "Main Test 1" (created Mar 2025) and my just-created precondition CDS (created today) are 1st and 2nd only by alphabetical coincidence, while "performance test"/"performance test 2" (created May/Jun 2025, far older) sort last purely because of lowercase initial. | ❌ **FAIL — confirmed bug (2nd independent reproduction, 7 weeks apart, different data)** |
| A3 | 4a | Channels appear in order: Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads, Pinterest (crossed-out) | Confirmed exact order in the Channels: selector, verified via DOM: Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads, Pinterest. | ✅ PASS |
| A4 | 4b | Pinterest channel appears after the divider in the channel container | Confirmed via DOM: Pinterest's icon wrapper (`channel-ghost pinterest disabled warning`) has an immediately-preceding sibling with class `chan-separator` — a literal divider element. | ✅ PASS |
| A5 | 4c | Only the selected metrics show: Engagements, Reactions, Comments, Reactions, Shares, Engagement Rate, Impressions (as transcribed in Jira — duplicated "Reactions", missing "Response Rate"; almost certainly a Jira transcription artifact for the QA-106218 7-metric set) | **BLOCKED** — see Problem below | ⛔ BLOCKED |
| A6 | 5 | Table view shows the same data as grid view | **BLOCKED** — step 5 not reached | ⛔ BLOCKED |
| A7 | 6 | All Metrics container shows only the selected metrics | **BLOCKED** — step 6 not reached | ⛔ BLOCKED |
| A8 | 7 | Unchecking Engagements removes it from the page | **BLOCKED** — step 7 not reached | ⛔ BLOCKED |

---

## Problem encountered — confirmed bug: Brand>Content table fails to load when a Custom Data Set is selected

Immediately after selecting `QA-109059-precondition-20260707` in the Data Set dropdown (step 4), the page displayed: **"This table failed to load. Please try again."** with a Reload button.

**Root-caused via network inspection (not just DOM signal — satisfies Rule 6):**
- `GET /content?...&data_set=DataSetContentCustom...` → **200 OK** (post-level data fetch succeeds)
- `GET /content/analysis?...&data_set=DataSetContentCustom...` → **503** (the Sum/Avg aggregate-row fetch fails)

Reproduced 3 times independently (initial load, Reload click, hard F5) — 503 every time on `/content/analysis` specifically when `data_set: DataSetContentCustom` is in the request payload.

**Isolated to the custom-data-set path specifically:** switched the Data Set dropdown back to "Public" (`data_set: DataSetContentLfm`) on the same brand/date-range/channels — the page loaded cleanly with a fresh 200 on the equivalent `/content` call and no error banner. The 503 only occurs when a Custom Data Set is the active `table_data_set`.

**Impact:** this blocks the entire remainder of the test (steps 5–7, assertions A5–A8) — you cannot verify column visibility, Table/Grid view parity, or the All Metrics container when the table itself won't render. This is the core feature under test (QA-109059 = "Custom Data Sets support on Brand > Content"), so this is a high-severity, reproducible regression, not a minor issue.

### Bugs filed

> Markdown only — no Jira tickets created.

**Bug 1 (confirmed) — Custom Data Set dropdown sorted alphabetically, not by creation date (A2).** Repro: Brand > Content > any brand > Data Set dropdown with ≥2 custom data sets of mixed-case names and non-alphabetical creation dates. Expected: ascending creation-date order per spec. Actual: case-sensitive ASCII alphabetical order. **Second independent confirmation** — first observed 2026-05-13 (same Jira case, filed then as a candidate; now reproduced on 2026-07-07 with entirely different data sets/timing). Recommend escalating from "candidate" to a filed Jira bug.

**Bug 2 (confirmed, new) — `/content/analysis` returns 503 whenever a Custom Data Set is selected on Brand>Content, blocking the whole table.** Repro: Brand > Content > any brand > Data Set dropdown > select any entry under "Custom Data Set". The post-level `/content` call succeeds but the Sum/Avg `/content/analysis` call 503s every time, and the UI shows "This table failed to load." Reload and F5 do not resolve it. Switching back to "Public" or a Channel-Specific data set resolves it immediately (fresh 200, no error). This is a **Blocker-severity regression for the core Custom Data Sets ↔ Brand>Content integration** — it was working in the prior QA-109062 run (2026-06-27, "Brand>Content export... PASS 7/7") which used a custom data set successfully, so this is either a recent dev-environment regression or an environment-specific flake. Recommend LFIQA verify against a stable environment before treating as a shippable-blocking bug; if it reproduces there too, this blocks QA-109059 end-to-end.

---

## Notes / Observations

- **No `brand-content-data-set-selector` skill exists on disk** despite two prior run reports (2026-05-13, this one) recommending one be authored. The Data Set dropdown navigation pattern (open dropdown → 3 option-groups → click a Custom Data Set entry by name) is now documented twice in run reports but never promoted to a skill file. Recommend authoring it once QA-109059 can be re-run end-to-end (currently blocked by Bug 2 above) so the skill can also document the Table/Grid/All-Metrics/unselect flow.
- **Account CDS count:** net 0 change (created 1 precondition, deleted 1 after test). Confirmed via F5 reload: 7 CDS both before and after.
- This is the **second run in today's session** to hit an anomaly around Custom Data Sets on the shared Adam Orfei account (see `QA-106221-report.md` Problem #3) — worth flagging to the team that this account/feature combination may be under active investigation or experiencing broader instability today.

## Skill / KB changes recommended (not yet made — pending team confirmation)

- `knowledge-base/known-quirks.md`: add an entry for the `/content/analysis` 503-on-custom-data-set regression once confirmed by a second tester or in a later run.
- `knowledge-base/bug-history.md`: upgrade the QA-109059 A2 alphabetical-sort finding from "candidate" (2026-05-13) to "confirmed, 2× reproduced."
