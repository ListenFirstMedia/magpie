# QA-134449 — Brandsets > Optimization — Layered tag filtering (Include + Exclude)

- **Run:** 2026-07-08 (headless Playwright MCP, unattended)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134449
- **Account:** HBO Max (account_id=657) · **Brandset:** LF // TV // Episodic (brand_set_id=756)
- **Surface:** Brand Sets > Optimization (`#explore/competitive/optimization`)
- **Date range:** Jan 1 – Jan 7, 2026 (`from=2026-01-01&to=2026-01-07`)
- **Perspective:** Public Data (default; spec does not require Authorized)
- **Skill reused:** `brand-content-filter` v2 (layered Tag filter, Brand Sets > Optimization is one of its 7 surfaces); `switch-account` v2
- **Open-bug screen:** "None open" → ran normally.

## Verdict

**BLOCKED — test-data gap (precondition unmet).**
The tag-filter **feature works** on this surface (panel, Include/Exclude greying, OR/AND enable+toggle, layered URL encoding, Clear All, reload persistence all PASS). But the core **data-dependent** assertions (A2, A6, A7, A9, A11) are **NOT EVALUABLE** because **no post in the Jan 1–7 2026 window carries any content tag** — the precondition "tags pre-applied to posts" is not satisfied for this window/brandset. Per Rule 1/3/5, no date-range/brandset substitution was made to manufacture matching posts (QA-91412 false-positive pattern). This is a test-data gap, **not a product defect**.

### Decisive evidence that in-window posts are untagged
- **Include = None** (untagged) → tiles + BPC **render data** (`.playwright-out/QA-134449/` — Include=None returned `noData:false`). Posts DO exist in the window (baseline BPC = 5 posts).
- **Include = "1923"** → 0 posts / all tiles "no data available" (`step9-applied-filtered.png`).
- **Include = "looney tunes"** (matches the #1 baseline BPC post's brand) → 0 posts / "no data available" (`step5-include-looney.png`).
- **Include = 9 campaign hashtags OR** (`#20daysofkindness`,`#bobesponja`,`#cerimôniadeseleção`,`#devoltaahogwarts`,`#littlewomenlibraries`,`#max`,`#meukryptonahbomax`,`#superhomieshbo`,`#twinlove`) → 0 posts / "no data available" (`probe-hashtags.png`).
- **Include = ALL tags EXCEPT None** ("any tagged post") → **0 posts, BPC empty** (`probe-all-except-none.png`).
→ Every content tag has zero in-window matches; only untagged (None) posts exist. Conclusion: the window's posts carry no content tags.

## Steps executed

| # | Spec step | Executed | Notes |
|---|-----------|----------|-------|
| 1 | Brandsets > Optimization | ✅ | Via Brand Sets menu → Optimization |
| 2 | Account HBO Max; Brandset LF // TV // EPISODIC | ✅ | Switched Hulu(336)→HBO Max(657) via LFQA menu Results row; brandset already LF // TV // Episodic (brand_set_id=756) |
| 3 | Date range 1/1/2026 – 1/7/2026 | ✅ | Two-calendar picker (Start=Jan 1, End=Jan 7); confirmed `from=2026-01-01&to=2026-01-07` |
| 4 | Open Tag Filter panel | ✅ | Filter dropdown → Tag → Include/Exclude + Or/And + Select All + tag list |
| 5 | Add tag to Include | ✅ | Selected "1923" (then also probed "looney tunes", campaign hashtags) |
| 6 | Attempt same tag to Exclude | ✅ | Switched to Exclude radio; "1923" row greyed/disabled |
| 7 | Add another tag to Exclude | ✅ | "a minecraft movie" added to Exclude |
| 8 | Toggle OR/AND | ✅ | With 2 tags in Include group, OR/AND becomes enabled + toggles OR↔AND |
| 9 | Apply filters | ✅ | URL encodes layered content_tags; tiles refresh (to 0 posts, test-data gap) |
| 10 | Add another tag with OR/AND; Apply | ✅ (mechanic) | 2-tag Include #20daysofkindness AND #bobesponja applied |
| 11 | Clear All | ✅ | Empties Include+Exclude; removes `filters=` from URL; restores baseline |
| 12 | Re-add tags, remove only Exclude | ⚠ partial | Include/Exclude re-add + greying shown; "returns Include-only set" not observable (0 posts) |
| 13 | Save layered filter, reload, reopen | ✅ (deep-link) | Applied filter re-hydrated after full page reload (pill restored from URL) |
| 14 | Export Optimization tiles/data as CSV | ❌ not evaluable | No filtered (tagged) rows exist to export — see A11 |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Tag Filter panel opens with Include+Exclude empty | Panel opened: Include (default-selected) + Exclude radios, Or/And, Select All, tag list; no tag checked | **PASS** (`step4-tag-panel.png`) |
| A2 | 5 | Include tag refreshes tiles to matching posts only | Tiles refresh on apply, but every content tag → 0 in-window posts ("no data available"); cannot observe a non-empty matching set | **NOT EVALUABLE** (test-data gap) |
| A3 | 6 | Same tag greyed in Exclude | "1923" row in Exclude = `option-row disabled`, opacity 0.38, `pointer-events:none` — greyed/unselectable | **PASS** (`step6-exclude-greyed.png`) |
| A4 | 7 | Exclude refreshes to Include AND NOT Exclude | URL encoded `content_tags:[{or,["1923"],not:false},{or,["a minecraft movie"],not:true}]` — Include AND NOT Exclude semantics correct; result 0 posts (data gap) | **PASS (semantics)** / result NOT EVALUABLE |
| A5 | 8 | OR/AND enabled after tag selected | 1 tag → operator `pointer-events:none` (disabled); 2 tags → `pointer-events:auto` (enabled); toggled OR→AND (pill "…Or…"→"…And…", URL operator `or`→`and`) | **PASS** (`step8-orand-toggle.png`) |
| A6 | 9 | BPC Posts updated | BPC changed on apply (5 baseline → 0/empty); no non-empty tagged subset to confirm meaningful update | **NOT EVALUABLE** (test-data gap) |
| A7 | 10 | OR shows any/both; AND shows both | Requires overlapping tagged posts; none exist in-window | **NOT EVALUABLE** (test-data gap) |
| A8 | 11 | Clear All empties both, restores unfiltered view | Clear All removed both pills, dropped `filters=` from URL, restored baseline tiles/BPC | **PASS** |
| A9 | 12 | Removing only Exclude returns Include-only set; Include persists | Pill remove + Include-persist is a working mechanic, but "returns Include-only set" of posts not observable (0 tagged posts) | **PARTIAL / NOT EVALUABLE** |
| A10 | 13 | Saved filter persists after reload | Applied layered filter (`#20daysofkindness AND #bobesponja`) re-hydrated into the pill after a full page reload from the deep-link URL | **PASS** |
| A11 | 14 | Export contains only filtered rows | No filtered (tagged) rows exist to export; export would cover only untagged/empty set. Not verified on disk (Rule 6 — did not fake a download) | **NOT EVALUABLE** (test-data gap) |

## Evidence (key numbers/text)

- **Account/brandset breadcrumb:** "Account: HBO Max | Brand Sets > Optimization", header "LF // TV // Episodic", "Date Range: Jan. 01, 2026 - Jan. 07, 2026".
- **Baseline (no filter), 5 BPC posts:** looneytunes TikTok (RR 1,096,600%, Engagements 10,966), @EBWebzine Twitter (RR 508.64%), cho_kaguyahime_pr TikTok (RR 243.27%), @Tubi Twitter (RR 17.03%), @DARKMOON_TBA Twitter (RR 13.96%). (`step3-baseline-full.png`)
- **A4 URL (Include+Exclude):** `filters={"content_tags":[{"operator":"or","values":["1923"],"not":"false"},{"operator":"or","values":["a minecraft movie"],"not":"true"}]}`
- **A5 URL (OR/AND with 2 tags):** `…{"operator":"and","values":["#20daysofkindness","#bobesponja"],"not":"false"}…`; pill text flipped "Tag: #20daysofkindness Or #bobesponja" → "…And…".
- **A8:** after Clear All the URL had no `filters=` param.
- **A10:** post-reload pill = "Tag: #20daysofkindness And #bobesponja" (re-hydrated).

## Screenshots (.playwright-out/QA-134449/)
- `step3-optimization-initial.png`, `step3-datepicker.png`, `step3-after-ok.png`, `step3-baseline-full.png` — nav + date-range setup + baseline
- `step4-tag-panel.png` — A1 (panel Include+Exclude empty)
- `step6-exclude-greyed.png` — A3 (same tag greyed in Exclude)
- `step7-two-pills.png` — Include + Exclude pills
- `step9-applied-filtered.png` — Include 1923 applied → no data
- `step5-include-looney.png`, `probe-hashtags.png`, `probe-all-except-none.png` — test-data-gap probes (all tags → 0 posts)
- `step8-orand-toggle.png` — A5 (OR/AND enabled + toggled)

## Bugs filed
None. The layered tag-filter feature on Brand Sets > Optimization behaves correctly (A1/A3/A4/A5/A8/A10 all pass). The blocked assertions are a **test-data gap** (no tagged posts in the Jan 1–7 2026 window on LF // TV // Episodic), not a product defect — do not file (would repeat the QA-91412 false-positive pattern).

## Recommendation to spec owner / LFIQA
Provision content-tagged posts on the **LF // TV // Episodic** brandset within the spec's **Jan 1–7 2026** window (or update the spec to a window/brandset that has tagged posts), then A2/A6/A7/A9/A11 become testable. The feature mechanics are already verified this run.
