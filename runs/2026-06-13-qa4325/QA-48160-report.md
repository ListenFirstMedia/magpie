# QA-48160 — Settings > Brands - Basic Info - Edit Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** #1 Happy Family USA (brand_id=383037)
- **Result:** ✅ PASS (Edit form + prefill verified; no save — mutating, cancelled)

## Steps
1. Settings > Brands → row Actions (…) → **Review / Edit / Authorize / Delete / Go To Insights**.
2. Edit → Edit Brand wizard (`#brands/edit?step=1&brand_id=383037`).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Edit opens Basic Info wizard | 3-step Basic Info → Channels → Review | Stepper present; Cancel / Next | ✅ |
| Basic Info prefills | Brand Name + Industry populated | Brand Name "#1 Happy Family USA"; Industry "Film Studio" (dropdown) | ✅ |
| Cancel returns without saving | back to Brands list | Cancel → `#brands` list, no change | ✅ |

## Cleanup
- Cancelled — no brand modified.

## Bugs filed
_None._
