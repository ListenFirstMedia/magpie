# QA-135430 — Settings > Custom Metrics - Delete Functionality — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** settings-custom-metrics
- **Result:** ✅ PASS

## Steps
1. Settings → **Custom Metrics** (route is `#custom-metrics` with a hyphen — see Notes).
2. **Create a Custom Metric** → Name **"qa-135430-del-0617"**, Description "QA delete-functionality test - safe to remove", Formula **100 ÷ Engagements** (`100 / lfm.post_engagement_score.public_nvo_engagement_v5`) → **Save** → "Custom metric successfully created!".
3. New metric row → **Actions ⋯ → Delete** → confirmation modal → **Ok**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Delete action present | Actions menu offers Delete | Actions ⋯ → **Edit / Delete** | ✅ |
| Confirmation modal | Named confirm before delete | **"Are you absolutely sure you want to delete your custom metric "qa-135430-del-0617"? Click "Ok" to continue."** (Cancel / Ok) | ✅ |
| Delete removes the metric | Metric gone from list | After Ok, **"qa-135430-del-0617" no longer in the list** (back to the original 7 metrics) | ✅ |

## Notes / automation learning
- **Custom Metrics route is `#custom-metrics` (hyphen)**, not `#custom_metrics` (underscore) — direct underscore nav fails to render; use the Settings-menu link or the hyphen URL.
- Custom-metric **formula requires a Metric token** — a constant-only formula leaves Save disabled ("Constant cannot be blank" until valued, but Save needs an operand+operator+metric). Builder: Metrics▶(ListenFirst/FB/Twitter/YouTube/IG/TikTok/Wikipedia) / Constant / Operators▶(+ − × ÷) / Parentheses.
- Delete confirmation modal names the metric and requires explicit Ok.

## Cleanup
- **Self-cleaned:** the throwaway test metric "qa-135430-del-0617" was created and then **deleted** as part of the test — no residue left. No pre-existing ("DO NOT CHANGE") metrics were touched.

## Bugs filed
_None._
