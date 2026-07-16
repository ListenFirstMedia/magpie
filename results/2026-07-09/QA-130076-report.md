# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Major (P3)
- **Account:** **Viacom** (switched via the LFQA user menu — precondition met)

## Verdict: BLOCKED (data availability — no lost-authorization notification exists to inspect; re-confirmed 2026-07-10)

## 2026-07-10 re-run update
Re-checked on **Viacom** Settings > Notifications: **98 notifications, all "Fetch Job Complete" type — still no "NOT COLLECTING" / "lost data collection" entry.** No Viacom feed is currently in a lost-authorization state, so the lost-auth messaging (A1–A4) still cannot be inspected. This is an **unfixable-by-retry** data condition: verifying lost-auth messaging requires a feed to actually be in a lost-auth state (seeded/real), which automation cannot create. Genuinely BLOCKED until such an event exists.

---
### (original verdict) BLOCKED (data availability — no lost-authorization notifications present to inspect)

## Known bugs checked
No open linked bug.

## Setup performed
- **Account precondition met:** switched from Adam Orfei to **Viacom** via the LFQA user-menu account switcher (the menu lists Viacom directly).
- **Note 1 (one-time setup):** opened Settings > Notifications → **Subscriptions** popover → enabled the **Data Collection** toggle (it was OFF).
- **Note 2:** on Dev (app.lfmdev.in), not Stage — OK.

## Why blocked
After switching to Viacom and enabling the Data Collection subscription, the **Notifications screen shows no lost-authorization notifications** — the list (78 items) contains only fetch-job and export messages ("Fetch job … completed", "Your Content/Paid Export … is now ready"). No entry with **"NOT COLLECTING"** status or the **"We lost data collection on the '<feed>' feed for the '<brand>' brand"** message is present. This means **no Viacom feed is currently in a lost-authorization state**, so the lost-auth messaging (A1–A4) cannot be inspected — a data-availability condition, not a product defect.

## Assertions
| ID | Expected | Status |
|---|---|---|
| A1 | Message displays affected feed name | BLOCKED (no lost-auth notification present) |
| A2 | Message displays associated brand name | BLOCKED |
| A3 | Status "NOT COLLECTING" | BLOCKED |
| A4 | Format: "We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot" | BLOCKED |

## Recommended re-test
Run when a Viacom feed is actually in a lost-authorization state (or seed one) so a "NOT COLLECTING" notification exists to inspect; then verify the message identifies the feed + brand and matches the standard format.

## Notes
- The **Data Collection** subscription toggle was left enabled (Note 1 frames it as intended one-time setup; benign notification preference). Account left on **Viacom** — switch back to Adam Orfei for subsequent cases as needed.

## Bugs filed
None.
