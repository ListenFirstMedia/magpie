# QA-461 — Data QA - Partnership - Graph Values

- **Run:** 2026-07-10, headless/unattended, Playwright MCP (`feature/playwright-mcp`)
- **Account:** Adam Orfei (account_id=54) — precondition met (session logged in as `lfiqa@listenfirstmedia.com`, already on Adam Orfei)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Surface:** Brand Sets > Content (`#explore/competitive/content`)
- **Verdict:** **BLOCKED — backend 500 on the Brand Sets Content data endpoint (step 4, blocks steps 4–13)**

## Summary

Pre-flight login and steps 1–3 executed cleanly via the real UI. The case then blocked at step 4:
the Brand Sets Content surface never renders its big-number tiles or posts table because the
platform's content data API (`data-api.lfmdev.in/content`) returns **HTTP 500** for
`brand_set_id=1738`. With no tiles/table, the **Filter** button stays disabled, the big-number
graphs (Sponsored Posts, Engagements) cannot be read, and no posts can be exported — so every
assertion (A5, A7, A10, A13) is **Not Evaluable**.

The 500 is a genuine server response observed on the app's **own authenticated** requests (bearer
token attached by the app), so it satisfies Rule 6 (real user-visible outcome, not a
programmatic-proxy inference). It reproduced **4×** across two date windows and a full reload —
not a transient automation render hang.

## Steps executed

| # | Step | Result |
|---|------|--------|
| — | Pre-flight: navigate + Cognito "With existing account" login | PASS — reached `#home`, title "Home - ListenFirst" |
| 1 | Brand Sets top nav → Content | PASS — hover-opened Brand Sets dropdown, clicked Content → `#explore/competitive/content?brand_set_id=1738` |
| 2 | Select 'Adam's Brand Set' | PASS — brand-set header already reads "Adam's Brand Set" (brand_set_id=1738) |
| 3 | Set date range Jan. 03, 2025 – Jan. 04, 2025 | PASS — two-calendar picker (Start=Jan 3, End=Jan 4 2025); Date Range button confirms "Jan. 03, 2025 - Jan. 04, 2025"; URL `from=2025-01-03&to=2025-01-04` |
| 4 | Click Filters → Branded Content: Yes | **BLOCKED** — content tiles/table never render (data-api 500); Filter button stays disabled (`al-button ... [disabled]`) |
| 5–13 | Channel enable / Export / Sum engagements (FB, Twitter, IG) | **NOT REACHED** — dependent on step 4 surface loading |

## Evidence — the backend 500

App-authenticated content requests (from `performance.getEntriesByType('resource')`, real app calls):

| Window | Endpoint | Status | Duration |
|--------|----------|--------|----------|
| 2026-07-02→07-08 (default) | `data-api.lfmdev.in/content?...brand_set_id=1738...` | **500** | — (network log req 430) |
| 2025-01-03→01-04 (spec) | `data-api.lfmdev.in/content?...brand_set_id=1738...` | **500** | 2375 ms |
| 2025-01-03→01-04 (after reload) | `data-api.lfmdev.in/content?...brand_set_id=1738...` | **500** | 3337 ms |
| 2025-01-03→01-04 (spec) | `dsp-api.lfmdev.in/content/filters?brand_set_id=1738...` | **500** | — (network log req 452) |

- The `filters?brand_set_id=1738` endpoint returned **200**, but `content/filters` and the main
  `content` data query **500**, so the story template / tiles never mount.
- Two additional `data-api/content` entries show **401** — those are my own in-page `fetch()`
  reproductions, which lack the app's bearer token (Rule-6 caveat: programmatic fetch ≠ the app's
  authenticated request). They are **not** evidence of the app's behavior and are disregarded; the
  authoritative signal is the app's own 500s above.
- Query shape (from the network log): a whole-brand-set partition query over 5 channels
  (`facebook,twitter,instagram,youtube,tiktok`), `partition_opts.ignore_limit:true`,
  `authorize_brand_view_as:standard`, `stat_type:lifetime`. Consistent with the known
  "Adam's Brand Set ~76K posts" heaviness, but here it errors rather than merely being slow.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Sponsored-posts big number == Sponsored Posts graph | Big-number tiles never render (data-api 500) | NOT EVALUABLE (BLOCKED) |
| A7 | 7 | Σ Engagements (export, FB) == Engagements big-number graph (FB) | No tiles / no export possible | NOT EVALUABLE (BLOCKED) |
| A10 | 10 | Σ Engagements (export, Twitter) == Engagements big-number graph (Twitter) | No tiles / no export possible | NOT EVALUABLE (BLOCKED) |
| A13 | 13 | Σ Engagements (export, Instagram) == Engagements big-number graph (Instagram) | No tiles / no export possible | NOT EVALUABLE (BLOCKED) |

## Screenshots (`.playwright-out/QA-461/`)

- `step4-before-filter.png` — surface after nav; content area is a skeleton bar
- `step4-loaded.png` — after ~12s; still skeleton, no tiles
- `step4-stuck-500.png` — persistent skeleton on the spec window (Jan 3–4 2025)
- `step4-stuck-after-reload.png` — still skeleton after one reload

## Spec-adherence notes

- Rule 1 (no brand substitution): honored — did not switch brand set or account.
- Rule 3 (every step in order): steps 1–3 performed via UI; stopped at step 4 rather than skipping ahead / faking values.
- Rule 6 (no proxy-only claims): the 500 verdict rests on the app's own authenticated request status, not on DOM/DIY-fetch signals; my 401 fetch reproductions are explicitly discounted.
- Step budget: one reload attempted (transient-retry); still 500 → whole case BLOCKED, per the render-hang rule. Not reported as partial PASS.

## Bugs filed

_None created in Jira (markdown only, per instructions)._

**Candidate defect (needs eng confirmation):** `data-api.lfmdev.in/content` returns **HTTP 500**
for Brand Sets > Content on **Adam's Brand Set (brand_set_id=1738)**, across the default window and
the spec window (Jan 3–4 2025), persisting through a reload. The companion
`dsp-api.lfmdev.in/content/filters?brand_set_id=1738` also 500s. Result: the entire Brand Sets
Content surface (big-number tiles, posts table, Filter button) fails to load for this brand set.

- **Caution:** dev-environment 500s can be environmental/transient at the infra level. Reproduced
  4× this run, but recommend LFIQA re-check on a real browser and/or a smaller brand set to confirm
  whether this is a product defect vs. a temporary backend outage before filing.
- **Repro:** Adam Orfei → Brand Sets → Content → Adam's Brand Set → any date window → observe
  content skeleton never resolving; Network shows `GET data-api.lfmdev.in/content?...brand_set_id=1738...` → 500.
