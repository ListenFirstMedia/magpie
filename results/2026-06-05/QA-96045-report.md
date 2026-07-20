# QA-96045 — Settings > Data Identities - Instagram Threads

**Run:** 2026-06-05 (batch 6/12 of QA-22296)
**Brand / Account:** Adam Orfei account
**Tester:** Yash via magpie

## Pre-test
- Spec from Jira description: "ensures on clicking Authorize button, it should open the respective channels 'Connect' auth flow, and allow users to multi-select data feeds for 'Threads' channel."
- Bug history check: no open/closed bug links — clean test.

## Steps executed
1. Navigated to `https://app.lfmdev.in/#data-identities?account_id=54` (Adam Orfei).
2. Waited for Channels list to render.
3. Enumerated channels visible in the Data Identities Channels (N) listing.
4. Probed `document.body.innerText` for `[Tt]hreads` match.

## Findings
- Channels (6) rendered on the page:
  - Facebook (196 AUTHORIZED USERS)
  - Twitter (1,158 AUTHORIZED USERS)
  - Instagram (137 AUTHORIZED USERS)
  - YouTube (245 AUTHORIZED USERS)
  - TikTok (68 AUTHORIZED USERS)
  - LinkedIn (1 AUTHORIZED USER)
- **No `Threads` channel row is present** in the Channels (6) list.
- `document.body.innerText.match(/[Tt]hreads/g)` returned `null` — confirms no Threads channel surfaces on the Settings > Data Identities page for the Adam Orfei account.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Data Identities lists Threads as a separate channel row | Threads row present alongside Facebook/Twitter/Instagram/YouTube/TikTok/LinkedIn | Channels (6) — no Threads row | INCONCLUSIVE — account/test-data gap |
| A2 | Authorize CTA opens Threads Connect auth flow | Connect modal/flow for Threads with multi-select feeds | Cannot test — Threads channel not present | INCONCLUSIVE — unreachable |

## Result
INCONCLUSIVE — **test-data / account configuration gap**. The Threads channel is not surfaced in the Adam Orfei account's Data Identities. Per spec-adherence Rule 1, no substitution is made (Threads is the target — not Instagram-as-fallback). The test case requires an account/brand where Threads is actually surfaced as a Data Identity channel.

This may be expected behavior if Threads identities are scoped per-page (via Instagram-page authorization rather than as a stand-alone Data Identity channel). The Jira description "for 'Threads' channel" implies a separate Threads channel row should exist, but the implementation may have unified Threads under the Instagram Data Identity. Needs LFIQA clarification on the spec's expected surfacing.

## Bugs filed
None — environment/setup INCONCLUSIVE, not a product defect.
