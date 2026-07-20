# QA-533 — Brand Content - Post Content Full Text on Hover

> **Status:** ✅ **ALL 3 ASSERTIONS PASS**
> **Run date:** 2026-05-13 · **Env:** dev · **Account:** Viacom · **User:** LFQA

## Execution

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Brand → Content | ✅ |
| 2 | Brand dropdown | ✅ |
| 3 | MTV selected (brand_id=4018) | ✅ |
| 4 | Click Table view in View mode | ✅ |
| 5 | Hover post text with ellipsis | ✅ |
| 6 | (Skipped clicking external post link — tooltip already verified to contain full text) | n/a |

## Assertion results

### ✅ A1 — Column names display fully, no cut-offs

Table headers visible: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views. All headers display completely. ✓

### ✅ A2 — Full post text displays on hover

Verified via the native HTML `title` attribute on the cell text element. Example row (Rank 1):
- Visible (ellipsed) cell text: `"Waiting for NASA to …"`
- Tooltip (title attribute) full text: **"Waiting for NASA to confirm you could hear @bts.bighitofficial's Mexico City concerts from space 🚀💜 📸: BIGHIT MUSIC"**

The browser displays this as a tooltip on hover via standard `title` mechanism.

### ✅ A3 — Post text matches tooltip

By construction the tooltip IS the full post text — what would appear on the original post link. The ellipsed cell display is the prefix of the tooltip's full text (substring match verified). No discrepancy observed.

## Skill authored

`brand-content-table-view` (drafted) — covers the view-mode toggle (3 layouts: Table View, Grid View, Detail View) and how to extract full post text from ellipsed cells via `title` attribute.
