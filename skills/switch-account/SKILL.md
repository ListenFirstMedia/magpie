---
name: switch-account
version: 2
last_verified: 2026-07-02
last_passed_run: 2026-07-02
trust: untrusted
pass_streak: 21
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

## 2026-06-11 batch-3 update — Wasserman IS reachable via the LFQA account switcher

- 9 clean switches in one session: Adam Orfei → Hulu → Sony Pictures → Disney Entertainment Television → Disney Ad Sales → FX Networks → Amazon Prime Video → UCLA → HBO Max → **Wasserman** — all via LFQA menu → Search Account → Results row. No Cognito re-auth was required for Wasserman (supersedes the 2026-06-04 "Wasserman requires re-authentication" note; the earlier blocker was the missing FIAWEC brand under Adam Orfei, not account ACL).
- Search Account input only renders after the LFQA menu is open AND the page is scrolled to top; first click on the menu can be eaten by an open overlay — Escape, scroll top, retry.
- Account search names can drift from test wording: "Max" → account is "HBO Max"; "Fx Networks" matches "FX Networks".

## 2026-07-02 — headed Playwright mechanics (QA-68691, Viacom → Michael Kors)

Under interactive headed Playwright the reliable sequence is:
- **Open the LFQA menu by HOVER, not click** — clicking toggles it (a second click closes it). Hover to reveal `Search Account` + `Results`.
- **Set the Search Account value via JS**, not `.fill()`: the input (`input.account-typeahead-input`) reports "not visible" to Playwright's fill/type. Use the React setter:
  ```javascript
  const inp = document.querySelector('input.account-typeahead-input');
  const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
  setter.call(inp, '<account_name>'); inp.dispatchEvent(new Event('input', {bubbles:true}));
  ```
- **Click the `.lfm-ta-option` Results row** — NOT the `.account-name` leaf and NOT the `.typeahead-options-list` container (those don't trigger the switch). Full `mouseover/mousedown/mouseup/click` dispatch on the `.lfm-ta-option` under the `Results` header works.
- Verify: URL `account_id` changes + breadcrumb `Account: <name>`.

## 2026-07-02 refinement (QA-949, Sephora → Michael Kors) — React-setter is flaky for triggering Results

The React value-setter above **does not reliably fire the live search**: for Sephora it produced a `.lfm-ta-option` under `Results`, but for **Michael Kors it showed only the `Recent Searches` list** (no `Results` section), so a click would have hit Recent Searches (which does NOT switch — see Step 3). **Prefer trusted typing** to surface Results:
- Clear the input via the React setter (set `''` + dispatch `input`), then `browser_type` **slowly** (`pressSequentially`) the account name into `input.account-typeahead-input`.
- Wait ~2s, confirm a `Results` header is present (not just `Recent Searches`), then click the `.lfm-ta-option` whose text equals the account name.
- The earlier QA-68691 note that the input "reports not visible to type/fill" did not recur here — `browser_type` on the tagged input worked. If typing is ever rejected as not-visible, fall back to the React setter and, if only Recent Searches shows, retype a character to nudge the live search.

### 2026-07-02 (QA-2498) — do NOT put a `browser_evaluate` between hover and type
The menu is **hover-only** and closes the instant the pointer leaves. The reliable sequence is **`browser_hover` the user-menu → `browser_type` into `input.account-typeahead-input` immediately** (browser_type moves the pointer onto the input, which is inside the menu, keeping it open). If you insert a `browser_evaluate` (even just to clear the field) between the hover and the type, the pointer leaves and the menu closes → the Results dropdown never renders (this cost several retries switching Hulu→HBO Max). Tag the input in the SAME evaluate that opens/prepares things, or just `browser_type` by CSS selector `input.account-typeahead-input` right after hovering. This same hover-then-act-immediately rule applies to the Settings > Data Collection "Search for a brand" typeahead.
