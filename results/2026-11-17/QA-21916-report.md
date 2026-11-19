# QA-21916 — Brand Content > LFM vs Native > YouTube Channel

**Run date:** 2026-11-17 (Tuesday)
**Track:** unattended lane first (both Tuesday rows had no YouTube posts), then interactive re-run on dev `app.lfmdev.in` for the allowed alternative account (prod not involved)
**Account:** Amazon Prime Video (account_id=342) · **Brand:** Amazon Prime Video (brand_id=25864) · Channel: YouTube only · Date range: default week Nov. 09, 2026 - Nov. 15, 2026
**Verdict: FAIL (data freshness) — first video "Blade Runner 2099 - Final Trailer | Prime Video" (Mon Nov 09): LFM Likes 5,733 vs native 6,321 (native +10.3%), Comments 835 vs native 958 (native +14.7%); Video Views 6,271,064 vs native 8.4M (+34%, not asserted by the case)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| – | Tuesday row 1: UCLA / University of California, Los Angeles | ⛔ YouTube only → Posts (0) in the default week (unattended lane, also seen in the Dev-vs-Prod run on dev and prod) |
| – | Tuesday row 2: Wasserman / Gatorade | ⛔ YouTube only → Posts (0) |
| 1–2 | Alternative per the case note ("Also use Amazon Prime Video on alternative days"): Brand > Content, brand Amazon Prime Video | ✅ |
| 3 | Enable the YouTube channel only | ✅ Posts (48), data set auto-switched to YouTube Only: Basic |
| 4 | Note Likes and Comments from the first post | ✅ 1 | Amazon Prime Video | MON NOV. 09, 2026 09:03 AM PST | Blade Runner 2099 - Final Trailer | Prime Video | Video | Original Post | Blade Runner 2099  → Likes 5,733 · Comments 835 · Video Views 6,271,064 |
| 5 | Click the image on the first post | ✅ native tab https://www.youtube.com/watch?v=1d4x_eSdqNc |
| 6 | Note the native Likes and Comments | ✅ like button label "like this video along with 6,321 other people" (6,321 + 1), comment header "958 Comments", "8.4m views 7 days ago" |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | 6 | LFM values should not have big variations vs native | Likes 5,733 vs 6,321 (+10.3% native); Comments 835 vs 958 (+14.7% native) — above the ~10% bound used for the native checks | ❌ FAIL |

## Evidence
- `results/2026-11-17/_native-QA-21916.json`.

## Known bugs checked
- No open linked bug on the case. Native is HIGHER than LFM here (collection lag on an 8-day-old, still-growing trailer), the opposite direction of LFMP-32113; same pattern as the 2026-10-22 run (trailer at 2× LFM).

## Bugs filed
None (data-freshness observation; re-check after the next collection).

## Cleanup
None (read-only — no brand, tag or data set was created).
