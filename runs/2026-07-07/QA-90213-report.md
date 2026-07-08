# QA-90213 — Data Studio ↔ Brand Content - Twitter Post Likes / Post Replies parity

- **Run date:** 2026-07-07 (interactive recovery run — was no-report BLOCKED in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-90213 · Priority: Major
- **Verdict:** **BLOCKED** — Data Studio (Post Level) **"Go" does not generate the report**, so the DS Sum can't be captured and A1/A2 parity cannot be evaluated. Reproducible across a hard-refresh + rebuild and 6 click techniques.
- **Account:** Adam Orfei (account_id=54) · **Brand:** MTV · **Skills:** switch-account, data-studio-post-level-run

## Open linked bugs
None open (cache 2026-07-03).

## What was set up (correctly)
Reporting → Data Studio → **Post Level** · Interval **Aggregate** · **Add Brand MTV** (View = **Public**) · Post Level Metrics = **Twitter Post Likes** + **Twitter Post Replies** (added via the `controlled-check-box` icons — `aria-checked=true` confirmed for both). Config panel shows all of this; **Go** button is enabled (yellow). Config even persisted across a full page reload.

## The block
Clicking **Go** never renders a result — the right panel stays on **"Add a Brand and a Metric to get started"**, no **Sum** row ever appears. Attempts (all with ~5–6 s waits):
1. Playwright real click ×3
2. JS `element.click()`
3. Synthetic `pointerdown/mousedown/pointerup/mouseup/click` sequence at the button's center
4. Neutralized the overlapping `statuspage.io` status-notification **iframe** (it was intercepting pointer events over Go), then real click
5. **Hard-refresh + rebuild** (per direction) → config re-verified valid → Go still does nothing

DOM after every attempt: `stillPlaceholder: true`, `hasSum: false`, no numeric result cells.

## Assertions
| ID | Expected | Status |
|----|----------|--------|
| A1 | DS "Twitter Post Likes" Sum == Brand>Content "Reactions" Sum | ⛔ Not evaluable — DS Go produced no result |
| A2 | DS "Twitter Post Replies" Sum == Brand>Content "Comments" Sum | ⛔ Not evaluable — DS Go produced no result |

## Evidence
- `.playwright-out/QA-90213/ds-sum.png`, `ds-go2.png` — valid config (MTV Public, both Twitter metrics, Aggregate), Go enabled, right panel still the empty placeholder.

## Assessment / likely bug
The Data Studio **Post-Level "Go" action appears non-functional on Dev** for this configuration — a valid brand+metrics setup does not generate the report. This matches why the 2026-07-04 unattended run produced no report (it would have hung here too). **Recommend a dev-side check / bug** on Data Studio Post-Level report generation. (Not filed as a Jira ticket per policy — flagged here only.)

## Bugs filed
None (markdown-only). Flagged: DS Post-Level "Go" not rendering — needs dev confirmation.
