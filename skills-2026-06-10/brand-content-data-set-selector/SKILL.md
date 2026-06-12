---
name: brand-content-data-set-selector
version: 2
last_verified: 2026-06-10
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in, account-set]
postconditions: [data-set-applied-on-brand-content]
related_pages: ["/#explore/brand/content"]
---

# Pick a Data Set on Brand > Content

Dropdown sections: 1) Cross-Channel Metrics, 2) Channel-Specific Metrics, 3) **Custom Data Set** (singular header) listing the account's saved sets.

## Steps
1. Brand > Content → `Data Set:` dropdown above the channel ghost row.
2. Click the set by exact leaf text (element-targeted click works; see v1 snippet).
3. Trigger label updates to the set name; URL gains `table_data_set=<name>`.

## Confirmed findings (re-verified 2026-06-10)
- **Custom sets display ALPHABETICALLY (case-sensitive), not in created order** — fails any "created order" assertion. Same order on Settings > Custom Data Sets listing. Ref APPS-61234 (closed; behavior persists).
- **Transient:** first apply of a custom data set can show "This table failed to load. Please try again." — Reload recovers; data-api request then 200.
- **BUG found via this page (QA-109059 A7):** unchecking a metric in `Metric Display` (e.g. Engagements, leaving "10 Selected") does NOT remove its column from the summary grid. Possibly interacts with Sort being set to that metric.
- Locked composite metrics (Comments, Shares) display Organic/Paid sub-columns in the grid — by design.
- Metric Display dropdown lists only the data set's metrics (verify with checkbox sub-tree FB/TW style entries).

## Channel row assertion (QA-109059)
Order: Facebook, X, Instagram, YouTube, TikTok, LinkedIn, Threads, then `|` divider, then crossed-out Pinterest.

## Changelog
- **v2** (2026-06-10): re-verified order bug; added table-failed transient, Engagements-column bug, Organic/Paid breakdown note.
- **v1** (2026-05-13): initial.
