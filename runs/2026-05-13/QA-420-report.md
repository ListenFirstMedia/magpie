# QA-420 — Brand Sets > Content - Post Table Post Limit Across Views

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-420
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Amazon Prime Video (account_id 342)
- **Result:** ⏸ **Deferred — Brand Set selector empty on dev for this account**

## Status

Navigated to Brand Sets → Content but no brand set was pre-loaded on this account. The "LF // TV // Episodic" brand set referenced in the test spec is not visible in the Amazon Prime Video account on dev. Likely:
1. The brand set was renamed or removed since the test was authored.
2. The "LF // TV // Episodic" name is owned by a different account (e.g. an internal/cross-account aggregation).

## Recommendation
- Confirm with LFIQA whether "LF // TV // Episodic" should be visible on Amazon Prime Video on dev.
- Substitute with any other brand set on this account, then verify the 100-posts-per-scroll behavior.

## Bugs filed
None — this is a precondition issue, not a code defect.
