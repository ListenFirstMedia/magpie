# QA-4325 — Batch 9 Log — 2026-06-13 (data 06-17 04:21 AM)

Cases #41–45 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 41 | QA-129608 | Abnormally High Response Rate — aggregate across channels | ✅ PASS | Brand Set RR across 5 channels/6 brands; aggregate row = **N/A** (no blown-up cross-channel rate); per-post RR sane (max 74.80%) |
| 42 | QA-130076 | Settings>Notifications — improved Lost Authorization messaging | ✅ PASS | Feed-specific "(Authorized)/(Public)" + brand + "Please click to troubleshoot" + NOT COLLECTING badge |
| 43 | QA-133403 | Brand Set>Content — Authorised Video Views Sum/Avg row | ✅ PASS | Authorized VV scopes to 2,752 video posts; Sum 1,063,666,815; Share=N/A in aggregate |
| 44 | QA-134176 | Brand>Insights — Auto Select Dates for all Intervals | ⛔ BLOCKED (renderer hang) | Header refs found but interaction froze renderer; prior-verified |
| 45 | QA-134182 | Brand>Insights — Interval date selector historical limits | ⛔ BLOCKED (renderer hang) | Same hang; prior-verified |

**Batch tally:** 3 PASS · 0 FAIL · 2 BLOCKED (renderer hang).

**Environment events:**
- **Brand>Insights renderer hang reconfirmed** (4th time) — header controls are *discoverable* via `find`, but any interaction triggers the 45s freeze. All Insights cases blocked under Chrome MCP.
- Brand Set Content "Rank" dropdown exposes **Public Data** vs **Authorized Data** metric groups; selecting Authorized Video Views auto-switches the View to Authorized.
- Rate metrics (Response Rate, Share) show **N/A** in cross-channel/cross-brand aggregate rows — the correct "abnormally high" handling.
- Authorized/heavy Brand-Set queries are slow (~25–35s).
