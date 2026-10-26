# QA-22105 — Brand Content > LFM vs Native > Twitter Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no X login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Twitter only · Date range: Jan. 01, 2024 – Dec. 31, 2024 · Data set: Public
**Verdict: FAIL — open linked bug LFMP-32113 (Open) ⇒ FAILED per policy. Execution outcome: native post could not be read — x.com returned "Access to x.com was denied … HTTP ERROR 403" to the logged-out headless browser, so the Likes/Retweets/Quote Tweets comparison was not evaluable**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → Hulu → date range Jan 01 – Dec 31 2024 | ✅ `from=2024-01-01&to=2024-12-31` (START/END fields "Jan 01, 2024 / Dec 31, 2024") |
| 3 | Twitter only → Apply | ✅ Posts (3) |
| 4 | First post metrics (grid card) | ✅ Tue Dec 31, 2024 "The past never stays buried. All episodes of Goosebumps: The Vanishing…" — Engagements 252 · Reactions 184 · Comments 9 · Shares 59 · Response Rate 0.02% · Video Views 15,746 |
| 5 | Click image → native tab | ⚠️ opened `twitter.com/15033883/status/1874153547341979847` → x.com answered **HTTP 403 "Access to x.com was denied"** (chrome-error page) |
| 6 | Note native Likes / Retweets / Quote Tweets | ⛔ not readable (403) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions/Shares/Comments ≈ native Likes/Retweets/Quote Tweets | Native page blocked (403) — not evaluable | ❌ FAIL (policy: open bug LFMP-32113; execution: BLOCKED on native access) |

## Evidence
- Session result `ctx._nat.q22105` (card text, LFM metrics, native tab URL/title/body text "Access to x.com was denied | HTTP ERROR 403").

## Known bugs checked
- **LFMP-32113 (Open)** "Brand Content > LFM vs Native - Past Date - native data is lower than LFM" — open ⇒ case marked FAILED (2026-10-22 directive). Could not be re-confirmed today because X blocks logged-out reads.

## Bugs filed
None (existing bug).

## Cleanup
Native tab closed.
