# Bugs Found — LF Regression Project (consolidated)

> **Run dates:** 2026-05-13 through 2026-05-20 (across batches 3, 6, 7, 9)
> **Env:** dev (`app.lfmdev.in`, `app-reporting.lfmdev.in`)
> **User:** LFIQA (lfiqa@listenfirstmedia.com)
> **Total bug candidates:** 2 reproduced (BC-1, BC-4); 2 retracted (BC-2, BC-3 — both false positives, lessons in `skills/_shared/spec-adherence-rules.md`)

---

## 🐛 BC-1 — Brand > Content "Custom Data Set" dropdown does not sort by creation order

| Field | Value |
|---|---|
| **Severity** | P2 |
| **Spec priority of failing test** | Blocker (QA-109059) |
| **Account / Brand** | Adam Orfei / MTV (brand_id 4018) |
| **Surface** | Brand → Content → Data Set dropdown → "Custom Data Set" section |
| **Failing assertion** | QA-109059 A2: "Ensure the created custom data sets are displayed in the created order." |
| **First seen** | 2026-05-13 (batch 3) |
| **Status** | Reproduced. Awaiting product-team triage to decide intended sort. |

### Expected vs Actual

```diff
Assertion:  table (cross-source: dropdown order vs created_at order)
Expected:   ["Main Test 1", "Some new data set name", "Test 3 Dupes",
             "performance test", "performance test 2", "Test"]   # asc by created_at
Actual:     ["Test 3 Dupes", "performance test", "performance test 2",
             "Test", "Main Test 1", "Some new data set name"]
Mismatched: positions 1, 2, 3, 4, 5, 6  (every position is wrong)
```

### Evidence — observed UI order vs Settings creation timestamps

Captured by reading the Custom Data Set dropdown labels on Brand → Content, then cross-referencing the "Created Date" column on `Settings → Custom Data Sets`:

| UI position | Custom Data Set name | Created Date (from Settings) | Out of order? |
|---:|---|---|:---:|
| 1 | Test 3 Dupes | May 9, 2025 | — |
| 2 | performance test | May 23, 2025 | — |
| 3 | performance test 2 | Jun 5, 2025 | — |
| 4 | Test | Jul 16, 2025 | — |
| 5 | Main Test 1 | **Mar 28, 2025** | **yes — should be position 1 (earliest)** |
| 6 | Some new data set name | **Apr 18, 2025** | **yes — should be position 2** |

The two earliest-created items (Main Test 1, Some new data set name) appear LAST in the dropdown. The other four are roughly in creation order. So the sort is not `created_at ASC`, not `created_at DESC`, not alphabetical. Likely candidates: `last_used`, `last_edited`, or `id ASC where id resets per-namespace`.

### Reproduction steps

1. Sign in as `lfiqa@listenfirstmedia.com`.
2. Switch to **Adam Orfei** account (My Profile dropdown → search "Adam Orfei" → click from Results — not Recent Searches).
3. Navigate to `Brand → Content`.
4. Brand dropdown → type "MTV" → click MTV.
5. Click the **Data Set** dropdown (default value `Public`).
6. Scroll to the bottom section labeled **Custom Data Set**.
7. Open a new tab → `Settings → Custom Data Sets`. The Created Date column is shown.
8. Compare the two orderings — they don't match `created_at ASC`.

### Impact

End users (e.g. analysts) expect the dropdown to be in a predictable order. The current ordering looks random and forces them to scan the whole list every time. For tests, the assertion fails on every run.

### Suggested next steps for the dev team

1. **Backend:** check the sort key on the API endpoint that returns custom data sets for the brand-content dropdown. If it's `last_used` (probable based on the observed order — "Test" is most recent because LFIQA used it last), the test case wording needs updating to match. If the intended sort is `created_at ASC`, fix the sort.
2. **QA:** confirm with the original test author (Prasanna J) whether "creation order" was the design intent or whether the spec drifted from the actual product behavior.

---

## ⚠️ BC-2 — RETRACTED (incomplete verification)

> **Status revised 2026-05-20:** BC-2 was a false positive. LFIQA verified that the CSV export filename is working correctly when actually downloaded end-to-end. My original "evidence" only checked the DOM `download` attribute and the CDN response headers via in-page `fetch` — I never clicked the link and observed what the browser actually saved. That's an incomplete check.
>
> The correct verification path was: click "Download file" in the Recent Activity notification → observe the browser's Save As dialog (or the file in Downloads folder) → read the actual saved filename. That step was skipped.

### Where the analysis went wrong

The captured evidence I relied on:
- Anchor element: `<a href="https://analytics-cdn.lfmdev.in/290891-1cf67c943fca0bb956460b27440d6537.csv" download="">`
- CDN response (via `fetch(url, {credentials: 'include'})`): no `Content-Disposition` header

These DOM/network signals suggested the browser should fall back to the URL's last segment. But in practice the browser uses additional signals when an authenticated click happens through the React notification component — likely the React handler programmatically sets the filename before triggering the download, or the CDN serves a different response (with `Content-Disposition`) when the request originates from an authenticated session click rather than an in-page `fetch` reproduction.

I never observed the actual download outcome to confirm.

### Lesson captured

- `skills/_shared/spec-adherence-rules.md` Rule 6 added (see below): never claim a download filename is wrong without observing the browser's actual save dialog or the resulting file in the Downloads folder.
- `skills/export-csv` SKILL doc to be updated with this caveat — DOM `download` attribute + fetch-headers ≠ end-to-end download outcome.

### Original false-positive evidence (kept for posterity)

The original BC-2 was filed based on:
- Anchor `download=""` attribute (empty)
- No `Content-Disposition` header on CDN response to in-page `fetch`

Both signals were real, but neither equates to "the browser saves the file with the hashed name when a user actually clicks the link." That conclusion was unwarranted without observing the actual download.

| Field | Value |
|---|---|
| **Original severity** | Medium |
| **Spec priority of test** | P2 (QA-531) |
| **Status** | RETRACTED — incomplete verification. Spec-correct behavior was not actually validated end-to-end. |

### Expected vs Actual

```diff
Expected filename:  Brand-Content-20260511-20260517-posts.csv
Actual filename:    290891-1cf67c943fca0bb956460b27440d6537.csv
                    └────┬───┘ └──────────────┬──────────────┘
                         │                    └── MD5/SHA hash
                         └── job ID
```

### Evidence — captured anchor element

From the Recent Activity notification panel after queueing the export:

```html
<a href="https://analytics-cdn.lfmdev.in/290891-1cf67c943fca0bb956460b27440d6537.csv"
   download="">Download file</a>
```

The `download` attribute is empty string (`download=""`). Per the HTML spec, when `download` has no value the browser falls back to either the `Content-Disposition` header or the URL's last path segment. There is **no** `Content-Disposition` header (see below), so the browser uses the URL's last segment — the hashed name.

### Evidence — CDN response headers (captured via in-page `fetch` with credentials)

```
status: 200
content-length: 16032
content-type:   binary/octet-stream
etag:           "e531d17e006b5e9471d99f0bddb1fa97"
last-modified:  Mon, 18 May 2026 14:47:27 GMT
```

Notable absences:
- **No `Content-Disposition` header** — so the browser can't get a friendly filename from the server.
- **`Content-Type: binary/octet-stream`** instead of `text/csv` — minor; doesn't break anything but is non-ideal.

### Evidence — JS confirmation snippet

The full filename + anchor capture was done with this hook installed before clicking Ok:

```javascript
const origClick = HTMLAnchorElement.prototype.click;
HTMLAnchorElement.prototype.click = function(){
  if (this.download !== undefined) {
    window.__captured_anchors.push({href: this.href, download: this.download});
  }
  return origClick.call(this);
};
```

Result returned:
```json
{
  "anchorCount": 1,
  "anchors": [{
    "href": "blob:...",  
    "download": ""
  }]
}
```

Wait — the captured `download` was empty for the post-notification anchor, but the user-facing anchor in the Activity panel rendered with the `<a download="">` shown above. Both confirm the empty value.

### Reproduction steps

1. Sign in as LFIQA, switch to **Adam Orfei** account.
2. Navigate to `Brand → Content`.
3. Brand = `Star Wars` (or any brand on this account).
4. Date range = Last 7 days (e.g. 2026-05-11 to 2026-05-17).
5. Channels → Facebook only → Apply.
6. Click `Export` (top-right) → in the modal, leave defaults (CSV toggle, Public data set checked) → click `Ok`.
7. Toast: "Your export has successfully been queued."
8. Wait ~30 sec → bell icon increments → click bell → Recent Activity shows "Select Data Sets Export … is now ready. Download file."
9. Right-click "Download file" → "Save link as…" — note the proposed filename is `290891-{hash}.csv`, NOT `Brand-Content-20260511-20260517-posts.csv`.

### Root-cause hypotheses (either fix suffices)

1. **Server-side (CDN object metadata):** the CDN object should be served with a `Content-Disposition: attachment; filename="Brand-Content-20260511-20260517-posts.csv"` header. Likely requires per-object metadata on S3 (or equivalent) at the moment the file is written, or a signed-URL response-content-disposition param.
2. **Client-side (React notification component):** the React component that renders the "Download file" anchor in the notification panel could set `download="Brand-Content-<from>-<to>-posts.csv"` based on the export job's metadata.

Either fix would satisfy QA-531 A2. Doing both would be belt-and-suspenders.

### Contrast — different export pipeline gets this right

The Brand → Insights tile export (verified in QA-115716 — Hulu Fan Growth Rate CSV) produces the spec-compliant filename `Hulu-Insights-Fan Growth Rate-2026-05-11-2026-05-17.csv` because the React component there sets the `download` attribute client-side. So the Brand → Content pipeline is the regression — the Insights pipeline shows what correct looks like.

### Impact

- End users save raw CDN hashes (`290891-1cf...csv`) and lose the ability to identify exports by brand/date in their Downloads folder.
- Automation/monitoring scripts at customer sites that rely on the documented filename pattern will fail.
- Downstream import scripts (e.g. data warehouse ETL) that match by filename pattern won't find the files.

---

## ⚠️ BC-3 — RETRACTED (test-setup error)

> **Status revised 2026-05-20:** BC-3 was a false positive caused by testing on the wrong brand. On the spec-correct brand FX Networks Composite, QA-91412 A1 PASSES — all metrics correctly show en-dash for FB Reels in Public perspective. Per `skills/_shared/spec-adherence-rules.md` Rule 1: never substitute brands. Re-run evidence below.

### Re-run on FX Networks Composite (the spec-correct brand)

- **Account/brand:** FX Networks / **FX Networks Composite** (brand_id 62693) — the brand the dropdown returns when typing the spec's "FX"
- **Date range:** Nov 13, 2025 – May 17, 2026 (per user direction, corrected from spec's 2025-03-08 to 2026-03-07)
- **Perspective:** Public Data
- **Channel:** Facebook only
- **Filter:** Publish Type = Reel
- **Posts matching:** 1
- **Result:** ✅ all metrics show en-dash on the single matching Reel:
  - Engagements: –
  - Reactions: –
  - Comments: –
  - Shares: –
  - Response Rate: –
  - Video Views: –
  - Video Response Rate: –

### Original false-positive evidence (kept for posterity)

The original BC-3 was filed because I tested on "It's Always Sunny in Philadelphia" (brand_id 433) when the dropdown didn't surface a literal "FX" result. On that wrong brand, FB Reels showed populated Engagements/Reactions/Comments/Shares/Response Rate. That brand's behavior may still be a separate question — but it is **not** a violation of QA-91412 because that's not the brand the spec specifies.

### Lessons captured

- `skills/_shared/spec-adherence-rules.md` Rule 1: **never substitute brands**.
- `skills/_shared/spec-adherence-rules.md` Rule 2: **always click toggles explicitly, never trust URL params**.
- `skills/view-perspective-toggle/SKILL.md`: new skill for the View toggle Public vs Authorized.

### Open question for the dev team

Is "It's Always Sunny in Philadelphia" supposed to have Authorized-equivalent metrics visible in Public perspective for FB Reels? If not, that's a separate (unfiled) potential bug. If yes, the product is correct. Not in scope for QA-91412.

| Field | Value |
|---|---|
| **Severity (original false positive)** | P1 (Blocker — failing the only assertion in a Blocker-priority test) |
| **Spec priority of failing test** | Blocker (QA-91412) |
| **Status** | RETRACTED — false positive due to brand substitution. Spec-correct brand passes the test. |

### Expected vs Actual

```diff
For a Facebook Reel post in PUBLIC perspective:

Expected (per QA-91412 A1):
  Engagements:          (en-dash)
  Reactions:            (en-dash)
  Comments:             (en-dash)
  Shares:               (en-dash)
  Response Rate:        (en-dash)
  Video Views:          (en-dash)
  Video Response Rate:  (en-dash)

Actual (observed in dev today):
  Engagements:          63,592      ← populated, NOT en-dash
  Reactions:            60,804      ← populated, NOT en-dash
  Comments:             1,284       ← populated, NOT en-dash
  Shares:               1,504       ← populated, NOT en-dash
  Response Rate:        1.96%       ← populated, NOT en-dash
  Video Views:          (en-dash)   ✓ correct
  Video Response Rate:  (en-dash)   ✓ correct
```

### Evidence — observed Reel post (sorted by Engagements desc)

```
Post 2 — Reel — Wed Jul. 02, 2025 05:32 PM PDT
Brand:    It's Always Sunny in Philadelphia
Channel:  Facebook
Type:     Video — Publish Type: Reel

Metrics displayed:
  Engagements           63,592
  Reactions             60,804
  Comments               1,284
  Shares                 1,504
  Response Rate          1.96%
  Video Views            (en-dash)       ✓
  Video Response Rate    (en-dash)       ✓
```

Contrast with adjacent Original Post (NOT a Reel) on the same brand, same perspective:

```
Post 1 — Original Post — Tue Oct. 21, 2025 04:42 PM PDT
  Engagements         75,247
  Reactions           71,671
  Comments               838
  Shares               2,738
  Response Rate         2.34%
  Video Views      2,870,050      ← populated for non-Reel
  Video Response Rate   2.62%      ← populated for non-Reel
```

So: only **Video Views** and **Video Response Rate** are en-dashed for Reels. The other 5 metrics are populated normally. That's 2 of 7 metrics en-dashed, not "all 7" as the spec says.

### Reproduction steps

1. Sign in as LFIQA, switch to **FX Networks** account (account_id 204).
2. Navigate to `Brand → Content`.
3. Brand = `It's Always Sunny in Philadelphia` (or any brand on this account with FB Reels in date range — the test spec says "FX" generically; this brand is the closest available).
4. Date range: 2025-03-08 to 2026-03-07 (per spec).
5. Perspective: **Public** (URL `perspective=extended`).
6. Channel: **Facebook only** → click Apply.
7. Filter → **Publish Type** → check `Reel` → click `Apply Filter`.
8. Sort by Engagements desc.
9. Inspect the top Reel post tile in the grid. Engagements, Reactions, Comments, Shares, Response Rate all render as numeric values — they should be en-dash per QA-91412 A1.

### Diagnosis — likely cause

Either:
1. **Regression in product behavior** — Facebook's public-Graph API has started returning engagement metrics for Reels (it didn't when QA-91412 was authored). The data ingestion is correctly storing them, and the product correctly displays them. The TEST is now wrong.
2. **Regression in data ingestion** — Some pipeline change started bucketing Reel engagement metrics into the Public perspective when they should still be Authorized-only. The PRODUCT is wrong.

To disambiguate: check the FB Graph API response for a sample of these Reel posts. If the API returns the values publicly, the spec needs updating. If the API only returns them on `like_count`/`comments_count`-with-token requests, the ingestion is leaking authorized data into public.

### Impact

- If product is wrong: end users see metrics on Public Reels they shouldn't be able to see → privacy/contractual exposure.
- If spec is wrong: every QA run of this test fails forever until the spec is updated.
- Either way the project's confidence in "Public vs Authorized" boundary is dented.

### Suggested next steps

1. **Pull Jira history on QA-91412** to see who authored A1 and what data source they tested against.
2. **Backend / data team:** check the ingestion path for FB Reels engagement metrics. Are they stored as `public_*` or `authorized_*` columns? If public, when did that change?
3. **Product:** if the data IS publicly available from FB, update QA-91412 wording from "all metrics show endash" to "only Video Views and Video Response Rate show endash for FB Reels in Public perspective."

---

## Inconclusive findings (not yet bugs)

### IF-1 — Brand > Audience "Export → Metrics" produces no observable file

| Field | Value |
|---|---|
| **Source case** | QA-110071 (Brand > Audience metrics export for Threads channel) |
| **Status** | INCONCLUSIVE — possibly automation-only friction, possibly a real silent failure |
| **First seen** | 2026-05-13 (batch 3) |

**Observed:** Clicking `Export → Metrics` fires Mixpanel telemetry but produces NO file detectable by:
- `URL.createObjectURL` interception
- `HTMLAnchorElement.prototype.click` with `download` attribute interception
- `window.open` interception
- `HTMLFormElement.prototype.submit` interception
- New tab in MCP tab group

**To resolve:** check the user's Downloads folder for a recent `Brand-Audience-Metrics.*` file. If present, this is "not a bug, automation friction only." If absent, file as a real silent-failure bug.

### IF-2 — QA-122942 Export "Ok" modal sometimes doesn't dismiss on Hulu

| Field | Value |
|---|---|
| **Source case** | QA-122942 (Hulu Brand>Content IG Public perspective export) + QA-71007 (Disney Ad Sales) |
| **Status** | Inconsistent — sometimes works, sometimes doesn't |

In two separate sessions on different accounts (Hulu, Disney Ad Sales), the "Ok" button in the Brand > Content "Export Select Data Sets" modal failed to dismiss the modal when clicked. No "Your export has successfully been queued" toast appeared. Three workarounds documented in `skills/export-csv/SKILL.md` v2.1 (uncheck-and-recheck Public, click underlying input directly, close-reopen-immediately).

**Not filed as a bug yet** because it's not consistently reproducible — flag-worthy but needs more sessions to characterize.

---

## Bug summary table

| ID | Severity | Test | Status | Single-line summary |
|---|---|---|---|---|
| **BC-1** | P2 | QA-109059 | Reproduced, untriaged | Custom Data Set dropdown order doesn't match creation order |
| ~~**BC-2**~~ | ~~Medium~~ | QA-531 | ❌ **RETRACTED 2026-05-20** | False positive — DOM/network signals didn't reflect actual download behavior. Spec-correct behavior verified by LFIQA. |
| ~~**BC-3**~~ | ~~P1 (Blocker)~~ | QA-91412 | ❌ **RETRACTED 2026-05-20** | False positive — wrong brand. Spec-correct brand (FX Networks Composite) passes the test. |
| **BC-4** | P2 | QA-23969 | Reproduced, untriaged | Social Recap PDF page footer shows `Page N` only — missing `(N - Page count)` suffix |
| IF-1 | TBD | QA-110071 | INCONCLUSIVE | Audience metrics export download not detected |
| IF-2 | TBD | QA-122942, QA-71007 | INCONSISTENT | Export modal "Ok" sometimes doesn't dismiss |
| IF-3 | TBD | QA-23969 | MINOR | Social Recap PDF filename missing space between `BrandName` and `-Weekly Social Recap` (spec template ambiguity) |

## Source reports — for deeper context per bug

- **BC-1:** [QA-109059 in batch3 bugs file](bugs-2026-05-13-batch3.md)
- **BC-2:** [batch6 bugs file](bugs-2026-05-13-batch6.md) · [QA-531 report](QA-531-report.md)
- **BC-3:** [QA-91412 report](QA-91412-report.md)

## Project metadata

- 49 test cases scoped across the regression project
- 20 skills authored — see [REGISTRY.md](../../skills/REGISTRY.md)
- All bugs reproduced on dev environment with the same user account (LFIQA)
- All evidence is from in-browser inspection (DOM, network, response headers) or direct screenshot
- No bug requires special tooling beyond Chrome MCP to reproduce
