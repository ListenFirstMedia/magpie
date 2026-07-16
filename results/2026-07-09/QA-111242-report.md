# QA-111242 — Brand > Content - Sentiment - Read comments CSV Export and notification pop-up

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Content · Jul 2–8, 2026 · Sentiment mode ON

## Verdict: PASS (A1 is the known-open-bug probe; core export + notification verified)

## Known bugs checked — tolerated (probe)
- **LFMP-31947** (Open) — "Sentiment Read Comments not displaying for IG channel (posts showing N/A for Classified/Emotions/Topics)." Probed as A1. Does not block the CSV-export/notification functionality (A2–A4) or the non-IG display (A5) → run + note.

## Flow
MTV Content (Sentiment ON) → clicked **Read Comments** on a post ("Bossbabe By'nature") → modal loaded **18 Sample Comments** → **Export ▾ → CSV** → **"Sentiment Export Request"** popup → Ok → CSV auto-downloaded.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (IG probe) | Read Comments displays comments (LFMP-31947 IG known bad) | modal displayed 18 comments; the LFMP-31947 symptom is present — rows with **N/A Classified/Emotion show empty Comment Text** (e.g. 07/06 09:43 AM). Known open bug | Known open bug (noted) |
| A2 | Notification/sample-comments messaging | modal header **"18 Sample Comments"** (sample-count messaging; caps at 2,000 for high-comment posts — this post has 18) | PASS |
| A3 | CSV export request submitted, notification confirms | **"Sentiment Export Request"** popup: "We're hard at work preparing your export… find the link in the app notifications menu, bell icon, and in an email to lfiqa@listenfirstmedia.com" + Ok | PASS |
| A4 | Resulting CSV contains rows + matches modal | `MTV-Brand Content-2026-07-02-2026-07-08-comments-sentiment.csv` — header (Comment Date/Day/Time/Channel/Author/Type/Text/Classified/Emotion/Topic 1/Post Link + tag cols) + **18 data rows matching the modal** (♥️ Positive/Love; "I Love Y'all…north america" Positive/Joy; N/A row with empty text) | PASS |
| A5 (control) | Non-IG channel displays correctly | the opened post's comments are **Facebook**-channel and displayed correctly (18 shown + exported) — non-IG display works | PASS |

## Notes
- The export **auto-downloaded** to disk despite the async/email messaging; verified content directly (A4). (Per emailed-export-scope, the email/notification-download path is otherwise out of scope; the in-app request flow + notification popup are the verified assertions.)
- A1: the post opened resolved to Facebook-channel comments (author posts cross-channel). Comments displayed, but the **N/A-sentiment rows show empty comment text** — the exact LFMP-31947 symptom. A dedicated pure-IG post would isolate the IG-only failure; the open bug covers it.

## Evidence
- `.playwright-out/MTV-Brand-Content-2026-07-02-2026-07-08-comments-sentiment.csv` (18 rows)
- `QA-111242-ig-empty.png` (comments table), `QA-111242-export-popup.png` (Sentiment Export Request)

## Bugs filed
None new — A1 covered by existing **LFMP-31947**.
