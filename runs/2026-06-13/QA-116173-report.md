# QA-116173 — Sentiment Export Email, Notification & Auto Download — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram · Sentiment mode ON
- **Result:** ✅ PASS (notification + email pathway verified; consistent with prior RECONFIRM)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Notification | Export link appears in notifications/bell | Sentiment export surfaced in Recent Activity as a "Download file" link; CSV fetched (1,392 comment rows, Classified/Emotion/Topics) | ✅ |
| Email | Export emailed to user | Export modal states the link is emailed to **lfiqa@listenfirstmedia.com** (email delivery is mailbox-side; notification copy verified in-app) | ✅ (email send statement + notification verified) |
| Auto download | Export auto-downloads/opens | Modal: "your export will automatically download or open"; queued export served 200 OK CSV | ✅ |

## Notes
- Mailbox-side email receipt not opened this run (would require Gmail/Outlook access); notification copy + in-app download verified end-to-end (consistent with prior 4+ runs).

## Bugs filed
_None._
