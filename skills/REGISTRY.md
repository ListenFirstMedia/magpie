# Skill Registry

Index of every skill in this project, with its current trust state and last verified date.

| Skill | Version | Trust | Last verified | Pass streak | Notes |
|-------|---------|-------|---------------|-------------|-------|
| [switch-account](switch-account/SKILL.md) | 2 | untrusted | 2026-05-13 | 5 | Recent-Searches-vs-Results warning. Verified across many switches (Hulu, Adam Orfei, Viacom) |
| [time-window-comparison-run](time-window-comparison-run/SKILL.md) | 4 | untrusted | 2026-05-13 | 4 | v4: Aggregate interval + Cohort/Competitor Average overlay-line behavior |
| [keydate-picker](keydate-picker/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | Season/Episode chained Auto-Select for TWC Relative Dates |
| [data-studio-post-level-run](data-studio-post-level-run/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | Data Studio → Post Level → metric picker → Go |
| [audience-metrics-export](audience-metrics-export/SKILL.md) | 1 | untrusted | 2026-05-13 | 0 | Download capture not yet solved — see skill doc |
| [brand-content-data-set-selector](brand-content-data-set-selector/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | Custom Data Set dropdown on Brand>Content. Ordering bug flagged |
| [brand-content-table-view](brand-content-table-view/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | **NEW from QA-533.** Layout selector (Table/Grid/Detail) + ellipsed-text extraction via `title` attribute |
| [data-collection-ad-account-status](data-collection-ad-account-status/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | **NEW from QA-127567.** Settings → Data Collection → brand/channel/page → Expand Ad Accounts |
| [settings-audit-logs](settings-audit-logs/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | **NEW from QA-20337.** Settings → Audit table read + format-validation patterns |
| [historical-twc-story-load](historical-twc-story-load/SKILL.md) | 1 | untrusted | 2026-05-13 | 1 | **NEW from QA-329.** Load existing TWC story by ID + verify saved settings via Change Settings dialog |
| [export-google-sheets](export-google-sheets/SKILL.md) | 2 | untrusted | 2026-05-13 | 1 | MCP tab-group caveat + window.open hook |
| [export-csv](export-csv/SKILL.md) | 2 | untrusted | 2026-05-18 | 3 | v2: server-side queued exports go through CDN `analytics-cdn.lfmdev.in` — read filename from the Recent Activity bell, then `fetch(url, {credentials:'include'})`. Filename bug BC-2 documented. Also verified working on Brand>Insights tile pipeline (filename correct there, contrasts with Brand>Content). |
| [data-studio-historical-limit](data-studio-historical-limit/SKILL.md) | 1 | untrusted | 2026-05-18 | 1 | **NEW from QA-83835.** 365-day max range auto-shift on Custom date picker. Both directions verified. |
| [brand-insights-interval-picker](brand-insights-interval-picker/SKILL.md) | 1 | untrusted | 2026-05-18 | 1 | **NEW from QA-134174.** Interval (Daily/Weekly/Monthly/Quarterly) + Make-a-Selection (Auto) defaults on Brand>Insights date overlay. |
| [data-studio-multi-perspective](data-studio-multi-perspective/SKILL.md) | 1 | untrusted | 2026-05-18 | 1 | **NEW from QA-86318.** Add same brand twice in Data Studio for Public vs Authorized comparison. Legend pattern `<Brand> [P]` vs `<Brand>`. |
| [brand-content-filter](brand-content-filter/SKILL.md) | 1 | untrusted | 2026-05-18 | 1 | **NEW from QA-91412.** Generic Filter dropdown on Brand>Content (Publish Type, Collaborator Name, etc.). URL `filters` JSON encoding documented. |
| [text-input-wrap-tooltip](text-input-wrap-tooltip/SKILL.md) | 1 | untrusted | 2026-05-18 | 1 | **NEW from QA-95226.** Wrap vs truncate-with-title-tooltip pattern across 4 search contexts. |
| [chart-hover-tooltip](chart-hover-tooltip/SKILL.md) | 1 | untrusted | 2026-05-18 | 0 | **NEW (scaffold) from QA-96670.** JS-based Recharts hover-event sequence to capture tooltip text. Not yet executed end-to-end. |
| [response-rate-math-verifier](response-rate-math-verifier/SKILL.md) | 1 | untrusted | 2026-05-18 | 0 | **NEW (scaffold) from QA-129801/802/673.** Per-day + aggregate RR math verifier with UI/Sheet cross-source compare. Needed for Wasserman trio. |
| [dashboard-mutation-flows](dashboard-mutation-flows/SKILL.md) | 1 | untrusted | 2026-05-18 | 0 | **NEW (scaffold) from QA-84202/85175/115037/16775/116177.** ⚠ MUTATING — requires user OK. Create/drag-drop/delete dashboards + sentiment tagging variant. |
| [view-perspective-toggle](view-perspective-toggle/SKILL.md) | 1 | untrusted | 2026-05-20 | 1 | **NEW from QA-91412 retraction.** Critical Public/Authorized toggle skill. Never trust URL `perspective` param — always click toggle + confirm via screenshot. |
| [social-recap-report-run](social-recap-report-run/SKILL.md) | 1 | untrusted | 2026-05-20 | 1 | **NEW from QA-23969.** End-to-end Social Recap report flow: brand add (Rule 1 exact-match), perspective toggle (Rule 2), options, Run, Preview, Download (defers verification to LFIQA per Rule 6). Cross-subdomain quirk documented. |
| [pdf-end-to-end-verification](pdf-end-to-end-verification/SKILL.md) | 1 | untrusted | 2026-05-20 | 1 | **NEW from QA-23969.** Genuine end-to-end PDF verification via `pdftoppm` rasterization + image reading. Replaces the DOM-signal approach that caused BC-2 false positive. Used to confirm BC-4. |
| [brand-content-tag-post](brand-content-tag-post/SKILL.md) | 1 | untrusted | 2026-05-20 | 1 | **NEW from QA-1677.** ⚠ MUTATING — add/remove tag flow. React `form_input` for input field, 4th `toggle-switch-checkbox` for Include/Exclude chip, Delete-All-Tags cleanup pattern. |
| [time-window-comparison-run](time-window-comparison-run/SKILL.md) | 4 | untrusted | 2026-05-20 | 5 | **+1 from QA-19482.** Cross-account flow re-verified: 2 brands (MTV + All NBA), 2 channels All On (FB+Twitter), full Options checkboxes including Cohort Average, Highlight Leader, Source Links, Insights Editor — all rendered correctly in preview. |
| [data-collection-brand-popup](data-collection-brand-popup/SKILL.md) | 1 | untrusted | 2026-05-20 | 1 | **NEW from QA-2498.** Brand → Channels → Pages drill-down with hover popups. Documents the "Not Collecting (N)" header format, Learn More Zendesk href, and spec variances around Reauthorize button count + Page Summary columns. |

## Trust lifecycle

- **untrusted** — newly created; every use is flagged in the report; no auto-updates allowed
- **stable** — has passed 3+ runs on separate days; auto-update allowed for fallback-promotion only
- **quarantined** — failed in ways that look like skill drift but couldn't be auto-fixed; needs human review

**Note:** Several skills now have pass_streak ≥ 3, but all runs occurred on the same day (2026-05-13). They remain `untrusted` until 3 successful runs on **separate** days per the architecture rule.

## Shared resources

- [_shared/selectors.md](_shared/selectors.md) — cross-flow stable selectors (header, nav, common widgets)
- [_shared/assertions.md](_shared/assertions.md) — reusable assertion patterns and normalization rules
- [_shared/network-patterns.md](_shared/network-patterns.md) — known API endpoints and what they should return for healthy responses
