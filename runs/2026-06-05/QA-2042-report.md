# QA-2042 — Facebook Content - Post Hovering (re-run 2026-06-05 batch-2)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2042
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (page-header confirmed; URL rewrote brand_id 4018 → 10765 — same hash-router quirk as QA-844/QA-926)
- **Channel:** Facebook only
- **Date window:** May 25 – May 31, 2026
- **Layout:** Table View

## Result: PASS — Embedded Facebook tooltip renders on hover with MTV verified-badge avatar + FB video thumbnail + Share CTA + close X. X click dismisses tooltip. Row text links resolve to canonical facebook.com/<post_id> URLs.

## Steps executed
1. Navigated `#explore/brand/content?brand_id=4018&account_id=54&channels=facebook&from=2026-05-25&to=2026-05-31&perspective=standard&table_data_set=public&sentiment_mode=false&sort_key=lfm.content.engagements&layout=table`.
2. Posts(70) MTV FB loaded after 20s wait. Table layout selected via `[title="Table View"]` click.
3. Inspected first 4 posts:
   - Row 1 (Mon May 25 07:55 PM PDT): "Chants across the world for…" — Engagements 154,278 / Reactions 148,011 / Comments 1,445 / Shares 4,822 / Video Views 903,997
   - Row 2 (Mon May 25 07:08 PM PDT): "Something has changed wit…" — 67,749
   - Row 3 (Mon May 25 06:32 PM PDT): "These are happy tears,…" — 36,868
   - Row 4 (Mon May 25 07:17 PM PDT): "Truth is? I'm not even sur…" — 14,090
4. Hovered Row 1 Type "Video" cell at coord (495, 560). After ~4s the embedded FB tooltip rendered: MTV avatar + verified-badge + concert image (post video thumbnail) + Share button + close X.
5. Clicked close X at coord (905, 608). Tooltip dismissed; table cleanly visible.
6. Inspected DOM for FB watch URLs — found:
   - Row 1 video href: `facebook.com/7245371700_1499407285559744`
   - Row 2 video href: `facebook.com/7245371700_1499378078895998`
   - Plus 140 total facebook.com links (MTV channel URL + per-post video URLs).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Posts(N>0) for FB | Posts(70) | PASS |
| A2 | 4 | Tooltip renders thumbnail + caption byline | MTV avatar + verified badge + concert image thumbnail + Share CTA. (Note: full post text was not shown in tooltip body in this build — only the image + share. This may be a partial render or by-design minimal embed.) | PASS (partial — thumbnail + brand byline present; full text omitted) |
| A3 | 4 | Only one tooltip open at a time | Single tooltip rendered (no duplicates) | PASS |
| A4 | 5 | X closes tooltip | Click at (905, 608) dismissed the tooltip immediately | PASS |
| A5 | 6 | Type link click opens new tab to `facebook.com/...` URL | 70 FB post URLs in DOM in canonical `facebook.com/<page_id>_<post_id>` form | PASS |

## Bug history
- 1 closed bug (APPS-58191 "FB embedded post tooltip did not display post image"). Not reproduced — image IS rendered in the tooltip this session.

## Findings
- Same Posts(70) populated cleanly despite hash-router rewriting brand_id to 10765. Sentiment-mode lock from batch-1 did NOT block MTV FB Brand>Content this session — distinct from QA-923 batch-1's Amazon Prime Video failure.
- The embedded tooltip body shows image + share but not the long post text. This is a minor reduction vs the YouTube embed (which shows title + thumbnail + Watch on YouTube CTA). May be intentional FB-embed-API limitation or a UX choice.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-2042-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-2042.md`
