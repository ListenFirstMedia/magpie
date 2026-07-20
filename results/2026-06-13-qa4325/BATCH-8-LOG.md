# QA-4325 — Batch 8 Log — 2026-06-13 (data 06-17 04:21 AM)

Cases #36–40 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 36 | QA-111243 | Brand>Content Sentiment — Emotion (Daily) CSV (email format) | ✅ PASS | Emotion (Daily) Export PNG/CSV/GS; CSV = real blob (positive size, direct download). Chart-tile CSV downloads directly vs Read Comments queue+email |
| 37 | QA-112579 | Brand Content — Tag modal dragging | ✅ PASS | Bulk Add Tags modal dragged by header (~x1143→x550), content intact; closed, no tag added |
| 38 | QA-113595 | Settings>Audit and Admin page changes | ✅ PASS-with-deviation | Admin (Users) page loads read-only; Audit reflects Admin changes (User/Brand/Brand Set Created+Deleted). New Admin mutation safety-gated |
| 39 | QA-113722 | Admin — User Creation + Audit screen | ⛔ BLOCKED-safety | User creation prohibited (account + automated email). Audit half verified ("User User012 test was created", Activity Type User Created) |
| 40 | QA-114845 | Brand>Insights — Hovering + PNG Export | ⛔ BLOCKED (renderer hang) | UCLA Insights shell loaded then froze on tile render — cross-brand hang confirmed again. Prior 2026-06-04 run verified hover+PNG (Michael Kors) |

**Batch tally:** 2 PASS · 1 PASS-with-deviation · 0 FAIL · 1 BLOCKED-safety · 1 BLOCKED-env.

**Environment events:**
- **Brand>Insights renderer hang reproduced again on UCLA** (3rd distinct brand this run) — shell paints, tiles freeze CDP. Frozen tab couldn't be closed.
- Sentiment chart-tile CSV downloads as a direct blob (vs Read Comments queue+email). Reading captured blob URL trips `[BLOCKED: Cookie/query string data]` — return only `blob=true size=positive`.
- Tag Bulk Add modal draggable by header (`.tagging-header`).
- Admin = Settings>Users; read-only view fine, creation prohibited (sends automated email).
