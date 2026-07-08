# QA-129606 — Handle Abnormally High Response Rate – Exclude Days Without Follower for TikTok and Twitter

- **Run date:** 2026-07-08 (headless, unattended, Playwright MCP, `feature/playwright-mcp`)
- **Account:** Wasserman (account_id=863)
- **Brand:** FIA World Endurance Championship (FIAWEC) — exact typeahead Results match (Rule 1)
- **Date range:** Absolute, Interval Days, Sep 26 – Oct 3, 2025 (8 days)
- **Perspective:** Public Data (default; spec does not specify — no toggle click needed)
- **Channels:** Twitter (story 155745) and TikTok (story 155746), run separately per spec
- **Skill reused:** `time-window-comparison-run` v6 + `response-rate-math-verifier` v2
- **Open-bug screen (Rule 7):** "None open" → ran normally
- **Verdict: PASS** (in-scope UI assertions; Google Sheets steps skipped — out of scope)

## Scope notes
- **A2–A5 reference a Google Sheet comparison.** Google Sheets export is OUT OF SCOPE on this track
  (Google 2FA). Every in-app step was executed and the case is judged on the in-app (UI) side of
  A2–A5. The "same on Google Sheet" half of each assertion is skipped; the UI half is verified in full.
- No CSV/TSV/XLS on-disk export was required by the spec (it names only Google Sheets at step 9).

## Steps executed
1. Reporting → Time Window Comparison (via top-nav hover → menu link). Header `Account: Wasserman`. ✓
2. Added brand "FIA World Endurance Championship (FIAWEC)" from the typeahead Results (exact match;
   the near-miss "FIA World Endurance Championship Highlights" was NOT chosen). ✓
3. Absolute Dates tab (default), Interval = Days (default). ✓
4. Date range set via the two-calendar picker: Start calendar → Sep 2025 → day 26; End calendar →
   Oct 2025 → day 3. Verified `range-start=Sep 26`, `range-end=Oct 3`. ✓
5. Select Channel Data → **By Channel** view.
   - Twitter variant: expanded Twitter → Audience & Growth + Content; selected Total Followers,
     Engagements, Posts, Response Rate → Twitter (4/70).
   - TikTok variant: via Change Settings, cleared Twitter (Off), expanded TikTok → same 4 metrics
     → TikTok (4/35).
6. Metrics: Total Followers (Audience & Growth); Engagements, Posts, Response Rate (Content). ✓
7. Run Report → story pages 155745 (Twitter) and 155746 (TikTok). ✓
8. Reviewed both reports (tables read from DOM). ✓
9. Export → Google Sheets — **skipped (out of scope).**

## Twitter data (story 155745)

| Date | Total Followers | Engagements | Posts | Response Rate (UI) | Computed E/(TF×P)×100 |
|------|----------------|-------------|-------|--------------------|-----------------------|
| Sep 26, 2025 | – | 14,453 | 23 | – | (excluded: no TF) |
| Sep 27, 2025 | – | 20,964 | 33 | – | (excluded: no TF) |
| Sep 28, 2025 | – | 24,395 | 20 | – | (excluded: no TF) |
| Sep 29, 2025 | – | 0 | 0 | – | (excluded: no TF) |
| Sep 30, 2025 | 456,352 | 1,723 | 3 | 0.13% | 0.1259% ✓ |
| Oct 01, 2025 | 456,450 | 3,592 | 1 | 0.79% | 0.7869% ✓ |
| Oct 02, 2025 | 456,492 | 2,029 | 1 | 0.44% | 0.4445% ✓ |
| Oct 03, 2025 | 456,520 | 3,738 | 4 | 0.20% | 0.2047% ✓ |

Exclusion behaviour confirmed: Sep 26–28 have Engagements+Posts **but no Total Followers**, and their
Response Rate is correctly `–` — exactly the "abnormally high RR" guard the case validates.

## TikTok data (story 155746)

| Date | Total Followers | Engagements | Posts | Response Rate (UI) |
|------|----------------|-------------|-------|--------------------|
| Sep 26, 2025 | – | 31,012 | 3 | – |
| Sep 27, 2025 | – | 10,138 | 4 | – |
| Sep 28, 2025 | – | 29,288 | 1 | – |
| Sep 29, 2025 | – | – | 0 | – |
| Sep 30, 2025 | – | – | 0 | – |
| Oct 01, 2025 | 520,200 | – | 0 | – |
| Oct 02, 2025 | 520,300 | 995 | 0 | – |
| Oct 03, 2025 | 520,200 | 606 | 0 | – |

TikTok Response Rate tile renders **"There is no data available."** — correct: no day satisfies both
`Total Followers > 0` AND `Posts > 0`. Sep 26–30 lack followers (excluded); Oct 1–3 have followers
but 0 posts → footprint `TF × Posts = 0` → RR excluded (division-by-zero / zero-posts guard,
consistent with the documented QA-129802 zero-posts rule). So RR is `–` on every day → tile shows
"no data". This still satisfies the exclusion rule (RR never appears on a no-follower day) and
additionally exercises the zero-footprint guard.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Report loads successfully with no errors | Both Twitter (155745) & TikTok (155746) reports rendered; no error tile | **PASS** |
| A2 | 10 | Engagements same on UI and Google Sheet | UI Engagements captured for both channels (see tables). GS comparison out of scope (skipped) | **PASS (UI); GS skipped** |
| A3 | 10 | Total Followers displayed only for days where it exists | Twitter: `–` Sep 26–29, values Sep 30–Oct 3. TikTok: `–` Sep 26–30, values Oct 1–3. Matches | **PASS** |
| A4 | 10 | Response Rate shown only for days where Total Followers exists | Twitter: RR `–` on all no-follower days (Sep 26–29) even with engagement present; populated Sep 30–Oct 3. TikTok: RR `–` all days (no valid follower+post day) | **PASS** |
| A5 | 10 | Day-wise RR = Engagements/(Total Followers × Posts) × 100 | Twitter Sep 30/Oct 1/Oct 2/Oct 3 all match computed values to rounding (0.13/0.79/0.44/0.20%). TikTok: no computable day (every candidate fails TF>0 & Posts>0) → correctly excluded | **PASS** |

## Evidence
- `.playwright-out/QA-129606/twitter-01-builder-config.png` — Twitter builder config (brand, dates, metrics)
- `.playwright-out/QA-129606/twitter-02-report.png` — Twitter report (story 155745)
- `.playwright-out/QA-129606/tiktok-01-report.png` — TikTok report (story 155746)
- Exact numeric values read from the report DOM tables (transcribed above).

## Bugs filed
None. Product behaviour is correct: the Response Rate exclusion rule for days without follower
(footprint) data works for both Twitter and TikTok, and the zero-posts footprint guard behaves
correctly (RR excluded rather than dividing by zero).
