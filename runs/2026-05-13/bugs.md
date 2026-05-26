# Bugs — 2026-05-13

> No bugs detected in this run. All three QA-5757 assertions passed.
>
> Three informational findings (F1, F2, F3) are captured in [report.md](report.md) — none reach the bar of "bug" because they're either test-case wording (F1), an open identity question (F2), or automation-only friction with no user impact (F3).

The format below is what bug entries will look like in future runs. Keeping it here as a reference template for the developer team.

---

## Template — what a bug entry looks like

```markdown
## QA-XXXX — <title>

- **Severity:** P1 | P2 | P3
- **Source case:** ../testcases/english/QA-XXXX.md
- **First seen:** YYYY-MM-DD
- **Recurrence:** N runs in last 7 days
- **Affected area:** <product area>

### What failed
<plain-English summary of the symptom>

### Reproduction (deterministic)
1. <step>
2. <step>

### Expected vs Actual
```diff
Assertion:  <type> on <selector or column>
Expected:   <value>
Actual:     <value>
Diff:       <character index | numeric delta | cell list>
```

### Evidence
- Full screenshot, element crop, DOM snippet
- Console errors (filtered)
- Network log with 4xx/5xx highlighted
- Timing breakdown
- Skill version state at point of failure

### Suggested next steps
- Backend / Frontend / QA next actions
```
