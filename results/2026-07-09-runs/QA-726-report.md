# QA-726 — Content Tagging - Character limit

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Brand:** Disney Channel (brand_id=3877), YouTube-only
**Skill used:** [brand-content-tag-post](../../skills/brand-content-tag-post/SKILL.md) v1 (popup structure only — no mutation performed, see below)

## Steps executed

1. Brand → Content, searched "Disney Channel", clicked the exact-match "Disney Channel" typeahead result (not any of the `Disney Channel (Africa/Espana/France/...)` international variants).
2. Selected YouTube-only channel via the channel selector + Apply. URL confirmed `channels=youtube`.
3. Clicked the per-post **Tag** link on post #1 (`Miraculous: Tales of Ladybug and Cat Noir...`, Jul 03 2026). Note: the page also has a toolbar-level "Tag ▾" button (Bulk Tag / Upload Tags / Manage Tags) with an identical accessible name "Tag" — first click attempt hit that one by mistake; corrected by targeting the specific per-post Tag span.
4. Add-tag popup opened. Confirmed input: `placeholder="Please enter up to 100 characters"`, `maxlength="100"`.
5. Typed a 150-character string via `pressSequentially` (character-by-character, to trigger any live validation handlers): `qa726-this-is-a-deliberately-long-tag-value-that-is-intended-to-exceed-the-one-hundred-character-limit-by-a-fair-margin-so-we-can-verify-the-limit`.
6. Read the input's actual `.value` and `.value.length` after typing.
7. Closed the popup via the × control — **no tag was added** (no click on "Add"), since the assertions only concern the input's built-in limit behavior, not a persisted tag.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Add-tag message box states `"Please enter up to 100 Characters"` | Input placeholder text: `"Please enter up to 100 characters"` — matches except capitalization (spec has `100 Characters`, app has `100 characters`) | ✅ PASS (cosmetic case difference noted, not filed — see note) |
| A2 | 8 | Total typed cannot exceed 100 characters | After typing 150 characters via `pressSequentially`, `input.value.length === 100` exactly — the DOM `maxlength="100"` attribute hard-stopped further input at the 100th character (`"...one-hundred-character-lim"`, cut mid-word) | ✅ PASS |

## Note on A1 capitalization

Spec text: `"Please enter up to 100 Characters"` (capital C). Actual UI: `"Please enter up to 100 characters"` (lowercase c). Per Rule 5, re-reading the spec: this is almost certainly a transcription artifact in the Jira ticket (title-casing "Characters" is an easy typo when writing test steps), not evidence of a real product string change. Documented, not filed as a bug — case-only text mismatches with no functional impact are exactly the kind of finding this project's Rule 5 examples (BC-2/BC-3) warn against over-filing.

## Result: ✅ PASS (2/2 assertions)

## Bugs filed

None.

## Cleanup

Not applicable — no tag was ever submitted (Add was never clicked); the popup was closed via ×. No mutation occurred on the post.
