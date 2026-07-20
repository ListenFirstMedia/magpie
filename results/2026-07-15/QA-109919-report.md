# QA-109919 — Brand > Content - Sentiment Comments limit - CSV

**Run date:** 2026-07-15
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54) · **Brand:** Amazon Prime Video (brand_id=25864, Rule 1 exact match — not any of the 66 regional/spin-off variants in the Results list)
**Window:** Mar 03, 2025 – Mar 06, 2025 (per spec, set via UI date picker click, not URL param — URL param alone was silently ignored by the app, which kept the prior session's date range until confirmed via the Ok button)
**Result:** ✅ PASS 3/4 (assertion 8(a) INCONCLUSIVE per Rule 6 — see below)

## Pre-test
- Reused `export-csv` skill (v2) for the queued-export pipeline (CDN `analytics-cdn.lfmdev.in`, Recent Activity bell for the filename/link).
- Checked known-quirks.md: a prior finding (QA-109920, 2026-06-02) documented that the Classification-**donut**'s "Read" popup can open but its inner Sample Comments tile sometimes fails to load ("This tile failed to load"). That popup is a **different** UI element from this ticket's per-**post** "Read Comments" link in the Posts table — confirmed distinct in this run (see Finding below).
- bug-history.md: no open bugs tied to this exact ticket.

## Steps executed
1. Brand > Content → brand switcher → typed "Amazon Prime Video" (slow keystrokes) → clicked the exact "Amazon Prime Video" row out of 67 matches (not any `(Country)` variant, not "Global", not "-- Episodic Network Roll-Up").
2. Opened Date Range → navigated the visible Start/End calendars back from April to March 2025 (offsetParent-filtered to the visible instance per known-quirks) → selected Mar 3 (start) / Mar 6 (end) → clicked Ok. Confirmed on-screen `Mar. 03, 2025 - Mar. 06, 2025`.
3. Clicked the **Sentiment** button (URL confirmed `sentiment_mode=true`). Classification donut: 50% Positive / 37% Neutral / 13% Negative.
4. Scrolled past Classification, Classification (Daily), Emotion, Emotion (Daily), Topics, and "25 Most Vocal" to the **Posts (74)** table (sorted by Engagements desc).
5. Clicked **Read Comments** on the first post ("Anyone else? 📺 REACHER Season 3" — Facebook, 3,182 comments, top of the Engagements-sorted list).
6. Modal opened cleanly (no load failure) — header **"Post Comments (2000)"**, sub-message **"2000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000 samples."** — both read verbatim from the DOM.
7. Clicked **Export Comments** → **CSV** in the dropdown.
8. **"Sentiment Export Request"** modal appeared with the documented boilerplate text (references the notification bell + email to `lfiqa@listenfirstmedia.com`) → clicked **Ok**.
9. Waited 15s, then checked the notifications bell (`(34)`, up from `(33)`) — found a `Sentiment Export` card: *"Your Sentiment Export for Amazon Prime Video from Mar. 03, 2025 to Mar. 06, 2025 is now ready. Download file."* with a direct CDN link.
10. Checked `.playwright-out/` for a native browser-downloaded file matching this export — **none found** (only unrelated older files from earlier sessions today).
11. Per Rule 6 fallback, fetched the CDN URL in-page with `credentials:'include'`: **200 OK**, header row + **3,509 comment/post data rows** (Rank/Date/Channel/... /Classified/Emotion/Topic columns), first row is the original post itself (Rank 1), remainder are individual comment rows.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 6(a) | Read Comments popup header | `"Post Comments (2000)"` | Exact match | ✅ |
| 6(b) | Popup sub-message | `"2000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000 samples."` | Exact verbatim match | ✅ |
| 8(a) | CSV auto-downloads itself | Browser saves the file automatically | **No native download event captured** in `.playwright-out/` for this export within the observation window. Could not confirm via Rule-6-valid means (no Save-As dialog, no on-disk file, no captured download event) — see Finding below. | ⚠️ INCONCLUSIVE (not filed as a bug per Rule 6 — absence of proof is not proof of absence) |
| 8(b) | CSV has more than 2,000 comments | >2,000 rows | 3,509 data rows via authenticated CDN fetch (200 OK) | ✅ |

## Finding (documented, not filed as a bug)

**Assertion 8(a) could not be positively verified.** The export completed server-side (confirmed via the notification bell and a successful authenticated fetch of the resulting CSV), but no corresponding file appeared in Playwright's automatic download capture directory (`.playwright-out/`) within the ~15s+ observation window after clicking Ok on the Sentiment Export Request modal. This could mean: (a) the auto-download genuinely didn't fire in this headless session, (b) it fires via a mechanism Playwright's download listener doesn't intercept (e.g., a server-push/polling flow that completed after this session's check), or (c) timing — the file may auto-download at an indeterminate later point once the async job finishes, independent of the browser tab still being "attentive." Per Rule 6, this is marked INCONCLUSIVE rather than a bug — the content itself is provably correct and complete (3,509 rows, well over the 2,000 spec threshold), so the underlying export pipeline works; only the specific "auto-downloads itself" UX claim is unverified.

**Also confirmed:** the per-post "Read Comments" popup (this ticket's flow) is a distinct component from the Classification-donut's "Read" popup documented in known-quirks (QA-109920) as sometimes failing to load its inner tile — this run's per-post popup loaded cleanly on the first attempt with no failure, so the existing quirk entry should NOT be read as "resolved" or "still broken" for this different popup; they are unrelated components sharing similar text.

## Bugs filed
None. (One INCONCLUSIVE assertion documented above per Rule 6, not filed as a defect.)

## Skill credit
- Reused `skills/export-csv/SKILL.md` (v2) — bumped pass_streak 25 → 26, `last_verified` → 2026-07-15. Added a dated credit line documenting the per-post Read-Comments popup flow and the auto-download-capture gap.
- Updated `skills/REGISTRY.md` entry.

## Cleanup
Not applicable — read-only navigation, sentiment export request is a queued read-only job (no data mutation).
