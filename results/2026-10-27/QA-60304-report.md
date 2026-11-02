# QA-60304 — Brand Sets Content > Twitter Video Views > Public and Authorized Data

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Amazon Prime Video / "Amazon Prime Video-- Episodic Network Roll-Up"
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Amazon Prime Video (account_id=342) · **Brand set:** Amazon Prime Video-- Episodic Network Roll-Up (brand_set_id=8223) · Channel: Twitter only · Mode: Lifetime · Date range: default week Oct. 19, 2026 – Oct. 25, 2026
**Verdict: FAIL — open linked bug LFMP-32125 (Open) ⇒ FAILED per policy. Execution outcome: Video Views are identical under Rank "Video Views (Public Data)" and Rank "Video Views (Authorized Data)" for all 97 tweets on the Twitter-only page (0 value differences, same 97 tweets under both ranks); two tweets show "–" for Video Views under each rank, which is the LFMP-32125 symptom ("Twitter one post Video Views data is not displayed")**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets > Content → Amazon Prime Video-- Episodic Network Roll-Up | ✅ `brand_set_id=8223` (set selected from the picker as soon as it rendered; dev home sat on "Loading" ~3 min first) |
| 3–5 | Rank By → **Video Views (Public Data)** (`rank_by_metric=lfm.content.public_video_views_v5`), Twitter only, Table View, note Video Views for all rows | ✅ 97 rows, top "The Lord of the Rings: Rings of Power" status 2112944717658734835 = 1,411,709 |
| 6–7 | Rank By → **Video Views (Authorized Data)** (`rank_by_metric=lfm.content.video_views`, last "Video Views" option), Twitter only, Table View, compare | ✅ 97 rows, same top post 1,411,709 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Public and Authorized Video Views identical for all posts | 97 tweets on both pages: 97/97 identical (0 mismatches, 0 missing either way); 2 tweets per page display "–" | ❌ FAIL (policy: open bug LFMP-32125; data parity itself holds) |

## Evidence
- Session result `ctx._bs.q60304` (+ `ctx._bs.q60304raw` with both 100-row scrapes).
- Mechanics note: the Rank dropdown echoes the current selection as its first option, so "Video Views" appears 3× once a Video Views rank is active — pick by position after skipping the echo (public = first remaining, authorized = last). A reload after setting the channel (URL keeps rank + channel) is the reliable way to get a fresh Twitter-only table.

## Known bugs checked
- **LFMP-32125 (Open)** "Brand and Brand Set > Content – Twitter One Post Video Views Data Is Not Display" — two "–" tweets per rank reproduce it; FAILED per the 2026-10-22 directive.

## Bugs filed
None (existing bug).

## Cleanup
None (read-only).
