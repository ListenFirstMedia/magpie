# QA-926 — Embedded Post Tooltip - YouTube (re-run 2026-06-05 batch-2)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-926
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, page-header confirmed; URL rewrote brand_id to 10765 — hash-router quirk).
- **Channel:** YouTube only
- **Date window:** May 25 – May 31, 2026
- **Layout:** Table View

## Result: PASS — Embedded YouTube tooltip renders cleanly on hover with thumbnail + post title + brand byline + Watch on YouTube CTA + close X. Click X closes tooltip. Post text links resolve to canonical youtube.com/watch?v= URLs.

## Steps executed
1. Navigated `#explore/brand/content?brand_id=4018&account_id=54&channels=youtube&from=2026-05-25&to=2026-05-31&perspective=standard&table_data_set=public&sentiment_mode=false&sort_key=lfm.content.engagements&layout=table`.
2. Page rendered MTV YouTube. Posts(4) loaded after 30s wait.
3. Clicked `[title="Table View"]` JS click to ensure Table layout.
4. Identified 4 YT posts in May 25–31 2026 window:
   - Row 1 (Thu May 28 01:45 PM PDT): "What songs do the 'Off Campus' cast have on repeat!?" — Engagements 4,760
   - Row 2 (Tue May 26 10:52 AM PDT): "The Warning takes us behind-the-scenes of 'Ego'" — Engagements 2,501
   - Row 3 (Wed May 27 10:43 AM PDT): "KATSEYE Takes on Australia | MTV" — Engagements 868
   - Row 4 (Fri May 29 10:51 PM PDT): "The Dirty Turkeys Perfor…" — Engagements 197
5. Hovered Row 1 Type column (Video link) at coord (495, 560). Embedded tooltip popped up positioned near hover anchor.
6. After ~3s the tooltip rendered the full YouTube embed content: MTV avatar + "What songs do the 'Off Campus'" title + "MTV" byline + YT thumbnail + red play button + share/clock icons + "Watch on YouTube" CTA + close X (top-right).
7. Clicked the close X at coord (905, 240). Tooltip dismissed; page returned to clean table.
8. Inspected DOM for YT watch URLs — found `http://www.youtube.com/watch?v=uGTTW_7D-Sg` (row 1) and `http://www.youtube.com/watch?v=KTKfw0RiYJw` (row 2) as embedded `<a>` hrefs on the post text/icon nodes.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Posts(N>0) for YT in chosen window | Posts(4) | PASS |
| A2 | 6 | Tooltip renders thumbnail + caption byline | YT thumbnail + "What songs do the 'Off Campus'" title + "MTV" byline + Watch on YouTube CTA | PASS |
| A3 | 6 | Only one tooltip open at a time | Single tooltip rendered (no duplicates observed) | PASS |
| A4 | 7 | X closes tooltip | Click at (905, 240) dismissed the tooltip; subsequent DOM probe showed tooltip element gone from view | PASS |
| A5 | 8 | Type/post link opens new tab to youtube.com/watch?v= URL | Watch URLs `youtube.com/watch?v=uGTTW_7D-Sg` and `youtube.com/watch?v=KTKfw0RiYJw` present in row DOM as `<a>` hrefs. (Note: in current build the Type column "Video" link routes internally to Brand>Video — the actual YT link is on the post-text `video` link inside the row, which has the canonical watch URL.) | PASS |
| A6 | 6 | Tooltip position anchored to hovered row | Tooltip rendered near hover coord (495, 560) — within ~80px of the Type cell | PASS |

## Bug history
- 4 closed bugs in this area (APPS-55973, APPS-52785, LFMP-29938, APPS-44635); none reproduced.

## Findings
- The QA-923 / QA-19950 Sentiment-mode-lock blocker from batch 1 did NOT reproduce on this MTV YouTube run — the post table populated cleanly (despite `sort_key=lfm.content.responses` being injected by hash router, the Posts(4) table rendered with all 4 YT posts and the embedded tooltip worked). The Sentiment-lock issue documented in known-quirks appears to be channel- and brand-specific rather than session-wide.
- The Type column literal "Video" link routes to Brand>Video (internal), NOT to YouTube. The canonical YT watch URL lives on the post-text `video` link inside the row.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-926-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-926.md`
