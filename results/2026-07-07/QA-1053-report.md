# QA-1053 — TWC Aggregate - Relative dates - Lock icon and Endash

- **Run date:** 2026-07-07 (interactive recovery run — was 900 s timeout/no-report in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1053 · Priority: Critical
- **Verdict:** **PASS** — all 3 assertions verified after a fresh re-run (first attempt hit a transient "tile failed to load" on Instagram Comments; rebuilding the report from scratch cleared it).
- **Account:** Hulu (account_id=328) · **Brands:** Hulu (primary), Full Frontal with Samantha Bee, Snowfall
- **Config:** TWC · Interval **Aggregate** · Relative dates **Start 5 Days Before Event** · Key date **Jan 01, 2024** (all 3 brands, via Bulk Select Key Date → Calendar) · **Use Authorized Data** · metrics: Instagram Comments, TikTok Total Followers
- **Skills:** switch-account, time-window-comparison-run, keydate-picker

## Open linked bugs
None open (cache 2026-07-03) — ran normally.

## Assertions (step 12)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Snowfall displays en-dash in TikTok Total Followers (Graph + Table) | Snowfall = **–** in TikTok Total Followers table (and bar absent in graph) | ✅ PASS |
| A2 | Full Frontal with Samantha Bee & Snowfall display **lock** for Instagram Comments (Graph + Table) | Instagram Comments table: Full Frontal = **LOCK**, Snowfall = **LOCK** (Hulu = 1,265) | ✅ PASS |
| A3 | Data displays for Full Frontal with Samantha Bee & Hulu for TikTok Total Followers | Hulu = **5,500,000**, Full Frontal = **149,700** | ✅ PASS |

## Evidence
- `.playwright-out/QA-1053/report-pass.png` — full report; Instagram Comments (locks) + TikTok Total Followers (data + Snowfall en-dash).
- DOM table extract:
  - Instagram Comments → Hulu 1,265 / Full Frontal LOCK / Snowfall LOCK
  - TikTok Total Followers → Hulu 5,500,000 / Full Frontal 149,700 / Snowfall –

## Why this recovered (vs 2026-07-04 BLOCKED, and the first attempt today)
- Unattended run: killed at the 900 s watchdog (this is a heavy 12-step flow: Aggregate + Relative + 3 brands + 3 key dates via calendar navigation to Jan 2024 + Authorized + 2 metrics). No product issue — a per-case time-budget limit.
- First interactive attempt today: the **Instagram Comments tile returned "This tile failed to load"** and stayed erroring through ~3 reloads (A1/A3 already passed). Per user direction, rebuilt the whole report fresh → the tile loaded normally and A2's locks rendered. Transient tile-generation glitch, not reproducible on the clean re-run.

## Bugs filed
None. (Note the transient "tile failed to load" on the first generation — worth watching if it recurs, but it did not reproduce on a fresh run.)
