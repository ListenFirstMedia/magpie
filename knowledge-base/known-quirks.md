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

### Playwright MCP track (feature/playwright-mcp) — newest first

_Findings from headless Playwright MCP regression runs against `app.lfmdev.in`. Many supersede Chrome-MCP-era quirks below._

### 2026-07-02 — Brand>Stories date picker is TWO independent calendars (interactive headed, QA-68691)

- **First observed:** 2026-07-02 (QA-68691, Brand>Stories, Michael Kors).
- **Behavior:** the Date Range popup renders **two separate calendars — "Start Date" (sets `from`) and "End Date" (sets `to`)**, each navigated independently (month-header → month grid → prev/next-year arrow → month → day). To set a range you click the from-day in the Start calendar, then navigate the **End calendar separately** and click the to-day, then **Ok**.
- **Gotcha:** clicking a *second* day in the **Start** calendar RESETS the from-date (it does not become the range end). On QA-68691 this produced `from=2025-01-04&to=2025-12-31` instead of Jan 1–4. Fix: set the End calendar separately; **verify `range-start`/`range-end` day classes before clicking Ok**.
- **Why accepted / how to apply:** it's a functional two-calendar widget, not a bug — just drive both calendars. Applies to the [[brand-stories-export]] skill (and likely other Stories/date-range surfaces).

### 2026-07-02 — switch-account under headed Playwright: hover + `.lfm-ta-option`

- The **LFQA profile menu opens on HOVER**, not click — clicking it toggles it shut (two clicks = closed). Hover to open.
- The **Search Account** input (`input.account-typeahead-input`) reports "not visible" to Playwright `.fill()`; set its value via the React setter + `input` event instead.
- The clickable **Results** row is the **`.lfm-ta-option`** element — clicking the `.account-name` leaf or the `.typeahead-options-list` container does NOT trigger the switch.
- Applies to [[switch-account]]; verified 2026-07-02 (Viacom → Michael Kors).

### 2026-07-01 — QA-130076 lost-authorization notification absent on Viacom → BLOCKED (test-data drift, not a bug)

- **First observed:** 2026-07-01 (QA-130076 "Settings > Notifications - Improve Lost Authorization Messaging", Viacom account_id=181). Was a **PASS on 2026-06-13** (QA-4325 batch) which captured the format `"We lost data collection on the '<Feed> (Authorized|Public)' feed for the '<Brand>' brand. Please click to troubleshoot."` + NOT COLLECTING badge.
- **Behavior:** On Viacom today, Settings → Notifications has **29** notifications, all Content/Sentiment/Paid **Export "…is now ready"** + **"Fetch job … completed successfully"** (brand MTV) — **none** are lost-authorization. The **Status** filter (`All` / `Not Collecting` / `Onboarding` / `Collecting`; "Not Collecting" == spec NOT COLLECTING) returns **Notifications (0)** with Read=All. So A1–A4 have no message instance to review/assert on.
- **Precondition Note 1 (Subscriptions → Data Collection toggle):** was **OFF**; enabling it (one-time config) governs **future** delivery only and does **not** backfill historical lost-auth events, so the table stays empty. The lost-auth notification is generated at the time a feed actually loses authorization.
- **Why accepted / not a bug:** The Notifications feature, the Not-Collecting status filter, and the Data Collection subscription control all work. A1–A4 are **Not Evaluable (BLOCKED)** — test-data gap (no Viacom feed is currently in a lost-auth state that produced a notification). Do **NOT** substitute another account/notification (QA-91412 false-positive pattern, Rule 1/3/5). Same shape as the 2026-06-29 QA-2498 A6–A8 "feed became fully collecting → BLOCKED".
- **Affected assertions:** QA-130076 A1–A4 and any lost-authorization / NOT COLLECTING notification-content case. Needs LFIQA/product to provision a lost-auth feed on Viacom (or name the specific account/feed that carries one).
- **Revisit if:** a Viacom feed loses authorization and generates a Not-Collecting notification, or the spec is retargeted to an account with a live lost-auth notification (A1–A4 test wording/format and are otherwise data-independent).

### 2026-06-30 — QA-27854 Bulk Import Tags Notification now PASSes (precondition met) + Gmail-MCP email-template verification pattern

- **First observed:** 2026-06-30 (QA-27854 "Bulk Import Tags Notification", Adam Orfei acct 54)
- **Behavior / state change:** The QA-27290 bulk-tag upload artifact now **exists** on Adam Orfei — an **Import Tags** notification (`"LF_Upload_Tags.csv" has been successfully uploaded. For details, please download detail log.`, Jun 30 2026 05:09 am) is present in both the **bell dropdown** (Recent Activity) and the **Settings → Notifications table**. This unblocks A1/A2, which were BLOCKED on the 2026-06-28 and 2026-06-29 unattended runs (no upload artifact then). Verdict: **PASS 4/4**.
- **Notifications page structure:** Settings → Notifications (`#notifications`) renders a real `<table>` with columns **[unread-icon] | Date | Message | New Status**. The Import Tags row's **New Status cell is blank** (matches A2). The bell dropdown uses `.notification-card` (`.status`=type label, `.date`, `.text` with `<a>download detail log</a>`, `left-group <i>` = empty/blank New-Status icon). The card's "download detail log" / table message link is an `<a>` with no `href` (JS handler) — still a rendered hyperlink.
- **A1 date-format variance (not a bug):** spec writes subheader format `MMM DD.HH:MM AM/PM`; platform renders `MMM DD, YYYY hh:mm am/pm` for every notification card. Illustrative spec string, not a defect.
- **Email A3/A4 verification via Gmail MCP (reusable pattern):** the in-browser "open mail in a new tab" step is a Google-auth surface (out of scope, like Google Sheets — never open gmail.com/docs.google.com). Verify the email **templates** through the **Gmail MCP** instead (`search_threads` + `get_thread` FULL_CONTENT). Both LFM bulk-tagging templates match the spec verbatim (genuine `no-reply@listenfirstmedia.com` emails, detail-log S3 path scoped to `…/bulk_tagging_job/54/…` = Adam Orfei):
  - **A3 success** — subject "ListenFirst Bulk Tagging Complete!": `Hi <User>, You're all set! The tags you uploaded with "<file>.csv" at <t1> have successfully been uploaded at <t2>. <N> tags were successfully uploaded.` + Download Detail Log button.
  - **A4 failure** — subject "ListenFirst Bulk Tagging Error": `Hi <User>, So close! Looks like there was something funky happening with the "<file>.csv" bulk upload. <N> tags were successfully uploaded, and <M> tags failed to upload. Check out where the job went wrong by downloading Detail Log in this email or in Notifications.` (Notifications → `#notifications`). The LF sample-template CSV always yields **6 ok / 2 failed** → always the failure email.
- **Mailbox caveat (Rule 6):** the available Gmail MCP is authenticated to the **operator** mailbox (yash.sharma@listenfirstmedia.com), while the email for a given upload is delivered to the **uploader/app-login** mailbox (lfiqa@listenfirstmedia.com). So you can confirm the email **template/format** (spec A3/A4 are format assertions) but NOT the exact message for the specific run's upload. To verify end-to-end for the exact run, wire a Gmail MCP on the lfiqa mailbox.
- **Affected assertions:** Any notification/email test (bulk tags, exports, sentiment) — use the bell `.notification-card` + Settings>Notifications `<table>` for in-app, and the Gmail MCP for email templates (operator-mailbox caveat applies).
- **Revisit if:** the QA-27290 artifact ages out of Adam Orfei's notifications again (re-BLOCK A1/A2), or a Gmail MCP scoped to the lfiqa mailbox becomes available (then A3/A4 become exact-run verifiable).

### 2026-06-29 — TWC Share: spec recipient == config/.env login (lfiqa) → self-share, A2/A3/A4 NOT EVALUABLE (not a bug)

- **First observed:** 2026-06-29 (QA-24544 "TWC - Share Functionality", Michael Kors, Adam Orfei acct 54, TWC story 155282)
- **Behavior:** On the Playwright track, pre-flight logs in programmatically as the config/.env identity, which **is** `lfiqa@listenfirstmedia.com`. QA-24544's share recipient (step 8) is also `lfiqa@listenfirstmedia.com`, so the report **Creator** and the **recipient** are the same user. The Share Report modal therefore shows the Creator row only; typing the lfiqa email + Add returns **"You've already shared this with lfiqa@listenfirstmedia.com"** (no new People row), and the modal **Share** button stays `crud-modal-button ... inactive` (clicking is inert — modal stays open, no "You've successfully shared a report" toast). So **A2 (recipient row), A3 (Action="Remove"), A4 (success prompt) are NOT EVALUABLE** on this identity.
- **Why accepted / not a bug:** The self-share / duplicate-share guard is **correct product behavior**. Do NOT substitute a different recipient email to force A2/A3/A4 (QA-91412 false-positive pattern, Rule 1/5). The Chrome-MCP-era runs (2026-05-27/05-29) PASSED A2/A3/A4 only because their active SSO identity was `yash.sharma` (≠ lfiqa), making lfiqa a genuine second user — but they deferred A5 (password sign-in disallowed). This run inverts it: **A5 PASS** (all 15 steps executed end-to-end incl. sign-out→sign-in→re-nav; copied link `#story/155282` re-rendered the report), A2/A3/A4 blocked.
- **A5 caveat:** A5 passes literally (shared link renders post-auth) but does NOT prove cross-user access, since the viewer == creator.
- **Copied share link format:** `https://app-reporting.lfmdev.in/#story/<id>` (short form; redirects to `#story/time_window_comparison/<id>`). Capture via a `navigator.clipboard.writeText` hook before clicking Copy Link.
- **Affected assertions:** Any Share/collaboration case whose named recipient equals the config/.env login. To evaluate the add-recipient path, the spec recipient must differ from the logged-in user, OR run the creator side as a different identity with lfiqa as the external recipient.
- **Revisit if:** config/.env login changes to a non-lfiqa user, or the spec recipient is updated to a different email.

### 2026-06-29 — Settings>Data Collection: HBO Max Facebook channel is now fully collecting → QA-2498 A6–A8 BLOCKED (test-data drift, not a bug)

- **First observed:** 2026-06-29 (QA-2498 "Channels not collected", HBO Max account_id=657)
- **Behavior:** QA-2498 steps 6–8 target the **Facebook** channel's **red exclamation** (channel-level Not-Collecting popup → A6 scrollable items / A7 Learn More / A8 one Reauthorize). On HBO Max today, Facebook carries **no red exclamation** — all 6 Facebook feeds show ✓ Collecting. The brand's only non-collecting feeds (red badge count 4) are **Pinterest User (Authorized)**, **Threads Page & Audience (Authorized)**, **Threads Posts (Authorized)**, **TikTok Ads (Authorized)**. Channels with red `.status-badge.red` = Threads(2)/Pinterest(1)/TikTok(1); LinkedIn(2)/Twitter(1) are blue `.fa-plus-circle`.
- **Why accepted / not a bug:** When QA-2498 was authored (skill changelog 2026-05-20, "5 PASS") HBO Max Facebook had a non-collecting feed; it has since been (re)authorized. The Not-Collecting popup feature works (verified on brand-level red ! → "Not Collecting (4)"). Per Rule 1/3/5, A6–A8 are **Not Evaluable (BLOCKED)**; do **NOT** substitute Threads/Pinterest/TikTok to force a pass (QA-91412 false-positive pattern). Rest of QA-2498 passes (A1–A5/A9/A11) with the long-documented A3/A4/A10/A12 spec-vs-UI variances (Reauthorize count = 1/item; page summary cols Data Feed/Start Date/Last Collection Date/Status — no "Posts Tracked").
- **Affected assertions:** QA-2498 A6/A7/A8 + step-8 red-exclamation trigger. Any Data-Collection case naming a specific channel that has since become fully collecting.
- **Revisit if:** HBO Max Facebook loses a feed again, or the spec is retargeted to a channel that currently has a non-collecting feed (Threads/Pinterest/TikTok).

### 2026-06-29 — Fixed historical date ranges in old specs roll out of the ~3-year data-retention window → BLOCKED (test-data drift, not a bug)

- **First observed:** 2026-06-29 (QA-929 "Pinterest Content - Embedded Post Tooltip", Sephora brand_id=7159 / account 655, spec date range **Jun 21–22, 2023**)
- **Behavior:** The Brand>Content date picker advertises **"Historical data is available back to Jun. 28, 2023"** and renders every June-2023 day from the 1st–27th as `disabled day` (cursor `default`, unselectable); only Jun 28/29/30 are selectable. The data floor is a **rolling ~3-year window** (run date 2026-06-29 → floor ~Jun 28, 2023). The spec's fixed Jun 21–22, 2023 range predates the floor by ~6 days, so it cannot be selected and the spec window returns **Posts (0)** / "There is no data available" (en-dash Sum/Average).
- **Why accepted / not a bug:** The picker correctly disables dates with no data and correctly advertises the floor. This is **spec drift** — the fixed 2023 date was inside retention when QA-929 was authored and has since aged out. Per Rule 1/3/5, **do NOT substitute a different date range**; mark the case **BLOCKED (test-data)** with assertions Not Evaluable. Filing a product bug would repeat the QA-91412 false-positive pattern.
- **Affected assertions:** Any case with a **fixed historical date range** older than the rolling retention floor (currently ~Jun 28, 2023, sliding forward daily). Recommend the spec owner refresh the window to ≥ floor, or express it relatively so it doesn't expire again.
- **Revisit if:** retention is extended, or the spec's date range is updated to within the current window (then the tooltip behavior A1–A6 becomes testable — the test itself is date-independent UI behavior).

### 2026-06-28 — Radaac jQuery-UI dialog Submit works under Playwright (supersedes Chrome-MCP submit quirk) + cache-file race + on-disk slugification

- **First observed:** 2026-06-28 (QA-43916 "Not Configured", QA-51425 "Duplicate Brands and Social Pages", QA-52776 "Brand Definitions Fetch/Patch/Apply")
- **Behavior:** The Chrome-MCP-era quirk "Radaac jQuery-UI dialog Submit input ignores programmatic clicks → needs the direct-URL GET workaround" did **NOT** reproduce under Playwright. A trusted `browser_click` on the dialog's Submit navigated normally (GET reports → query-param endpoint; multipart POST reports → file upload via `browser_file_upload`). The URL-nav workaround is unnecessary and is not even usable for the Patch/Apply reports (they POST multipart uploads).
- **Cache-file race (accept + retry):** the `/cache/<name>.<ext>` link returns an inline HTML "File not found. Some reports require a bit more time." page until generation finishes. Wait a few seconds and re-load the cache URL; the real Playwright `download` event then fires. Typical waits: Fetch ~3s, Patch ~5s, Apply ~12s.
- **On-disk filename slugification:** Playwright saves the file with `_<hash>` rewritten to `-<hash>` (underscore→hyphen). The **server-emitted** name (download-event name + cache URL) keeps the spec underscore (e.g. `20260628NotConfigured_629fb1.tsv`). Assert against the server name, not the slugified on-disk artifact. Not a product bug.
- **Why accepted:** Automation-only mechanics under the trusted-event model; consistent with the broader Playwright trusted-event findings (TWC/DS/CPR). The historical Radaac CSV→TSV regression remains RESOLVED — CSV exports are genuinely comma-separated.
- **One-off seen, not a confirmed defect:** QA-52776 Apply (`POST /apply_brand_definition_report`) returned a transient **502 Bad Gateway** on first submit, then succeeded on retry ~15s later (synchronous DB-write endpoint). Single occurrence → flagged for eng, not filed.
- **Revisit if:** Submit stops responding to trusted clicks, the cache race disappears, or the Apply 502 becomes reproducible.

### 2026-06-28 — PDF verification fallback when poppler is absent (use the Read tool's multimodal render)

- **First observed:** 2026-06-28 (QA-837, Hulu+Conan Social Recap PDF)
- **Behavior:** The run host lacked poppler (`pdfinfo` / `pdftoppm` / `pdftotext`), so the documented `pdf-end-to-end-verification` pattern (`pdftoppm` → Read on rendered PNG) could not run. Fallback that satisfied Rule 6: (a) parse the raw PDF bytes for the page-tree `/Count` to confirm page count + producer (e.g. jsPDF 3.0.1, 4 pages), and (b) use the **Read tool's native multimodal PDF render** to read each page's content (headers, metrics, share %, page breaks, thumbnails) directly from the downloaded file.
- **Why accepted:** Verification is still performed on the actual downloaded bytes (not DOM/network proxies); only the rasterization tool differs. Recommended as the macOS/poppler-absent fallback for `pdf-end-to-end-verification`.
- **Affected assertions:** Any PDF download/parity check on a host without poppler.
- **Revisit if:** poppler is installed on the run host (prefer `pdftoppm` for pixel-level checks), or the Read tool's PDF render changes.

### 2026-06-28 — QA-33510 External-user test: named test user is Admin on the reachable account → BLOCKED, not a bug

- **First observed:** 2026-06-28 (QA-33510, Settings > Users "Access message for External")
- **Behavior:** QA-33510 validates that an **External** user sees NO "Add a New User" button (A1) and a contact-admins message (A2). The precondition logs in as `testing@drylogics.com` (password is in the Jira Xray Preconditions field `customfield_11100`, fetchable via Atlassian MCP — NOT in `config/.env`). After full re-authentication as that user, the app pins to the **last active account** (Adam Orfei, account_id=54 — APPS-54436, a CLOSED defect linked to this very ticket), where `testing@drylogics.com` is provisioned **Admin**. The Users page therefore correctly renders the full admin view (Add a New User visible, Export, full user list); the External message is absent. A clean `#home` nav re-resolves to acct 54 again (sticky last-active).
- **Why accepted / not a bug:** For an **Admin** role, showing the Add button + user list is correct product behavior. A1/A2 are **Not Evaluable (BLOCKED)** — the *precondition* (user being External) is unmet, not a product defect. Filing A1/A2 as FAIL would repeat the QA‑91412 wrong-configuration false-positive (Rule 1 + Rule 5). Note Adam Orfei has a *separate* dedicated external test user `dontdelete-aoexternaltest@test.com`, so `testing@drylogics.com` being Admin here may be intentional.
- **Affected assertions:** Any Settings>Users (or other role-gated) test whose precondition needs an External/non-admin user. BLOCKED until LFIQA confirms the account where `testing@drylogics.com` holds an External role, or corrects the user's role if it drifted. Do NOT substitute the internal lfiqa account (it is Admin → guaranteed false A1).
- **External login itself works:** LFMP-29876 "Unable to login External User" did **not** reproduce (oauth_callback succeeded first try). Account switching cannot satisfy this precondition — it changes brand/account *context*, not the logged-in user's *identity/role*; a full Sign Out + re-auth is required.
- **Revisit if:** the test account is re-provisioned External on a reachable account, or the spec names the specific External account.

### 2026-06-28 — Brand>Stories charts render fine under Playwright MCP (supersedes Chrome-MCP tile-fail) + donut-ring hover pattern

- **First observed:** 2026-06-28 (QA-949, Michael Kors brand_id=3801, IG Stories, Authorized)
- **Behavior:** The Chrome-MCP-era quirks "Brand>Stories trend tiles fail to render — 'This tile failed to load'" (see entries dated 2026-06-13 / 2026-06-04 below) did **NOT** reproduce under Playwright. All four big-number tiles (Engagements / Impressions / Taps Back / Exits) painted bar charts (`rect.bar.instagram.story_insight.<metric>-<YYYY-MM-DD>`, 7 bars), and the Impressions tile switched cleanly to a Pie/donut. Confirms those are CDP-specific render artifacts, not product defects.
- **Tooltip components (Stories):** bars use the shared `app-lib chart-tooltip` (`.chart-tooltip__header` = `Mon. DD, YYYY`, `.chart-tooltip__row` = `<i class="chart-tooltip__icon fab fa-instagram">`+label+value+change-indicator). Donut uses **`.al-donut__tooltip`** (`Instagram: <value>`). NOT Recharts and NOT the Insights `.al-bar-chart__tooltip`.
- **Donut hover pattern (important):** the pie renders as a **donut**; `browser_hover` lands on the empty center hole and the `<svg class="donut">` intercepts pointer events (Playwright hover times out). Workaround: tag the slice `path`, compute a point on the ring (radius ≈ midpoint of inner/outer, e.g. `(80.7+47.075)/2` px from the path bbox center) and dispatch `mouseover`/`mouseenter`/`mousemove` at that client coordinate — the tooltip then renders. Bars respond to plain trusted `browser_hover`.
- **Export:** toolbar Export is a split-button (`lfm-button-dropdown-container.csv`); CSV submenu = "Only Current Data Set" / "All Data Sets" / "Google Sheets". Choosing "Only Current Data Set" fired a **synchronous** Playwright `download` event → `Michael Kors-Brand Stories-2026-06-21-2026-06-27-posts.csv` (spec-format filename, NOT a CDN hash), with `i.lf-spinner.fa-spin` shown on the button until done. Post Type cell ("video"/"image") is an `<a target="_blank">` to `instagram.com/stories/<handle>/<post_id>` — clicking opens the post in a new tab.
- **Revisit if:** Stories tiles fail to render under Playwright on another brand/window (would re-open the render-artifact question).
### 2026-07-15 — Max brand (Adam Orfei dev) has no Brand>Audience surface at all (NEW)

- **First observed:** 2026-07-15 (QA-112583, QA-22296 remaining batch, Playwright MCP)
- **Behavior:** Navigating to `#explore/brand/audience?brand_id=412264&...` (Max, Adam Orfei account_id=54) is silently rewritten by the SPA router to `#explore/brand/insights?brand_id=412264` every time (reproduced twice). The Brand sub-nav tab list for Max is limited to Insights / Channels / Content / Video / Optimization / Partnerships / Conversation — no Audience, no Stories, no Paid tab.
- **Why accepted:** Extends the existing 2026-06-27 "Max brand has no Threads channel" quirk (which covered Brand>Content and Brand>Channels channel gaps) — Max's data-collection/test-data footprint is narrower than most brands, missing entire page surfaces, not just channels within a surface.
- **Affected assertions:** Any QA spec naming Max + Brand>Audience (or Stories/Paid) is BLOCKED on test-data, not a functional defect. QA-112583 assertion 14 (Follower Demographics vs Brand>Audience Threads Gender Breakdown parity) cannot be evaluated on Max for this reason.
- **Revisit if:** Max gains Audience/Stories/Paid data collection, or the spec is updated to a brand that has these surfaces.

### 2026-07-13 — Brand>Video renderer hang escalates to a full Playwright MCP server crash (CRITICAL, reproduced 2026-07-15 on Brand>Insights)

- **First observed:** 2026-07-13 (QA-947, QA-22296 batch-2, Hulu brand_id=11003)
- **Behavior:** Navigating to Brand>Video and calling `browser_wait_for` while the stacked bar charts render **timed out after 30s**, and the very next Playwright MCP tool call returned `MCP error -32000: Connection closed`. Every Playwright MCP tool (`browser_navigate`, `browser_click`, `browser_evaluate`, `browser_tabs`, etc.) then disappeared from the tool registry for the rest of the session — `ToolSearch` for `playwright browser` returns no matches. This is a full server-process crash, not a single hung call.
- **2026-07-15 reproduction (QA-22296 remaining batch, QA-134271 in progress):** navigating directly to `#explore/brand/insights?brand_id=4018&account_id=54` (MTV) and calling `browser_evaluate` immediately after triggered the same failure mode — the MCP connection dropped and every `mcp__playwright__*` tool disappeared from the tool registry for the rest of the session (`ToolSearch` confirmed no matches). This proves the crash is **not Brand>Video-specific** — Brand>Insights alone can trigger it too, with no special action beyond a plain navigate + one evaluate call. 6/26 cases in the batch had been completed (QA-112583, QA-113594, QA-113723, QA-114840, QA-116140, QA-116173) before the crash ended the session; the remaining 20 were not run.
- **Relationship to existing quirk:** this is the same underlying "Brand>Insights / Brand>Video renderer hang" documented extensively below under Chrome MCP (CDP `Runtime.evaluate` 45s timeouts, recoverable via `tabs_close_mcp` + fresh tab). Under Playwright MCP the failure mode is worse: the whole MCP server dies, and there is no `tabs_close_mcp`-equivalent recovery tool available once the connection drops. There is currently no in-session recovery — the user must restart/reconnect the Playwright MCP server before browser-driven cases can resume.
- **Why accepted (for now):** treated as a dev-environment/renderer-perf issue triggering a client-side crash, not a product defect. But the automation impact is severe and now confirmed **recurring across two separate sessions on two different pages** (Video 2026-07-13, Insights 2026-07-15) — both times a batch run was cut short (62 cases skipped 2026-07-13; 20 cases skipped 2026-07-15).
- **Affected assertions:** any test that navigates to Brand>Video or Brand>Insights under Playwright MCP is now a **run-ending risk**, not just a per-case blocker.
- **Workaround/mitigation to try next run:** avoid Brand>Video/Brand>Insights until this is fixed, OR isolate those specific cases into their own single-case `claude -p` invocation (fresh process per case) so a crash there doesn't take down a whole batch. Consider filing an infra ticket against the `@playwright/mcp` launch config (`.mcp.json`) to add a hard per-navigation timeout + auto-restart. Given the second reproduction, this should be escalated from "try to avoid" to "treat Brand>Insights/Video cases as needing isolation by default."
- **2026-07-15, 3rd occurrence, same session after reconnect:** after the user reconnected the Playwright MCP server, login + account-switch succeeded and Brand>Insights (MTV) loaded and read fine (`Data Last Updated` matched Home). The very next navigation — Brand>**Audience** for the same MTV brand, a plain `browser_navigate` + `browser_wait_for` — began timing out (`wait_for` 5s/30s timeouts, then `browser_snapshot` 30s timeout), and the following `browser_tabs` call returned `MCP error -32000: Connection closed`. All `mcp__playwright__*` tools disappeared again; `ToolSearch` confirmed no matches. This shows the crash is **not confined to Video/Insights** — Brand>Audience can trigger it too, and it can recur within the same reconnected session after a successful heavier-page load. This raises the possibility the trigger is cumulative session state/resource exhaustion (many prior snapshots/tool calls) rather than one specific page's renderer.
- **Revisit if:** the Playwright MCP server gains a navigation timeout/auto-restart, or the underlying Brand>Video/Insights/Audience renderer hang is fixed product-side, or a repro isolates this to page-specific vs. cumulative-session causes.

### 2026-06-27 — Settings surfaces do not inherit the active Home account context

- **First observed:** 2026-06-27 (QA-106218; reconfirmed implicitly in QA-104870)
- **Behavior:** With an account active on `#home` (e.g. Adam Orfei), navigating Settings → Custom Data Sets loaded the page under a *different* account from Recent Searches (Hulu, account_id=336) without any user-initiated switch. Re-navigating to `#home` then also showed the carried-over account — i.e. the cold `#home` label did not reflect the account the app actually resolved on first real navigation.
- **Why accepted (for now):** Likely persisted "current account" session-state carryover from a prior LFQA session plus a possibly stale cold-render header label. Flagged as a **candidate Minor/UX bug** (product to confirm whether Settings surfaces are intentionally account-independent), NOT a functional defect — every Custom Data Sets assertion passes once the account is explicitly set. Treat as a precondition step, not a failure.
- **Affected assertions:** Any Settings-surface test with an account precondition — switch to the spec account via user-menu → Search Account → click the **Results** entry (not Recent Searches) and re-verify the breadcrumb before evaluating.
- **Revisit if:** Settings pages start honoring the global account selection on first navigation, or product confirms intended behavior.

### 2026-06-27 — Max brand (Adam Orfei dev) has no Threads channel — Brand>Content AND Brand>Insights

- **First observed:** 2026-06-27 (QA-100764, BLOCKED). **Re-confirmed 2026-07-01** (QA-100764 unattended re-run — still BLOCKED, revisit-trigger NOT met). **Extended 2026-07-01 to Brand>Insights** (QA-96665 "Brand Insights - Threads - Basic View", BLOCKED).
- **Behavior:** On the Adam Orfei account, the **Max** brand (brand_id=412264) Brand>Content channel selector offers only Facebook / X (Twitter) / Instagram / TikTok / YouTube — **no Threads** (and no LinkedIn/Pinterest) toggle. Navigating with `&channels=threads` is rewritten by the hash router with the param **stripped**. DOM `.channel-icon`/`.channel-ghost` sets confirm Threads absent. (NB: `fab fa-threads` icons do appear in the DOM but only inside `dataset-tooltip__…__channel-icon` data-set composition tooltips — NOT in the channel selector.) On 2026-07-01 the HBO Max account (657) brand typeahead returned no exact-match "Max" brand either — the spec "Max" brand is reachable only on Adam Orfei (54).
- **Brand>Insights confirmation (2026-07-01, QA-96665):** Same gap on Brand>Insights. The Max `.chan-icon-wrapper` channel selector enumerates FB/X/IG/TikTok (`enabled`) → separator → YouTube/Pinterest/Wikipedia/RottenTomatoes/IMDb/Metacritic (`disabled`) → Apply — **no Threads and no LinkedIn** icon at all. Additionally the **perspective toggle is disabled** (`toggle-switch toggle-switch-disabled`, `<input id="perspective" checked disabled>`, right label "Authorized Data" `disabled`) — Max has **no Authorized data**, locked to Public (compare pill reads "…for Max [Public]"). So QA-96665 A1 (Threads-next-to-LinkedIn separator) and A2–A8 (Threads tiles/BPC) are unreachable, and A9 (Threads gone under Public) is moot since Threads is never present and Authorized can't be selected.
- **Why accepted:** Test-data / data-collection gap, not a product defect (not in the Daily Post Analysis modal, not in Brand>Insights). Threads cases written against Max cannot run as-is on this account.
- **Affected assertions:** Any Brand>Content (or DPA-modal) **or Brand>Insights** Threads case targeting Max — BLOCKED on test-data, do not substitute another channel/brand (Rule 1). Needs LFIQA/product to either enable Threads collection (and Authorized perspective) for Max, name the specific account where Max has Threads, or update the stale brand/channel pairing.
- **Revisit if:** Threads data collection is enabled for Max, or the spec is updated to a brand that collects Threads.
- **2026-07-14 extension (QA-95190, Playwright MCP):** Gap confirmed on **Brand>Channels** too, not just Brand>Content. On `#explore/brand/channels?brand_id=412264` (Dec 01, 2024 – Dec 01, 2024 window), only **Instagram and TikTok** tiles render — Facebook, Twitter, LinkedIn, Threads, YouTube all absent. Additionally the **View toggle is disabled** (`toggle-switch-disabled`, `Authorized Data` label carries a `disabled` class) — Max is locked to Public Data on this page, Authorized cannot be selected at all. Any Brand>Channels case naming Max + Threads/LinkedIn, or expecting an Authorized-view assertion on Max, is BLOCKED the same way.

### 2026-06-22 — QA-198 TWC export-to-disk spike (Disney Ad Sales)

- **Playwright MCP download-to-disk WORKS (key win).** Clicking an export option fires a Playwright
  `download` event and the file is saved to the `--output-dir` (`.playwright-out/`) automatically —
  confirmed for **CSV, TSV, XLS** on the TWC report (report 154984). Filenames are slugified
  (spaces/commas → `-`), e.g. `Disney-Channel---Time-Window-Comparison---Jun-14-2026---Jun-20-2026.csv`.
- **TWC exports are SYNCHRONOUS** — direct download, no "queued / notification-bell / signed-CDN
  anchor" async path. (Contrast the Chrome-MCP note that Content/Paid CSV exports are async; that
  does not apply to TWC.) No `URL.createObjectURL` or anchor-click hook needed.
- **TWC brand picker accepts Playwright real keystrokes.** `pressSequentially` triggers the React
  typeahead onChange — the documented `Object.getOwnPropertyDescriptor(...).set` + `dispatchEvent`
  workaround in `time-window-comparison-run/SKILL.md` is **obsolete** under Playwright. (Same as DS.)
  Note: `browser_type` with `slowly:true` APPENDS — `fill('')` first to clear between brands.
- **TWC metric checkboxes are the same `.controlled-check-box`** and respond to trusted
  `browser_click` (no focus+Space dispatch needed) — consistent with the DS finding.
- **Brand exact-text gotcha:** the FOX News option renders as **"FOX News"** (uppercase FOX), not
  "Fox News" as written in the QA-198 steps. Match case-insensitively or verify the rendered label.
- **Export verification on disk:** CSV header = `Perspective, Brand, Date, <metrics…>`; 28 data rows
  (4 brands × 7 days). TSV is byte-identical to CSV. XLS (saved `.xlsx`) carries the same header +
  rows + values. No en-dash in any export for this window; rate metric serialized as a raw float
  (e.g. `0.000104…`), not a `%` string.
- **Screenshot filename caveat:** `browser_take_screenshot` with a bare `filename` saves to the CWD
  (repo root), NOT `--output-dir`. Use a path under `.playwright-out/` or expect the file at root
  (it won't be gitignored there).

### 2026-06-22 — chart-hover-tooltip spike (QA-96670, Brand>Insights, HBO Max)

- **`browser_hover` triggers the chart tooltip natively (trusted hover).** No synthetic
  `mousemove`/`mouseover` dispatch needed. The Chrome-MCP-era finding ("synthetic events don't fire;
  only real `computer.hover` works") is **obsolete** under Playwright.
- **`chart-hover-tooltip/SKILL.md` is STALE.** Insights charts are **D3 / custom SVG**, NOT Recharts.
  Real markup: bars are `rect.bar.<channel>-<YYYY-MM-DD>` (e.g. `rect.bar.twitter-2026-06-14`),
  donut is `.arc`/`.donut-center-label`, axes are `.axis .tick .domain`. The skill's Recharts
  selectors (`.recharts-rectangle`, `.recharts-tooltip-wrapper`, `.recharts-dot`) **do not exist**
  here. Needs a rewrite.
- **Tooltip is readable in the DOM** at selector **`.al-bar-chart__tooltip`** — screenshot fallback
  NOT required. Format: `Mon. DD, YYYY` then one line per channel `Channel: value (±%)`
  (matches QA-96670 A2/A4). Bar `<title>` elements are empty; the tooltip is JS-driven.
- **The Brand>Insights "renderer hang" did NOT reproduce.** Earlier failures (30s `wait_for`
  timeout, page closing) were caused by navigating to Insights with **missing/invalid compare
  dates** (no `compare_from`/`compare_to`), not a renderer perf hang. With valid dates the tiles
  render fine and fast. The Chrome-MCP "Insights hang" quirk should be re-characterized as a
  date-validation issue under Playwright.
- **Account switch flow (verified):** LFIQA menu (`.navigation-menu-header`, hover) → "Search
  Account" input → type name → click the brand under **Results** → app reloads into that account
  **and auto-populates valid `from`/`to`/`compare_from`/`compare_to`**. This is also why the DS case
  earlier had no date issues. Switched Michael Kors (657… acct 328) → HBO Max (acct 657,
  brand 155614).

### 2026-06-22 — Playwright MCP tooling findings (Data Studio post-level spike)

Re-validating Chrome-MCP-era quirks under Playwright's trusted-event model. Case:
`data-studio-post-level-run`, Michael Kors, 7D, report_id 298410.

- **`.controlled-check-box` works with a normal Playwright click (BIG WIN).** A `browser_click`
  on the `.controlled-check-box` span flipped `far fa-square` → `fas fa-check-square`,
  `aria-checked=true`, and **persisted** (no React revert) — verified 0.8s later. The Chrome-MCP
  quirk (synthetic `.click()` reverts; needed `focus()`+Space dispatch) **does not apply** under
  Playwright. Same expected for CPR numeric inputs / TWC Options checkboxes. Use real
  `browser_click`, not JS `.click()`.
- **Custom widgets are not in the accessibility tree.** The brand `al-typeahead` options and the
  metric-tree checkboxes have no listbox/option/checkbox roles, so they don't appear in
  `browser_snapshot`. Pattern that worked: `browser_evaluate` to locate the element by text/class
  and tag it (`el.setAttribute('data-spk', …)`), then `browser_click('[data-spk=…]')` for a trusted
  click. Avoids brittle snapshot refs.
- **Brand picker responds to typed input**, but `browser_type` with `slowly:true`
  (`pressSequentially`) **appends** — it does not clear first. Clear with an empty `fill('')` before
  typing, or the value concatenates (saw "MTVMichael Kors").
- **"Search for a Metric" filter works**: typing "Engagements" surfaced the Engagements rollup +
  per-channel variants (Facebook/Twitter/Instagram/YouTube/TikTok/LinkedIn/Threads/Pinterest).
- **DS data grid = `.al-table` → `.al-table__row` → `.al-table__cell`** (metric name in
  `.al-table__metric`). NOT a `<table>`/`role=row`; query `.al-table__row` directly. Row text order:
  Metric, Brand, perspective badge (P/A), Sum, Average, then one cell per day.
- **Em-dash (`–`) = missing day** confirmed (Facebook Jun16/Jun20). Per-row Σ(daily) == Sum holds.
- **Direct-URL nav to Data Studio rendered fine** this run — the Chrome-MCP "blank on direct nav"
  quirk did not reproduce under Playwright (still prefer menu nav if a blank page appears).

### 2026-06-22 — storageState auth replay is unreliable; use programmatic login (RESOLVED)

**Symptom.** Pre-flight step 2 failed. `browser_navigate('https://app.lfmdev.in')` redirected to the
Cognito hosted-UI login form. Console showed the app JS fully bootstrapped (`Bootstrapping
application` → `global storage initialized`) and *then* the client redirected to login — i.e. the app
ran its own session check and found itself unauthenticated. `config/storageState.json` was only
~12 min old, so this was not simple expiry.

**Root cause — confirmed by inspecting a live authenticated session** (`browser_evaluate` after a
successful login):
- The app session is **`apc_session`** (localStorage) **+ `apc_user`** (611 chars, **`sessionStorage`**)
  **+** a server-side **HttpOnly cookie** on the app domain (not JS-visible).
- There are **no discrete Cognito tokens** (`idToken`/`accessToken`/`refreshToken`,
  `CognitoIdentityServiceProvider.*`) in localStorage or sessionStorage. The Cognito side rides in the
  HttpOnly cookie.
- Playwright `storageState` (`--save-storage` / `--storage-state`) serializes **only cookies +
  localStorage — never sessionStorage.** So `apc_user` is dropped on capture, and the captured file
  also lacked the app-domain session cookie (it only had `G_ENABLED_IDPS` on `.app.lfmdev.in` plus
  `auth.lfmdev.in` Cognito cookies). Replay is therefore missing two of the three required pieces →
  redirect to login. Re-capturing the same way cannot fix this.

**Resolution — programmatic email/password login (adopted).** Logging in fresh at the start of each
run rebuilds the full session (localStorage + sessionStorage + HttpOnly cookie) and renders the
dashboard. Verified headed end-to-end on 2026-06-22:
1. `browser_navigate('https://app.lfmdev.in')` → redirected to Cognito hosted UI.
2. Fill the **"With existing account"** form: Email address, Password (creds from gitignored
   `config/.env`: `LFM_EMAIL` / `LFM_PASSWORD`).
3. Click that form's **Sign in** button → `oauth_callback` → dashboard (`#home`, title
   "Home - ListenFirst").

Note there are **two** "Sign in" buttons on the page (Corporate-email SSO vs. existing-account).
Target the existing-account form specifically, e.g.
`page.locator('form').filter({ hasText: 'With existing account' }).getByRole('button', { name: 'Sign in' })`.

`storageState.json` is no longer required for auth and can be ignored/removed for this track.

### Data Studio layered tag filter NOW has Include/Exclude (FIXED 2026-06-13)

- **First observed fixed:** 2026-06-13 (QA-4325 QA-134517) — was a FAIL on 2026-06-02.
- **Behavior:** The Data Studio Post-Level **Filters → Tag** panel now exposes the full layered structure — **Include/Exclude radios + Or/And radios + Select All/None + tag list** — matching Brand>Content/Optimization/Brand Sets. Previously (2026-06-02 run) the DS tag filter was **missing Include/Exclude** (QA-134517 FAIL).
- **Why noted:** A prior FAIL is resolved; the layered tag-filter component is now consistent across all 4 surfaces (Brand>Content, Brand>Optimization, Brand Sets>Content, Data Studio). Recommend closing the QA-134517 bug.
- **Revisit if:** DS tag filter regresses.

### SPA route quirks: hyphenated Settings routes + stale hash params (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-135430).
- **Behavior:** (a) **Custom Metrics route is `#custom-metrics` (hyphen)**, not `#custom_metrics` (underscore) — the underscore URL renders a blank page. (b) Navigating to a Settings hash route while a stale query string from another page is in the URL can leave the page blank / not re-render. Workaround: navigate via the **Settings dropdown menu link**, or to `#home` first then the target. (Also: Data Studio sometimes renders blank on direct URL nav — load via the **Reporting menu**.)
- **Why accepted:** Automation/routing friction, not a product defect for end users (who click menu links).
- **Revisit if:** the SPA router normalizes route names / handles stale params.

### Audit deep-link opens a NEW tab (APPS-54603 possible fix) (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-107134).
- **Behavior:** Clicking an entity deep-link in a Settings>Audit Description (e.g., a Brand Set name) opened the entity detail page in a **new tab** (`#brand-sets/detail?brand_set_id=…`). The prior run flagged **APPS-54603** (same-tab URL-replace) — not reproduced this run.
- **Why noted:** Possible fix of APPS-54603; flag for eng re-confirm before closing.
- **Revisit if:** same-tab-replace behavior returns.

### Data Studio post-level Impressions require In-Window + Authorized view (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-84194)
- **Behavior:** In Data Studio → Post Level, the Impressions metric tree (Impressions / Public Impressions / Reach + channel sub-metrics) is **greyed/disabled** while Window Mode = **Lifetime** and/or the brand's View = **Public**. Switching Window Mode to **In-Window** *and* the brand row's View toggle to **Authorized Data** enables them; MTV then returns Authorized Impressions (Sum 39,726,174 for Jun 9–15).
- **Why accepted:** Impressions are window-based, private/authorized metrics — not available in lifetime/public context by design. This is the precise characterization of the long-noted "DS metric-tree friction."
- **Affected assertions:** Any DS post-level Impressions/Reach data-QA. Engagements (public) is unaffected.
- **Revisit if:** Product exposes lifetime/public Impressions, or the metric-tree disables differently.

### Brand>Stories & Brand>Paid trend-tile charts fail to render under Chrome MCP (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-51442, QA-72455, QA-83928)
- **Behavior:** The trend tiles on Brand>Stories and Brand>Paid persistently show "This tile failed to load. Please try again." (chart canvas never paints), while the **data table** below renders correctly (e.g., Stories Impressions Sum 1,248,958). Reload of an individual tile goes to a permanent skeleton. Tile-level **PNG export** therefore produces no file (nothing to rasterize), but the **CSV** export (table-based) works fine.
- **Why accepted:** Chrome-MCP/CDP rendering artifact (matches the prior-run retraction of the Brand>Stories tile-fail). The data layer is healthy; only the chart render under CDP is affected — **not a product defect**.
- **Affected assertions:** Tile-render & tile-PNG assertions on Stories/Paid under Chrome MCP. Verify those manually / in a real browser.
- **Revisit if:** Tiles render under CDP after a Chrome-MCP upgrade, or a real-browser check shows the tile genuinely failing.

### Brand>Insights renderer hang now reproduces across brands (UPDATE 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-51457) — escalation of the long-known MTV hang
- **Behavior:** Brand>Insights froze the whole CDP pipeline (screenshot / JS / tab-close >45s) on **both MTV and #1 Happy Family USA** this session — previously mostly MTV-specific. Recovery = abandon the frozen tab, open a fresh one, and avoid Insights.
- **Why accepted:** Treated as an environment/perf blocker (cf. APPS-55565), not a functional defect in the feature under test. Puts all Brand>Insights cases at risk under Chrome MCP.
- **Affected assertions:** Any Brand>Insights case (QA-51457, QA-114845, QA-134176/134182/134184/134188/134639). 
- **Revisit if:** Insights loads under CDP without hanging; worth a perf ticket regardless.

### Async exports (Content/Paid CSV) need the anchor-click hook, not createObjectURL (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-28405, QA-83928)
- **Behavior:** Content/Paid CSV exports are **asynchronous** ("Your export has successfully been queued"). The file is delivered later via an **auto-download (an `<a href>` to a signed CDN URL)** + a notifications-bell entry ("…is now ready. Download file.") + email. A `URL.createObjectURL` hook captures nothing; hooking `HTMLAnchorElement.prototype.click` to grab the href + in-page `fetch(url,{credentials:'include'})` is the reliable Rule-6 verification. (DS PNG/Social-Recap PDF, by contrast, DO emit a real Blob via `createObjectURL`.) LF Content CSVs also carry a "Data Set" preamble row before the true header.
- **Why accepted:** Automation-only verification mechanics; not a product behavior.
- **Affected assertions:** Any CSV-export verification on Content/Paid/Brand-Set.
- **Revisit if:** Export delivery changes to a synchronous blob.

### Channel-selector icons are not exposed as accessibility refs; Audience needs from/to (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 QA-72455, QA-92735)
- **Behavior:** (a) The Brand>Paid/Content channel icon toggles (FB/X/IG/YT/TikTok/LinkedIn/Threads) are not addressable via `find` (no refs) and are too small for reliable coordinate clicks — use the URL `channels=` param or a DOM-dispatched click instead. (b) Navigating to Brand>Audience without `from`/`to` query params leaves the sub-nav stuck on skeleton (~25s); always include the full date params.
- **Why accepted:** Automation-only friction.
- **Affected assertions:** None directly; fold into the brand-paid/brand-audience nav skills.
- **Revisit if:** The channel toggles gain accessible roles.

### Brand>Content Tag-filter Search field is not cleared on Tag-section header collapse/reopen (NEW 2026-06-08)

- **First observed:** 2026-06-08 (QA-22296 batch-12 QA-135837)
- **Behavior:** On Brand>Content Filter dropdown → Tag filter, the per-Tag-section Search textarea retains its typed value after collapsing the Tag-section header label and expanding it again. The spec assertion 9 of QA-135837 reads "fresh state on reopen" expecting the search input to clear, but actual product behavior retains the typed text.
- **Why accepted:** Likely intentional product behavior — preserve in-progress search across sub-section UI interactions so user doesn't lose their search context. Selected tags (chips/checkboxes) correctly persist as expected. The substantive APPS-61098 regression-fix (search field NOT clearing during select/deselect operations) is still working correctly.
- **Affected assertions:** QA-135837 assertion 9 (close/reopen → empty search).
- **Revisit if:** Product PM confirms close/reopen should clear, or QA spec is updated.

### Hulu account: brand_id 5670 auto-redirects to 11003 on Brand>Content (NEW 2026-06-08)

- **First observed:** 2026-06-08 (QA-22296 batch-8 QA-121158 / QA-121217)
- **Behavior:** Navigating to `app.lfmdev.in/#explore/brand/content?brand_id=5670&account_id=336&...` (Hulu on Hulu account) silently resolves URL to `brand_id=11003` (a Hulu LA sub-brand). UI header shows "Hulu" with the green Hulu logo for both brand_ids, but the underlying brand-data sets are different.
- **Why accepted:** Likely a backend default-brand resolution for account_id=336 — Hulu user typically lands on the Hulu LA sub-brand as the favorite brand. Not a defect for end-user UX but the data underneath differs from the named spec brand.
- **Affected assertions:** Any QA spec that names "Hulu" without disambiguating to a sub-brand variant. Particularly Brand>Content / Brand>Audience IG-collaborator and channel-specific tests where brand_id=11003 may not have the data the spec assumes brand_id=5670 has.
- **Revisit if:** Backend brand-resolution changes, or LFIQA confirms which specific Hulu sub-brand is intended for IG-collaborator tests like QA-121158/QA-121217.

### Brand>Content perspective-toggle click can auto-fall back to a different brand when Threads channel was selected (NEW 2026-06-08)

- **First observed:** 2026-06-08 (QA-98351 QA-22296 batch-6)
- **Behavior:** On Brand>Content with `channels=threads&perspective=extended` (Authorized), clicking the Public/Authorized toggle to switch to Public can cause the URL `brand_id` to silently change to a different (non-Threads-authorized) brand AND drop the `channels=threads` query param. Observed transition: MTV (brand_id=4018) → brand_id=10765, channels stripped to default Public set.
- **Why accepted:** Likely a backend-driven fallback: brand 4018 lacks Threads-public data, so toggle click triggers a Public-mode preference that finds the user's last-Public brand. Not a product defect for end-user UX, but breaks deterministic automation.
- **Affected assertions:** Any Threads-Brand>Content perspective test that toggles mid-flow. The skill should re-navigate via URL with explicit `brand_id` after each toggle, not trust DOM/URL post-click.
- **Revisit if:** Backend stops the brand-fallback behavior or product changes to keep brand_id stable across perspective changes.

### TWC report-builder pane fails to render (only sub-header loads)

- **First observed:** 2026-07-10 (QA-137047 QA-4325 rerun, Playwright MCP, Hulu account)
- **Behavior:** Navigating to `#explore/reporting/time_window_comparison` sometimes loads only the **sub-header** (brand name, "Date Range: …", favorite/help/info buttons) — the entire report-builder config pane (brand "Add Brand", the Content>Video>Channel View metric tree, perspective toggle, "Run Report") **never mounts**. `main` body was ~331 chars total; page title stayed "ListenFirst: Brand Explorer" (not "…Time Window Comparison"). A `location.reload()` did not fix it. Blocks any test that must build+run a TWC report (QA-137047 A6/A8/A15 all BLOCKED).
- **Note on account reach:** the **Hulu** account is NOT in the LFQA quick-switcher, but the TWC "Search Account" box (`.account-typeahead-input`) finds "Hulu" and selecting it **switches the whole session to that account** (account_id=336). Useful for "logged in as <account>" preconditions when the account is missing from the switcher.
- **Why (likely):** app-reporting TWC bundle/init race under the automation harness (consistent with the broader TWC fragility — QA-129608 was likewise TWC-blocked). Not confirmed as an end-user defect.
- **Workaround / affected:** re-run in a fresh session or on a different account; if it still won't mount, verdict BLOCKED with the ~331-char body as evidence. The Channel-side of PVV parity is verifiable independently (QA-134586).

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
- **2026-06-08 update (QA-95190 QA-22296 batch-5):** Hang also reproduces on **Brand>Insights `channels=threads` single-channel default-window** MTV (`brand_id=4018`, `from=2026-05-25&to=2026-05-31`). CDP `Runtime.evaluate` 45s timeout on the post-navigate query. Recovery via `tabs_close_mcp` + fresh tab worked. Pattern is not multi-channel-specific — Threads single-channel is enough to trigger. For Threads-cross-source tests (QA-95190 cross-check Brand>Insights ↔ Brand>Channels), use Brand>Content Threads as the alternative sanity check (Posts(0) ↔ New Posts=0 verified consistent today).
- **2026-06-08 update (QA-109749/QA-112583 QA-22296 batch-7):** Brand>Audience Threads channel single-channel filter ALSO reproduces renderer hang on Michael Kors brand_id=12597 (Adam Orfei). MTV Brand>Audience Threads single-channel renders (no hang) but returns no-data on all 5 tiles. Recovery via `tabs_close_mcp` + fresh tab succeeded. Pattern: brand-specific Threads-Audience hang on Michael Kors but not MTV; both expose Threads-Insights hang.
- **2026-06-08 update (QA-96759/QA-99531 QA-22296 batch-6):** **Threads-inclusive multi-channel mixes also hang.** Verified across: `channels=threads` alone, `channels=threads&channels=instagram&channels=facebook` (3 channels, 7-day), `channels=threads&channels=twitter` (2 channels, 7-day). All hang Brand>Insights renderer. Worse: also wedges the Chrome MCP screenshot pipeline — `screenshot` and `get_page_text` calls timeout for >60s and the only recovery is `tabs_close_mcp` after extended wait + fresh tab. The hang escalation now affects multi-channel Threads mixes, not just Threads-only. **Brand>Content Threads renders cleanly with `table_data_set=threads_only%3A_insights`** — confirms the hang is Brand>Insights-specific, not all Threads queries.
- **2026-07-10 update (QA-134639 QA-4325 rerun, PLAYWRIGHT MCP):** On the **Playwright MCP** harness (not Chrome-CDP), navigating to MTV Brand>Insights (`brand_id=4018`, default range) escalates beyond a timeout — it **fully disconnected/crashed the Playwright MCP server**: the `wait_for` timed out at 30s, then the next call returned "Connection closed" and **all `mcp__playwright__browser_*` tools dropped** (surfaced as "no longer available — MCP server disconnected"). Recovery required the user to `/mcp` reconnect AND a fresh Cognito re-login (session lost). **Guidance for the Playwright-MCP harness: do NOT navigate to MTV Brand>Insights to fetch tiles — treat it as a hard MCP-crash trigger.** For Insights-export tests (QA-134639/134188/114845), rely on prior on-disk CSV/PNG evidence + cross-refs (QA-134188 Monthly export, QA-134176/134182/134184 interval picker) instead. This crashed the run twice in one session.
- **Why accepted:** Likely Chrome MCP + dev-environment performance interaction (large data-fetch + heavy SVG/chart paint stalls the renderer enough that CDP can't dispatch). Not a product defect for end users on real browsers. On Playwright MCP the same paint stall now takes down the automation server process, not just the CDP channel.
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

### Brand>Content session stuck in Sentiment-mode tile rendering (NEW 2026-06-05)

- **First observed:** 2026-06-05 (QA-22296 batch 1, QA-923 + QA-19950)
- **Behavior:** After visiting `#explore/brand/conversation` (e.g., during the QA-6315 probe) in the same Chrome MCP tab session, subsequent navigations to `#explore/brand/content?...` for any `brand_id`, channel, perspective, or `sentiment_mode=false` URL param render the Sentiment Overview tiles (`Classification` / `Classification (Daily)` / `Emotion` / `Emotion (Daily)` / `Topics` / `Top 7 Topics (Daily)` / `Most Vocal` headers) and `Posts (0)` instead of the standard post-table. The URL hash router automatically rewrites `sort_key` to `lfm.content.responses` / `lfm.content.responses_mixed` (Sentiment-mode sort keys) on load even when the explicit URL specifies `sort_key=lfm.content.engagements`. `sessionStorage.clear()` does not break the loop.
- **Why noted:** Blocked QA-923 (LFMP-31857 + LFMP-31915 Twitter-text + IG-image-tooltip probes) and QA-19950 (LFMP-31979 FB + Pinterest thumbnail probe) in batch 1 — both filed as NOT VERIFIED.
- **Workaround:** Close the entire MCP tab group + reopen a fresh Chrome window (full session reset). Avoid visiting `#explore/brand/conversation` or any Sentiment-Overview-rendering surface in the same tab where a subsequent Brand>Content post-table probe is needed.
- **Affected assertions:** Any Brand>Content post-table-content test that runs after a Conversation/Sentiment-Overview page visit. Mark NOT VERIFIED.
- **Revisit if:** the hash router stops merging Sentiment-mode state into Brand>Content `sort_key` on navigation, OR `sentiment_mode=false` URL param becomes authoritative.

### TWC Relative Dates exports embed RELATIVE labels in Date column (not absolute dates) (NEW 2026-06-05)

- **First observed:** 2026-06-05 (QA-199 batch 2)
- **Behavior:** When a TWC report is built with Relative Dates (e.g., 3 Days Before Event / 1 Day After Event, Key Date Jun 5 2026), the TSV export's Date column contains the relative-day labels (`3 Days Out`, `2 Days Out`, `1 Day Out`, `Event Day`, `1 Day Post`) rather than the resolved absolute calendar dates (`Jun 2 2026`, `Jun 3 2026`, …). Same labels appear in the in-report X-axis.
- **Why noted:** The QA-199 spec description literally says "TSV exports displays the correct **absolute** dates." Either: (a) this is a regression to be filed as a Bug, OR (b) the spec is outdated and should be rewritten to say "relative-day labels matching the in-report axis."
- **Affected assertions:** Any TWC Relative-Dates export test that asserts the Date column resolves to absolute dates. Document as a FAIL-with-finding (per QA-199 batch-2) rather than retrying.
- **Revisit if:** Product clarifies whether relative-label encoding is intentional, OR an absolute-date column gets added alongside the relative labels.

### Brand>Content queued-export may not surface in Notifications within 60s on Adam Orfei dev (NEW 2026-06-05)

- **First observed:** 2026-06-05 (QA-844 batch 2)
- **Behavior:** On Brand>Content with TikTok-only channel on MTV, Export → Public data set CSV submission was accepted by the UI ("We're hard at work preparing your export…"), but no new notification entry surfaced in `#notifications` page within 60+ seconds of submission. Newest entry visible remained from May 21 2026. No new CSV in ~/Downloads either.
- **Possible causes:** Background-queue lag on dev today; OR the hash-router's `brand_id` rewrite (4018→10765 observed during same session) queued the export under a different brand entity that didn't surface in the user's notification feed.
- **Affected assertions:** Brand>Content queued-CSV verification tests that need the resulting file on disk. Mark NOT VERIFIED rather than FAIL and retry in a clean session.
- **Revisit if:** queued exports start surfacing reliably again within reasonable time on Adam Orfei dev.

### Brand>Content `brand_id` URL hash-router rewrites on Lifetime-mode load (NEW 2026-06-05)

- **First observed:** 2026-06-05 (QA-574, QA-844, QA-926, QA-2042 batch 2)
- **Behavior:** Navigating to `#explore/brand/content?brand_id=4018&account_id=54&channels=<X>&...` with `stats_attribution_window=lifetime` (default Brand>Content Mode) consistently rewrites `brand_id=4018` (MTV) to `brand_id=10765` in the URL on page load. The page header still displays "MTV" and content loads correctly (Posts(N), Sum/Avg row, embedded tooltips all work). Functional impact: minimal for read tests; potential ambiguity for queued exports (see queued-export quirk above) since the queue may key off the rewritten brand_id.
- **Why noted:** Distinct from `table_data_set` rewrite known-quirk. Affects multiple channel tests in the same session (TikTok / YouTube / Facebook on MTV). Likely a Lifetime-mode-specific hash-router transform.
- **Affected assertions:** Any test that verifies `brand_id` URL param round-trips correctly, or any cross-brand-id test that relies on the URL value matching the page-header brand. Use page-header text and DOM probe (`document.querySelector('h1, .brand-name')`) rather than URL param when discriminating brands.
- **Revisit if:** the rewrite stops, OR product clarifies what brand_id=10765 maps to.

### Radaac Ads Account IDs report stuck in "Fetching report" → "Failed to process." cycle (NEW 2026-06-08; LFMP-30870 REGRESSION)

- **First observed:** 2026-06-08 (QA-43915 QA-22296 batch 4)
- **Behavior:** Submit on `radaac.lfmdev.in/ads_account_ids?file_format=csv&...` surfaces a cached filename `/cache/20260608AdsAccountIds_bceac0.csv` in the page DOM almost immediately, but the page H1 stays on "Fetching report" for 60+ seconds. After ~60-100 s, the page TITLE flips to "Failed to process." even though the H1 stays on "Fetching report" — head OG title and body content are out of sync. Reload cycles back to "Fetching report" H1 + body and re-races. The file never lands in `~/Downloads`. Clicking the cached `/cache/...` href shows "File not found. Some reports require a bit more time." This reproduces historical LFMP-30870 / LFMP-31249 (both Closed) — likely a regression in the Ads Account IDs job-runner.
- **Why noted:** Distinct from the QA-51425 Duplicate-Brand-Social-Pages flow which now produces valid CSV. The Ads Account IDs runner-path is specifically broken.
- **Affected assertions:** Any test that asks to download the Ads Account IDs report. Mark FAIL with LFMP-30870 reproduction evidence; do not retry beyond ~2 minutes.
- **Revisit if:** the job-runner stabilises and the cached file actually lands on disk (would close the regression), OR engineering surfaces a deterministic error state instead of the cycling title.

### Radaac auth + app.lfmdev.in cross-domain session can hang app SPA on first nav (NEW 2026-06-08)

- **First observed:** 2026-06-08 (QA-22296 batch 4 — Radaac Cognito SSO followed by `app.lfmdev.in/#tags?account_id=54`)
- **Behavior:** After completing Cognito-SSO for `radaac.lfmdev.in`, navigating back to `app.lfmdev.in/#home` or `#tags` in the same Chrome MCP tab leaves the SPA stuck on "Loading..." indefinitely. JavaScript timeouts (`Runtime.evaluate` 45s) start firing on subsequent calls. Recovery: `tabs_close_mcp` on the stuck tab + open a fresh tab via `tabs_context_mcp(createIfEmpty:true)` and re-navigate. The fresh tab loads cleanly in <12 s.
- **Why accepted:** Automation-only friction at the Chrome MCP / cross-domain session-cookie boundary. Real users don't see this on a hardware browser.
- **Affected assertions:** Any batch that visits Radaac then immediately needs an app.lfmdev.in surface in the same tab. Pre-emptively close + reopen tab between Radaac and app surfaces.
- **Revisit if:** Chrome MCP gains better cross-domain session handling.

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

### Brand>Content tag export = one column per tag name (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-22296 re-run batch-1 QA-844)
- **Behavior:** When a Brand>Content CSV export includes tagged posts, each applied tag is emitted as its **own column** whose header is the tag name (e.g. `hi`). The cell holds the tag name for tagged rows and is blank for untagged rows — there is no single delimited "Tags"/"Content Tags" column. If no posts in the result set are tagged, no tag column appears at all.
- **Why it matters:** QA-844-style assertions ("CSV header includes Tags column") PASS as long as the tag-named column is present and correctly populated. Don't fail the case looking for a literal "Tags" header.
- **Affected:** export-csv skill; QA-844, QA-27292, tag-export tests.
- **Revisit if:** product consolidates tags into a single column.

### Twitter embedded post tooltip can render empty (no oEmbed) (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-22296 re-run batch-1 QA-923, Amazon Prime Video Twitter)
- **Behavior:** Hovering a Twitter post Type link opens the embedded-tooltip frame, but the tweet embed stays blank (white box + X) even after several seconds, whereas Instagram embeds populate fine (after a ~4s lag).
- **Why accepted (provisional):** Most likely an X/Twitter-platform oEmbed restriction (tweets frequently fail to embed since X API changes), not an LFM rendering defect — parallels the Pinterest blank-embed quirk (QA-929). Treat as observation, not auto-bug.
- **Affected:** QA-923, QA-2042 (FB/Twitter embedded tooltip tests).
- **Revisit if:** LFM switches to a server-rendered tweet preview, or X embeds start working.

### APV Brand>Content post-table renderer transient (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-22296 re-run batch-1 QA-923)
- **Behavior:** Amazon Prime Video (brand_id=25864) Brand>Content post table stays skeleton >15-20s on first paint per channel; `location.reload()` recovers it. Seen on both Twitter and Instagram channels this run.
- **Why accepted:** dev-env stability family (cf. APPS-55565); recovers on reload.
- **Affected:** any APV Brand>Content case.
- **Revisit if:** first-paint render stops needing a reload.

### TWC/DS brand typeahead needs a REF-based focus click (not coordinate / value-setter) (NEW 2026-06-13)

- **First observed:** 2026-06-13 (QA-4325 re-run QA-298, Hulu/Yash session)
- **Behavior:** On the TWC (and Data Studio) "Search for a Brand" typeahead, coordinate `left_click` + `type` and even the React `value`-setter + dispatched `input` event leave the field effectively unfocused — the value may set but the **Results dropdown never renders**, so the brand can't be added. Repro'd across two fresh tabs.
- **Fix:** `find` the "Search for a Brand" textbox → `left_click` by **ref** (this properly focuses it) → then `type` the brand name; Results render normally and the exact-match row is selectable (Rule 1). Same ref-click approach fixes metric checkboxes and Run Report.
- **Why accepted:** automation-only focus quirk (real users click+type fine); session-dependent (worked via coord earlier in the 2026-06-13 QA-22296 run, failed in the later Hulu/Yash session).
- **Affected:** time-window-comparison-run, data-studio-post-level-run, any brand-picker flow.
- **Revisit if:** Chrome MCP coordinate clicks reliably focus React inputs.

## 2026-06-13 (run 2, TWC cluster)
- **Account-switch dropdown is hover-driven**: to automate, remove `.is-hidden` from `.navigation-controls-user .navigation-menu-dropdown`, set the Search Account input via React value-setter + `input` event, then dispatch mousedown/mouseup/click on the `.lfm-ta-option` row. Coordinate clicks on the LFQA header or option rows silently no-op.
- **TWC brand typeahead options** are `.lfm-ta-option` inside `.typeahead-options-list` (`.account-name` child). Same event-dispatch pattern when real clicks miss.
- **controlled-check-box state**: `aria-checked` lives on a CHILD element, not always the `span.controlled-check-box` itself — read `span.querySelector('[aria-checked]')`; toggle via dispatch on the inner `label`.
- **In-page XLS verification**: the extension blocks large base64 strings in JS results; instead parse the xlsx inside the page (manual zip walk + `DecompressionStream('deflate-raw')` on `xl/worksheets/sheet1.xml` + sharedStrings) and compare to CSV in-page.
- **Weekly relative TWC** shows a "Choose the Ending Day of Weekly Intervals" modal after Run Report (default: Use the Weekday of Each Brand's Key Date); it also prints the resolved campaign window — use it to verify Start/End math.
- **TWC graph no-data convention**: absent bar + `<title>No Data</title>` on the axis label (brand-name title otherwise); en-dash appears only in tables.
- **Channel banner img regression (intermittent)**: TWC story/preview can render `img.channel-banner-img` with `src=null` (empty box, label missing) instead of font-icon + label; re-render fixes it. Watch in Preview & Share checks (QA-19482 BUG-3).
- **Months-interval TWC header label** shows only the start month ("June 2025") — Days/Aggregate show full spans (QA-457 BUG-4).
- **Extension idle drop**: after long idle, all tab calls return "No tab available" — recover with `select_browser` + `tabs_create_mcp`; previous tab IDs may land in a different tab group (navigate refuses), so continue in the fresh tab.
- **Metric rename drift**: "Average/… Responses per Post" no longer exists — "Responses" → "Engagements" family (affects QA-457-era specs).

## 2026-06-13 (run 3+4)
- **Audience/Insights tile PNG export**: header = LISTENFIRST logo → Brand Name → tile title; footer (bottom of PNG) = Tab Name ("Brand Audience"/"Brand Insights") + "Date: <start>-<end>". To verify PNG contents, capture the image/png blob via the createObjectURL hook and render it in a full-screen overlay <img> (scroll top→bottom) — base64 in JS results is blocked.
- **Filename format (exports)**: single-hyphen separators (`Brand-Tab-Chart-YYYY-MM-DD-YYYY-MM-DD`); colons in chart names stripped; `.png`/`.csv` not always in the anchor download attr though blob MIME is correct. Don't flag as a bug per Rule 6.
- **Social Recap "Social Footprint - All-Time" async tile can hang forever** (AsyncPoller polls every ~60s, never resolves, no console error) → keeps the **Preview & Share Report** button disabled (spinner) → blocks the entire PDF preview/download/share flow. Hit on Adam Orfei + ListenFirst (Authorized), 3/3 reloads (QA-23969 blocker bug). Any Social Recap PDF case may be blocked by this; try a lighter brand or wait 10+ min.
- **CSV by graph type**: Area/Line/Bar → time-series CSV (Date,Brand,Channel,Metric); Table → flat CSV (Brand,Channel,Metric — no Date).

## 2026-07-09 (QA-49908)
- **`app-reporting.lfmdev.in` story pages can hang forever on "Loading..."** with a console `net::ERR_HTTP2_PROTOCOL_ERROR` on a required vendor JS bundle (`reporting-vendors-<hash>.js`), reproduced 2x in a row on a direct historical-story URL (`#story/follower_demographics/<id>`). Workaround: open a second tab to the same URL and close the stuck one — the fresh tab's asset fetch had apparently completed by then, and it renders correctly. Not filed as a bug (looks like an HTTP/2 multiplexing flake against the CDN, not app logic), but re-check if it starts blocking more than one report family.
- **Follower Demographics "new report" builder is `#/follower_demographics`** (no `story/` segment) — navigating to `#story/follower_demographics` with no numeric ID does NOT open the builder; it silently redirects elsewhere (observed landing on Time Window Comparison). Always reach the builder via the Reporting nav-menu link, or use the `#/follower_demographics` hash directly.
- **Historical (People Pattern) vs current (Audiense) Follower Demographics exports differ structurally, not just numerically**: the historical CSV lacks a YouTube channel block entirely (columns absent, not just blank), and the current export adds an "Organizations" gender-split bucket the historical one has no column for at all. Any diff-check between the two should compare column sets first, values second.
