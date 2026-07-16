# QA-110083 — Settings > Audit – Brand Set Created - Audit Actions Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54)
- **Type:** Mutating (create + delete a Brand Set)

## Verdict: BLOCKED (entry point NOW FOUND — Settings > Brand Sets → "Create a Brand Set"; blocked at step 2 by the undrivable Available-Brands `controlled-check-box`)

## 2026-07-10 re-run update
The original blocker (couldn't locate the create entry point) is **RESOLVED**: the Brand Set builder is at **Settings > Brand Sets → "Create a Brand Set"** (`#brand-sets/create?step=1`), a 3-step wizard **Basic Info → Add Brands → Review**.
- **Step 1 (Basic Info):** entered a unique name `QA-110083-rerun-0824` (React-controlled input — needs real keystrokes; Next enables after blur). ✅ drove Next → step 2.
- **Step 2 (Add Brands):** the "Available Brands" table lists brands with a per-row **`controlled-check-box`**; "Selected Brands (N)" counter. **Could NOT toggle the MTV row's checkbox** via any method — trusted click on `.controlled-check-box` span / `.controlled-check-box__icon` (role=checkbox), the name cell, focus+Space (real key), and the full synthetic keydown/keypress/keyup Space dispatch all left `aria-checked=false` and "Selected Brands (0)". This is the documented `controlled-check-box` React-revert quirk (see `knowledge-base/known-quirks.md`).
- Without ≥1 brand, the wizard can't proceed to Review/Save, so the create (and therefore the Audit A1–A6) still can't complete under automation. **No mutation** — the wizard was abandoned before save.
- **Net:** entry-point blocker cleared; a distinct automation-only checkbox blocker now gates it. Recommend a manual pass (or a checkbox-drive fix) to finish A1–A6; the Audit log itself is confirmed working (QA-107134).

---
### (original 2026-07-09 verdict) BLOCKED — create-Brand-Set entry point not locatable via automation within budget

## Known bugs checked
No open linked bug.

## What was verified
- The **Audit page + log works** (established in QA-107134, same run): rows populate with real activity (Brand Edited / User Edited entries, Actor + Description + timestamp columns).
- The **brand-set picker** (chevron next to the brand-set title) opens a **selection-only list** of existing brand sets (1923 Talent, 2019 BET Awards Sponsors, 2024 Election Candidates, …) — it exposes **no create/"+"/search-to-create** control.

## Why blocked
The test requires **creating a new Brand Set** (name + brands) and then confirming the Audit log records the creation (A1–A5), then deleting it and confirming a delete entry (A6). The **Brand Set creation UI entry point could not be located** via automation:
- Brand Sets > Content page — no create control.
- Brand Sets nav dropdown — only Rankings / Content / Optimization / Partnerships (tabs).
- Brand-set picker (title chevron) — selection list only, no create/manage/"+".

Creating a brand set evidently uses a dedicated Brand Set Builder reached from a path not discovered from these surfaces. Without creating a set, none of A1–A6 (all of which depend on the creation having happened) can be exercised. Per the run's effort-discipline rule, I stopped after a bounded search rather than guess builder URLs (against the UI-navigation rule).

## Assertions
| ID | Expected | Status |
|---|---|---|
| A1 | New Audit row after brand-set creation | BLOCKED (no creation performed) |
| A2 | Activity Type = 'Brand Set Created' | BLOCKED |
| A3 | Description references new brand-set name + actor | BLOCKED |
| A4 | Date matches creation timestamp | BLOCKED |
| A5 | Actor = current user | BLOCKED |
| A6 | 'Brand Set Deleted' row after cleanup | BLOCKED (nothing created/deleted) |

## No mutation performed
Nothing was created or deleted — no cleanup needed.

## Recommended manual re-test
Locate the Brand Set Builder ("Create Brand Set") entry point (likely a dedicated builder page/CTA not surfaced on Brand Sets > Content), create a uniquely-named set, then verify the Audit log shows the creation (Activity Type, Description w/ name + actor, timestamp), delete it, and confirm the deletion row. The Audit log itself is confirmed working (QA-107134).

## Bugs filed
None (no product defect — automation could not locate the create-Brand-Set entry point).
