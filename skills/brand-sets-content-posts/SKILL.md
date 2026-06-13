---
name: brand-sets-content-posts
version: 1
last_verified: 2026-06-11
last_passed_run: 2026-06-11
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-set]
postconditions: [posts-grid-rendered]
inputs: [brand_set_id, account_id]
outputs: [posts_count, loaded_post_count]
related_pages: ["/#explore/competitive/content"]
---

# Brand Sets > Content — posts surface, Rank dropdown, 100-post infinite scroll

Verified on LF // TV // Episodic (brand_set_id=756) under Amazon Prime Video (acct 342) and DET (acct 113) — QA-420, QA-395-adjacent.

## Steps

### Step 1 — Navigate
- `https://app.lfmdev.in/#explore/competitive/content?brand_set_id={id}&account_id={acc}` (LF // TV // Episodic = 756; ~33K posts for a 7-day window — expect 10-20 s skeleton on first paint).
- Rank: defaults to **Engagements**; Rank Mode Overall/Filtered radios; Layout icons right of the Sort row.

### Step 2 — Infinite scroll = +100 posts per bottom-hit (Table AND Detail views)
- Page loads 100 posts. Programmatic `window.scrollTo(0, scrollHeight)` alone does NOT trigger the loader — finish with a real wheel scroll at the bottom; a small spinner appears under the last row, next 100 arrive in ~5-10 s.
- Count Table View rows: `tbody tr` whose first cell is a numeric rank (verified 100→200→300).
- Count Detail View cards: occurrences of the per-card "Daily Analysis" link ÷ 2, or max visible rank (verified 300→400; view-switch preserves already-loaded posts).

### Step 3 — Rankings sibling page
- `…/competitive/rankings?brand_set_id=…` — Rank dropdown groups **Public Data** (20 metrics, Engagements default) + **Authorized Data** (Average Video Views, Impressions, Video Views); search box filters options; selection rewrites `rank_by_metric=` and may auto-narrow `channels=` (Public Impressions → twitter-only observed).

## Known quirks
- Brand Sets > Content View toggle is disabled (perspective derives from Rank-by group) — see known-quirks.md.
- Test-spec drift: older specs cite URL `#explorer/brand-set-name/rankings`; actual is `#explore/competitive/rankings?brand_set_id=`.

## Changelog
- **v1** (2026-06-11): Initial from QA-420 PASS (+100/scroll in Table & Detail) + QA-395 Rankings facts.
