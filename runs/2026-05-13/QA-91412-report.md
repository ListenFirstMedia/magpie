# QA-91412 — Brand Content > Public perspective Reels data check for Facebook

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-91412
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** FX Networks (account_id 204)
- **Brand exercised:** It's Always Sunny in Philadelphia (brand_id 433) — closest FX-family brand available; the "FX" brand search yielded only FX Networks variants. The assertion is generic to any FB brand on FX Networks.
- **Date range:** 2025-03-08 to 2026-03-07 (per spec)
- **Channel:** Facebook only
- **Perspective:** Public (URL perspective=extended)
- **Result:** ⚠ **FAIL — Likely bug or stale test spec**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (6) | All metrics show en-dash for Facebook Reels posts (Public) | **Mixed:** Engagements, Reactions, Comments, Shares, Response Rate **all show numeric values** (populated, NOT en-dash) for Reel posts. Only **Video Views** and **Video Response Rate** are blank/en-dash for Reels. | ❌ |

## Proof — observed Reel post metrics (Post #2, sorted by Engagements desc)

```
Post 2 — Reel — Wed Jul. 02, 2025 05:32 PM PDT
  Engagements:    63,592
  Reactions:      60,804
  Comments:       1,284
  Shares:         1,504
  Response Rate:  1.96%
  Video Views:    (not shown / en-dash)
  Video Response Rate: (not shown / en-dash)
```

Contrast with adjacent Original Post (non-Reel):

```
Post 1 — Original Post — Tue Oct. 21, 2025 04:42 PM PDT
  Engagements:         75,247
  Reactions:           71,671
  Comments:            838
  Shares:              2,738
  Response Rate:       2.34%
  Video Views:         2,870,050
  Video Response Rate: 2.62%
```

## Diagnosis

The Reel post **does** populate the basic public engagement metrics (Reactions, Comments, Shares, Engagements, Response Rate) but **omits** Video Views and Video Response Rate. So the assertion "ALL metrics show endash" is too strong — only video-specific metrics are en-dash.

Possible cause:
1. **Regression** (real bug): FB Reels public-perspective Engagement/Reaction/Comment/Share metrics should be en-dash but the API has started returning them, contradicting the spec.
2. **Test spec drift**: Facebook's API has changed since this test was written, now returning public-Reel engagement metrics. Spec needs to be updated to: "Only Video Views and Video Response Rate show en-dash for FB Reels in Public perspective."

I can't tell which without checking the Jira ticket history. Filing as bug candidate **BC-3** (renumbered, see below).

## Bugs filed

### 🐛 BC-3 — FB Reels (Public perspective) populate engagement metrics that the spec says should be en-dash

- **Source case:** QA-91412
- **Severity:** P2 (Blocker priority test failing on its only assertion)
- **First seen:** 2026-05-18 on FX Networks → It's Always Sunny in Philadelphia
- **Affected area:** Brand → Content → Public perspective → FB Reels

### What failed
QA-91412 A1 expects all metrics on Facebook Reels to render as en-dash in Public perspective. Observed metrics for Reel posts:

| Metric | Spec expectation | Observed |
|---|---|---|
| Engagements | en-dash | numeric (e.g. 63,592) |
| Reactions | en-dash | numeric |
| Comments | en-dash | numeric |
| Shares | en-dash | numeric |
| Response Rate | en-dash | numeric |
| Video Views | en-dash | en-dash ✓ |
| Video Response Rate | en-dash | en-dash ✓ |

### Reproduction
1. Log in as LFIQA, switch to FX Networks account.
2. Brand → Content → It's Always Sunny in Philadelphia (or any FB brand on FX).
3. Date range: 2025-03-08 to 2026-03-07.
4. Perspective: Public (URL perspective=extended).
5. Channel: Facebook only, Apply.
6. Filter → Publish Type → Reel (Include) → Apply Filter.
7. Inspect any Reel post tile in the grid.

### Suggested next steps
- Backend/Data: verify whether FB Public API now returns engagement metrics for Reels. If yes, this is a spec drift, not a bug — update QA-91412 wording. If no, investigate whether the data ingestion is mis-bucketing Reel metrics into Public.
- QA: cross-reference original ticket's discussion thread for any recent API behavior changes.

(Note: this is the **3rd** bug candidate of the regression project; renumbered as BC-3. Earlier bugs are BC-1 in batch3 [Custom Data Set ordering], and BC-2 in batch6 [Brand>Content CSV filename hash]. The earlier batch3 bugs file used the BC-2 number for the Audience export issue — that one stays as batch3-BC-2 since it's INCONCLUSIVE.)
