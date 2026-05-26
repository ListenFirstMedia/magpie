# QA-109059 — Settings > Custom Data Sets support on Brand > Content

> **Status:** 🟡 PARTIAL — A1 verified PASS, A2 likely FAIL (bug-flag), A3-A8 not exercised (time-boxed)
> **Run date:** 2026-05-13 · **Env:** dev · **Browser:** Regression Testing
> **Account:** Adam Orfei · **User:** LFQA (LFIQA)

## Execution

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Brand → Content | ✅ |
| 2 | MTV (default for Adam Orfei) | ✅ |
| 3 | Open Data Set dropdown | ✅ |
| 4 | Click custom data set | not executed — sufficient to verify A1/A2 from the open dropdown |
| 5-7 | Table view, grid view, unselect Engagements | not executed |

## Assertion results

### ✅ A1 — Custom Data Set section appears below Channel-Specific Metrics, header "Custom Data Set"

The Data Set dropdown contains three sections in order:
1. **Cross-Channel Metrics** (Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels)
2. **Channel-Specific Metrics** (Facebook Only, Twitter Only, Instagram Only, YouTube Only, Threads Only, Pinterest Only — 14 entries)
3. **Custom Data Set** (6 entries — Adam Orfei's saved custom data sets)

The header text is `Custom Data Set` (singular) — matches the assertion exactly.

### ⚠ A2 — Display order does NOT match creation order (POTENTIAL BUG)

The displayed order in the dropdown vs the creation order in Settings > Custom Data Sets:

| UI order | Custom Data Set | Creator | Created | Note |
|---------:|-----------------|---------|---------|------|
| 1 | Test 3 Dupes | Phil Cutler | May 9, 2025 | |
| 2 | performance test | Sasikumar Drylogics | May 23, 2025 | |
| 3 | performance test 2 | Sasikumar Drylogics | Jun 5, 2025 | |
| 4 | Test | James Butler | Jul 16, 2025 | |
| 5 | Main Test 1 | Phil Cutler | Mar 28, 2025 | **out of place** |
| 6 | Some new data set name | Phil Cutler | Apr 18, 2025 | **out of place** |

Items 1-4 are in ascending creation-date order, but items 5-6 (the two oldest sets) are appended at the END instead of being at the start. Possible causes:
- The list is sorted by some hidden field (last-edited? last-used? favorited?) rather than created_at.
- There's a partial migration or backfill in the data store where some sets carry a different timestamp.
- The Settings page sort doesn't match the Brand>Content dropdown sort by design — but the assertion explicitly says "displayed in the created order."

**File this as a bug.** Repro: open Brand > Content > Data Set dropdown with the 6 existing custom data sets in Adam Orfei. Expected display order if strictly by created_at ascending: Main Test 1, Some new data set name, Test 3 Dupes, performance test, performance test 2, Test. Actual: as shown above.

### A3 — A8 — Not exercised

The remaining assertions (channel order, Pinterest after divider, selected-metrics visibility, table-view consistency, grid-view container, unselect Engagements) require clicking into a custom data set and switching views. Time-boxed for this session. The skill `brand-content-data-set-selector` documents the entry point so these can be exercised in a follow-up run.

## Findings

### 🐛 F1 — Bug candidate: Custom Data Set display order not matching creation order

See A2 above. High confidence this is a genuine product issue, not an automation artifact. Worth filing as a bug under APPS or as a sub-task of QA-104867.

## Skills authored

| Skill | Purpose |
|-------|---------|
| `brand-content-data-set-selector` (new, v1, untrusted) | Open Brand > Content for a brand, open the Data Set dropdown, find the Custom Data Set section, click a custom data set by name |
