---
name: embedded-post-tooltip
version: 1
last_verified: 2026-07-02
last_passed_run: 2026-07-02
trust: untrusted
pass_streak: 1
preconditions: [brand-content-in-table-view]
postconditions: [embedded-post-tooltip-verified]
inputs: [brand_id, channel]
outputs: [tooltip_rendered, tooltip_pin_href]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content — Embedded Post Tooltip (Type column)

Verifies the hover-triggered embedded post tooltip on the **Type** column of Brand > Content **Table View**. The tooltip embeds the actual social post (via the channel's own embed widget). Feature origin: APPS-2107 ("Create Embedded Post Tooltip"), APPS-8258 ("Limit Embedded Post Tooltip to One Item at a Time").

Used by:
- **QA-929** — Pinterest Content - Embedded Post Tooltip (Sephora, Pinterest, Table View)
- Any test asserting the Type-column post preview tooltip.

## Preconditions
- Be in **Table View** (`i.lf-table-view`) so the `Type` column shows post-type links.
- Table View headers include `Type` at column index 4 (Rank, Date, Channel, Brand, **Type**, Live, Publish Type, Paid, Sponsor, Collaborated, Text, …).

## Key selectors
- **Type-column link:** `div.label-blob[data-ui-name="type_column"] > a` — the `<a>` has `target="_blank"` and `href` = the canonical post URL (e.g. `https://www.pinterest.com/pin/<id>`). The `.label-blob` class also carries the post type (`video` / `image` / etc.).
- **Tooltip container:** `div.embedded-post-tooltip` — `position:absolute`, `z-index:999`, appended near the row. **Exactly one exists at a time** (single-tooltip guarantee).
  - Close X: `div.close-row > i.fas.fa-times.close-embed` (click the **`i.close-embed`** directly; clicking the `.close-row` wrapper can miss the small icon).
  - Body: `div.embedded-post-tooltip-body > div[id^="embedded-post-"]` containing `<a data-pin-do="embedPin" href="…">` (the platform embed widget renders into this).

## Steps
1. Tag the Type-column links: `document.querySelectorAll('.label-blob[data-ui-name="type_column"] a')`.
2. `browser_hover` a link (trusted hover triggers the tooltip natively — no synthetic events).
3. Wait ~2s; read `div.embedded-post-tooltip`. Its `textContent` includes the post caption (matches the row's Text column). For Pinterest the image renders inside the embed; the caption text is present in the container's textContent.
4. Verify assertions below.

## Assertion recipes
- **Displays on hover:** `.embedded-post-tooltip` becomes visible after hover.
- **Only one at a time / no stacking:** hover a second link → still exactly one `.embedded-post-tooltip`; its content changes to the new post (the prior one is replaced, not stacked).
- **Closes on X:** click `i.close-embed` → container removed/hidden.
- **Closes on click-away:** click any neutral page element → container removed/hidden.
- **Click opens correct post:** clicking the Type `<a>` opens a new tab at its `href` (`target="_blank"`); the new tab's post matches the tooltip's pin. Verify via `browser_tabs list` (new tab URL + title). Close the extra tab afterward.
- **Image + text match:** the tooltip caption == the row's Text column; the embedded image == the post's media.

## Known finding — empty tooltip when the external post is unavailable (QA-929, 2026-07-02)
The tooltip is built from the **platform's live embed widget** (`data-pin-do="embedPin"` for Pinterest). If the referenced post no longer exists externally, the widget never renders and an **empty ~370×350 white box** (only the X) is shown.
- Detection: `.embedded-post-tooltip` present but `textContent` empty AND no `img`/`iframe` rendered inside.
- Confirm the external cause: open the pin `href` in a new tab — an unavailable Pinterest pin **redirects to `pinterest.com/ideas/`** (valid pins load a real pin page).
- This reproduces closed bug **LFMP-31385** ("Empty Embedded Post Tooltip is displaying while hovering"). The embed id also carries a suspicious `-undefined` suffix (`embedded-post-<hash>-undefined`). Per QA-929's NOTE ("check … no external pin; if any, raise a bug"), document it as a finding — do not auto-file.
- In dev, many seeded posts (esp. empty-caption ones) have pin IDs that don't map to live pins, so empty tooltips are common there; still report the pattern.

## Failure signatures
| Signature | Interpretation | Action |
|---|---|---|
| No `.embedded-post-tooltip` after hover | Hover didn't land on the `<a>`, or Table View not active | Re-hover the exact `type_column` anchor; confirm Table View |
| `.embedded-post-tooltip` empty (no img/iframe) | External post unavailable OR embed failed to load | Open pin href in new tab; if it redirects to `/ideas/`, external pin gone → document per LFMP-31385 |
| Two tooltips visible | Single-tooltip guarantee broken (APPS-8258 regression) | FAIL A2/A4; capture |
| Clicking `.close-row` doesn't close | Missed the icon | Click `i.close-embed` directly |

## Changelog
- **v1** (2026-07-02): Initial skill from QA-929 (Sephora / Pinterest / Table View). Verified A1–A6 PASS; documented empty-tooltip finding for unavailable external pins (LFMP-31385 symptom).
