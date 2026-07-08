# QA-134277 — Brand > Content: CSV Export respects active Include/Exclude tag filter

- **Run:** 2026-07-08 (unattended, headless Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134277 (Critical / P2)
- **Account / Brand:** Hulu (account_id=336) / **Hulu** brand (brand_id=5670), Brand > Content
- **Window:** default last-7-days = **Jun 30 – Jul 6, 2026** (spec has no date step)
- **Open linked bugs:** None open (screen passed — ran normally)
- **Skill used:** `brand-content-filter` (v2, layered Tag Include/Exclude)

## VERDICT: BLOCKED — test-data / unmet precondition (no tagged posts in window)

The case cannot be meaningfully executed for its core assertions (A1–A4) because **no post in the
Hulu Jun 30–Jul 6 2026 window carries any content tag**, so there is no `TAG_INC` with matching
posts to drive the positive Include+AND / Include-OR + Exclude rounds. This is a **test-data /
precondition gap** (the precondition "5-6 tagged posts; 2-3 with ≥2 tags each" is a manual setup
step that is not satisfied in this unattended run / window), **not a product defect**. Per
spec-adherence Rule 1/3/5 I did **not** substitute a different brand or date range to manufacture
tagged posts.

The zero-match path (A5) **PASSES**; A6 is **satisfied with variance** (see below).

## Evidence that no in-window post is tagged (authoritative)

| Probe | Method | Result |
|---|---|---|
| Untagged count | UI: Filter → Tag → Include → **None** → Apply | Posts (77) rendered (see note*) |
| Any-tag check | API `data-api/content` `content_tags` Include-None (`values:[""], not:false`) | matched **all 92** posts → 0 tagged |
| Per-post tags | API `/content` `source_attrs=lfm.content.tag` **and** `lfm.content.tags` | **empty** for all 92 posts |
| Strong candidate | UI: Include `#fourthofjuly` (July 4 ∈ window) → Apply | **Posts (0)** — no match |
| Tag catalog | API `dsp-api/content/filters` → `content_tags.options` | 2,814 tags, full catalog, **not window-scoped, no counts** |

\*The UI "77" (vs 92 unfiltered) is a **channel-set artifact**, not tagging: when a tag filter is
active the query drops the YouTube channel (channels reduce to twitter/instagram/facebook/linkedin/
tiktok/threads), removing ~15 YouTube posts. The API Include-None over all channels returns the full
92, confirming **zero** posts are tagged. (Note: counts drift 84/92 between renders due to data
freshness — not material to the verdict.)

## Steps executed

1. Pre-flight login (Cognito "With existing account", lfiqa@…) → `#home` "Home - ListenFirst". OK.
2. Switched account Viacom → **Hulu** via LFQA menu (hover) → Search Account → Results `.lfm-ta-option`.
3. Brand nav → **Content**; brand header = **Hulu** (brand_id=5670). Pre-filter Posts (92).
4. Filter → **Tag**: sub-panel exposes **Include/Exclude** radios, **Or/And**, Select All/None, search,
   and the 2,814-tag catalog. Widget structure matches `brand-content-filter` v2.
5. Determined no in-window tagged posts exist (table above) → **TAG_INC/TAG_EXC cannot be chosen with matches**.
6. Zero-match round (A5/A6): Include `#fourthofjuly` → Apply → **Posts (0)** empty state
   (`08-A5-empty-state.png`).
7. Export behavior probed at 0 posts and with data (84 posts); ran a real CSV export with data and
   fetched the delivered CDN file to inspect its columns.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 9 | UI shows posts tagged TAG_INC, excluding TAG_EXC | No in-window post carries any tag → no TAG_INC with matches; positive filter cannot be built | **BLOCKED (Not Evaluable)** |
| A2 | 13 | Filtered tag only visible in CSV | No filtered (non-empty) export possible (no tagged posts). Also: Brand>Content CSV has **no tag column** at all (header below) | **BLOCKED (Not Evaluable)** |
| A3 | 16 | UI post count updates after Include AND → OR | Requires ≥1 positive tag match; none exist | **BLOCKED (Not Evaluable)** |
| A4 | 20 | Filtered tag only visible in CSV | Same as A2 | **BLOCKED (Not Evaluable)** |
| A5 | 24 | UI empty state; POSTCOUNT_C = 0 | Include `#fourthofjuly` → **Posts (0)**, "There is no data available. Please select a different brand, brand set, or date range."; Sum/Average all en-dash / N/A. **POSTCOUNT_C = 0** | **PASS** |
| A6 | 28 | No tag columns in CSV | Export button is **disabled at Posts (0)** (no empty CSV producible). Independently, a Brand>Content CSV **never contains a tag column** — so "no tag columns" holds trivially. | **PASS (with variance)** |

## Export evidence (verified on the delivered CDN file, Rule 6)

- With data (84 posts) the **Export** button is enabled; at **Posts (0)** it is
  `disabled` + `pointer-events:none` (reconfirms prior-run "Posts(0) → Export disabled" finding).
- Ran Export → **CSV** (View toggle left; "Public" data set) → async delivery via Recent-Activity
  bell + email. Delivered file fetched from
  `https://analytics-cdn.lfmdev.in/301364-85cd64f9cbb8f66c1cd5b422100b68b8.csv` (HTTP 200, 28 lines).
- **Row 0 (preamble):** `Data Set,,,…,Public,Public,…` (known "Data Set" preamble row).
- **Row 1 (header):** `Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type,
  Post Link, Live, Publish Type, Sponsor Name, Sponsor Link, Text, Engagements, Reactions, Comments,
  Shares, Response Rate, Video Views, Video Response Rate` — **no Tag/Content-Tag column present.**
- Row 2 sample: `1,06/30/2026,Tue,10:02 AM,Instagram,Hulu,…,Reel,…` (hashtags appear only inside the
  free-text `Text` column, not as an LFM tag column).

## Findings / notes for maintainers

- **NEW quirk — Exclude-None also fails:** applying `Tag = None` with **Exclude** (`not:true`,
  operator `or`, `values:[""]`) returns the **"This table failed to load."** error pane
  (`06-exclude-none.png`) — the same backend rejection previously documented only for the
  **OR + None (Include / Select-All)** combination. So the empty-string+OR rejection affects both
  Include and Exclude. Include-only `None` (`not:false`) still renders. (Automation friction, not a
  user-facing defect — accepted, extends the existing known-quirk.)
- **Brand>Content CSV has no tag column** (header above). This makes spec assertions A2/A6 (which
  presume a tag column that shows only TAG_INC / is absent when empty) not literally testable as a
  column check — the product exports posts (rows) that match the filter, never a tag column.
  Recommend the spec author re-scope A2/A6 to "only filtered posts appear as rows" and confirm
  whether a tag column is expected in the export at all.
- **Automation note:** `data-api.lfmdev.in` requires an `Authorization: Bearer …` header (cookies
  alone → `401 Unauthorized (invalid token)`). Captured the live token by hooking `window.fetch`
  during an app-triggered request; reused it for read-only `/content` + `/content/filters` probes.
- **Precondition gap:** to make A1–A4 runnable, the environment needs 5-6 posts tagged (2-3 with ≥2
  tags) **within the tested window**, or the spec should name a window/brand where such tagged posts
  already exist. Do not substitute (Rule 1) — re-runs will pick this up once test data is provisioned.

## Bugs filed

None. No product defect observed. The blocking condition is a **test-data/precondition gap**
(no tagged posts in the window). Filing a product bug here would repeat the QA-91412
wrong-configuration false-positive pattern (Rule 5). The Exclude-None "table failed to load" is an
extension of an already-accepted known-quirk (automation-only), flagged above for the KB, not filed.

## Artifacts (`.playwright-out/QA-134277/`)

- `01-brand-content-loaded.png` — Hulu Brand>Content, Posts (92)
- `03-tag-panel.png` — Tag filter sub-panel (Include/Exclude, Or/And, catalog)
- `04b-selectall-loaded.png` — OR + None (Select All) → "table failed to load" (known quirk)
- `06-exclude-none.png` — **Exclude + None → "table failed to load" (new)**
- `07-fourthofjuly-probe.png` — Include `#fourthofjuly` → Posts (0)
- `08-A5-empty-state.png` — **A5 empty state, POSTCOUNT_C = 0**
- `09-export-modal.png` — Export modal (CSV/Google Sheets toggle, Public data set)
- `csv-head.json` — delivered CSV header/rows (no tag column)
- `tag-dist3.json`, `tagged-15.json`, `content-tags-rec.json` — API tag-probe data
