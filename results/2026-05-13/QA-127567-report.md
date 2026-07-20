# QA-127567 — Settings - Data Collection - Ad Account Level Status

> **Status:** ✅ **A2 & A3 PASS**; A1 not testable in current configuration
> **Run date:** 2026-05-13 · **Env:** dev · **Account:** Adam Orfei · **User:** LFQA

## Execution

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Settings → Data Collection | ✅ |
| 2 | Click Scorpion | ✅ |
| 3 | Click Facebook channel | ✅ |
| 4 | Click Scorpion page | ✅ |
| 5 | Click Expand on "Facebook & Instagram Ads (Authorized)" | ✅ |

## Assertion results

### ⚠ A1 — Single-AA → overall reflects that AA's status

**NOT DIRECTLY TESTABLE** in the current Scorpion configuration. The only ad-account-bearing data feed under Scorpion's Facebook page is "Facebook & Instagram Ads (Authorized)", which has **two** ad accounts (`act_246150802260022`, `act_104851869627522`) — i.e., the multi-AA scenario, not single. A1 would need a different brand/page where exactly one ad account is connected.

### ✅ A2 — Multiple AAs → overall summary status is empty

**PASS.** Parent row "Facebook & Instagram Ads (Authorized)" with two ad accounts has no "Collecting" or "Not Collecting" text in the Status column (JS verification: `parentHasStatusText: false`).

### ✅ A3 — Status shown per Ad Account row only

**PASS.** Each ad-account child row carries its own status:
- `act_246150802260022` — Feb 12, 2017 → Feb 18, 2017 — **Not Collecting**
- `act_104851869627522` — Aug 18, 2014 → Apr 30, 2018 — **Not Collecting**

The parent data-feed row has no separate overall status.

## Skill authored

`data-collection-ad-account-status` (drafted, captures the Settings → Data Collection → Brand → Channel → Page → Expand-Ad-Accounts flow).
