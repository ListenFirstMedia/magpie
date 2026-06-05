# QA-84194 — Reporting > Data Studio - Brand > Content - Data QA - Impressions (re-run 2026-06-04 batch-6)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84194
- **Account:** Adam Orfei (account_id=54)
- **Brand attempted:** MTV (brand_id=4018) and Hulu (brand_id=5670)
- **Channel:** Twitter (Authorized-only metric path)
- **Window:** Absolute May 27 – Jun 02 2026, In-Window mode

## Result: PARTIAL — DS Post Level Twitter Impressions blocked at metric-pick (Authorized-only on Adam Orfei lookup) AND Brand>Content cross-source for Hulu BLOCKED (same as QA-84193)

## Steps executed

1. Reporting → Data Studio → Post Level.
2. Window Mode = In-Window, Custom date range May 27 – Jun 02 2026.
3. Added MTV brand via typeahead (first Results entry).
4. Public view default toggle position (left).
5. Select Metrics → filter input typed `Twitter` → metric tree expanded.
6. **Finding:** Under Impressions section the `Twitter Post Impressions` checkbox is GRAYED OUT (disabled) for the Public view. Only `Twitter Post Likes`, `Twitter Post Replies`, `Twitter Shares`, `Twitter Public Views` (Public Video Views), `Twitter Views` (Public Impressions sub-tree) are enabled.
7. Attempted to flip the View toggle to Authorized — toggle handle showed transient movement but on re-screenshot remained in left/Public position (per `controlled-check-box` quirk pattern; would need focus+Space dispatch).
8. Time budget constraint stopped further metric-tree retries.

## Source-1: DS Post Level (intended — Twitter Authorized Impressions Sum) — INCOMPLETE
The Authorized-perspective fetch did not complete in time. Only verified that the path requires Authorized view, which Adam Orfei MTV defaults to Public; the toggle-flip-then-rerun path is documented but not executed end-to-end in this batch.

DS Post Level UI signal: `Twitter Post Impressions` leaf disabled-state confirmed under Impressions → Impressions (All).

## Source-2: Brand > Content Hulu Twitter Impressions — BLOCKED
Same as QA-84193 — Hulu Brand>Content URL nav from Adam Orfei session redirects to `/#home`. Cross-account verification deferred.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | DS Twitter Impressions value loads | (numeric Sum) | Authorized perspective required; toggle flip incomplete in run window | NOT VERIFIED |
| A2 | Brand>Content Twitter Impressions Sum loads | (numeric Sum) | Hulu BC URL nav redirects to Home; account-cross access blocker (same as QA-84193) | NOT VERIFIED |
| A3 | DS – BC delta within 1.5% | (computed delta) | Cannot compute without both sources | NOT VERIFIED |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-84194-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-84194.md` (proxy spec)

## Notes / Carry-forward

- **Confirmed pattern:** Public-view DS Post Level metric tree shows `Twitter Post Impressions` as disabled — selecting it requires flipping the per-brand row View toggle to Authorized. (Per `view-perspective-toggle` skill: never trust URL; flip and verify.)
- **Carry-forward:** Same Hulu Brand>Content cross-account redirect from QA-84193 — affects any Hulu-named test exercised from Adam Orfei session.
- The QA-90213 batch-12 finding (sub-1.5% residual drift) remains the closest reference for likely numeric parity behavior on this metric pair.
- For future runs of QA-84193/QA-84194, recommend pre-switching to a brand that lives on Adam Orfei AND has Twitter Authorized (so both DS and BC are on the same account session), OR running this case on an account that natively owns Hulu (e.g., a Hulu-account login).
