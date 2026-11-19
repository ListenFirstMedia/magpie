# QA-22104 — Brand Content > LFM vs Native > Facebook Channel - Past Date

- **Run date:** 2026-11-18 (unattended, headless `claude -p`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-22104 · Test Set QA-21686 "Daily Data Testing -3"
- **Verdict:** **FAILED (blocked by open bug)** — not executed. Per Rule 7 (open-bug auto-fail, `skills/_shared/spec-adherence-rules.md`), a case with any OPEN linked bug is marked failed without running the browser flow.
- **App:** `app.lfmdev.in` (Brand > Content), Wednesday rotation row would apply (FX Networks / GQ - Japan)

## Steps executed
None. The case's "## Open linked bugs" section lists an open bug, so the screen failed before the browser was opened (no login, no navigation, no screenshots).

## Known bugs checked
- **LFMP-32119 (Open)** — "Brand Content > LFM vs Native > Facebook Channel - Past Date shows big variations when we compare with native".
  - Same surface and same scenario as this case (Facebook channel, Jan. 01 – Dec. 31, 2023, LFM vs Native).
  - It directly matches the sole assertion (6): the LFM-vs-Native variance check cannot be trusted while this bug is open.
  - Listed as `[Open]` in the cached case file (baked in 2026-10-20) and in `results/open-bugs-2026-11-18.json`.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-22104 (pre-fetched shell-side).

## Assertions (not executed)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 6 | 4–6 | LFM metric values (Reactions/Comments/Shares of first Facebook post) show no big variation vs Native (Likes/Comments/Shares on the native post page) | Not run | ⛔ Blocked by open bug LFMP-32119 |

## Evidence
No screenshots. Nothing was executed against the app.

## Cleanup
None (read-only Data Test; nothing created).

## Bugs filed
None. The pre-existing open bug LFMP-32119 is the blocker; no new Jira tickets are created from this run.

## Re-run condition
Re-execute once LFMP-32119 is closed and the case's cached "Open linked bugs" section is refreshed from Jira.
