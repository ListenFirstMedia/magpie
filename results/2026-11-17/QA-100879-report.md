# QA-100879 — Brand Content > LFM vs Native > Threads Channel

- **Run date:** 2026-11-17 (unattended, headless `claude -p`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-100879 · Test Set QA-21686 "Daily Data Testing -3"
- **Verdict:** **FAILED (blocked by open bug)** — not executed. Per Rule 7 (open-bug auto-fail, `skills/_shared/spec-adherence-rules.md`), a case with any OPEN linked bug is marked failed without running the browser flow.
- **App:** `app.lfmdev.in` (Brand > Content), precondition account HBO Max

## Steps executed
None. The case's "## Open linked bugs" section lists an open bug, so the screen failed before the browser was opened (no login, no navigation, no screenshots).

## Known bugs checked
- **LFMP-32113 (Open)** — "Brand Content > LFM vs Native - Past Date - native data is lower than LFM".
  - It sits on the same surface as this case, Brand Content LFM vs Native comparison.
  - It directly interferes with the sole assertion (7): the LFM-vs-Native variance check cannot be trusted while native data is known to be lower than LFM.
  - The cached case file (baked in on 2026-10-20) and `results/open-bugs-2026-11-17.json` both list it as `[Open]`.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-100879 (pre-fetched shell-side).

## Assertions (not executed)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 7 | 5–7 | LFM metric values (Reactions/Comments/Shares of first Threads post) show no big variation vs Native (Likes/Comments/Shares on the native post page) | Not run | ⛔ Blocked by open bug LFMP-32113 |

## Evidence
No screenshots. Nothing was executed against the app.

## Cleanup
None (read-only Data Test; nothing created).

## Bugs filed
None. The pre-existing open bug LFMP-32113 is the blocker; no new Jira tickets are created from this run.

## Re-run condition
Re-execute once LFMP-32113 is closed and the case's cached "Open linked bugs" section is refreshed from Jira.
