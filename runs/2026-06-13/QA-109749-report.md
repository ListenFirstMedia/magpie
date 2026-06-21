# QA-109749 — Brand Audience > Threads - Hovering Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (carry-forward) — Threads-Audience no-data + Brand>Audience renderer-hang family

## Rationale
- Brand>Audience for Threads requires Threads-audience data, which is absent on accessible MTV/Michael Kors brands (Threads channel not in Data Identities — see QA-96045), so there are no hoverable audience tiles. Brand>Audience+Threads is also part of the renderer-hang family that froze the CDP pipeline repeatedly this session (QA-89390/QA-96759). Not driven, to protect the session. Consistent with 2026-06-05 PARTIAL/no-data.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Audience Threads tile hover tooltips | Tooltip on audience tiles | No Threads-audience data / renderer hang | 🚫 BLOCKED |

## Bugs filed
_None (test-data gap + renderer hang; see known-quirks)._
