# QA-137874 — Data Collection: Channel Collection Status Validation 2

- **Run date:** 2026-07-12 (unattended, headless, Playwright MCP)
- **Test set:** QA-22296
- **Skill used:** `data-collection-channel-status` (v2, untrusted)
- **Account / brand exercised:** HBO Max (account_id=657) / brand **HBO Max**
- **Channels exercised:** Twitter (Collecting + To Do feeds) and Threads (Not Collecting feeds)
- **Verdict:** **FAIL** — status-icon assertions (A3, A4, A5a, A5d, A5e) all PASS; **A5b FAILS**, attributed to the known open bug **APPS-61562** (stale Last Collection Date). A5c not fully evaluable (see below).

---

## Preconditions & scope note

The spec names a multi-account/brand/channel matrix (HBO Max, UCLA, Apple Music, Spotify News on
their respective accounts; all 9 channels). This unattended run exercises one representative account
+ brand (**HBO Max** on account 657) across two channels chosen to surface all three status states:
**Twitter** (Collecting + To Do) and **Threads** (Not Collecting). Rule 1 respected — the exact
"HBO Max" brand was the first typeahead Result and was selected (no substitution).

Data freshness context: page header **"Data Last Updated (PT): 07-11-2026 04:28 PM"**. System/run
date is 2026-07-12.

---

## Steps executed

1. Pre-flight: programmatic Cognito login as `lfiqa@listenfirstmedia.com` → `#home` rendered.
2. Switched account Viacom → **HBO Max (657)** via profile-menu → Search Account → **Results** entry.
3. **Step 1** — Settings → Data Collection (`#data-collection?account_id=657`); My Brands (1,067) rendered.
4. **Step 2** — Searched "HBO Max", clicked the exact-match **HBO Max** brand Result → Channels (9) panel
   (Instagram, TikTok, Threads, YouTube, LinkedIn, Pinterest, Facebook, Twitter, Wikipedia).
5. **Step 3** — Clicked **Twitter** channel → breadcrumb "HBO Max › Twitter", Pages (2) panel showed only
   Twitter pages (`hbomax`, `streamonmax`). Filter applied correctly.
6. **Step 4** — Clicked the **hbomax** page → URL `…/twitter/page/01d46c8f…`.
7. **Step 5** — Data Collection Summary rendered; probed the data-feed table (DOM + computed colors).
8. Repeated Steps 3–5 for the **Threads** channel (page `973fa21a…`) to exercise the Not-Collecting state.

---

## Evidence — feed tables

### Data Collection Summary header (both pages)
`Data Collection Summary — Attributed to HBO Max  Jan 3, 2000 - Dec 31, 2027`
Helper text: `Click to reauthorize collection on any data feed`

### HBO Max / Twitter / page `hbomax`
| Data Feed | Start Date | Last Collection Date | Status | Icon class | Computed color |
|---|---|---|---|---|---|
| Twitter Ads (Authorized) | N/A | N/A | **To Do** | `icon fas fa-plus-circle` | `rgb(0, 129, 237)` (blue) |
| Twitter Posts (Authorized) | Nov 1, 2025 | Jul 9, 2026 | Collecting | `icon fas fa-check-circle` | `rgb(0, 135, 128)` (green) |
| Twitter Earned Comments (Public) | May 14, 2025 | Jul 9, 2026 | Collecting | `icon fas fa-check-circle` | `rgb(0, 135, 128)` |
| Twitter Page (Public) | Aug 11, 2025 | Jul 9, 2026 | Collecting | `icon fas fa-check-circle` | `rgb(0, 135, 128)` |
| Twitter Posts (Public) | Aug 11, 2025 | Jul 9, 2026 | Collecting | `icon fas fa-check-circle` | `rgb(0, 135, 128)` |

Screenshot: `.playwright-out/QA-137874/twitter-summary.png`

### HBO Max / Threads / page `HBO Max`
| Data Feed | Start Date | Last Collection Date | Status | Icon class | Computed color |
|---|---|---|---|---|---|
| Threads Page & Audience (Authorized) | Nov 17, 2024 | Feb 5, 2026 | **Not Collecting** | `icon fas fa-exclamation-circle` | `rgb(214, 79, 66)` (red) |
| Threads Posts (Authorized) | Nov 18, 2024 | Feb 6, 2026 | **Not Collecting** | `icon fas fa-exclamation-circle` | `rgb(214, 79, 66)` (red) |

Screenshot: `.playwright-out/QA-137874/threads-summary-notcollecting.png`

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A3 | 3 | Selected channel filter applied; only feeds for that channel displayed | Twitter selected → breadcrumb "HBO Max › Twitter"; Pages (2) listed only Twitter pages (`hbomax`, `streamonmax`); summary feed rows all `Twitter …`. Same held for Threads. | **PASS** |
| A4 | 4 | Data Collection Summary page opens | Summary rendered with header "Attributed to HBO Max Jan 3, 2000 - Dec 31, 2027" + 4-column data-feed table for both pages | **PASS** |
| A5a | 5 | Collecting → green check icon | 4 Twitter Collecting feeds: `fas fa-check-circle`, computed `rgb(0,135,128)` | **PASS** |
| A5b | 5 | Last Collection Date = current date or day before when Collecting | All 4 Collecting feeds = **Jul 9, 2026**. Current date 2026-07-12 (Data Last Updated 07-11-2026) → expected Jul 11 (or Jul 10 as day-before). Jul 9 is stale by ≥1 day and frozen across the whole feed set. | **FAIL** (open bug APPS-61562) |
| A5c | 5 | Collecting → data on Brand Content matching Native source with latest collection date | Native-source (live Twitter) comparison is out of scope on the headless track. In-app cross-check impeded: Brand>Content on account 657 auto-resolved to `brand_id=11003` (a Hulu sub-brand, documented 11003 default-brand artifact), not the HBO Max brand. Collection activity itself is confirmed by the summary's populated Start/Last-Collection dates. | **PARTIAL / Not fully evaluable** |
| A5d | 5 | Not Collecting → red exclamation icon | Both Threads (Authorized) feeds: `fas fa-exclamation-circle`, computed `rgb(214,79,66)`; Last Collection dates (Feb 5/6, 2026) older than yesterday — correct stopped-feed signal | **PASS** |
| A5e | 5 | To Do → blue plus icon | Twitter Ads (Authorized) = To Do: `fas fa-plus-circle`, computed `rgb(0,129,237)` (blue); Start/Last = N/A | **PASS** |

---

## Known bugs checked

- **bug-history.md** grep for `QA-137874`: **no entry**.
- **Skill-documented open bug — APPS-61562** ("Last Collection Date is showing Incorrect", QA-Ready,
  *blocks* QA-137874): **REPRODUCED.** All four HBO Max Twitter Collecting feeds report Last Collection
  Date **Jul 9, 2026** on run date 2026-07-12 (expected Jul 11/Jul 12). The date is frozen 3 days back
  across the entire feed set — a stronger manifestation than the 2026-07-10 observation (which had most
  feeds at the then-correct Jul 9 and only Facebook stale). Per skill guidance, A5b FAILS while
  APPS-61562 is open; the icon/status assertions (A5a/A5d/A5e) are unaffected and pass. Case run + noted,
  not blocked outright — the bug interferes only with A5b.
- The case file carried no baked-in "## Open linked bugs" section, so Rule 7's hard open-bug gate did
  not trigger from the file; APPS-61562 handled per the narrower "interferes-with-assertion" rule.
- **Icon color note:** Not-Collecting red measured `rgb(214,79,66)` this run (matches skill v1); the
  2026-07-10 run saw `rgb(237,0,21)`. Colors captured per-run, not hard-asserted — no bug.
- **To Do state:** previously DEFERRED in the skill (never seen in a drilled-down summary). First
  captured here (Twitter Ads Authorized) — blue `fa-plus-circle` `rgb(0,129,237)`. A5e now verifiable.

## Bugs filed

None. A5b failure is attributed to the pre-existing open bug **APPS-61562** (not a new defect, not a
regression). A5c limitations are scope/environment (Native-source out of scope; 11003 default-brand
artifact) — not product defects.

---

## Verdict

**FAIL** — A5b fails the Last-Collection-Date currency rule, attributed to open bug **APPS-61562**.
All other in-scope assertions pass: **A3, A4, A5a, A5d, A5e PASS**; **A5c PARTIAL** (Native-source out
of scope headless + 11003 default-brand artifact). Status-icon mapping (green check / red exclamation /
blue plus) verified end-to-end with computed-color evidence, including the first summary-row **To Do**
capture.
