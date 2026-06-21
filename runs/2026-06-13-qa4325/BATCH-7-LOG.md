# QA-4325 — Batch 7 Log — 2026-06-13 (data 06-17 04:21 AM)

Cases #31–35 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 31 | QA-99416 | Brand Sets>Content — DPA modal table | ✅ PASS | NBA post (Eng 2,175,310); table Metric/Sum/Avg/per-day consistent (daily=Sum, Avg=Sum/3); Brand-Sets variant uses "Rank" not "Data Set" |
| 32 | QA-103246 | Brand>Content — DPA modal Export PNG & GS | ✅ PASS | Export menu PNG/CSV/Google Sheets; PNG = `blob:` download (anchor-href captured); GS opened "…-Daily Content Analysis-2026-06-02-2026-06-15" |
| 33 | QA-107134 | Settings>Audit — Deep Linking | ✅ PASS | Description entity links deep-link to detail (`#brand-sets/detail?brand_set_id=11610`); opened in a NEW tab — **APPS-54603 (same-tab replace) not reproduced — possible fix** |
| 34 | QA-110083 | Settings>Audit — Brand Set Created | ✅ PASS | "Brand Set Created" row (Actor LFQA Testing, "Brand Set qa_new 68998… was created"); vocab incl. Brand Set/Brand Created+Deleted, User Created/Deactivated |
| 35 | QA-111242 | Brand>Content Sentiment — Read Comments CSV + notification | ✅ PASS | MTV IG sentiment mode (Classification 68/22/9); Read Comments modal (rino_siconolfi, 51 comments classified); modal Export → CSV/GS; CSV queued |

**Batch tally:** 5 PASS · 0 FAIL · 0 BLOCKED. (Cleanest batch of the run.)

**Environment events:**
- DPA modal (Brand & Brand Sets) renders + exports reliably; PNG downloads a real `blob:` image via anchor (createObjectURL hook misses it — caches the orig ref).
- **APPS-54603 (Audit deep-link same-tab replace) did NOT reproduce** — link opened a new tab correctly. Possible fix; flag for eng re-confirm.
- Sentiment mode must be toggled via the button (URL param resets). Brand Sets DPA uses "Rank" field vs Brand's "Data Set".
- No Brand>Insights surfaces → no renderer hang.
