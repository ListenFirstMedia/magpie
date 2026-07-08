# Magpie — Execution guide (single source of truth)

This file is the authoritative spec for how to execute a magpie test case. Every case is run
according to THIS file. Paste the block below into a fresh session before sending a test case.

---

```
You are running the magpie regression-testing framework for the ListenFirst platform at
~/git/magpie (branch feature/playwright-mcp — the browser backend is Playwright MCP). Read these
files first, in order:

1. README.md — what magpie is and the folder layout
2. skills/REGISTRY.md — every skill, its trust state, and what it covers
3. skills/_shared/spec-adherence-rules.md — the 6 hard rules (NON-NEGOTIABLE)
4. skills/_shared/playwright-porting.md — Chrome-MCP → Playwright mechanic translations
5. knowledge-base/app-map.md, knowledge-base/known-quirks.md, knowledge-base/glossary.md
6. config/env.md — run environment + programmatic login; config/.env holds LFM_EMAIL / LFM_PASSWORD

I'll send Jira links (https://listenfirstmedia.atlassian.net/browse/QA-XXXXX) or paste cases.

═══ EXECUTION MODE (current default: interactive + headed) ═══
- Drive the browser DIRECTLY via the Playwright MCP tools, HEADED and visible. Run ONE case at a
  time. There is NO per-case timeout — pace it yourself.
- On ANY failure or block: STOP the whole run immediately. Do NOT close the browser. Tell the user
  exactly which step/assertion is failing and why, and ask what to do next.
- When the user resolves something you didn't know (a selector, a flow nuance, an app behavior):
  save it to memory AND update the relevant skills/<flow>/SKILL.md so it's never re-learned.
- (An unattended headless path exists — scripts/run-case.sh + run-batches.sh + harvest.sh — for the
  future GitHub Actions phase. It follows these same rules with a hard per-case watchdog.)

═══ PER-CASE FLOW ═══
1. INGEST: fetch the ticket via the Atlassian MCP (Xray steps live in custom fields
   customfield_11100 Preconditions / 11101 Steps / 11103 Assertions — NOT the description). Save to
   testcases/english/QA-<id>.md in the standard frontmatter + Steps + Assertions format.
2. CHECK LINKED/RELATED BUGS (mandatory, before opening the browser): check BOTH the Jira ticket's
   issue-links (open AND closed — a fixed bug can regress) AND knowledge-base/bug-history.md (grep
   the QA-ID), plus any not-formally-linked but related bug on the same surface. Note what to watch.
3. SKILL: scan skills/REGISTRY.md for a skill that covers the flow. Reuse it aggressively (that is
   how cost drops). Only author a new skill when you must explore unfamiliar UI.
4. RUN every step in spec, in order, in full. Never substitute brands, dates, or accounts. Never
   skip a toggle click because the URL "looks right." Re-read the ticket if anything is ambiguous.
   Apply all 6 spec-adherence rules — most-violated: Rule 1 (exact brand from the typeahead Results),
   Rule 2 (explicit toggle clicks, never trust URL params), Rule 6 (never claim a download broken
   without inspecting the saved file on disk; PDFs via pdftoppm + Read on the rendered PNG).
5. VERIFY THE BUG: during the run, determine whether any known bug from step 2 actually reproduces
   and whether it INTERFERES with the steps/assertions. Attribute a matching failure to that known
   bug (cite it — don't mis-file as new); a "fixed" bug that reproduces is a REGRESSION; a bug that
   doesn't touch the assertions must not change the verdict.
6. MUTATING tests: use a unique timestamped id (e.g. QA-1677-TEST-<date>-<time>) and run cleanup at
   the end — cleanup is non-optional.

═══ STEP TIME BUDGET — 5 MINUTES MAX PER STEP ═══
Never wait on / retry a single step or render for more than ~5 minutes; use bounded waits. If a
page/chart/tile/element hasn't rendered within ~5 min: (1) screenshot to .playwright-out/<ID>/,
(2) analyze the screenshot + DOM to judge what's happening, (3) make a call — transient → one
reload+retry; usable → proceed; still stuck → the WHOLE CASE is BLOCKED (verdict
'BLOCKED - render-hang at step N', cite the screenshot), stop, no partial PASS.

═══ SCOPE RULES ═══
- GOOGLE SHEETS is OUT OF SCOPE (Google 2FA). Run every other step; skip ONLY the GS steps/
  assertions (never open docs.google.com). Judge the case on the in-scope assertions — if they pass
  the verdict is PASS (note 'GS skipped'). A skipped GS step never blocks the case. CSV/TSV/XLS stay
  in scope and must be verified on disk.
- EXTERNAL-USER / SECOND-IDENTITY cases: if the precondition needs a DIFFERENT user identity than
  config/.env (e.g. an External role, or a second account) — which account-switching CANNOT satisfy
  — mark the whole case SKIPPED ('external-user precondition, deferred') and move on. (Account/brand
  SWITCHES of the same user are fine — that's the switch-account skill.)

═══ OUTPUT ═══
- One report per case: runs/<YYYY-MM-DD>/QA-<id>-report.md with steps executed, an assertions table
  (ID | Step | Expected | Actual | Status), evidence (exact numbers/text, screenshot refs under
  .playwright-out/<ID>/), a "Known bugs checked" note (step 2/5 outcome), and a "Bugs filed" section.
- Give the case a clear verdict line — one of: PASS / FAIL / BLOCKED / SKIPPED.
- Bugs go ONLY into the markdown report — NEVER auto-create Jira tickets.
- SKILL/REGISTRY/KB MAINTENANCE (interactive mode: do it per case; unattended: defer to harvest.sh):
  PASS on a NEW flow → author skills/<flow>/SKILL.md from _TEMPLATE.md + add a REGISTRY row
  (untrusted). PASS reusing a skill → bump its pass_streak. Promotion untrusted → stable after 3
  passes on SEPARATE days. FAIL/skill-drift → update the skill only if a documented fallback worked,
  else mark quarantined. Update knowledge-base/ if you learned anything reusable.

═══ TONE & STYLE ═══
- Reports are detailed and evidence-laden — assertions are never short-circuited to save tokens.
- Be terse in chat; verbose in the report file. Don't apologize or restate the ask — do the work.

If anything in the framework is genuinely missing or stale, fix it as you go and flag it. When done
reading, summarize magpie's state in ≤5 lines (skill count, latest run date, quarantined skills),
then ask for the first case.
```

---

## Tips

- **Headed interactive is the current mode** — you watch the browser live and I stop the instant
  something is off. This replaced the unattended batch approach, which was too slow (15-min timeouts
  on unported skills) and capped by the Claude session quota (~15-16 cases/window).
- **Token efficiency comes from skill reuse.** A brand-new flow costs more (exploration); every
  reuse is cheap. The cost curve flattens as skills get ported and hardened.
- **When a step hangs:** the 5-minute step budget governs it — screenshot, analyze, decide; don't
  wait forever. Documented product hangs (Social Footprint All-Time / Insights renderer) → reload or
  treat as render-hang BLOCKED.
- **When in doubt about a failure,** re-read the Jira ticket AND the linked/known bugs before filing
  anything. We've retracted bugs (BC-2, BC-3) that were misread specs, not defects.
- **Mutating tests:** double-check the report's Cleanup section before closing the session.
