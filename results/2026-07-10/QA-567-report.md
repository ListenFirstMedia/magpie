# QA-567 — Facebook Lifetime Private Data QA

- **Run date:** 2026-07-10
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Account (spec):** Hulu
- **Verdict:** **BLOCKED — dev-vs-stage parity precondition unmet (no stage environment in this harness)**
- **Browser flow opened:** No (unmeetable precondition recognized pre-flight; per SCOPE-RULES "do not spend the timeout exploring")

## Why BLOCKED (pre-flight scope decision)

QA-567 is a **cross-environment parity test**. Its explicit precondition is:

> "User is logged in as Hulu. User has **dev open in 1 browser and stage open in another**."

Every step drives **both** dev and stage in parallel, and every assertion is a dev↔stage comparison:

| Spec assertion | What it compares |
|----------------|------------------|
| A8  | Impressions data for posts — **dev vs stage** must match |
| A10 | Video Views data — **dev vs stage** must match |
| A11 | Number of posts per view — **dev vs stage** must match |

This harness is **dev-only**:
- `config/.env` contains credentials for **`app.lfmdev.in` only** (`LFM_EMAIL` / `LFM_PASSWORD`), labeled "for automated Cognito email/password sign-in to app.lfmdev.in".
- `config/env.md` describes login against `app.lfmdev.in` exclusively; no stage URL, host, or stage credentials are configured anywhere in the repo.

There is no stage instance to compare against, so **none of A8/A10/A11 can be evaluated**. Running only the dev side would collect half of each comparison and still leave every assertion Not Evaluable — it cannot produce a trustworthy PASS. This is structurally the same situation the SCOPE RULES call out for external-user/second-identity cases (a precondition the harness cannot satisfy); by the same logic the whole case is deferred rather than partially executed.

## Steps executed

None. The unmeetable dev-vs-stage precondition was identified from the spec + harness config before opening the browser, so the per-step budget was not spent.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A8  | 6 | Impressions data for posts matches between dev and stage | No stage environment available to compare | Not Evaluable (BLOCKED) |
| A10 | 10 | Video Views data matches between dev and stage | No stage environment available to compare | Not Evaluable (BLOCKED) |
| A11 | 11 | Post count per view matches between dev and stage | No stage environment available to compare | Not Evaluable (BLOCKED) |

## Evidence

- `config/.env` keys: `LFM_EMAIL`, `LFM_PASSWORD` (values redacted) — scoped to `app.lfmdev.in` only; no stage credentials.
- `config/env.md` — auth + pre-flight target `app.lfmdev.in` only; no stage instance referenced.
- No screenshots captured (browser flow not opened).

## Notes

- The matching skill for the in-app portion would be **brand-content-data-set-selector** (Brand>Content channel + Impressions/Video Views data-set switching) plus **switch-account** (Hulu). Not exercised — case blocked upstream on the missing stage environment.
- The cached case file has **no `## Open linked bugs` section**, so Rule 7 (open-bug auto-fail screen) could not be applied from the cache. Not the reason for the block, but noted.
- To make QA-567 runnable here: provision a stage URL + stage credentials in `config/.env` / `config/env.md`, or split the case into a dev-only data-collection assertion. Until then it defers, and a re-run will pick it up automatically once a stage environment is wired.

## Bugs filed

None. The block is a harness/environment gap (no stage instance), not a product defect. No substitution attempted (Rule 1). No Jira ticket created (markdown-only per instructions).
