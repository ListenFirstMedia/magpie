# QA-574 — Instagram Lifetime Private Data QA — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram · **Window:** May 25 – 31 2026 · **Mode:** Lifetime
- **Skills:** view-perspective-toggle, brand-content-data-set-selector
- **Result:** ✅ PASS (with spec-interpretation note) — consistent with 2026-06-05

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Authorized perspective confirmed (Rule 2) | `perspective=extended`, `.al-toggle__checkbox.checked === true` (brand_id 4018) | ✅ |
| A2 | Post table populates, row count > 0 | Posts(75); Sum Eng 3,841,956 / Reactions 3,810,581 / Comments 31,375 / Video Views 66,043,280; Avg 51,226 / 50,808 / 418 / RR 0.24% / VV 2,063,852 / VRR 3.35% | ✅ |
| A3 | Per-post lifetime values equal "Recent" tab | **No "Recent" tab in current UI build** → Public used as proxy. Public (brand_id 10765) IG Sum **identical**: 3,841,956 / 3,810,581 / 31,375 / 66,043,280, Posts(75). Authorized↔Public parity exact | ✅ (proxy) |
| A4 | No "data is private — log in" placeholder | Authorized rows render real numerics, no private/login placeholder | ✅ |

## Notes
- **Spec drift (carry-forward):** No "Recent" tab exists in current Brand>Content; Public perspective is the comparable lifetime source. Suggest updating QA-574 to reference Public/Authorized parity instead of a "Recent" tab.
- **Quirk reconfirmed:** toggling Public/Authorized for MTV IG flips brand_id (4018 Authorized ↔ 10765 Public) and can expand channels — re-navigated via explicit URL per the documented perspective-toggle brand-fallback quirk. Both brand_ids represent MTV and yield identical IG lifetime sums.

## Bugs filed
_None._
