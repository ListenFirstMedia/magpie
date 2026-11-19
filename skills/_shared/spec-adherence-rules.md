# Spec adherence rules (CRITICAL)

> Lessons captured from QA-91412 re-execution on 2026-05-20.
> These rules are mandatory for every future test run.

## Rule 1 — Never substitute brands

The Jira test case names a specific brand. If the dev environment's brand-search dropdown returns an exact-match result for that name, **that is the only acceptable brand to test on**. Do not pick "the closest available" or "a brand from the same family."

**Wrong:** Spec says "FX" → dropdown shows no exact "FX", you pick "It's Always Sunny in Philadelphia" because it's an FX show.
**Right:** Spec says "FX" → type "FX" exactly → click the literal "FX" result if it exists. If it doesn't, the case is BLOCKED on test-data setup, not "use a substitute." Document the block; do not invent a substitute.

### Anti-pattern from this project
- **QA-91412** initially run on "It's Always Sunny in Philadelphia" because typing "FX" in the brand dropdown returned only related brands. The test "failed" with engagement metrics populated. After the user corrected the brand to FX Network (which surfaces as "FX Networks Composite" on dev), the test PASSED — all metrics en-dash as spec expects.
- **Consequence:** false-positive BC-3 bug filed for ~2 days based on wrong-brand testing. Real product behavior is correct; only the spec brand vs. fallback-brand distinction was off.

### When the exact-name brand doesn't appear
Possible reasons + actions:
1. **Spec drift** — the brand was renamed/removed. Action: file a "test-data gap" report; do NOT substitute.
2. **Wrong account** — the brand exists on a different account than the spec names. Action: re-read spec preconditions; switch account if needed.
3. **Typeahead is stale** — close and reopen the dropdown; try typing slower or via React-aware input setter (see `_shared/selectors.md`).
4. **Brand requires authorization** — some brands only appear when the user has the right ACL. Action: contact LFIQA.

If none of the above resolve, treat the case as BLOCKED with reason "spec brand not findable on dev." Never substitute.

## Rule 2 — Explicitly click UI toggles, never trust URL parameters

URL params like `perspective=extended` or `view=public` are NOT a substitute for clicking the actual toggle on screen. The platform sometimes:
- Inverts the visual indicator's position relative to the URL param.
- Caches a previous toggle state in localStorage that overrides URL.
- Renders the toggle in a state that doesn't match the URL until the user clicks it.

### Anti-pattern from this project
- Navigated to `…?perspective=extended` assuming this = "Public Data" view.
- Test result depended on the toggle being in Public position, but the visual toggle indicator was on the right (Authorized side).
- All assertions were technically evaluated against Authorized perspective despite intent.

### The right pattern
1. After navigation, take a screenshot of the View toggle area.
2. Identify the toggle's indicator (the dot/handle position).
3. If indicator is not on the spec-required side, click the toggle (or use the ref-element click pattern).
4. **Re-screenshot** to confirm the indicator moved.
5. Wait 3-5 seconds for the page to re-fetch data with the new perspective.
6. Only THEN proceed to the assertion-evaluation steps.

### Code snippet — verify toggle state before proceeding

```javascript
(function(){
  // Find the al-toggle widget for view perspective
  const toggle = document.querySelector('.al-toggle__checkbox');
  if (!toggle) return "no view toggle found";
  return JSON.stringify({
    checked: toggle.checked,
    disabled: toggle.disabled,
    // checked === true conventionally means Authorized side; false === Public
    // BUT verify per-flow because conventions differ across pages
  });
})()
```

After clicking, re-run this snippet to confirm `checked` changed.

## Rule 3 — Execute every step in the spec, in order, in full

Steps in a Jira test case are sequential preconditions for the assertion. Skipping ANY step invalidates the assertion result.

If a step is "Change the perspective to Public" and you navigate via URL with `perspective=extended`, you have NOT performed that step. The user expects to see you click the toggle.

### Checklist before recording an assertion result
- [ ] All preconditions met (account, brand, date range, channel, perspective).
- [ ] All numbered steps performed via UI interaction (click, type, select).
- [ ] Page state visually confirmed via screenshot.
- [ ] Only then is the assertion's pass/fail meaningful.

## Rule 4 — Reuse skills aggressively, but never silently override the spec

Skills exist to accelerate execution, not to substitute for spec compliance. If a skill's default behavior conflicts with what the spec asks for (e.g. a skill defaults to Authorized perspective and the spec wants Public), the spec wins — adjust your skill invocation accordingly.

## Rule 5 — When in doubt, re-read the Jira ticket

Before claiming a bug, re-read the source Jira ticket's Steps + Assertions + Preconditions. A surprising number of "bugs" found in this project were actually test-setup mistakes:
- BC-3 (initially): wrong brand → no bug
- BC-2 (initially): incomplete download verification → no bug
- QA-122942 export quirk: modal had Public unchecked by user oversight → not a bug, just a fresh-modal-state issue

Re-read before reporting. Re-execute on the exact spec configuration before filing. Capture screenshots of every step before the assertion.

## Rule 6 — Never claim a download/export is broken without observing the actual save outcome

DOM signals (anchor `download` attribute, `href`) and network signals (response headers, status code) are NOT the same as "what the browser saves to disk when the user clicks the link." There can be:

- React handlers that intercept the click and set the filename before triggering save
- Server-side response variation between in-page `fetch()` reproductions and authenticated user clicks (e.g. the CDN may serve different `Content-Disposition` to the click than to a fetch reproduction)
- Browser save dialog logic that uses additional signals beyond DOM/headers
- localStorage / extension behavior overriding default save paths

**The only valid verification of an export filename is one of:**
1. Observe the browser's Save As dialog and read the proposed filename, OR
2. Allow the download to complete and read the filename on disk, OR
3. Hook into the actual download event (not just `URL.createObjectURL` or `anchor.click`) and capture the resulting file metadata.

If you can't perform one of those, do NOT claim the filename is broken. Mark as "INCONCLUSIVE — needs end-to-end download verification" and ask the user to confirm.

### Anti-pattern from this project
BC-2 was filed based solely on:
- Anchor `download=""` (empty)
- No `Content-Disposition` header on CDN response to in-page `fetch`

Both signals were real, but neither equates to "browser saves the file with the hashed name when a user clicks." When LFIQA actually clicked the download link in real use, the filename was correct. BC-2 retracted.

### Same caveat applies to all observability-by-proxy claims

This rule generalizes: never assert that a user-visible behavior is broken based purely on programmatic signals that LOOK like they should produce the behavior. Always verify against the actual user-visible outcome. Other examples:
- "The dropdown shows no options" because the JS query returned nothing → could be a hidden overflow scroll; screenshot first
- "The chart has no data" because the SVG path is empty → could be rendering at 0 height due to CSS; verify with the user
- "The export silently fails" because no `URL.createObjectURL` hook fired → could use a different download path; ask the user to check Downloads folder

## Rule 7 — Open linked bug: execute, probe, then FAIL

The open linked bugs come from the case file's **"## Open linked bugs (as of <date>)"** section, regenerated from the Jira issue-links by `bin/sync_set.py` on every sync (the unattended `claude -p` run has no Jira/Atlassian MCP access). `bin/run-case.sh` extracts it shell-side and puts it at the top of the PRE-FETCHED CONTEXT as **OPEN LINKED BUGS** — use that block; legacy headings such as `# Open bug to probe` count too.

1. **Never block or skip the case because of an open bug.** Execute every step and evaluate every assertion in full, exactly as you would with no bug linked.
2. **Probe every listed open bug** during the run: check on this surface whether the bug's symptom reproduces, and record the evidence (screenshot / DOM value / network status). Each bug gets one of `REPRODUCED`, `NOT REPRODUCED`, or `NOT PROBEABLE (<why>)`. You may NOT dismiss a listed bug as "does not apply", "outside this case's steps" or "not inspected" — if the case's own steps don't reach the bug's symptom, take the extra minimal action needed to probe it (without changing any assertion's result), or mark it `NOT PROBEABLE` with the concrete reason.
3. **Verdict:** if **any** linked bug is open in the section, the verdict is **FAIL** — even if every assertion passed and even if the bug did NOT reproduce (it stays FAIL until the bug is closed in Jira and the case is re-synced). Write the verdict line exactly as:
   `**Verdict: FAIL** (open linked bug: LFMP-31857 — REPRODUCED; LFMP-31915 — NOT REPRODUCED)`
   and add a short note per NOT REPRODUCED bug: "close candidate — not reproduced on <date>".
   The verdict line must not contain the words PASS or BLOCKED before FAIL (the batch scorer takes the first keyword).
4. The assertions table is still filled normally (PASS/FAIL per assertion), so the report shows whether the rest of the feature works. Other genuine blocks (no test data, env down) are still recorded per assertion; the open bug still makes the overall verdict FAIL.
5. **Section says "None open"** → no open-bug effect; the verdict comes from the assertions.
6. **Section missing or `UNKNOWN`** → do NOT read that as "none open". Run normally, take the verdict from the assertions, and write `Open-bug status: UNKNOWN (no synced section)` in "Known bugs checked". Also probe any open bug that the pre-fetched bug-history lists for this case; if one of those REPRODUCES, the verdict is FAIL.

Rationale: a case with an open linked defect can't produce a trustworthy PASS, but blocking it without running hides whether the rest of the feature still works and whether the bug is actually still there. Running it in full gives both answers; the FAIL stays until the bug is closed in Jira.

### Anti-pattern from this project (2026-11-17 run)
QA-23991, QA-923, QA-947, QA-83977 and QA-6315 were all scored **PASS** while each had an open linked bug (LFMP-32010, LFMP-31857, LFMP-31781, LFMP-31814, LFMP-31800). The case files either had no section or used the heading `# Open bug to probe`, so the old screen read them as "none open"; the agent then dismissed the bugs as "does not apply" / "not separately inspected" — and QA-947 even recorded LFMP-31781 as **REPRODUCED** and still passed. Under this rule all five are FAIL.
