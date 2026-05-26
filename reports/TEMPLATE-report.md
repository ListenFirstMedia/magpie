# Regression Run — YYYY-MM-DD

> **Status:** ✅ All passed | 🐛 Bugs found | ⚠️ Smoke failed
> **App:** _name_ · **Env:** _production | staging_ · **Browser:** attached Chrome
> **Started:** HH:MM · **Finished:** HH:MM · **Wall time:** _Xm Ys_

---

## At a glance

| Metric | This run | Previous | Delta |
|--------|---------:|---------:|------:|
| Cases run | _N_ | _N_ | _+/-_ |
| Passed | _N_ ✅ | _N_ | _+/-_ |
| Bugs | _N_ 🐛 | _N_ | _+/-_ |
| Blocked | _N_ ⛔ | _N_ | _+/-_ |
| Skipped | _N_ ⤼ | _N_ | _+/-_ |
| Tokens in | _N_ | _N_ | _+/- %_ |
| Tokens out | _N_ | _N_ | _+/- %_ |
| Wall time | _XmYs_ | _XmYs_ | _+/-_ |
| Skills used | _N_ | _N_ | _+/-_ |
| Skills updated | _N_ | _N_ | _-_ |

## Pre-flight

- App reachable: ✅
- Login as default user: ✅
- Dashboard renders: ✅

## Bugs (this run)

### 🐛 TC-XXX — <title>
- **Severity:** P1 | P2 | P3
- **Skills used:** login (v4), switch-account (v2)
- **What failed:** _one-line summary_
- **Evidence:** [full bug report](../runs/YYYY-MM-DD/bugs.md#tc-xxx)

_(repeat per bug)_

## Stale-skill auto-updates

| Skill | From | To | Change | Triggering case |
|-------|------|----|--------|-----------------|
| _name_ | v3 | v4 | promoted fallback selector | TC-XXX |

## Untrusted skills used (please review)

| Skill | Version | Cases | Recommendation |
|-------|---------|-------|----------------|
| _name_ | v1 | TC-XXX | inspect SKILL.md and confirm steps look right |

## Per-case detail

| ID | Title | Status | Time | Tokens (in/out) | MCP calls | Skills |
|----|-------|:------:|-----:|----------------:|----------:|--------|
| TC-001 | Login as default user | ✅ | 4.2s | 1,103 / 218 | 8 | login (v4) |
| TC-014 | Switch to Acme Corp | 🐛 | 9.1s | 4,820 / 612 | 14 | login (v4), switch-account (v2) |
| _..._ | _..._ | _..._ | _..._ | _..._ | _..._ | _..._ |

## Notes

Anything worth flagging that isn't a bug or a skill change — e.g., the app felt slow today, a banner appeared we don't have in the KB, etc.
