# QA-60304 — Brand Sets Content > Twitter Video Views > Public and Authorized Data

**Run date:** 2026-10-26 (Monday) — case is fixed to Amazon Prime Video / "Amazon Prime Video-- Episodic Network Roll-Up"
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Amazon Prime Video (account_id=342) · **Brand set:** Amazon Prime Video-- Episodic Network Roll-Up (brand_set_id=8223, Posts (824)) · Channel: Twitter only · Mode: Lifetime · Date range: default week Oct. 18, 2026 – Oct. 24, 2026
**Verdict: FAIL — open linked bug LFMP-32125 (Open) ⇒ FAILED per policy. Execution outcome: Video Views are identical under Rank "Video Views (Public Data)" and Rank "Video Views (Authorized Data)" for all 99 tweets present on both 100-row pages (0 value differences); one tweet on each page shows "–" for Video Views, which is the LFMP-32125 symptom ("Twitter one post Video Views data is not displayed")**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets > Content → Amazon Prime Video-- Episodic Network Roll-Up | ✅ `brand_set_id=8223`, Posts (824) (dev needed ~3 min + a reload to render the page under batch load; the dev session also expired once mid-run and was re-logged) |
| 3–5 | Rank By → **Video Views (Public Data)** (`rank_by_metric=lfm.content.public_video_views_v5`), Twitter only, Table View, note Video Views for all rows | ✅ 100 rows (page cap), top "The Lord of the Rings: Rings of Power" status 2112944717658734835 = 1,404,394 |
| 6–7 | Rank By → **Video Views (Authorized Data)** (`rank_by_metric=lfm.content.video_views`, last "Video Views" option), Twitter only, Table View, compare | ✅ 100 rows, same top post 1,404,394 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Public and Authorized Video Views identical for all posts | 99 tweets on both pages: 99/99 identical (0 mismatches); 1 tweet only on the public page and 1 only on the authorized page (100-row cut-off at the tail, equal values near the cut); 1 tweet per page displays "–" | ❌ FAIL (policy: open bug LFMP-32125; data parity itself holds) |

## Evidence
- Session result `ctx._bs.q60304` (+ `ctx._bs.q60304raw` with both 100-row scrapes).
- Mechanics note: the Rank dropdown echoes the current selection as its first option, so "Video Views" appears 3× once a Video Views rank is active — pick by position after skipping the echo (public = first remaining, authorized = last). Stale all-channel tables were served for 1–2 min after a Rank change on dev today; a reload after setting the channel fixed it.

## Known bugs checked
- **LFMP-32125 (Open)** "Brand and Brand Set > Content – Twitter One Post Video Views Data Is Not Display" — one "–" tweet per rank reproduces it; FAILED per the 2026-10-22 directive.

## Bugs filed
None (existing bug).

## Cleanup
None (read-only).
