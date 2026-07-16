# QA-48160 — Settings > Brands - Basic Info - Edit Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP) — **MUTATING**
- **Account:** Hulu (account_id=336)
- **Brand edited:** "11.22.63" (brand_id=17738, low-stakes Hulu show)

## Verdict: PASS (edit works) — with a NEW BUG found + partial cleanup

## Known bugs checked (refined open-bug rule)
- **APPS-59449** (Open) — channel validation error only on blur. The case's optional sub-flow A5 explicitly tolerates it; not exercised this run. Non-blocking.
- **APPS-61494** (In Progress/Code Review) — "Settings > Brands not working properly while *creating* a brand" (error popup on create). Scoped to **create**, not edit → judged non-interfering. **Confirmed:** on edit-save, **no error popup appeared** — the create-bug did not affect the edit flow.

## Steps executed
1. Settings > Brands — list loaded with editable rows (A1 ✓).
2. Row Actions (⋮) → Edit → brand edit wizard opened (Basic Info / Channels / Review) exposing Name, Type, Industry, Genre (A2 ✓). (Note: on a *roll-up* brand like "1266 Talent Roll-Up", ⋮→Review opens the brand-**set** detail — those are brand sets, not single brands; used the single-brand "11.22.63" instead.)
3. Appended marker → Brand Name "11.22.63 qa48160" → Next → Next → Finish → **"Success! You've successfully updated your brand."** Reopened edit: field persisted as "11.22.63 qa48160", and brands list showed "11.22.63 qa48160" (A3 ✓ — valid edit saved without errors, persists on row + modal).
4. **Cleanup:** attempted to revert Name to the exact original "11.22.63" → **blocked** (see bug). Per user direction, saved a suffixed variant **"11.22.63 (Hulu)"** (on-convention, matches sibling "1266 (Hulu)"), which passed uniqueness and saved. Brands list now shows **"11.22.63 (Hulu)"** — the raw `qa48160` test marker is removed.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Brands list loads with editable row | loaded, ⋮ actions present | PASS |
| A2 | Edit page exposes Basic Info fields | Name/Type/Industry/Genre wizard | PASS |
| A3 | Valid edit saves; shows on row + modal re-open | "11.22.63 qa48160" saved & persisted | PASS |
| A4 | Cleanup revert restores ORIGINAL value | **Could NOT restore exact "11.22.63"** (uniqueness bug); saved near-name "11.22.63 (Hulu)" instead | PARTIAL |
| A5 | (optional) invalid handle error only on blur (APPS-59449) | not exercised | N/A |

## NEW BUG FOUND (documented here only — not filed to Jira)
**Brand-name uniqueness validation blocks reverting a brand to its own original name.** After renaming brand 17738 from "11.22.63" → "11.22.63 qa48160" and saving, attempting to rename it back to "11.22.63" is rejected with *"Heads up! Looks like that name is already taken. Be sure to enter a unique name for your brand,"* and the **Next button stays disabled**. Persisted across multiple fresh reloads and a ~30 s+ backend-reindex wait. No other owned brand named "11.22.63" exists (only this one). → The uniqueness check does **not exclude the brand being edited** (or does not release the brand's prior name), so a brand **cannot be renamed back to its own original name**. Repro: Settings > Brands > edit any brand > append text > Finish > edit again > remove the appended text (back to original) > observe "already taken" + disabled Next. Adding any *other* prefix/suffix (e.g. "(Hulu)") saves fine, confirming the block is exact-string-only.

## Cleanup status (IMPORTANT)
Brand **17738's true original name was "11.22.63"**; it is currently **"11.22.63 (Hulu)"**. Exact restoration is impossible via the UI due to the bug above — **restore "11.22.63" directly via DB/admin if the exact original is required.**

## Evidence
- `.playwright-out/QA-48160-brands.png`, `QA-48160-editform.png`, `QA-48160-saved.png`, `QA-48160-revert-step1.png` (the "already taken" error).

## Bugs filed
None to Jira (per policy). New bug documented above for triage.
