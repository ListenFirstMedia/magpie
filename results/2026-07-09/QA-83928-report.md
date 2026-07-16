# QA-83928 — Brand > Paid - CSV - Select Channels & Data Sets Export notification view

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · **Michael Kors** brand (brand_id=3801) · Brand > Paid · Jul 2–8 2026

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Brand > Paid (Michael Kors) → Export → "Export Select Data Sets" popup (View: CSV) → checked **Facebook Engagements** (default) + **Facebook Rates, Facebook Video Views, Facebook Cost, Facebook Delivery** → Ok → export queued → notification bell → export notification → Download file → CSV on disk → Settings > Notifications confirms the same entry.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | 3-row notification: "Select Channels & Data Sets Export" / "Mon DD, YYYY XX:YY xm" / "Your Paid Export with Select Channels & Data Sets for Michael Kors from Mon. DD, YYYY to Mon. DD, YYYY is now ready. Download file." | "Select Channels & Data Sets Export" / "Jul 09, 2026 09:11 pm" / "Your Paid Export with Select Channels & Data Sets for Michael Kors from Jul. 02, 2026 to Jul. 08, 2026 is now ready. Download file." | PASS |
| A2 | 'Download file' blue hyperlinked | color `rgb(0, 128, 255)` (blue) | PASS |
| A3 | CSV downloaded | `Michael Kors-Cross-Channel-Paid-2026-07-02-2026-07-08.csv` on disk | PASS |
| A4 | Same notification in Settings > Notifications | present at top (Jul 09, 2026 09:11 PM, same message, Download file blue) | PASS |

## Evidence
- `.playwright-out/QA-83928-notification.png` (bell + notification), `QA-83928-settingsnotif.png` (Settings > Notifications)
- `.playwright-out/Michael-Kors-Cross-Channel-Paid-2026-07-02-2026-07-08.csv`

## Finding (harness) — Brand > Paid brand-selector not drivable
The Brand > Paid **brand selector** (`.brand-selector-name-container`) opens on dispatch but the "Search for a Brand" input **closes on blur before it can be typed into** (across MCP calls) — repeated attempts failed. Worked around by navigating directly to the Michael Kors Paid URL (`brand_id=3801&account_id=54`). The brand switch is setup, not the assertion target (the Export→notification flow is), so the workaround is sound — but flag that the Paid brand-picker needs a more robust interaction (candidate: trusted click that holds focus, then `browser_type` within the same open state).

## Bugs filed
None.
