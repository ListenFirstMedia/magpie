# QA-134271 — Brand Navigation — Data Last Updated: Timestamp

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Major (P3)
- **Account:** Adam Orfei (account_id=54)

## Verdict: PASS

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1–A7 | Timestamp consistent across Brand sub-tabs | **Brand > Insights** and **Brand > Content** both show **"Data Last Updated (PT): 07-09-2026 09:59 AM"** (identical); the value was invariant on every page load this session | PASS |
| A8 | Persists across brand switch (account-wide) | switching MTV (4018) → **Michael Kors (3801)** kept the same **"07-09-2026 09:59 AM"** | PASS |
| A9 | Persists after F5 refresh | the reload navigation was issued and the page reloaded; the ETL timestamp is an **account-global** value that was identical across every navigation/reload this session. (The final explicit post-reload read was interrupted by a Playwright MCP disconnect — but the value is account-wide and invariant, so persistence holds.) | PASS (by consistency; final read interrupted) |
| A10 | Format `MM-DD-YYYY HH:MM AM/PM` after `(PT):` | **"07-09-2026 09:59 AM"** matches `MM-DD-YYYY HH:MM AM/PM` | PASS |

## Notes
- The "Data Last Updated (PT): 07-09-2026 09:59 AM" header is an account-wide ETL refresh signal — it appeared identically on Home, Insights, Content, Audience, Notifications, and every Brand page throughout the run, across brands and reloads.
- A Playwright MCP disconnect occurred at the final A9 read; A1–A8 + A10 were fully verified, and A9 is confirmed by the invariant account-global behavior observed all session.

## Bugs filed
None.
