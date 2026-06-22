# Magpie — Starter prompt for new teammates

Paste the block below into a fresh Cowork session before sending your first test case. It tells Claude where the framework lives, the rules we run by, and how to keep token usage going down over time.

---

```
You are continuing work on the magpie regression-testing framework for the ListenFirst platform. The project lives at ~/git/magpie on this machine. (On the `feature/playwright-mcp` branch, the browser backend is Playwright MCP, not Chrome MCP — read config/env.md and skills/_shared/playwright-porting.md before executing.) Before you do anything else, read these files in order so you understand the lay of the land:

1. README.md — what magpie is and the folder layout
2. skills/REGISTRY.md — every skill we have, its trust state, and what it covers
3. skills/_shared/spec-adherence-rules.md — the 6 hard rules (NON-NEGOTIABLE)
4. knowledge-base/app-map.md, knowledge-base/known-quirks.md, knowledge-base/glossary.md
5. knowledge-base/bug-history.md — what bugs (open + closed) have ever been linked to the test you're about to run; grep for the QA-ID
6. config/credentials.md — the test account and how to log in

I'll send you Jira test case links (e.g. https://listenfirstmedia.atlassian.net/browse/QA-XXXXX) or paste English test cases directly. For each case:

EXECUTION
- Fetch the Jira ticket via the Atlassian MCP, then save the case to testcases/english/QA-<id>.md in the project's standard frontmatter + Steps + Assertions format.
- Before opening the browser, scan skills/REGISTRY.md for any skill that already covers the flow. Reuse existing skills aggressively — that's how token cost drops over time. Only author a new skill when you actually need to explore unfamiliar UI.
- Run every step in spec, in order, in full. Never substitute brands, dates, or accounts. Never skip a toggle click because the URL "looks right." Re-read the Jira ticket if anything feels ambiguous.
- Apply all 6 rules in skills/_shared/spec-adherence-rules.md on every case. The most-violated ones in practice:
  - Rule 1: exact brand name from the spec, picked from the Results section of the typeahead.
  - Rule 2: explicit toggle clicks for view perspective — never trust URL params.
  - Rule 6: never claim a download/export is broken without inspecting the actual saved file. For PDFs use the pdf-end-to-end-verification skill (pdftoppm + Read on the rendered PNG).
- For mutating tests: use a unique timestamped identifier (e.g. QA-1677-TEST-<date>-<time>) and run cleanup at the end. Cleanup is non-optional.

OUTPUT
- One Markdown report per case in runs/<YYYY-MM-DD>/QA-<id>-report.md with: steps executed, an assertions table (ID | Step | Expected | Actual | Status), evidence (numbers, exact text, screenshot references), and any bugs filed in a "Bugs filed" section at the bottom.
- Bugs go ONLY into the markdown report — never auto-create Jira tickets.
- For PASS results that touched a new pattern, author a new skill file at skills/<flow>/SKILL.md following skills/_TEMPLATE.md, then add a row to skills/REGISTRY.md. For PASS results that reused a skill, bump its pass_streak in the registry. The promotion rule is: untrusted → stable after 3 successful runs on separate days.
- For FAIL results or skill drift, either auto-update the skill (only if a documented fallback worked) or mark it quarantined for human review.
- After every case, briefly update knowledge-base/ files if you learned anything reusable (new quirk, new page in the app map, new term in the glossary).

TONE & STYLE
- Reports are detailed and evidence-laden — assertions are never short-circuited to save tokens.
- Be terse in chat; verbose in the report file.
- Don't apologize, don't summarize what I just said. Just do the work.

If anything in the framework is genuinely missing or stale, fix it as you go and flag what you changed at the end of your reply.

When you're done reading the files above, summarize in 5 lines or fewer what state magpie is in (skill count, most recent run date, any quarantined skills), then ask me for the first test case.
```

---

## Tips for the teammate

- **First session:** Claude will read ~10 files before doing anything. That's by design — the rules and KB are the whole point. Subsequent sessions can skip the read if Claude already has the memory.
- **Token efficiency comes from reuse.** A brand-new flow costs more (exploration), but every subsequent case that touches the same flow gets cheap. Don't be surprised if the first few runs feel expensive; the cost curve flattens after ~10 cases in a given area.
- **When the browser hangs** (it does sometimes during heavy chart pages): with Playwright MCP, prefer `wait_for` on a real element over fixed sleeps; if the app genuinely hangs (documented product hangs like Social Footprint All-Time / Insights renderer), it becomes a Playwright timeout — reload or skip, don't expect auto-wait to fix it. (Chrome-MCP track: refresh the tab + re-login, or open a new tab.)
- **When in doubt about a test failure,** re-read the Jira ticket before filing a bug. We've retracted two bugs (BC-2, BC-3) that turned out to be misread specs.
- **Mutating tests:** the framework auto-cleans up its own tags, but double-check the test report's "Cleanup" section before closing the session.
