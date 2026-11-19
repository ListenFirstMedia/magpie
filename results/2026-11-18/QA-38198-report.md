# QA-38198 — Reporting - Data QA - Social Recap Year - Date

**Run date:** 2026-11-18 · **Track:** Playwright MCP, unattended (`claude -p`) · **Env:** dev
**Browser flow:** NOT opened (open-bug auto-fail screen, see below)

## Verdict: FAILED (blocked by open bug) — APPS-58195

Per `skills/_shared/spec-adherence-rules.md` **Rule 7** (open-bug auto-fail, screen before running) and the known-quirks policy confirmed by the user on 2026-10-22 (any open linked bug = FAILED, in the report and in the Xray execution), the case was screened against its **"Open linked bugs"** section and the shell-side open-bug map `results/open-bugs-2026-11-18.json`:

- **APPS-58195** — "Social Recap > FB and TW > Negative value displayed for the Video Views and Engagements" — status **Code Review** (not closed). Listed in both `cases/QA-38198.md` (as of 2026-10-20) and `results/open-bugs-2026-11-18.json` (today's map).

Rule 7 says: do not execute the steps and do not open the browser flow; write the report with the bug cited and stop. Rule 7 is one of the hard rules and the per-run "execute in full" instruction does not override it. Skipping the run also saves the per-case token budget.

## Steps executed
None. Steps 1–13 were not run (Rule 7).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 6–7 | Sum of FB + TW + IG + YT + TikTok Paid + LinkedIn Impressions = donut Impressions total (data-tooltip) | Not executed (open bug APPS-58195) | FAILED (blocked by open bug) |
| A9 | 8–9 | Sum of Video Views (FB Organic+Paid, IG, TW, YT, TikTok, LinkedIn) = donut Video Views total | Not executed | FAILED (blocked by open bug) |
| A11 | 10–11 | Sum of Engagements = donut Engagements total | Not executed | FAILED (blocked by open bug) |
| A13 | 12–13 | Sum of positive New Followers = donut New Followers total | Not executed | FAILED (blocked by open bug) |

## Evidence
No live evidence this run. For reference only, the most recent full evidence-gathering run was **2026-11-17** (`results/2026-11-17/QA-38198-report.md`, Sephora, Authorized, "Social Activity - Year to Date", story 162866). In that run all four sums matched the donut totals and APPS-58195 did **not** reproduce (no negative FB/TW Video Views or Engagements). That does not change today's verdict, because the policy keeps the case FAILED until the bug closes.

## Known bugs checked
- **APPS-58195** (Code Review): open, linked → auto-fail trigger (Rule 7).
- `knowledge-base/bug-history.md`: no entries for QA-38198 (pre-fetched shell-side).
- Precondition note (Dec 15, 2025 Meta deprecation of Facebook Organic Impressions): informational only, not exercised this run.

## Bugs filed
None. (Markdown-only; nothing created in Jira.)

## Cleanup
None (read-only; nothing created).

## Notes
- To flip this case to PASS: close APPS-58195 in Jira, refresh the case cache (`## Open linked bugs` → "None open") and re-run. The 2026-11-17 evidence suggests the data assertions will pass.
- No skill/REGISTRY maintenance this run (deferred to harvest.sh; nothing exercised).
