# Known Quirks

Accepted product behavior or automation-only friction that previously looked like bugs. Anything in this list is **not** reported as a bug on future runs.

Each entry should explain *why* it's accepted so we can revisit when product decisions change.

## Format

```
### <quirk title>
- **First observed:** YYYY-MM-DD (TC-XXX)
- **Behavior:** what the app does
- **Why accepted:** product/design decision, link to ticket if available
- **Affected assertions:** which checks should ignore this
- **Revisit if:** condition that would make us care again
```

## Related references

- [bug-history.md](bug-history.md) — per-ticket bug history (open + closed defects). Read this for the specific QA-ID before re-running any test in `runs/2026-05-27/`.

## Entries

### Brand picker requires programmatic InputEvent dispatch

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** The "Search for a Brand" textbox in the TWC builder is React-controlled and ignores plain `value` mutation. Chrome MCP's `type` action sets the value but doesn't trigger React's `onChange`, so the autocomplete dropdown doesn't open. A manual user typing on a real keyboard triggers it normally.
- **Why accepted:** This is automation-only friction, not a product bug. End users are not affected.
- **Affected assertions:** None — assertions still verify the dropdown appears, but the *means* of triggering it is documented in the skill so the assertion doesn't false-fail.
- **Revisit if:** The Chrome MCP `type` action is upgraded to dispatch synthetic input events (then we can simplify the skill).

### Google Sheets tab title includes "- Google Sheets" suffix

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** When a Google Sheet opens in a tab, the browser tab title is `<filename> - Google Sheets`. The `- Google Sheets` suffix is added by Google Drive, not by the LFM export.
- **Why accepted:** Standard Google Drive behavior across all hosted spreadsheets.
- **Affected assertions:** Filename pattern checks (e.g., QA-5757 A1) — strip the trailing ` - Google Sheets` before comparing to the expected pattern.
- **Revisit if:** Google changes the convention (highly unlikely).

### Reporting top-nav menu opens on hover, not click

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The "Reporting" item in the top global navigation is a hover-triggered dropdown. Clicking the label is unreliable — sometimes nothing happens, sometimes the click is interpreted as a toggle-close.
- **Why accepted:** This is the product's intended interaction model.
- **Affected assertions:** Any skill that opens a top-nav dropdown. The skills now use `hover` then `click` on the child item.
- **Revisit if:** Product changes to click-to-open.

### Brand picker "Recent Searches" section is display-only

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The "Add Brand By Name" typeahead shows a "Recent Searches" section above the live "Results". Clicking an entry in Recent Searches does **not** add a brand row — it appears to dismiss the dropdown without selecting. Only entries under the `Results` heading add a brand row.
- **Why accepted:** Likely intentional — Recent Searches is shown as a hint, not as a selectable history.
- **Affected assertions:** Skill `time-window-comparison-run` step 5 — always pick from Results.
- **Revisit if:** Product changes Recent Searches to be interactive.

### Default 7-day date range shifts forward daily

- **First observed:** 2026-05-13 (QA-5757 first run on 5-13, then re-run later same day)
- **Behavior:** The TWC builder's default Absolute Dates range is "last 7 days ending yesterday". Two runs on different days will see different default ranges. Within a single day, the range may shift at midnight Pacific or after a session refresh.
- **Why accepted:** Standard relative-default behavior.
- **Affected assertions:** Filename assertions that include dates — capture the actual rendered range from the built report rather than hardcoding.
- **Revisit if:** The default range stops shifting (could indicate a frozen-time bug).

### Em-dash cells for dates past data freshness

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The data table for a metric may render `–` (em dash) for any date that is past the `Data Last Updated` timestamp shown on Home. Today's run on 2026-05-13 had data through 2026-05-12 06:32 PM PT, so the May 12 row in a May 6–12 window correctly showed `–`.
- **Why accepted:** Normal data freshness — that day's ETL hadn't run yet.
- **Affected assertions:** Any cross-export parity check — treat `–` as a recognized missing-value marker, not a value mismatch.
- **Revisit if:** Em dashes appear for dates that should be available (e.g., a date 3+ days in the past).

### Google Sheets export opens a tab outside the Chrome MCP group

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** Clicking `Export → Google Sheets` triggers `window.open` to a `docs.google.com/spreadsheets/...` URL. The resulting tab often opens in the user's regular Chrome window, **not** in the Chrome MCP-managed tab group. Consequences:
  - `tabs_context_mcp` won't list the sheet tab.
  - The Export button can stay in a loading state because the LFM tab waits for a message from the new tab that never arrives across the MCP boundary.
- **Why accepted:** Browser / MCP integration behavior, not a product bug.
- **Affected assertions:** Anything that needs to read the Google Sheet content from automation. Workarounds documented in `skills/export-google-sheets/SKILL.md`: install a `window.open` hook to capture the URL, then open that URL in a fresh MCP tab.
- **Revisit if:** Chrome MCP gains the ability to absorb externally-opened tabs.

### Google Sheets export sheet is not in the user's Drive

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The LFM Google Sheets export creates the spreadsheet under a service identity (not the test user's Google account). `drive.google.com/drive/recent` for the test user does not show the sheet at the top; Drive search may not find it either. The sheet IS accessible via the direct URL.
- **Why accepted:** Service-account ownership is a common export pattern.
- **Affected assertions:** Filename assertions that try to verify via Drive — use the direct URL captured by the `window.open` hook instead.
- **Revisit if:** Drive listing starts showing the exports.

### `~/Downloads` can be mounted via `mcp__cowork__request_cowork_directory` for end-to-end file verification

- **First observed:** 2026-05-27 (PNG/PDF verification round)
- **Behavior:** Calling `mcp__cowork__request_cowork_directory` with `path="~/Downloads"` mounts the user's Downloads folder into the session. After approval, Read/Write/Edit/Grep/Glob and the Linux bash sandbox can all see the actually-saved exports — PNGs, PDFs, CSVs, XLSX — without LFIQA needing to drag files into chat.
- **Why this matters for Rule 6:** Filename / chart-title / legend / footer / page-break assertions can now be verified directly from the saved file on the host, not via DOM signals. This is the canonical pattern for Rule 6 verification going forward.
- **Affected skills:** `pdf-end-to-end-verification`, `export-csv`, `export-google-sheets`, and any PNG-export test (QA-20988, QA-12532, future Brand>Paid / Brand Sets > Partnerships tests). The skills should default to: `mkdir /sessions/.../mnt/outputs/qa-<id>-png && cp ~/Downloads/<saved-file> there` then `Read` the PNG via the file tool.
- **Revisit if:** the user revokes the mount, or Cowork changes the mount behavior.

### Brand > Content default Data Set hides channel-specific data

- **First observed:** 2026-05-27 (QA-929 retry, LFIQA-provided correction)
- **Behavior:** The Data Set dropdown on Brand > Content defaults to a generic value (`Public` or `Organic Performance`) depending on perspective. For some channel tests (Pinterest is the confirmed case; possibly also Threads / TikTok / niche channels), the generic data set returns `Posts (0)` even though channel-specific data exists. Switching to a channel-specific data set like `Pinterest Only: Basic` unlocks the full post corpus (e.g., 85,292 Sephora Pinterest posts for May 26 2025 – May 25 2026 became visible only after this switch).
- **Why accepted:** The "Public" / "Organic Performance" data set only includes posts whose metrics are available in those metric bundles. Channel-specific data sets pull from richer per-channel feeds. This is intentional architecture, not a bug.
- **Affected assertions:** Any Brand > Content test that names a single niche channel (Pinterest, Threads, etc.) and checks posts. The skill `brand-content-data-set-selector` should be invoked to select the matching channel-specific data set BEFORE asserting `Posts (N>0)`.
- **Revisit if:** the platform auto-selects a sensible channel-specific data set when the user narrows channel selection to a single channel.

### `controlled-check-box` ignores synthetic `.click()`; needs focus+Space or real coord click

- **First observed:** 2026-05-27 (QA-23969 re-run)
- **Behavior:** The Options-section checkboxes on Social Recap (`Show Insights Editor`, `Show Source Links`, `Worst Performing Content`) and TWC builder render as `<span class="controlled-check-box"><i role="checkbox">…</i><label/></span>` — NOT a native `<input type="checkbox">`. Programmatic `wrapper.click()` from JS flips `aria-checked` momentarily but React immediately reverts it. Dispatching `MouseEvent` sequences (`pointerdown` → `click`) has the same problem.
- **Why accepted:** Real users click with a hardware mouse, which dispatches trusted events. This is automation-only friction.
- **Affected assertions:** Any Social Recap or TWC Options test that requires toggling an Options checkbox.
- **2026-06-02 update (QA-19482 batch-10 re-run):** **Focus + Space-dispatch on the `i[role=checkbox]` does work** for TWC Builder Options section (Interleave Graphs & Tables, Show Cohort Average, Show Source Links, Highlight Leader, Show Insights Editor — all 5 flipped to `aria-checked=true` and persisted through Run Report click). Required pattern: `icon.focus(); icon.dispatchEvent(new KeyboardEvent('keydown', {key:' ', code:'Space', bubbles:true, cancelable:true})); icon.dispatchEvent(new KeyboardEvent('keypress', ...)); icon.dispatchEvent(new KeyboardEvent('keyup', ...));`. The `focus()` call before the keydown is the missing piece; previous attempts had skipped it.
- **2026-06-02 caveat (QA-198 batch-10 re-run):** The same Space-dispatch pattern is FLAKY on the TWC Builder metric-tree leaves (`Select Channel Data` section). On the same page in the same session, IG Follower Growth Rate flipped to true; New Followers and Facebook New Fans flipped transient then reverted. Likely a per-leaf React-state race condition. Workaround for the metric tree: prefer `label.controlled-check-box__label.click()` first, then verify aria-checked; retry up to 3 times if revert detected. Or use the Filter Metrics input + Apply Stored Selections shortcut.
- **Revisit if:** Engineering swaps the widget for a real `<input>` (would simplify automation).

### Top-nav Brand picker "Recent Searches" routes to unrelated brand variants

- **First observed:** 2026-05-27 (QA-90213)
- **Behavior:** The global top-nav search (magnifying-glass icon, top right) shows a "Recent Searches" list above live Results, similar to the TWC brand picker. Clicking a Recent Searches entry like `MTV` does NOT load `MTV` (brand_id=4018) — it can route to a different variant (in this run it loaded `MTV (Argentina)`, brand_id=70901). The user must type into the search field to surface the live Results section and pick the exact-match entry from there.
- **Why accepted:** Consistent with the TWC brand picker quirk — Recent Searches is treated as a hint, not a stable selector. The first Results row after typing the exact name is the canonical entity.
- **Affected assertions:** Any test that uses the top-nav search to load a brand by name. Always type the brand name and click from Results, never from Recent Searches.
- **Revisit if:** Recent Searches stops re-routing to brand variants (would mean either the rename is fixed or Recent Searches is removed).

### Recharts donut tooltips/popups need trusted pointer events — RESOLVED 2026-06-02

- **First observed:** 2026-05-27 (QA-109920)
- **Resolved:** 2026-06-02 (QA-109920 batch-8 re-run). Sustained `computer.hover` over the donut segment center (e.g., the Positive arc of the Classification donut on Brand > Content > Sentiment) now renders the Recharts tooltip with the visible `Read` button. Clicking Read at its rendered coordinates opens the popup modal titled "Positive Classification: 50%" reliably. Retain this entry for historical reference; do NOT actively defer Recharts tooltip clicks on future runs.
- **Behavior (historical):** Hovering a Recharts donut segment is supposed to open a popup with a `Read` link. Chrome MCP's `hover` action and JS-dispatched `MouseEvent`/`PointerEvent` sequences flashed the Recharts tooltip momentarily but Recharts re-evaluated `isTooltipActive` each frame and dismissed the popup without sustained trusted pointer movement, making the Read link unreachable.
- **Caveat (NEW finding 2026-06-02):** After opening the popup via Read, the inner Sample Comments tile may fail to load with "This tile failed to load. Please try again." even after Reload retry. This is a separate, server-side fetch issue — NOT the Recharts hover quirk. CSV export path serves the same data successfully (6,160 rows for the APV Apr 1-7 2025 positive donut).
- **Affected assertions:** Any test that requires reading the in-popup Sample Comments content (such as QA-109920 A2 verifying the 2,000-message text). The popup opens correctly but its inner data load may fail. CSV export path is the canonical workaround for verifying the comment corpus.
- **Revisit if:** the Sample Comments tile starts loading reliably again (would unblock the A2 message-text verification), OR the popup gains a deterministic retry/timeout that surfaces the spec message.

### TWC date-picker `th.prev` / `th.next` arrows ignore screenshot-coord clicks

- **First observed:** 2026-05-27 (QA-129606 Wasserman TWC run)
- **Behavior:** The Bootstrap-style date picker on the TWC builder (and likely other Reporting pages) has `th.prev` (left arrow `«`) and `th.next` (right arrow `»`) header cells. Synthetic `computer:left_click` at the cell's screenshot center (or even at the verified `getBoundingClientRect()` center) does not reliably navigate the month — sometimes a single click of 7 (e.g., for 7 months back) advances the month by 1, sometimes by 0. The inner arrow span may absorb the click. Same issue for `.day` cells when the cell text matches multiple dates (e.g., "26" appears as the in-range Sep 26 AND the May 26 end selection AND the "old"-class out-of-month preview).
- **Why accepted:** Real users with hardware mouse pointers don't see this — it's automation-only friction. Underlying date picker JS works correctly when given the right click target.
- **Workaround:** Use JS `document.querySelectorAll('th.prev')[N].click()` (N=0 for start calendar, 1 for end calendar) for arrow nav. For `.day` cells, query by class + bounding rect: `Array.from(document.querySelectorAll('.day')).filter(d => d.textContent.trim() === '3' && !d.classList.contains('disabled') && !d.classList.contains('old') && !d.classList.contains('new'))`. Pick the one whose `getBoundingClientRect()` is on the correct side (left = start calendar, right = end).
- **Affected skills:** `time-window-comparison-run` v4, `data-studio-historical-limit`, `keydate-picker`. All should add the JS-fallback note.
- **Revisit if:** the date picker is rebuilt with native `<input type="date">` (would simplify) or Chrome MCP `computer:left_click` upgrades to dispatch deeper than the surface element.

### View toggle default position is `Public Data`

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** When a brand is added to a Reporting context via the "Add Brand By Name" picker, the per-brand `View:` toggle defaults to `Public Data` (left position, `checkbox.checked === false`).
- **Why accepted:** This is the intended default per product behavior; the test case wording "Hulu (Public Data)" was a descriptive note referring to this default toggle state, not a separate brand entity.
- **Affected assertions:** Skill `time-window-comparison-run` step 6 expects this default and only flips the toggle if a test case requires `Authorized Data`.
- **Revisit if:** Default changes to `Authorized Data` for any user/brand combination, OR if a separate "Hulu (Public Data)" brand entity is later created.

### Metric tree `li.leaf` nodes render lazily — invisible until filtered/scrolled
- **First observed:** 2026-05-27 (QA-1053 Hulu TWC run)
- **Behavior:** The Select Channel Data tree (TWC builder, possibly elsewhere) uses `<details>` + lazy DOM construction. `document.querySelectorAll('li.leaf')` initially returns ~36 nodes; many metrics including `Instagram Comments` are not present at all until the user either expands a `<details>` parent or types in the **Filter Metrics** input box at the top of the section.
- **Why accepted:** Performance optimization to avoid rendering the full ~261-metric tree on every page load.
- **Workaround:** When toggling a deep metric via JS, first set the Filter Metrics input to a substring of the metric name (e.g., `"Comments"`) via React-aware setter + `input` event dispatch, await ~700 ms, then locate `li.leaf[title='<exact name>']` and toggle. Clear the filter before selecting the next metric to avoid hiding it.
- **Affected skills:** `time-window-comparison-run`, `data-studio-post-level-run`, any other skill that toggles deep-tree metrics.
- **Revisit if:** the tree is rewritten to eagerly render all nodes, or the Filter Metrics input gains a programmatic API.

### TWC Bulk Select Key Date opens in Filter view, not Calendar view
- **First observed:** 2026-05-27 (QA-281 / QA-1053)
- **Behavior:** Clicking `Bulk Select Key Date` opens a modal whose default tab is **Filter** (TV Show / Film / Consumer Brand pickers), not **Calendar**. Most QA flows expect to enter an absolute date directly.
- **Why accepted:** Filter view supports TV-Show campaign keying which is the more common LFM analyst workflow.
- **Workaround:** Click the `View: Filter [toggle] Calendar` switch (coords near top of modal, just below the title) to flip to Calendar view before navigating month arrows. Confirm via `document.querySelector('.al-modal th.datepicker-switch')?.textContent` showing a month label.
- **Affected skills:** `keydate-picker`, `time-window-comparison-run` (Relative Dates path).
- **Revisit if:** product changes the default tab or unifies the picker.

### Radaac report Export returns TSV when CSV format requested — RESOLVED 2026-05-29

- **First observed:** 2026-05-27 (QA-51425)
- **Resolved:** 2026-05-29 (QA-51425 batch-3 re-run) — downloaded `20260601DuplicateBrandSocialPages_37a06f.csv` and verified the first row is genuine comma-separated (`brand id,brand name,title category,channel,url,perspective` — 6 columns, no tab characters). 14,987-line file. Cache regression appears fixed. Retain this entry for historical reference; do not actively guard against TSV on future Radaac CSV exports unless it recurs.
- **Behavior (historical):** On `radaac.lfmdev.in`, the **Duplicate Brands and Social Pages** report (and likely others) lets the user pick `Export → CSV`. Server-side download returns the correct filename (`*.csv`) and `Content-Disposition: attachment`, but the **payload was tab-separated**, not comma-separated. CSV parsers treated the file as a single column. Possible cause: server cache key keyed only by `report_id`, not `format`; an earlier TSV cache entry was served back for the CSV request. Re-issuing the request the next day still returned TSV.
- **Why accepted (historical):** Documented as a finding in the QA-51425 report and surfaced for product/eng triage. Not auto-reported as a bug until product confirmed it wasn't intended.
- **Affected assertions:** Any Radaac CSV export check should still sniff the first row for tab-vs-comma separators before asserting column parity (defense in depth).
- **Revisit if:** the bug regresses.

### Adam Orfei Brand Set returns ~76K posts; Chrome MCP render cycle strains on per-Rank-by switches

- **First observed:** 2026-05-29 (QA-132392, QA-132387)
- **Behavior:** `Adam's Brand Set` (brand_set_id=1738) returns ~76,780 posts on `Brand Sets > Content` with a `Last 30 Days` window. Each `Rank by Metric` switch triggers a full data re-fetch + tile rebuild that takes 8+ seconds. Chrome MCP's screenshot/wait cycle frequently times out before the tile finishes rendering, blocking the Sum/Avg row verification.
- **Why accepted:** Automation-only friction. Real users wait and see the row.
- **Workaround:** Pre-narrow the dataset before the verification sweep — either narrow to a shorter window (`Last 7 Days`) or apply a single-brand filter (e.g., Content Brand = `MTV`) before clicking Rank-by. Then expand for the final assertion if absolutely needed.
- **Affected skills:** any future Brand Sets > Content Sum/Avg verification (no dedicated skill yet — candidate for a future `brand-sets-content-rank-by` skill).
- **Revisit if:** Chrome MCP gains longer screenshot timeouts, or the platform serves Rank-by recomputes from cache.

### Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer

- **First observed:** 2026-05-29 (QA-96665 re-run, batch 2)
- **Behavior:** Navigating to `#explore/brand/insights` with `from`/`to` spanning 6 months on Adam Orfei dev (e.g., `from=2025-11-30&to=2026-05-30`) causes the Chrome MCP renderer to become unresponsive — every `javascript_exec`, `screenshot`, and `tabs_close_mcp` call times out after 45s. Creating a fresh tab and navigating to the same URL reproduces the hang. Recovery requires waiting ~30s+ and a fresh tab on a lighter URL.
- **2026-06-04 update (QA-51457 batch-4):** **Renderer hang now reproducing on shorter ranges too.** Last 5 / Last 7 Days windows on MTV (Authorized, 4 channels), Hulu (Public, IG-only), and Disney Channel (Public, 4 channels) all hang Brand>Insights. Pattern not limited to long ranges or to Hulu — heavy SVG/chart paint on Brand>Insights affects multiple brand/perspective combos. Recovery still requires `tabs_close_mcp` + `tabs_context_mcp(createIfEmpty:true)` + retry on a lighter brand or even shorter window. Sometimes a different brand still hangs on retry.
- **2026-06-04 update (QA-134188 batch-11 RECONFIRM):** Hang reproduced multiple times in one session across all Brand>Insights URL variants tried on MTV / Adam Orfei: 4-channel default + `from=2026-03-01&to=2026-05-31`, single-channel `channels=facebook` + same 3-month range, single-channel `channels=instagram` no-range, single-channel `channels=facebook` + `from=2026-05-01&to=2026-05-31` 1-month range. Brand>Audience / Brand>Content / Brand>Channels / Brand>Stories / Brand>Optimization / Brand Sets surfaces on the same MTV brand in the same session all rendered cleanly. Tory Burch Brand>Insights (`channels=instagram`) DID render cleanly. The hang is MTV-Brand>Insights-specific in this session window. Recovery via `tabs_close_mcp` + fresh tab + non-Insights surface succeeds. For QA-134188-family export tests: rely on prior on-disk evidence + CDP-reachable header text rather than retrying tile-paint when this hang reproduces.
- **2026-06-04 update (QA-134639 QA-4325 batch-12):** Hang broadened — Tory Burch IG Last 30 Days NOW hangs (previously stable in batch-11). Reproduced same session across MTV (`brand_id=4018`), Michael Kors (`brand_id=12597`), and Tory Burch (`brand_id=21648`) all with `channels=instagram` + `from=2026-05-01&to=2026-05-31`. CDP `Runtime.evaluate` 45s timeout each. Brand>Insights surface is widely unstable in this session window — not brand-specific. Recovery `tabs_close_mcp` + fresh tab still works but next brand likely hangs too. Defer Brand>Insights heavy-export tests (QA-134639, QA-134188, QA-114845) to LFIQA real-browser verification when 3+ brands fail in a row.
- **Why accepted:** Likely Chrome MCP + dev-environment performance interaction (large data-fetch + heavy SVG/chart paint stalls the renderer enough that CDP can't dispatch). Not a product defect for end users on real browsers.
- **Workaround:** Split the long-range verification into multiple shorter ranges or single-channel queries. For tests that specifically require 6/12 month range to verify a chart-rendering bug (e.g., LFMP-32027 Trends overlap), defer to manual LFIQA verification on real hardware browser.
- **Affected skills:** any flow that navigates to Brand Insights (brand-insights-interval-picker if extended, future Trends-graph tests).
- **Revisit if:** Chrome MCP gains longer CDP timeouts, or the dev-environment Brand Insights API caches queries faster.

### Brand > Stories chart-tile visualization persistently fails to load on MTV (NEW 2026-06-04)

- **First observed:** 2026-06-04 (QA-51442 batch-4)
- **Behavior:** On `#explore/brand/stories?brand_id=4018 (MTV)&perspective=extended&channels=instagram`, all 4 chart tiles at the top of the page (Engagements / Impressions / Taps Back / Exits) render in either "This tile failed to load. Please try again." error state or persistent skeleton-shimmer state across multiple date windows (May 27–Jun 2 range, May 15–20 range, May 29 single day). Clicking Reload on a failed tile re-enters skeleton then never resolves. The Sum/Avg row below the tiles + the Stories data table both populate correctly with real numbers (Sum Impressions = 121,106–199,265 across windows), so the underlying data IS available — only the chart-tile fetch / render path is broken.
- **Affordance check:** The per-tile `Bar | Export | Save to Dashboard` row at the bottom of each tile IS present and the Export dropdown opens cleanly with `PNG / CSV / Google Sheets / Metrics`. But clicking PNG on a failed/skeleton tile produces no download (no chart canvas to serialize).
- **Why noted as quirk + bug:** Documents the upstream blocker for any Brand > Stories tile-PNG-export test (QA-51442 and siblings). The fix is product/eng-side (chart-tile fetch endpoint), not workaround-able from automation. Should be filed as LFMP-* if not already tracked.
- **Affected assertions:** QA-51442 and any sibling Brand>Stories tile-level export tests. Mark PARTIAL with the carry-forward finding rather than retrying repeatedly.
- **Revisit if:** Brand > Stories chart tiles render reliably for a brand+window combination — would unblock the PNG-export verification path.

### Reporting > Content Performance + Data Studio Tag Filters lack Include/Exclude (vs Brand > Content)

- **First observed:** 2026-05-29 (QA-134516 batch 4); reconfirmed for Reporting > Data Studio 2026-06-04 (QA-134517 QA-4325 batch 12)
- **Behavior:** The Tag Filter sub-popup on `app-reporting.lfmdev.in/#/content_performance` AND on `#explore/reporting/data_studio` shows only `Or | And` operator radios plus tag-value checkboxes. There is NO Include section and NO Exclude section. By contrast, the Brand > Content / Brand > Optimization / Brand Sets > Content Tag Filter shows Include/Exclude radios + Or/And operator + tag-value checkboxes. This means "layered tag filtering" (Include + Exclude on the same query) is not possible on Reporting surfaces today. APPS-59381 scope appears to NOT include Reporting/CPR/DS.
- **DOM evidence (Data Studio 2026-06-04 QA-134517):** `.filter__options-container` children = [`text-input-wrapper`, `header-configs`, `filter__options`, `footer-config`]; `.header-configs` labels = `['Or', 'And']` only; widget class is `tag-filter-dropdown` + `tag-filter-popover` (LEGACY); distinct from Brand>Content's `content-type-dropdown` + `option-row` pattern.
- **Why accepted (pending product triage):** Unclear whether Reporting surfaces are missing the feature or whether the spec assumes parity that was never built. Treat tests like QA-134516, QA-134517 as FAIL-with-finding rather than skill drift; don't keep retrying.
- **Affected assertions:** Any Reporting Tag Filter test that asks for Include + Exclude semantics (CPR, DS, future Reporting surfaces). Document the absence; defer to LFIQA/product to decide direction.
- **Revisit if:** CPR + DS Tag Filters gain Include/Exclude radios (then re-run QA-134516, QA-134517 in full), OR the specs are rewritten to reflect actual Reporting-surface behavior.

### Brand > Content backend rejects `OR` operator with empty tag value (`None`) — extended 2026-06-04 to "Or with sparse-match real tags also fails"

- **First observed:** 2026-05-29 (QA-134277 batch 4)
- **Behavior:** Filter URL `content_tags:[{operator:"or",values:[""],not:"false"}, …]` causes the posts table to fail to load with persistent "This table failed to load. Please try again." after Apply Filter + Reload click. Same filter with `operator:"and"` for the empty-value Include succeeds. The `values:[""]` shape encodes the "None" tag selection.
- **2026-06-04 extension (QA-134273 batch 11):** Same failure mode reproduces with `content_tags:[{operator:"or",values:[" jbkaxlx","+tag"],"not":"false"}]` (two real test tags) on MTV / IG / 2025 full-year window. The Sum/Avg row populates (so the metric aggregation path works) but the Posts table enters skeleton → "This table failed to load. Please try again." state, with Reload button. Switching to `operator:"and"` does NOT recover the table in this case (different from the None-tag case). Likely cause: zero matching posts in the OR set + a backend query path that doesn't gracefully return empty.
- **Why accepted:** Likely backend query construction issue — None-tag inclusion is meaningful (matches posts with no tags) but combining it with OR may produce an invalid SQL/clause server-side. The OR-with-sparse-real-tags case may share the same root or be a sibling. Flagged as a finding; awaiting backend triage.
- **Affected assertions:** Any Brand > Content test that toggles a None-tag Include from AND → OR (QA-134277 A3/A4 blocked); any test that asks for 4-combo numeric dataset compare on tags with low match counts (QA-134273 A4 NOT VERIFIED).
- **Revisit if:** the backend stops returning the table-failed-to-load state for this filter, OR the platform disables the AND→OR toggle when None is the only Include value (would be a clean UX fix).

### Brand > Content Export button disabled when Posts count is 0

- **First observed:** 2026-05-29 (QA-134277 batch 4)
- **Behavior:** When a Brand > Content filter returns zero matching posts (`Posts (0)`), the Export button in the top-right toolbar renders in a disabled/greyed state (non-actionable). Cannot trigger the queued CSV export to inspect what a 0-row CSV would contain.
- **Why accepted:** Likely intentional UX — no point exporting an empty dataset. Document so future tests don't false-fail looking for an export modal.
- **Affected assertions:** Any spec assertion that asks to verify CSV column structure under a 0-result filter (e.g., QA-134277 A6). Mark NOT VERIFIED rather than FAIL.
- **Revisit if:** Engineering enables export-of-empty-CSV (would unblock empty-state column verification), OR a different code path produces a CSV under 0-result conditions.

### Brand Sets > Content View toggle disabled at brand-set level; perspective derived from Rank-by metric group

- **First observed:** 2026-06-02 (QA-132392, QA-132387 batch-6 re-runs)
- **Behavior:** The `View: Public Data | Authorized Data` toggle on `app.lfmdev.in/#explore/competitive/content` (Brand Sets > Content) is DISABLED — `.toggle-switch-disabled` class set on the wrapper. Unlike Brand > Content where the toggle drives perspective, on Brand Sets > Content the perspective is implicitly derived from the Rank-by metric selection: choosing a metric from the dropdown's "Public Data" subsection sets `perspective=standard`, choosing one from "Authorized Data" sets `perspective=extended`. URL programmatic `rank_by_metric` changes also flip perspective accordingly.
- **Why accepted:** Product behavior — likely intentional because brand-sets aggregate across mixed Authorized/Unauthorized brands, so global view-toggle is ambiguous; the Rank-by metric-level Public/Authorized split is more precise.
- **Affected assertions:** Any Brand Sets > Content spec assertion that names "click View → Authorized Data" should be interpreted as "pick a metric from the Rank-by Authorized Data subsection" instead.
- **Revisit if:** Engineering re-enables the View toggle on Brand Sets > Content, or product clarifies the intended semantics.

### YouTube Audience data-freshness lag for recent default windows

- **First observed:** 2026-06-02 (QA-116113 batch-8 re-run)
- **Behavior:** Disney Channel → Brand > Audience → YouTube channel only with default window `from=2026-05-25&to=2026-05-31` renders ALL 5 tiles as "There is no data available. Please select a different brand, brand set, or date range." Same brand + same channel narrowed to an older window (`from=2025-05-01&to=2025-05-31`) populates every tile with real distributions (Gender 41/58/1, Age 13-17 7%, 18-24 19%, 25-34 27%, 35-44 29%, 45-54 12%, 55-64 4%, Demographics bar chart non-zero across all 7 age groups).
- **Why accepted (pending product triage):** This is the practical state of DATA-12043 (Code Review) as of 2026-06-02 — YouTube audience data is no longer a complete outage but a freshness/lag issue. Document so tests don't false-fail on "no data available" by accident.
- **Affected assertions:** Any YouTube Audience test that asks to verify tile values on a recent default range. Switch to a Q1-Q2 2025 window to obtain populated tiles for assertion purposes.
- **Revisit if:** Engineering closes DATA-12043 with a freshness-lag note, OR the recent default window starts returning data.

### CPR Builder numeric inputs (Visual Top/Bottom Posts, Additional Top/Bottom Post Table Rows) — RESOLVED 2026-06-02

- **First observed:** 2026-05-27 (QA-3630 BLOCKED on React-controlled numeric input revert)
- **Resolved:** 2026-06-02 (QA-3630 batch-11 re-run). The `triple_click + type + Tab` sequence successfully commits values in CPR builder numeric inputs. Setting Visual Top Posts = 5, Additional Top Post Table Rows = 5, Visual Bottom Posts = 5, Additional Bottom Post Table Rows = 5 all persisted through Run Report.
- **Behavior (historical):** The four CPR Builder numeric inputs are React-controlled. Plain `value` mutation + `input` event dispatch via the React `Object.getOwnPropertyDescriptor(...).set` setter does NOT persist; React's internal state immediately reverts to 0. Synthetic clicks fail similarly.
- **Why accepted:** Pattern matches the `controlled-check-box` quirk philosophy — automation-only friction. Real-mouse + real-keyboard users have no issue.
- **Workaround:** Use the Chrome MCP `computer.triple_click` to select existing content, then `computer.type` to enter the new value, then `computer.key Tab` to blur (which commits the value in the React state). For inputs not visible in viewport, use `find` to get an element ref then `scroll_to` + `left_click ref` + `key Backspace ×N` + `type` + `key Tab`.
- **Affected skills:** Future `cpr-report-run` skill (not yet authored).
- **Revisit if:** Engineering migrates the inputs to native `<input>` patterns or React Hook Form with proper synthetic event support.

### CPR Preview & Share Report — Least Engaging headings collapse to 0x0 (LFMP-32010 OPEN)

- **First observed:** 2026-06-02 (QA-3630 batch-11 re-run — DOM bounding-rect probe)
- **Behavior:** In Preview & Share Report mode, all per-channel `Least Engaging Content` heading `<h*>` elements render with `getBoundingClientRect()` width=0, height=0 — invisible to users — despite computed `display: inline-block` and `visibility: visible`. The same headings render normally at 250x20 in the regular Story view. Tracked as LFMP-32010 (Bug, Major, Open).
- **Why noted as quirk:** So future CPR tests don't false-fail by counting visible Least Engaging headings in Preview mode; the headings ARE in DOM but invisible.
- **Affected assertions:** Any CPR test that verifies Preview & Share Report has a Least Engaging section heading visible. Use DOM bounding-rect inspection rather than `innerText.includes()` to verify the bug.
- **Revisit if:** LFMP-32010 closed by engineering — Least Engaging headings render normally in Preview mode.

### Custom Metrics page — spec/UI copy drift in three places

- **First observed:** 2026-05-29 (QA-85176, QA-134173, QA-134185)
- **Behavior:** Settings > Custom Metrics has three known copy-drift items between current spec and current UI build:
  1. **Formula dropdown** — spec writes `Constants` (plural); UI renders `Constant` (singular).
  2. **Info-mode tooltip header on list page** — column header `Created Date`; corresponding tooltip header `Date Created` (word order swapped).
  3. **Create screen** — spec references a `Metric Definition Link` element to be hovered for tooltip; current build of `#custom-metrics/create` has only Name, Description, Formula (no link element).
- **Why accepted:** None of the three are functional defects; all three are documentation/spec ↔ UI sync issues worth filing as minor tickets but not blocking test PASS.
- **Affected assertions:** Tests that assert exact strings on the Custom Metrics flow should normalize to the UI strings, not the spec strings. Tests that step through "hover Metric Definition Link" should mark that assertion N/A.
- **Revisit if:** Product confirms one canonical wording for each of the three, or restores the Metric Definition Link element to the Create screen.

### Pinterest embed iframe tooltip can render blank for unavailable pins

- **First observed:** 2026-05-27 (QA-929 batch — Sephora Pinterest row 3); reconfirmed 2026-06-02 (QA-929 batch-12 — same row 3 and now row 4)
- **Behavior:** Hovering the Pinterest row's Type column link in Brand>Content Table View opens an embedded Pinterest pin tooltip with X close button. For rows whose Pinterest pin URL renders successfully on Pinterest's CDN, the tooltip shows the post image + caption + "Published By <Brand>" byline (working as designed). For some rows the iframe stays BLANK (white frame with X only) even after 14+ seconds — the pin URL is well-formed but the Pinterest embed widget fails to render content (likely the pin is deleted, restricted, or redirect-broken on Pinterest's side).
- **Why accepted:** This is external to LFM. LFM correctly passes the canonical Pinterest pin URL; Pinterest's embed-widget renders or fails to render based on its own pin-availability rules.
- **Affected assertions:** Any QA-929-style assertion that requires "image + text match the tooltip content" can only be verified for rows where the embed loads. Mark blank-tooltip rows as PARTIAL with reproduction details.
- **Recommended product action:** Brand>Content embedded tooltip should render a graceful "Pinterest pin unavailable" placeholder if the iframe is still empty after N seconds (suggest 5-10s).
- **Revisit if:** Brand>Content adds the placeholder, or Pinterest's pin-render policy changes.

### Data Studio Post Level ↔ Brand>Content parity has residual freshness drift

- **First observed:** 2026-06-02 (QA-90213 batch-12 re-run; significant change from 2026-05-27 batch where mismatch was 3.84×/2.19×)
- **Behavior:** When testing parity between Data Studio Post Level Aggregate Twitter Post Likes Sum vs Brand>Content Reactions Sum (and Twitter Post Replies Sum vs Comments Sum) for the same brand, perspective, channel, and date range, the values are typically within ~1-1.5% of each other rather than strictly equal. Previously (2026-05-27) this discrepancy was 3-4×; since then a fix likely landed.
- **Why noted:** Tests that assert strict numeric equality on this parity will technically FAIL with sub-1.5% diff. Practical interpretation: parity is achieved within freshness/snapshot tolerance. SME guidance needed on whether spec wants strict equality or tolerance-bounded equivalence.
- **Affected assertions:** QA-90213-style strict-equality parity assertions. Future similar tests should capture both pages within the same N-second window to remove freshness from the equation.
- **Revisit if:** SME confirms strict equality is required (file LFMP-31782b for residual) or sets a documented tolerance window in spec.

### Brand > Content `table_data_set` URL param doesn't always stick

- **First observed:** 2026-06-02 (QA-929 batch-12)
- **Behavior:** Navigating directly to `/#explore/brand/content?...&table_data_set=pinterest_only_basic&...` results in the URL being rewritten to `table_data_set=public` after page load, regardless of how the param was URL-encoded. The dataset must be explicitly selected via the Data Set dropdown (clicking the option labeled `Pinterest Only: Basic`) after the page renders.
- **Why accepted:** Workaround is trivial (dropdown click); doesn't block the test.
- **Affected assertions:** Any test that requires a non-default Brand > Content data set must include an explicit dropdown selection step rather than relying solely on URL params.
- **Revisit if:** Direct-URL navigation honors `table_data_set` consistently.

### Twitter Brand>Content In Window Video Views tile skeleton-hang (45+ seconds, no error)

- **First observed:** 2026-06-04 (QA-581 batch-3)
- **Behavior:** On Brand>Content with Twitter-only channel + In Window mode + Authorized View on Hulu (brand_id=5670), switching the Data Set from "Impressions" to "Video Views" leaves the Posts tile in a persistent skeleton-shimmer state for 45+ seconds. No "This table failed to load. Please try again." error appears (unlike the IG render-lifecycle pattern), no Reload button surfaces, and clicking Apply on the channel row does not re-trigger the fetch. The same channel + range with Impressions data set populates Posts(6) successfully.
- **Why noted:** Distinct from the IG render-lifecycle hiccup (which surfaces an explicit "failed to load" + Reload button). The Twitter Video Views path appears to enter an indefinite loading state. Possible causes: zero eligible video posts in the 3-day window OR backend slow-path / timeout for Twitter video metrics that doesn't surface an error to the UI.
- **Affected assertions:** Any Brand>Content Twitter Video Views In Window verification on tight date windows. Document and ask LFIQA to verify in real browser; deferring to "did not load" rather than filing as a defect.
- **Revisit if:** the tile starts surfacing a "failed to load" error + Reload (would unify with the IG pattern), OR Video Views Twitter populates reliably in a tighter timeframe.

### Brand Insights tile-level PNG export absent on modern Trends-consolidated tile

- **First observed:** 2026-06-04 (QA-10387 batch-3)
- **Behavior:** The current Brand Insights build consolidates Impressions, Video Views, Engagement Rate, etc. into a single Trends tile with Bar Chart + Line Chart selector dropdowns. This Trends tile has NO kebab / Export / Download / PNG affordance — neither in the visible UI nor in the DOM (`[title*="Export"]`, `[aria-label*="export"]`, kebab class all return zero matches inside the tile container).
- **Why noted:** The QA-10387 spec (and likely sibling Brand>Insights tile-level export specs) predates the Trends-consolidation redesign. Tests that ask for "Brand Insights - Impression Chart PNG" or "Video Views Chart PNG" tile-level export are no longer reproducible via the current UI.
- **Affected assertions:** QA-10387 and any similar Brand>Insights tile-PNG-export test. Mark BLOCKED with spec-drift finding. Do NOT retry on alternate brands.
- **Revisit if:** Engineering restores tile-level PNG export, OR product clarifies that PNG export was intentionally consolidated to a page-level affordance elsewhere.

### Radaac jQuery UI dialog Submit click is JS-resistant — workaround: direct URL nav

- **First observed:** 2026-06-04 (QA-54202 + QA-52778 batch-5)
- **Behavior:** Modals opened from `radaac.lfmdev.in/` (e.g., Brand Listing (not full definition), Brand Definitions (Fetch)) wrap a vanilla `<form action="/<endpoint>" method="GET">` inside a jQuery UI dialog. The Submit `<input type="submit">` accepts coordinate clicks and JS `.click()` events without throwing, but the click does NOT navigate the page — the dialog stays open. `form.submit()` also fails to navigate. Real users with a hardware mouse click and the form submits normally (verified during initial QA-51425 batch).
- **Why accepted:** Automation-only friction; likely jQuery UI event-delegation race vs. CDP click dispatch.
- **Workaround:** Build a direct URL with the form's action endpoint + form-encoded GET params (e.g., `radaac.lfmdev.in/brand_listing?account_name=&category=Automotive&company_ids=&brand_set_ids=&brand_ids=` or `radaac.lfmdev.in/brand_definition_report?brand_ids=236&include_url_mgrs=on`) and `navigate()` directly. Backend response is identical to a real Submit click.
- **Affected skills:** Future `radaac-report-runner` skill (not yet authored) should default to URL-nav-after-DOM-state-set rather than relying on the Submit input.
- **Revisit if:** the Submit input becomes responsive to programmatic click (unlikely without re-engineering the dialog).

### Brand > Paid Michael Kors tile-fetch + Export queue degradation (NEW 2026-06-04)

- **First observed:** 2026-06-04 (QA-83928 batch-5, Adam Orfei dev)
- **Behavior:** `app.lfmdev.in/#explore/brand/paid?brand_id=3801&account_id=54&channels=facebook` (Michael Kors) renders all 12 default tiles in "This tile failed to load. Please try again." error state, both top-row (Active Ads / Paid Impressions / Spend / Clicks / Paid Actions / 95% Completed Video Views) and lower secondary tiles. Reload retries do not resolve. The Export → Select Data Sets modal opens and accepts data-set selection, but clicking Ok submits a request that leaves the Export button in a continuous spinner state (35+ seconds) without surfacing an error toast or a "failed export" notification. The fresh export-ready notification never arrives in Recent Activity.
- **Why noted:** Distinct from the IG render-lifecycle hiccup (which surfaces an explicit "failed to load" + Reload button that eventually resolves) and the Twitter Video Views skeleton-hang (which is per-tile). This is a full-page Paid endpoint degradation that affects all tiles AND the queued-export path simultaneously.
- **Affected assertions:** Any Brand>Paid Michael Kors test that requires tile values, post-table values, or a successfully-completed CSV/GSheets export within the test window. Mark BLOCKED / PARTIAL.
- **Revisit if:** the Paid endpoint stabilizes for Michael Kors (or any single-brand Paid test brand) AND the Export queue surfaces a notification within a reasonable timeout (e.g., 60s).

### Hulu Brand>Content not reachable from Adam Orfei account via URL nav (NEW 2026-06-04)

- **First observed:** 2026-06-04 (QA-84193 / QA-84194 batch 6)
- **Behavior:** Direct URL navigation to `#explore/brand/content?brand_id=5670&account_id=54&...` (Hulu under Adam Orfei) redirects to `/#home?account_id=54` immediately on page load. Same URL with `account_id=63` also redirects. Hulu Brand>Content appears to require a different account session (likely a Hulu-owned account). Hulu DS Post Level (Reporting → Data Studio) DOES work for Hulu under Adam Orfei context — so the gating is page-specific (Brand>Content surface only), not account-blanket.
- **Why noted:** Affects any parity test (DS↔BC, e.g. QA-84193/84194) that names Hulu when running on Adam Orfei. The DS half captures cleanly; the BC half can't be verified without switching to a Hulu-owned account.
- **Affected assertions:** QA-84193/QA-84194 BC source-2 verification. Mark NOT VERIFIED on cross-source delta and document the carry-forward.
- **Workaround:** Pre-pick a brand co-located on both DS and BC for the active account (e.g., MTV for Adam Orfei), or run the parity test under a different account login (would require user-account-switcher use).
- **Revisit if:** Adam Orfei gains Hulu Brand>Content ACL, or the parity spec is rewritten to recommend a same-account brand.

### Admin page (admin.lfmdev.in) gated by Cognito sign-in challenge

- **First observed:** 2026-06-04 (QA-113595 / QA-113722 batch-9)
- **Behavior:** Clicking the key-icon → Admin menu item on `app.lfmdev.in` redirects to `auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=https%3A%2F%2Fadmin.lfmdev.in%2Foauth%2Fcognito_callback`. The sign-in page asks for corporate email + password OR Google/Facebook social OR existing-account email+password. The main `app.lfmdev.in` Yash session does NOT auto-pass through; Admin is a separate identity boundary.
- **Why accepted:** Admin tools are gated separately from the main app session by intentional security policy.
- **Affected assertions:** Any QA test that asks to enter Admin and perform CMS-level mutations (brand title edit, user creation, etc.). Assistant cannot enter passwords per safety policy. Mark BLOCKED with finding.
- **Affected tests:** QA-113595 (Settings > Audit + Admin Brand Edit), QA-113722 (Admin User Creation), and likely any other tests that touch Admin / Accounts → Users flows.
- **Workaround:** LFIQA executes manually and confirms the audit-row generation. Long-term, magpie could gain a documented Admin-auth flow if SSO becomes feasible.
- **Revisit if:** Admin gains a session-pass-through from the main app, OR safety policy allows password entry for the test environment.

### Brand>Insights multi-channel renderer freeze (reconfirmed on Michael Kors 2026-06-04)

- **First observed:** 2026-05-29 (QA-96665 batch 2). Re-confirmed on Michael Kors (Adam Orfei) 2026-06-04 (QA-114845 batch-9).
- **Behavior:** Navigating to `#explore/brand/insights?brand_id=12597` (Michael Kors on Adam Orfei) with all 4 default channels (twitter+instagram+facebook+tiktok) hangs the renderer mid-tile-paint after a few interactive clicks (e.g., Export dropdown click on the Total Followers tile). Recovery requires `tabs_close_mcp` + fresh tab. Restricting to a single-channel URL (`channels=instagram`) renders cleanly and stays responsive.
- **Affected skills:** `chart-hover-tooltip`, `audience-metrics-export`, `brand-insights-interval-picker`.
- **Workaround:** When testing Brand>Insights tile-level interactions (hover, Export), narrow to a single channel via URL param before any tile-mutating click.
- **Revisit if:** Brand>Insights stabilizes on multi-channel, OR Chrome MCP CDP timeouts extend.

### Wasserman-account-only TWC tests require account-session switch outside Adam Orfei

- **First observed:** 2026-06-04 (QA-129608 batch-9)
- **Behavior:** TWC tests that name `FIA World Endurance Championship (FIAWEC)` (and likely other Wasserman-exclusive brands) require Wasserman account context. On Adam Orfei (account_id=54), the TWC brand-picker typeahead does not surface FIAWEC even with substring search "FIA" (returns 90 Day Fiance variants instead). Per Rule 1, no substitute. Account switch requires re-authentication via Cognito — same blocker as Admin auth.
- **Affected tests:** QA-129608 (cross-channel Aggregate RR), QA-129606 / QA-129803 (Twitter+TikTok / Facebook daily variants — previously executed under Wasserman by LFIQA, then re-verified by magpie on a Wasserman session if available).
- **Workaround:** LFIQA runs Wasserman-only tests directly; magpie skips them on Adam Orfei batches.
- **Revisit if:** magpie gains an account-session switcher skill (similar to brand-picker switching but at account level), OR the spec allows a non-Wasserman brand substitution for the math-verifier flow.

### Brand > Content channel URL param merging on hash route

- **First observed:** 2026-06-02 (QA-90213 batch-12)
- **Behavior:** Setting `?channels=twitter` directly in the URL on the Brand>Content page sometimes results in the URL being expanded to include all six previously-selected default channels (`channels=twitter&channels=instagram&channels=facebook&channels=linkedin&channels=tiktok&channels=threads`). To force a Twitter-only filter, navigate with only `channels=twitter` in the URL AND verify post-load via `.channel-ghost.enabled` DOM check that only twitter is the active channel. If multiple channels show enabled, the URL must be re-set with only the intended channel.
- **Why accepted:** Re-navigating with the param works reliably.
- **Affected assertions:** Channel-isolated parity tests (Twitter-only, IG-only, etc.). Verify channel filter via DOM, not just URL.
- **Revisit if:** Hash router stops merging session-state channel picks.

### Brand Sets > Content `filters` URL param persists across navigation; only Clear-All button clears it (NEW 2026-06-04)

- **First observed:** 2026-06-04 (QA-133403 batch-10)
- **Behavior:** Once a Content Brand filter has been applied on `#explore/competitive/content` (Brand Sets > Content), navigating to a different URL (even one without `filters=` or with `filters=%7B%7D`) re-applies the prior filter to the page state. The URL is rewritten by the page to re-add the saved filter on every load. The only way to clear the filter is to click the **Clear All** button in the filter toolbar.
- **Why accepted:** Workaround is trivial (Clear All click).
- **Affected assertions:** Any Brand Sets > Content cross-test that mixes filter-on vs filter-off states. Magpie tests should ALWAYS invoke Clear All explicitly when transitioning to a filter-off state.
- **Revisit if:** URL re-write stops re-applying the saved filter, or `filters=%7B%7D` becomes authoritative.

### Chrome MCP click-coordinate space flip-flops between 1:1 CSS and 1.225× mid-session (NEW 2026-06-11)

- **First observed:** 2026-06-11 (batch-3, multiple cases)
- **Behavior:** Within one session the click/hover coordinate space alternates between equal-to-CSS (screenshot 1280×570) and 1.225×CSS (screenshot 1568×698/767), apparently when the window/zoom state changes. Clicks computed with the wrong factor land ~18% off and silently no-op (e.g., Apply buttons toggling the wrong channel ghost).
- **Why accepted:** MCP/browser scaling behavior, not a product bug.
- **Workaround:** Before every coordinate click, derive the factor from the latest screenshot width (`1280 → 1.0`, `1568 → 1.225`); recompute element rects fresh after any scroll/expand. Also: clicks at coordinates below the viewport bottom silently no-op — scroll the target into view first.
- **Revisit if:** Chrome MCP normalizes the coordinate space.

### Reporting datepickers have a hidden duplicate instance in DOM (NEW 2026-06-11)

- **First observed:** 2026-06-11 (QA-83835 Data Studio, then TWC builder)
- **Behavior:** TWO `.from-calendar`/`.to-calendar`/`.datepicker-days` instances exist; only one is visible. Synthetic events on the hidden one appear to work (headers change when queried via `querySelector`, which returns the hidden first instance) but the real picker is untouched — the report then runs on the default range, mimicking a "custom range ignored" product bug.
- **Workaround:** always filter pickers by `offsetParent` before reading or clicking; prefer real coordinate clicks on the visible calendar.
- **Affected skills:** `time-window-comparison-run`, `data-studio-historical-limit`, `keydate-picker`.
- **Revisit if:** the duplicate instance is removed.

### Trash/remove icons are BUTTONs — events on the inner `<i>` no-op (NEW 2026-06-11)

- **First observed:** 2026-06-11 (QA-80360/83835 Data Studio brand+metric rows)
- **Behavior:** Row-removal trash controls render as `<button class="fas fa-trash button--unset …"><i…/></button>`. Dispatching mouse events on the inner icon (the element usually matched by `i[class*=trash]`) does nothing; dispatching the same events on the BUTTON works.
- **Workaround:** query `button[class*=fa-trash]` (or closest('button')) before dispatching.
- **Affected skills:** `data-studio-post-level-run`, `data-studio-multi-perspective`, any builder row-removal flow.

### Dropdown togglers need full mousedown/mouseup/click dispatch (NEW 2026-06-11)

- **First observed:** 2026-06-11 (QA-85175 Save to Dashboard, top-nav Dashboards, Options menu)
- **Behavior:** `.dropdown-name`-style togglers ignore bare `.click()` and are flaky with plain coordinate clicks; a full synthetic `mousedown → mouseup → click` MouseEvent sequence opens them reliably. Dropdown option lists (`.selector-dropdown`) exist as ~30 empty DOM instances; only the open one has rows.
- **Affected skills:** `dashboard-mutation-flows`, any Save-to-Dashboard or Options-menu flow.

### Brand > Paid: carried-over from/to without compare params → "Invalid date" + all tiles fail (NEW 2026-06-11)

- **First observed:** 2026-06-11 (QA-121438, APV)
- **Behavior:** Navigating `#explore/brand/paid` with `from/to` but no `compare_from/compare_to` renders "Compared to: Invalid date - Invalid date" and every tile shows "This tile failed to load"; reload does not recover. With full params the page works.
- **Why noted:** Bug-ish (graceful default expected) — worth a ticket; meanwhile always pass compare params.
- **Affected skills:** `brand-paid-ads-table`.

### Wasserman reachable via normal account switcher (SUPERSEDES 2026-06-04 entry)

- **Observed:** 2026-06-11 (QA-129801/802/673)
- **Behavior:** LFQA menu → Search Account → "Wasserman" switches cleanly, no Cognito re-auth. The 2026-06-04 blocker ("Wasserman-only TWC tests require account-session switch outside Adam Orfei") was about FIAWEC not being visible under Adam Orfei — solved by switching accounts, which works normally.
- **Action:** Wasserman TWC trio (QA-129801/129802/129673) is fully automatable; QA-129608 also unblocked for a future run.

### Brand>Insights renderer hang NOT reproduced on 2026-06-11

- HBO Max (Threads, Sep 2025 month window), Sony Pictures Spider-Verse, Hulu (May 2024 + FGR tiles), FX public year-range Content all rendered cleanly in one session. Keep the 2026-06-04 quirk entry but treat the hang as intermittent/env-load-dependent rather than permanent.
