# QA-107134 — Settings > Audit - Deep Linking — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Window:** Jun 1–15 2026
- **Skills:** settings-audit-logs
- **Result:** ✅ PASS (deep link navigates to entity detail; opened in a NEW tab — see Notes re APPS-54603)

## Steps
1. Settings → Audit. Log rows render with columns Date / Customer / Business Unit / Account / Actor / Activity Type / **Description** (entity names in Description are blue **deep links**).
2. Clicked the **"qa_new 68998 06/15/21/58"** Brand Set deep link in a "Brand Set Created" row.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Description entities are deep links | Clickable links to the audited entity | Brand/Brand Set/User names rendered as blue links | ✅ |
| Deep link navigates to detail | Opens the audited entity | Opened **`#brand-sets/detail?brand_set_id=11610`** (Brand Set detail) | ✅ |

## Notes / automation learning
- The deep link opened in a **NEW tab** this run (tabId spawned), navigating to the Brand Set detail page. The prior run flagged **APPS-54603** (same-tab URL-replace) — this session it behaved as a proper new-tab open, suggesting **APPS-54603 may now be fixed** (or behavior varies by entity type). Worth an eng re-confirm.
- Entity-link → detail-page URL schema: Brand Set → `#brand-sets/detail?brand_set_id=<id>`.

## Bugs filed
_None new — APPS-54603 not reproduced as same-tab-replace this run (possible fix)._
