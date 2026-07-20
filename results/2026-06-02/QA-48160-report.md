# QA-48160 — Settings > Brands - Basic Info - Edit Functionality (re-run, MUTATING)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-48160
- **Run date:** 2026-06-04 (QA-4325 batch-4)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Alex Test 1 (brand_id=422865) — designated test brand
- **Mutation marker:** `Alex Test 1 qa48160-260604-0436` (timestamped)
- **Result:** **PASS** — Edit succeeded, cleanup (revert to original) completed.

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-48160.md`. Open bug APPS-59449 (Minor) — channel-handle validation only fires on blur — was not exercised this run (no invalid channel handle added).

## Reused skills
None directly mapped. Pattern is new (Settings > Brands Edit wizard). Candidate for a future `settings-brands-edit` skill.

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Settings dropdown → Brands → load `app.lfmdev.in/#brands` | PASS |
| 2 | Search "test" → result list filtered | PASS |
| 3 | Click row "Alex Test 1" → brand detail page loads (brand_id=422865, current name "Alex Test 1", Created 03/09/2026, Last Updated 04/06/2026 by Pankaj Nagar) | PASS |
| 4 | Click Basic Info `Edit` → wizard `#brands/edit?step=1` opens with Brand Name input pre-filled, Industry dropdown loading | PASS |
| 5 | Triple-click Brand Name input → type new value `Alex Test 1 qa48160-260604-0436` → Tab to blur | PASS — input visibly updated, no validation error |
| 6 | Click Next → Channels step → YouTube channel + filter `example` shown | PASS |
| 7 | Click Next → Review step → Brand Name in Brand tile reads `Alex Test 1 qa48160-260604-0436` | PASS |
| 8 | Click Finish → success page: "Nice work! You've successfully updated your brand." Title at top shows new name. | PASS |
| 9 | **Cleanup (NON-OPTIONAL):** Navigate back to `#brands/edit?step=1&brand_id=422865`. Use React-aware setter (`Object.getOwnPropertyDescriptor(HTMLInputElement.prototype,'value').set` + `input`/`change` event dispatch) to set Brand Name back to `Alex Test 1`. | PASS |
| 10 | Click Next → Next → Finish | PASS — Success page with title now reading `Alex Test 1` (no suffix) |
| 11 | Navigate to `#brands/detail?brand_id=422865` → verify Brand Name field reads `Alex Test 1`, Last Updated 06/03/2026 01:42 PM PDT by Yash Sharma | PASS — full audit trail visible, mutation occurred and was reverted |

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 1-3 | Settings > Brands list loads with editable brand row | Brand list with 9+ rows on initial scan; `Alex Test 1` available via search | PASS |
| A2 | 4 | Edit wizard opens exposing Basic Info fields | Wizard has 3-step bar (Basic Info → Channels → Review), Brand Name + Industry on Basic Info | PASS |
| A3 | 5-8 | Valid edit can be saved without errors; new value persists on save & on re-open | Brand Name change to `Alex Test 1 qa48160-260604-0436` saved successfully; success page + title reflect new name | PASS |
| A4 | 9-11 | After cleanup revert, original value fully restored | Brand Name field re-shows `Alex Test 1`; Last Updated timestamp + Last Updated By correctly updated to current user (Yash Sharma) at 01:42 PM PDT | PASS |
| A5 | (sub-flow) | Invalid IG channel handle should defer validation until blur (APPS-59449) | NOT exercised this run — no invalid channel handle added | NOT EXERCISED |

## Bugs filed
None new. APPS-59449 (Minor, Open) — channel handle validation timing — neither reproduced nor refuted this run (no invalid handles added).

## New findings (non-blocking)
- The Brand Name plain `triple_click` + Chrome MCP `type` action did NOT reliably update the React-controlled input on this page (the field accepted typing but the React state may not have committed on Tab blur — the Review step rendered with stale state on at least one navigation cycle). **The reliable workaround is React-aware setter**: `Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(input, newVal)` + `input.dispatchEvent(new Event('input',{bubbles:true}))` + `change` event. This pattern is documented in `_shared/selectors.md` for other inputs and now applies to Settings > Brands as well. Worth promoting to a `settings-brands-edit` skill.

## Files
- `testcases/english/QA-48160.md` (spec)
- `runs/2026-06-02/QA-48160-report.md` (this report)
- No exports generated — pure mutation flow.
