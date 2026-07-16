---
name: brand-sets-rankings
version: 1
last_verified: 2026-07-09
last_passed_run: 2026-07-09
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-has-brand-set]
postconditions: [rankings-table-visible]
inputs: [brand_set_name, rank_metric]
outputs: [rank_by_metric_in_url, channel_selection]
related_pages: ["#explore/competitive/rankings?brand_set_id={id}"]
---

# Brand Sets > Rankings

Ranks all brands in a Brand Set by a chosen metric. **NEW from QA-395.**

## Steps

### Step 1 — Navigate
- Hover "Brand Sets" in top nav → click "Rankings".
- The default brand set for the account loads automatically (no explicit picker needed if the account only has one brand set favorited/default).
- **Assertion:** URL is `#explore/competitive/rankings?brand_set_id=<id>`; breadcrumb reads `Account: <name> | Brand Sets > Rankings`.

### Step 2 — Toolbar layout (read-only checks)
- Help Center / Guide / Info buttons top-right.
- `View:` toggle shows Public Data (left, active by default) / Authorized Data (right, `disabled` class if the current channel/metric combo doesn't support it).
- Channel icons (Facebook/Twitter/Instagram/YouTube/TikTok) + disabled `Apply` button (enabled only after a channel toggle changes) + `Export` button.
- `Filter:` row (Select dropdown + Apply/Load/Save Filter + Clear All) sits below the channel/export row.
- Default Rank metric = Engagements, sorted descending.

### Step 3 — Open the Rank dropdown
- **Target:** `.lfm-dropdown-select-box` (click opens an absolutely-positioned overlay with a `Search` textbox + two groups: "Public Data" and "Authorized Data").
- Group contents are static per-account (not brand-set-dependent): Public Data = Average Engagements per Post, Average Public Video Views, Comments, Digital Audience Rating™, Engagements, Fan Growth Rate, Interactions, Interest Score, New Followers, Owned Social Score, Posts, Public Impressions, Public Video Views, Reactions, Response Rate, Shares, Social Talkability, Total Followers, Video Posts, Wikipedia Page Views. Authorized Data = Average Video Views, Impressions, Video Views.

### Step 4 — Filter + select a metric
- Type into the dropdown's `Search` textbox (`getByRole('textbox', {name:'Search'})`) — filters the option list live.
- **Click target: use `page.getByTitle(metricName)`**, NOT a generic textContent scan. The option node is `<span class="lfm-option-label" title="<Metric Name>">` — a bare-text JS query can match an unrelated off-screen node (e.g. a hidden date-picker cell) and silently no-op.
- **Assertion:** URL `rank_by_metric=` param changes to the metric's internal key (e.g. `lfm.audience_ratings.public_fan_acquisition_score_v5` for New Followers, `lfm.content.public_impressions` for Public Impressions); the Rank label + the sortable table column header both update to the metric's display name.

### Step 5 — Channel-exclusive metrics auto-collapse the channel selector
- Selecting a metric that's only collected for one channel (e.g. "Public Impressions" → Twitter-only) replaces the multi-icon channel toggle + Apply button with a single non-interactive channel chip, and the URL `channels=` param drops to just that one channel.
- This is the Rankings-surface version of the channel/data-set exclusivity pattern already documented in `brand-content-data-set-selector`.

## Known quirks

- **A one-time "This tile failed to load. Please try again." can appear right after switching the Rank metric** — a single click on the inline `Reload` link recovers it. Seen once in the QA-395 run, did not reproduce on a second metric switch in the same session.
- **Spec-wording drift:** older test-case text may reference the URL pattern `#explorer/brand-set-name/rankings` (current is `#explore/competitive/rankings?brand_set_id=<id>`) and may call the second Rank-dropdown group "Extended Data" (current UI label is "Authorized Data"). Treat as spec-text staleness, not a product defect, when the underlying content/behavior matches.

## Known bug history

See `knowledge-base/bug-history.md`. No bugs tied to this flow yet.

## Changelog
- **v1** (2026-07-09): Initial draft from QA-395 (Disney Entertainment Television, LF // TV // Episodic brand set). 20/20 assertions PASS. Documented the `getByTitle` click-target requirement, channel-auto-collapse-on-metric-select behavior, and the transient tile-reload quirk.
