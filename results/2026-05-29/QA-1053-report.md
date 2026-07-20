# QA-1053 — TWC Aggregate - Relative dates - Lock icon and Endash

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1053
- **Run date:** 2026-06-02 (batch 7)
- **Account:** Hulu (account_id=336)
- **Brands:** Hulu (primary, Authorized Data), Full Frontal with Samantha Bee (Public, lock-only metrics), Snowfall (Public, lock-only metrics)
- **Interval:** Aggregate
- **Date Range:** 5 Days Before Event ↔ 0 Days After Event (key date Jan 01, 2024 for all 3 brands)
- **Data points:** Instagram Comments, TikTok Total Followers
- **Priority:** Critical (P2)
- **Result:** PASS 3/3

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account Adam Orfei → Hulu via Search Account | OK |
| 1 | Top nav: Reporting → Time Window Comparison | OK |
| 2 | Interval dropdown → Aggregate | OK |
| 3 | Relative Dates tab; Start=5 Days Before, End=0 Days After (auto) | OK |
| 4 | Add Brand By Name "Hulu" → picked Hulu from Results | OK |
| 5 | Key Date for Hulu = Jan 01, 2024 | OK — datepicker year-view → 2024 → Jan → 1 |
| 6 | Add brand "Full Frontal with Samantha Bee" → picked from Results | OK |
| 7 | Key Date FFwSB = Jan 01, 2024 | OK |
| 8 | Add brand "Snowfall" → picked from Results | OK |
| 9 | Key Date Snowfall = Jan 01, 2024 | OK |
| 10 | Clicked "Use Authorized Data" — Hulu toggle flipped to Authorized Data. FFwSB+Snowfall toggles remain Public (greyed; auth not available) | OK |
| 11 | Channel Data filter "Instagram Comments" → checked the leaf checkbox (under Content > Comments > Instagram Comments). Then filter "TikTok Total Followers" → expanded Audience & Growth → checked the leaf | OK — final selection: 2 metrics, 1 each in 2 categories |
| 12 | Run Report | OK — report rendered after Building Your Story / View Now |

## Report contents

**Header:** Hulu — Time Window Comparison (5 Days Out - Event Day)  
**Type:** TV Network. **Manufacturer:** Hulu.  
**Competitors:** Full Frontal with Samantha Bee, Snowfall.  
**Legend chips:** Hulu | Full Frontal with Samantha Bee [P] | Snowfall [P]

### Instagram tile — Instagram Comments

**Graph:**
- Hulu — purple bar at ~1,250
- Full Frontal with Samantha Bee — NO BAR; X-axis position shows orange/red **lock icon** (🔒)
- Snowfall — NO BAR; X-axis position shows teal **lock icon** (🔒)

**Table:**
| Brand | Instagram Comments |
|-------|--------------------|
| Hulu | **1,265** |
| Full Frontal with Samantha Bee | **🔒 lock icon** |
| Snowfall | **🔒 lock icon** |

### TikTok tile — TikTok Total Followers

**Graph:**
- Hulu — purple bar at ~5.5M
- Full Frontal with Samantha Bee — small orange bar (~149K)
- Snowfall — no bar drawn (DOM verified: only 2 `<rect>` data points present, no third for Snowfall)

**Table:**
| Brand | TikTok Total Followers |
|-------|------------------------|
| Hulu | **5,500,000** |
| Full Frontal with Samantha Bee | **149,700** |
| Snowfall | **– (endash)** |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Snowfall displays en-dash in TikTok Total Followers Graph and Table | Graph: no bar drawn for Snowfall (DOM-verified 2 rects only, no 3rd). Table: explicit `–` endash in Snowfall row's TikTok Total Followers cell | PASS |
| A2 | Full Frontal with Samantha Bee and Snowfall display lock for Instagram Comments in Graph and Table | Graph: both brands' X-axis positions show 🔒 lock icons in their respective brand colors (orange + teal). Table: both rows have a lock icon in the Instagram Comments column (instead of a value) | PASS |
| A3 | Data displays for Full Frontal with Samantha Bee and Hulu for TikTok Total Followers | Hulu=5,500,000; Full Frontal with Samantha Bee=149,700 — both numeric values rendered in the table and visible as bars in the graph | PASS |

## Bugs filed
None.

## Skill registry impact

- `time-window-comparison-run` — pass_streak +1 (Aggregate interval Relative Dates Hulu+FFwSB+Snowfall on Jan 01 2024).
- `keydate-picker` — pass_streak +1 (3 brands x same datepicker navigation — year-view to 2024 → Jan → 1).
- `switch-account` — used Adam Orfei → Hulu via Search Account.

## Notes on quirks observed

- **Brand picker requires React-aware input setter** (known quirk). `Search for a Brand` input ignored synthetic `value=` mutation; using `Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set` + `input` event was required to open the autocomplete Results.
- **TWC date-picker `th.prev` arrow:** Synthetic `.click()` worked when targeted via `.al-modal th.prev`, but only after first clicking the `datepicker-switch` label to go to year-view. Year-view navigation was reliable; the day-view navigation had the historic click-target friction (known quirk).
- **Filter Metrics tree lazy nodes:** `Instagram Comments` leaf was initially `leaf--disabled` with `title="Authenticated Data Unavailable for Public Perspectives"` because Hulu was still on Public. Re-enabling Hulu to Authorized Data made the metric selectable.
- **`Use Authorized Data` button vs row toggle:** The bulk button toggles Hulu's row toggle in-place; clicking the row's `al-toggle__checkbox` via JS was the most reliable way to set the perspective.

## Sources
- [QA-1053 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-1053)
- Prior run: `/runs/2026-05-13/QA-1053-report.md` (PASS) and `/runs/2026-05-27/QA-1053-report.md` (PASS)
