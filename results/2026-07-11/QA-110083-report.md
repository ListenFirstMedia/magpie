# QA-110083 — Settings > Audit – Brand Set Created – Audit Actions Functionality

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Account:** Adam Orfei (account_id=54)
- **Identity:** `lfiqa@listenfirstmedia.com` (config/.env) → Actor renders as **LFQA Testing**
- **Skills reused:** `settings-audit-logs` (v2, Brand Set Created/Deleted enum) + `dashboard-mutation-flows` (mutation + cleanup discipline)
- **Type:** MUTATING (create + delete a brand set) — cleanup executed
- **Verdict:** **PASS (6/6)**

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Settings → Audit (`#audit?account_id=54`) | Loaded; 7-col table rendered (Date, Customer, Business Unit, Account, Actor, Activity Type, Description). |
| 2 | Note current audit state | Latest pre-existing row: `Sat Jul. 11, 2026 05:51 AM PDT / Brand Edited / Brand Family Guy's metadata was edited.` (prior day top: Thu Jul. 09 09:56 PM User Deactivated Test 7536). |
| 3 | Brand Sets → Create a Brand Set → Basic Info: name + Add Brands (2) | Name `qa-110083-pw-2026-07-11-1718`; brands **16 and Pregnant \| MTV Deutschland** + **2021 MTV Movie & TV Awards: Unscripted** (both TV Shows). |
| 4 | Save (Review → Finish) | Success ("Hooray!!! You've successfully created a brand set."); `brand_set_id=11671`. |
| 5 | Return to Settings → Audit; widen range to include today (07-05→07-11) | New row surfaced at top of table. |
| 6 | Verify Brand Set Created row | Present with correct Activity Type. |
| 7 | Verify Description references brand-set name | Name present verbatim (rendered as entity deep-link). |
| 8 | Cleanup — delete test brand set + verify Deleted audit row | Deleted via Actions → Delete → confirm "Ok"; list empty; `Brand Set Deleted` audit row present. |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | A new Audit row exists post brand-set creation | Row `Sat Jul. 11, 2026 10:21 AM PDT … Brand Set Created … qa-110083-pw-2026-07-11-1718 was created.` appears at top of audit table | PASS |
| A2 | 6 | Activity Type contains 'Brand Set Created' | Activity Type column = **Brand Set Created** | PASS |
| A3 | 7 | Description contains the new brand-set name (and actor) | Description = `Brand Set qa-110083-pw-2026-07-11-1718 was created.` — name verbatim, rendered as a clickable entity deep-link. Actor carried in the dedicated **Actor** column (templated description does not embed the actor name — see note) | PASS |
| A4 | 6 | Date column matches creation timestamp | Row dated `Sat Jul. 11, 2026 10:21 AM PDT` = 17:21 UTC; Finish/save fired 17:21:43 UTC — match | PASS |
| A5 | 6 | Actor column populated with current user's name | Actor = **LFQA Testing** (the config/.env `lfiqa` login), rendered as a link | PASS |
| A6 | 8 | After cleanup, a "Brand Set Deleted" Audit row exists | Row `Sat Jul. 11, 2026 10:23 AM PDT … Brand Set Deleted … Brand Set qa-110083-pw-2026-07-11-1718 was deleted.` present | PASS |

### Evidence (exact audit rows)

```
Sat Jul. 11, 2026 10:23 AM PDT | ListenFirst | ListenFirst | Adam Orfei | LFQA Testing | Brand Set Deleted | Brand Set qa-110083-pw-2026-07-11-1718 was deleted.
Sat Jul. 11, 2026 10:21 AM PDT | ListenFirst | ListenFirst | Adam Orfei | LFQA Testing | Brand Set Created | Brand Set qa-110083-pw-2026-07-11-1718 was created.
```

Screenshots (`.playwright-out/QA-110083/`):
- `audit-initial.png` — pre-test audit table
- `brand-sets-list.png`, `create-step1.png`, `create-step2.png`, `step2-mtv-search.png`, `step2-selected.png`, `step3-review.png`, `step4-created.png` — create wizard end-to-end
- `audit-created-row.png` — Brand Set Created audit row (A1–A5)
- `brand-set-search.png`, `actions-menu.png`, `delete-confirm.png` — cleanup delete flow
- `audit-deleted-row.png` — Brand Set Deleted audit row (A6)

### Note on A3 (Description vs Actor)
The audit Description column is templated as `Brand Set <name> was created.` — it embeds the **brand-set name** but not the actor's name. The **actor** is a separate dedicated column (A5), populated with `LFQA Testing`. Both facts the assertion cares about are present; the "and actor" phrasing in the spec maps to the Actor column, not to text inside Description. No discrepancy filed.

### Notable observations (not defects)
- **Actor is "LFQA Testing"**, not "Yash Sharma" as in the 2026-06-04 batch-8 run. Expected: this headless track authenticates as the `config/.env` identity (`lfiqa@…`); the earlier run used a different SSO identity. Not a regression.
- **Create wizard Basic-Info name input:** `.fill()` and React value-setter + synthetic `input` events did NOT enable the Next button; only real keystrokes (`pressSequentially`) **followed by a blur (Tab)** committed the value and enabled Next. (Selector: `input[placeholder="Enter Brand Set Name"]`; Next = `button[data-ui-name="settings:_brand_set_step_1.next_button"]`.)
- **Add-Brands step:** brand-selection uses `td.al-table__check` checkboxes in `.al-table__row`; a middle **"Move →"** button (`button.al-button--tertiary-button.small`, first/enabled instance) moves checked brands into the Selected pane. ≥2 brands required.
- **Newly-created brand set shows an onboarding icon** with Total Brands "–" ("allow up to 1 to 24 hours to view"), but is immediately deletable and the audit row is generated instantly.
- **Delete confirm modal:** `Are you absolutely sure you want to delete your brand set "<name>"? Click "Ok" to continue.` → `button.modal-accept-button`.

## Known bugs checked
- **Case file:** no `## Open linked bugs` section present (older cached format). 
- **bug-history.md (QA-110083):** Open bugs (0) — _None._ → screen passed, case run normally.
- **During run:** no linked/known bug applies; audit-trail generation and cleanup both worked. APPS-54603 (same-tab URL-replace) not exercised (not part of this case). Prior-known Brand>Insights renderer hang N/A to Audit/Brand Sets. No interference with any assertion.

## Bugs filed
None.

## Cleanup
Test brand set `qa-110083-pw-2026-07-11-1718` (id 11671) **deleted** and confirmed gone from the Brand Sets list; corresponding `Brand Set Deleted` audit row verified. No orphan left.
