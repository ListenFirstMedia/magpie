# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** settings-notifications (new pattern)
- **Result:** ✅ PASS

## Steps
1. Settings → Notifications. Screen: **Notifications (8,328)**, columns **Date / Message / New Status**, filters **Unread ▾ / Status ▾ / Search messages**, ALL READ control.
2. Reviewed the lost-data-collection / lost-authorization messages.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Lost-auth messaging present | Notifications show lost-authorization/collection alerts | Multiple "We lost data collection on the '…' feed…" entries | ✅ |
| Improved specificity | Per-feed + brand + actionable wording | e.g. **"We lost data collection on the 'TikTok Posts (Authorized)' feed for the 'Comedy Central Stand-Up' brand. Please click to troubleshoot."**; also Instagram Earned Comments (Authorized) / Instagram Mentions (Authorized) / Facebook Earned Comments (Authorized) / Wikipedia Page (Public) | ✅ |
| Authorized vs Public distinction | Feed qualifier shown | Messages explicitly tag **(Authorized)** vs **(Public)** per feed | ✅ |
| Status indicator | Clear status | **NOT COLLECTING** badge in New Status column | ✅ |

## Notes / automation learning
- The improved lost-authorization messaging is **feed-specific** (names the exact feed + Authorized/Public qualifier + brand) with a **"Please click to troubleshoot"** CTA and a **NOT COLLECTING** status badge — a clear upgrade over generic "lost authorization" wording. Filterable via Unread/Status/Search.
- New surface — candidate for a small `settings-notifications` skill (message schema: "We lost data collection on the '<Feed> (<Auth|Public>)' feed for the '<Brand>' brand. Please click to troubleshoot.").

## Bugs filed
_None._
