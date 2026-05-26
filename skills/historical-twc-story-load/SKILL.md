---
name: historical-twc-story-load
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-has-access-to-story]
postconditions: [story-fully-loaded]
inputs: [story_id, account_id]
outputs: [report_brand, report_date_range, selected_metrics, options]
related_pages: ["/#story/time_window_comparison/{id}"]
---

# Load an existing TWC story by ID and verify its saved settings

Some tests check that an historical (saved) TWC story loads correctly with all its original settings intact. This is the read-only sibling of `time-window-comparison-run`.

## Steps

### Step 1 — Navigate to the story URL
- Direct URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/{story_id}`
- **CRITICAL caveat:** the URL contains no account_id; the active session's account is used. If the test specifies "User logged in as X", switch to account X FIRST (using `switch-account` skill), then load the story URL.
- If the account doesn't have access to the story, the page silently redirects to `/#/time_window_comparison` (the empty builder) — that IS a failure mode for an "A1: report loads" assertion, but happens with no user-visible error.

### Step 2 — Verify the story loaded
- Check the URL still contains `/#story/time_window_comparison/{story_id}` after a 5-10s wait.
- Page shows brand name as the title (e.g., `The Walking Dead`), with Series/Network metadata, a chart, and a `Change Settings` button at top-right.

### Step 3 — Open Change Settings to inspect saved config
- Click the `Change Settings` button.
- A modal opens with sections: Add Brands, Select a Date Range, Select Channel Data, Options.

### Step 4 — Read brand + date range
- Brand list shows the saved brand with its View toggle state (Public Data / Authorized Data).
- Date Range section: `Absolute Dates` or `Relative Dates` tab is highlighted with the saved value.

### Step 5 — Inspect metric selections
- Scroll down past the date pickers to the Select Channel Data section.
- Counts in each category header show `(M / N)` where M is selected, N is total.
- Per-leaf checkbox state via `aria-checked`:

```javascript
const metric = 'Facebook New Fans';
const lbl = [...document.querySelectorAll('*')].find(el => (el.textContent||'').trim() === metric && el.offsetWidth > 0);
const i = lbl?.closest('li,div')?.querySelector('i[role=checkbox]');
const isChecked = i?.getAttribute('aria-checked') === 'true';
```

### Step 6 — Inspect Options
- Scroll to the Options section at the bottom.
- Verify Graph Options (Show Metrics Graphs) and Table Options (Show Metrics Tables, Show Change, Show Share) by reading checkbox `aria-checked`.

## Assertion patterns

For tests like QA-329:
- **A1 "Report fully loads without errors":** URL didn't redirect to `/#/time_window_comparison`, page shows title + chart + Change Settings button.
- **A2 "Brand X, Date range Y":** Open Change Settings; verify brand row text and Absolute/Relative tab selection.
- **A3 "Specific metrics selected":** For each expected metric, `aria-checked === 'true'`. For each unexpected metric, `aria-checked === 'false'`.
- **A4 "Show X / Show Y checked":** Verify the relevant checkbox aria-checked state.

## Known quirks

- Some saved stories include View=Authorized Data on the brand, but the test may expect Public — read the toggle state explicitly rather than assuming.
- The story URL pattern is shared between dev and stage (`app-reporting.lfmdev.in` vs `app-reporting.stage.lfmprod.in`) — the case may give multiple URLs; pick the env matching the run.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-329 run. Verified 4 assertions for The Walking Dead story 119501 on Hulu / Jan 1-7, 2023 / FB+TW+IG+YT New Fans-Followers-Subscribers / Show Graphs+Tables.
