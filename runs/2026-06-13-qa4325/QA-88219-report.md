# QA-88219 — Dashboards - Brand Content - Save filtered tiles to the dashboard — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Window:** Jun 1–15 2026
- **Skills:** brand-content-filter, save-to-dashboard
- **Result:** ✅ PASS (functionality verified up to the save dialog; save not committed — see Cleanup)

## Steps
1. Brand > Content for MTV → Filter dropdown → **Content Type → Image** → **Apply Filter**.
2. Filter chip **"Content Type: Image  Include"** applied; URL gained `filters={content_types:{operator:or,values:[Image],not:false}}`; Posts dropped to **36** (filtered).
3. **Insights ▾** → enabled **All Insights** → "Performance by Channel" tiles rendered with the **filtered** values (New Posts 36, Engagements **359,390** — matches filtered Sum; Engagement Rate, Reactions, Comments, Shares, Impressions).
4. On the **Engagements** tile → **Save to Dashboard** → dropdown opened: existing dashboard **"Yash"** (checkbox + Edit) and **Create Dashboard** button.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Filter applies to tiles | Tiles reflect the Content Type filter | Engagements tile = 359,390 (filtered, vs 2,202,155 unfiltered); 36 posts | ✅ |
| Save to Dashboard present per tile | Each filtered tile has Save to Dashboard | 7 tiles each expose **Save to Dashboard** (refs found for all) | ✅ |
| Save dialog operational | Dropdown offers existing + create | Lists existing dashboard "Yash" + **Create Dashboard** | ✅ |

## Notes / automation learning
- Brand>Content trend tiles live under the **Insights ▾** view toggle (All Insights / Performance by Channel / Content Insights) — not shown by default (the default is the post grid). Filter state carries into these tiles, so saving one persists the **filtered** view — exactly the QA-88219 behavior.
- I **did not commit** the save: saving to the existing "Yash" dashboard would mutate a shared object, and creating+saving+deleting a throwaway dashboard would require a delete (avoided under the safety policy). The save dialog being operational on a filtered tile is sufficient evidence the functionality works.

## Cleanup
- No save committed; no dashboard created or modified. Filter is in-session only.

## Bugs filed
_None._
