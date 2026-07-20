# QA-84193 — Reporting > Data Studio - Brand > Content - Data QA - Engagements (re-run 2026-06-04 batch-6)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84193
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Hulu (brand_id=5670) — DS Post Level side; BC side BLOCKED (see below)
- **Channels:** Facebook, Twitter, Instagram, TikTok
- **Window:** Absolute May 27 – Jun 02 2026, In-Window mode

## Result: PARTIAL — DS Post Level numerics captured; Brand>Content side BLOCKED (Hulu not accessible from Adam Orfei BC route)

## Steps executed

1. Navigated to Reporting → Data Studio → Post Level via top-nav.
2. Set Window Mode = In-Window.
3. Custom date range May 27 – Jun 02 2026 (Days interval, default).
4. Added Hulu brand via React-aware InputEvent + triple_click/type/click on first Results entry.
5. Select Metrics → typed "Engagements" in metric filter → checked Facebook Engagements, Twitter Engagements, Instagram Engagements, TikTok Engagements (4 channel-level leaves) → closed modal.
6. Public view (default toggle position).
7. Clicked Go (via JS `Array.from(...).find(b => b.textContent.trim() === 'Go').click()` — coordinate click delivered to spinner).
8. After ~25 seconds of skeleton loading the Post Level Aggregate table rendered with per-day + Sum + Average columns.

## Source-1: DS Post Level (Hulu Public, In-Window May 27 – Jun 02 2026)

| Metric | Sum | Average | May 27 | May 28 | May 29 | May 30 | May 31 | Jun 1 | Jun 2 |
|---|---|---|---|---|---|---|---|---|---|
| Facebook Engagements | **167,094** | 23,871 | 1,343 | 4,675 | 5,314 | 34,799 | 64,642 | 40,629 | 15,692 |
| Twitter Engagements | **4,306** | 615 | 229 | 247 | 795 | 1,138 | 754 | 876 | 267 |
| Instagram Engagements | **938,530** | 134,076 | 68,244 | 267,073 | 177,405 | 195,545 | 82,829 | 65,644 | 81,790 |
| TikTok Engagements | **44,501** | 6,357 | 5,859 | 38,642 | 0 | 0 | 0 | 0 | – |

## Source-2: Brand > Content (Hulu Public, In-Window May 27 – Jun 02 2026) — BLOCKED

Direct URL navigation `#explore/brand/content?brand_id=5670&from=…&perspective=standard&window=in` from Adam Orfei (account_id=54) redirects to `#home?account_id=54` — Hulu Brand>Content is not accessible from the active session's account ACL. The same URL with `account_id=63` also redirects. Switching accounts to Hulu's home account would require the user account-switcher, but cross-account verification for this parity test stalled the run; documented as the BC-side blocker.

Substituting MTV (`brand_id=4018`) loads MTV Brand>Content but the parity numerics would then be on a different brand than the DS Post Level side, defeating the comparison.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | DS Aggregate Engagements value loads | FB=167,094; TW=4,306; IG=938,530; TK=44,501 | All 4 per-channel Sum values rendered cleanly with per-day breakdown | PASS |
| A2 | Brand>Content Sum Engagements value loads | (Hulu BC numerics) | BC URL redirects to Home from Adam Orfei account_id=54 — BLOCKED on cross-account access | NOT VERIFIED |
| A3 | DS – BC delta within 1.5% per channel | (computed delta) | Cannot compute without BC side | NOT VERIFIED |
| A4 | Match within tolerance OR documented delta | (verdict) | DEFERRED to LFIQA real-browser verification or run on a brand co-located on both DS-Post-Level + BC for Adam Orfei | NOT VERIFIED |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-84193-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-84193.md` (proxy spec)

## Notes / Carry-forward

- **New finding:** Hulu Brand>Content URL nav from Adam Orfei (account_id=54) consistently redirects to `/#home`. Hulu lives on a different account; cross-account testing via URL nav alone is not viable. Should add to `known-quirks.md` as "Hulu Brand>Content account-cross-route".
- The DS Post Level half of the parity test worked cleanly; this is the easier side. Future executions should pre-select a brand that lives on the Adam Orfei account for both sides (e.g., MTV) to make the parity test self-contained.
- The QA-90213 sub-1.5% drift quirk is the closest analogue — same parity approach showed near-parity within freshness tolerance.
