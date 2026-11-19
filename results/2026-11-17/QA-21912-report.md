# QA-21912 — Brand Content > LFM vs Native > Facebook Channel

**Verdict: PASS** (UCLA pair — Reactions 646 vs 684, Comments 11 vs 13, Shares 77 vs 85). The second Tuesday pair (Wasserman / Gatorade) had **no Facebook posts** in the app's default range, so its step 4–6 could not be executed (not a failure, see below).

- Run: 2026-11-17 (Tuesday), unattended headless, Playwright MCP, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-native-post-check` + `switch-account` (no skill/REGISTRY maintenance — deferred to harvest.sh)
- Spec row (Description table, Tuesday): Accounts **UCLA, Wasserman** / Brands **University of California, Los Angeles, Gatorade**. The Notes line in the case file (Tue = UCLA / Sony Pictures) is stale and conflicts with the table; the table was followed.
- Date range: none specified by the case; app default **Nov 9 – Nov 15, 2026** (Lifetime attribution) used for both pairs. No dates were invented.

## Steps executed

### Pair 1 — Account UCLA / Brand University of California, Los Angeles
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account") | OK → `#home` |
| pre | Switch account → UCLA (LFQA menu → Search Account → real mouse click on `.lfm-ta-option` "UCLA" under Results; not "UCLA Law") | OK, `ACCOUNT: UCLA`, `account_id=799` |
| 1 | Hover Brand → Content | OK, `#explore/brand/content?brand_id=127756&account_id=799…` |
| 2 | Add a Brand | Account's default brand is already the exact spec name **University of California, Los Angeles** (127756); no typeahead substitution needed (Rule 1 satisfied) |
| 3 | Enable Facebook channel only | Trusted clicks disabled twitter/instagram/tiktok/linkedin/threads (youtube/pinterest already disabled); Apply → URL `channels=facebook`; ghosts: only `facebook enabled`; **Posts (33)** |
| 4 | Note Reactions / Comments / Shares of first post | Card #1 (sort Engagements desc): THU NOV. 12, 2026 08:00 PM PST, "ICYMI: The "Mozart of Math" Read the full story: ucla.in/4t3gB8s", type Image. Engagements 734 · **Reactions 646 · Comments 11 · Shares 77** · Response Rate 0.13% (646+11+77 = 734 ✔ internally consistent) |
| 5 | Click the image on the first post | Real mouse click on `.image-card .image-link` → new tab `https://www.facebook.com/UCLA/posts/pfbid0VGu2cYvNdMtmS8d2too7JpS6yuGs8rtX48RjDKLZoPqqiBBceBjg1SBg4iD3zfnUl` (tile href: `facebook.com/11360325957_1146239737795067`) |
| 6 | Note native Likes / Comments / Shares | Public post page rendered logged-out (login bar visible, content behind). Body text: "Friday 13 November 2026 at 09:30 … **All reactions: 684 · 13 comments · 85 shares**"; og:description matches the LFM caption (same post confirmed) |

### Pair 2 — Account Wasserman / Brand Gatorade
| # | Step | Result |
|---|------|--------|
| pre | Switch account → Wasserman (Results list, exact match, single result) | OK, `ACCOUNT: WASSERMAN`, `account_id=863` |
| 1 | Hover Brand → Content | OK, default brand = Gatorade (`brand_id=3580`) |
| 2 | Add a Brand | Opened picker, typed "Gatorade" (needed Backspace + retype to trigger Results, per skill gotcha). Results: Gatorade, Gatorade (Canada), Gatorade Argentina, Gatorade Brasil, Gatorade Performance Partner, Gatorade Playbook, Team Gatorade. Clicked the **exact "Gatorade"** (3580), Rule 1 ✔ |
| 3 | Facebook channel only | Same trusted-click disable + Apply; only `facebook enabled`, `channels=facebook` |
| 4–6 | First post / image / native | **Not executable:** `Posts (0)`, SUM/AVERAGE rows all "–", message "There is no data available. Please select a different brand, brand set, or date range." Re-checked after 15 s extra wait (not a render hang). No Gatorade Facebook posts in Nov 9–15. Per Rule 1/3 no brand or date substitution made. |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6a | 6 (UCLA) | LFM Reactions vs native Likes/reactions: no big variation | 646 vs 684 → native +38 (+5.9%) | PASS |
| A6b | 6 (UCLA) | LFM Comments vs native Comments: no big variation | 11 vs 13 → native +2 (+18% of a tiny base; absolute diff 2) | PASS |
| A6c | 6 (UCLA) | LFM Shares vs native Shares: no big variation | 77 vs 85 → native +8 (+10.4%) | PASS |
| A6d | 4–6 (Gatorade) | Same comparison for Wasserman / Gatorade | No Facebook posts in default range (Posts (0)) — comparison not possible | N/A (no data, not a failure) |

Drift is one-directional (native ≥ LFM) and consistent with the post continuing to accrue after LFM's last stats pull (native shows the post ~1 day later; LFM stamps it Nov 12 08:00 PM PST vs native "Friday 13 November 09:30" in a different timezone). Spec gives no numeric threshold; all deltas are within the range seen previously (2026-10-20 UCLA: +3.2% / +4 / +1; LinkedIn +10%).

## Evidence
- `.playwright-out/QA-21912/01-fb-only.png` — UCLA, Facebook-only Posts (33)
- `.playwright-out/QA-21912/02-native-fb.png` — native Facebook post (UCLA)
- `.playwright-out/QA-21912/03-wasserman-content.png`, `04-brand-selector.png` — Wasserman/Gatorade setup
- `.playwright-out/QA-21912/05-gatorade-fb-only.png`, `06-gatorade-fb-recheck.png` — Gatorade Facebook-only, Posts (0)

## Known bugs checked
- Case file "Open linked bugs": **None open** → Rule 7 screen passed, case run.
- bug-history / known-quirks: no QA-21912 entries (pre-fetched). Skill's LFMP-32113 (native far lower than LFM) — not reproduced; native was higher.
- Prior runs of this case: 2026-10-20 PASS (UCLA), 2026-10-22 BLOCKED (FX Networks — Facebook native login wall). This run, the logged-out Facebook post page rendered again (fragile; login wall is intermittent).

## Bugs filed
None.

## Cleanup
None (read-only data test). Native tab closed; nothing was created or saved.

## Notes for the human / harvest
1. Weekday Notes line in `cases/QA-21912.md` is stale vs the Jira table (Tue = UCLA/Sony Pictures there; table says UCLA/Wasserman).
2. Wasserman/Gatorade has no Facebook posts in the default week — consider documenting a date range for that pair or treating Wasserman as N/A on this case.
3. Skill `brand-content-native-post-check`: add Facebook native-read row — public post page body text "All reactions: N · N comments · N shares" works when no login wall appears; login wall "This content isn't available at the moment" otherwise → BLOCKED on native access. Also: Brand-picker typeahead may need Backspace + retype to show Results.
