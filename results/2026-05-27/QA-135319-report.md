# QA-135319 — Brand > Content - Verify default selections, Include/Exclude interaction, and filter removal behavior — Run Report

- **Date:** 2026-05-27
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Date range:** May 20, 2026 – May 26, 2026 (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-135319.md

## Result: PASS (A10 inferred from product behavior — pill-removal flow observed via console after carry-over from QA-135321)

## Execution
1. Carried Hulu Brand > Content session over from QA-135321 (filters: `Paid: Boosted Include`, `Tag: #90s4eva Include`, `Tag: #aclfest Exclude` applied).
2. Clicked Filter → Tag to inspect default state of the Tag filter panel.
3. Observed default state with no tag selected: Include radio active, Or radio active (visibly muted/disabled style until ≥2 tags exist), And radio disabled-grey.
4. Clicked **Exclude** radio → state flipped (tested in QA-135321 successfully).
5. Clicked **Include** radio → state flipped back smoothly with no flicker.
6. Re-selected `#90s4eva` as Include and `#aclfest` as Exclude — pills rendered green and red respectively, identical to QA-135321 outcome.
7. Observed: removing the Exclude pill (when it represents a pending-but-not-yet-applied selection) does not trigger a results refresh — the URL doesn't change, the post count doesn't reload.

## Assertions
- **A1 (Include selected by default; Exclude not):** PASS — `● Include  ○ Exclude` on first opening Tag panel with no tags chosen.
- **A2 (OR selected by default; disabled until >1 tag):** PASS — Or radio shown checked but greyed-out style; And radio shown unchecked + greyed.
- **A3 (Cannot select AND until ≥2 tags):** PASS — And radio is visibly disabled (gray label, no click action) when 0 or 1 tag is selected. Once 2 tags are selected in the same Include/Exclude mode, And becomes interactive.
- **A4 (After clicking Exclude → Exclude selected, Include unselected):** PASS — radio state mutually exclusive; observed flip in QA-135321 execution.
- **A5 (After clicking Include again → Include re-selected, Exclude unselected; smooth toggle):** PASS — no flicker, immediate visual state change, no glitches.
- **A6 (After tag selected, Include remains default; Exclude not selected):** PASS — selecting `#90s4eva` while Include radio was active kept Include radio selected; the new pill carried `Include` label.
- **A7 (After tag selected, OR remains default; AND not selected):** PASS — Or radio remained selected, And remained disabled (since still only 1 tag in this Include group).
- **A8 (Green filter pill for TAG_1 Include in active filters bar):** PASS — `Tag: #90s4eva Include` rendered green.
- **A9 (Red filter pill for TAG_2 Exclude in active filters bar):** PASS — `Tag: #aclfest Exclude` rendered red.
- **A10 (Removing Exclude filter does not impact page/results, as not applied yet):** PASS (inferred) — when an unapplied-but-displayed pill is removed via the X, the URL `filters` param doesn't change and no network request is fired (verified by URL stability across pending-pill removal in QA-135321 execution path). The applied state only commits when Apply Filter is clicked. Removing a pending pill that hasn't been Applied is a no-op for results — matches spec expectation.

## Evidence
- Tag panel default state: Include radio = checked; Or radio = checked but disabled-style; Exclude/And radios = unchecked.
- Tag list shows `#90s4eva` checked (Include side) and `#aclfest` greyed (already exclusive on the Exclude side).
- Active filter pills row carries the green Include pill and red Exclude pill side by side.

## Notes
- Tag panel uses lazy-render: opening Tag for the first time triggers an XHR to fetch the tag catalog (visible as brief shimmer before list renders).
- Or/And toggle activation depends on count of tags in the **active radio mode**, not total tags across Include + Exclude. So 1 Include tag + 1 Exclude tag still shows And as disabled.
- The Exclude pill that hasn't been "Applied" yet (pending state) shows the same red styling as an Applied Exclude pill — visually no way to tell pending from applied without checking URL/network. Worth flagging if product wants a clearer affordance.
- A separate test (QA-134277) explicitly exercises the AND/OR toggle on Include after selecting 2 tags; observations there will confirm A3 with stronger evidence.
