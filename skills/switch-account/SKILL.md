---
name: switch-account
version: 2
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 3
preconditions: [user-logged-in]
postconditions: [account-switched]
inputs: [account_name]
outputs: [account_id_in_url]
related_pages: ["/#home"]
---

# Switch Account

Open the user profile dropdown and use the "Search Account" textbox to switch the current account context. Used when a test case requires a specific account (e.g., "User should be logged in as Hulu").

## Steps

### Step 1 — Open profile dropdown
- **Action:** click
- **Target (primary):** element with visible text equal to the user display name in the top-right of the global header. Locate via `find` with query "user profile menu trigger at top right showing username <Name>"
- **Target (fallback CSS):** the rightmost menu item in `.navigation-menus` immediately to the left of the search icon. **Do NOT** click on coordinate `(1380, 19)` — that lands on the Settings dropdown, not the profile.
- **Assertion:** A dropdown panel appears containing the literal labels `My Profile`, `Search Account`, `Recent Searches`, `Sign Out`.
  - type: existence
  - selector: textbox with placeholder `Search Account`

### Step 2 — Type the account name in Search Account
- **Action:** type
- **Target (primary):** textbox `[placeholder="Search Account"]`
- **Value:** `{account_name}` (e.g., `Hulu`, `Adam Orfei`)
- **Assertion:** A `Results` section appears containing at least one matching item.
  - type: existence
  - selector: list item containing text `{account_name}` under the `Results` heading

### Step 3 — Click the matching result — IMPORTANT: from `Results`, NOT `Recent Searches`

The profile dropdown shows two sections of items:
- **Recent Searches** — items previously selected. **Clicking these does NOT switch accounts** (likely a display-only list, but worth flagging as a UX bug if a real user expects them to be clickable).
- **Results** — the live filter output that appears once you type. **Only clicks in this section trigger an account switch.**

If `find` returns a candidate, check its description: it will mention `Recent Searches section` or `Results section`. Only click items in the `Results section`.

- **Action:** click
- **Target (primary):** result whose visible text equals `{account_name}` exactly AND is under the `Results` heading. Use `find` with the query "{account_name} result item in account search dropdown" and inspect the description.
- **If find returns a Recent Searches item:** ignore it and use JavaScript to locate the Results entry instead:

```javascript
// Find the literal text "Results" then collect items that follow it
const sections = [...document.querySelectorAll('*')].filter(el =>
  (el.textContent || '').trim() === 'Results' && el.children.length === 0
);
const resultsHeader = sections[0];
const item = [...document.querySelectorAll('*')].find(el =>
  el.textContent.trim() === '<account_name>' &&
  resultsHeader.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING
);
item?.click();
```

- **Assertion (mid-flight):** URL changes and a `Loading…` indicator appears briefly.

### Step 4 — Verify switch
- **Assertions:**
  - URL contains `account_id=<numeric>` (capture the value as `account_id_in_url`)
  - Element with breadcrumb `Account: {account_name}` is present
    - type: text_equals (after `Account: ` prefix)
    - normalize: trim=true, case_sensitive=true
  - The page lands on the Home view (`#home`)

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Profile dropdown does not open after click | STALE SKILL (selector for username changed) | flag |
| `Search Account` textbox not found inside dropdown | STALE CANDIDATE | flag for human review |
| `Results` section is empty after typing a valid account name | BUG (account exists but isn't searchable) or PERMISSION (this user lacks access) | report with screenshot of dropdown |
| Click on result does not change `account_id` in URL within 5s | BUG (switch-account API failed; check `/api/...` network for 5xx) | report |
| Page renders `Account: <wrong>` after switch | BUG (state inconsistency) | report immediately |

## Known quirks observed

- Recent Searches appear above the Results list; do not confuse them — only items under the literal `Results` heading reflect the current search.
- The profile dropdown click target is small. The button has no `data-testid`; we rely on `find` by username. If engineering can add `data-testid="user-menu-trigger"` it would harden this skill.

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v2** (2026-05-13): Added explicit "Recent Searches does NOT trigger switch" warning. Re-observed during QA-458 when an attempt to switch to Adam Orfei via Recent Searches silently failed. Only clicks under the `Results` heading switch accounts.
- **v1** (2026-05-13): Initial draft from QA-5757 exploration run. Successful switch from `HBO Max` to `Hulu` (account_id=336).
