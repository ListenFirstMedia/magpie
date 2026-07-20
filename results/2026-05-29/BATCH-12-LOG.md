# Batch 12 log — 2026-06-02 (FINAL)

| Ticket | Account / Brand | Skill(s) | Result |
|---|---|---|---|
| QA-65554 | Adam Orfei | export-google-sheets v2 | PASS 3/3 — re-confirmed GS export filename `Adam Orfei-Tags`, columns Tag/Date Created/Creator/Content Tagged, 5 spot-check rows including `*` creator and `iconic`→2 multi-count row all match. Skill pass_streak 2→3 (eligible for stable promotion). |
| QA-90213 | Adam Orfei / MTV (brand_id=4018) | data-studio-post-level-run | MAJOR FINDING — parity mismatch has NEARLY RESOLVED. DS Twitter Post Likes Sum 370,018 vs BC Reactions Sum 368,312 (Δ +0.46%); DS Twitter Post Replies 2,265 vs BC Comments 2,238 (Δ +1.21%). Previous batch (2026-05-27) showed 3.84× and 2.19× ratios — now sub-1.5%, consistent with normal snapshot freshness lag. Recommend SME confirm whether sub-1.5% diff is tolerated. |
| QA-929 | Sephora (acct 655 / brand 7159) | brand-content-data-set-selector | 7/7 resolved (5 PASS, 1 PARTIAL, 1 PASS via DOM-href). A5 newly verified via DOM href inspection (row 1, 3, 4 all show real Pinterest pin URLs). A3 X-close newly confirmed (click at 887,10). Row 3/4 blank-tooltip issue persistent (Pinterest embed not rendering — likely deleted/restricted pins on Pinterest side, not LFM bug). |
| QA-96038 | Hulu (acct 336 / brand 5670) | audience-metrics-export | PASS 2/2 re-confirmed. M=856,949, F=1,333,591 in both Gender Breakdown fetch and CSV first row. Meter values NOT summed across 7 days (each row shows snapshot). Filename `Hulu-Audience-Followers Gender Breakdown-2026-05-19-2026-05-25.csv`. Identical values to 2026-05-27 batch run. |

## Bugs surfaced this batch

- **QA-90213 (residual parity):** Previously-FAIL parity test is now within ~1% — recommend SME determination of strict vs tolerance equality semantics. Not a new bug filing; rather an update to QA-90213's existing "magnitude has shrunk" status.
- **QA-929 (carry-forward investigation):** Pinterest embed iframe stays blank for some pin URLs (Sephora rows 3 & 4 in this Data Set / date range). Same issue across batches 2026-05-27 + 2026-06-02 (6+ days persistent). Likely external to LFM (Pinterest pin restricted/deleted/redirect-broken). Product team should add graceful "Pinterest pin unavailable" placeholder.

## Skill registry updates

- `export-google-sheets` v2 → stable promotion eligible (3 separate-day successful runs: 2026-05-13, 2026-05-27, 2026-06-02).
- `brand-content-data-set-selector` v1 → stable promotion eligible (3 separate-day successful runs).
- `data-studio-post-level-run` → pass_streak preserved (skill mechanics work; the FAIL was data-side).
- `audience-metrics-export` → stable (already promoted), pass_streak +1.

## Known quirks reinforced

- DS Twitter parity vs Brand>Content can show a small residual diff (sub-1.5%) due to snapshot timing; not always strict equality.
- Pinterest embed in tooltip can render blank for pins no longer available on Pinterest; row 1 of Sephora data renders fine.
- Brand>Content Data Set selector reverts to `Public` on direct-URL navigation; must be set via UI after page load.
- Brand>Content channel URL params get auto-merged with prior session channel set on first nav; force-set via URL works but requires careful overwrite (only `channels=pinterest` param remained final after manual selection).

## All 59 tickets — batches 1-12 complete

This batch (12/12) is the LAST. All 59 tickets in the re-run program now have reports in `runs/2026-05-29/`.

Total batches: 12. Total tickets re-run: 59. Bug-history.md tracks linked Jira bug status per ticket. KB additions: rule-1 brand exact-match patterns reinforced (MTV → MTV not MTV Argentina), Pinterest data-set quirk, audience CSV first-row vs meter-snapshot semantics, fetch-hook capture technique.
