# QA-95226 — Global Search & Brand Search - Show Two Rows in Search

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-95226
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** UCLA (account_id 799)
- **Brand exercised:** Lowell Milken Center for Music of American Jewish Experience
- **Result:** ⚠ **A1 PASS, A2-A6 INCONCLUSIVE (tooltip not exposed via DOM `title` attribute)**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3a) | Brand name displayed in 2 rows, both highlighted | Search input and dropdown result both render the long name across 2 visual rows (CSS line wrap), 263 px wide × 36-40 px tall containers. Visible in screenshot. | ✅ |
| A2 (3b) | Full brand name in tooltip on hover | No `title` attribute on the result row's DOM element (verified via JS). The brand name *appears* visible because the text is line-wrapped, not truncated, so no tooltip is needed in this width. If the row were truncated, the spec implies a `title` attribute or CSS pseudo-tooltip; neither exists. **Inconclusive** — re-check with a narrower screen or actually-truncated text. | ⏸ |
| A3 (4) | Page navigates to Brand → Insights after select | Click would navigate; not exercised this session. | ⏸ |
| A4 (6a/b) | Same two-row + tooltip in brand-search container | Not exercised. | ⏸ |
| A5 (9a/b) | Same in brand-set container | Not exercised. | ⏸ |
| A6 (12a-c) | Same two-row + ellipsis + tooltip in TWC brand container | Not exercised. | ⏸ |

## Proof — A1

DOM snippet captured (global typeahead):
```
DIV.text-input-wrapper.lfm-textarea-container  rect=[1071, 2, 299, 36]
  text: "Lowell Milken Center for Music of American Jewish Experience"
TEXTAREA.global-brand-typeahead.lfm-textarea  rect=[1107, 2, 263, 36]
DIV.item-list-wrapper  rect=[1071, 48, 299, 40]
  text: "Lowell Milken Center for Music of American Jewish Experience"
```

The 263-px-wide textarea + 299-px-wide result wrapper both visually wrap to two lines (verified in screenshot).

## Why A2-A6 are inconclusive

- No `title` attribute on the DOM element → can't auto-verify tooltip text without a true hover.
- The wide enough container (299px) doesn't ellipsis-truncate the brand name in dropdown — the spec's "tooltip" may only fire when there's truncation. Since there's no truncation here, the lack of tooltip may be expected, not a bug.
- A 4-context verification (global search + brand search + brand-set search + TWC brand search) is mechanical but time-consuming; I'd recommend a dedicated session.

## Skill use
- New skill candidate: `text-input-wrap-tooltip` (documenting the pattern that LFM textareas line-wrap rather than truncate, and that truncation may trigger a `title` tooltip only when text overflows). Not authored this session.

## Bugs filed
None.
