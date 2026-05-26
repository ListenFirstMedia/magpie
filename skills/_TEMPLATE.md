---
name: <skill-name-kebab-case>
version: 1
last_verified: YYYY-MM-DD
last_passed_run: null
trust: untrusted              # untrusted | stable | quarantined
pass_streak: 0
preconditions: []             # e.g. [user-logged-out]
postconditions: []            # e.g. [user-on-dashboard]
inputs: []                    # parameters this skill consumes, e.g. [username, password]
outputs: []                   # state this skill leaves the app in
related_pages: []             # URLs touched by this skill
---

# <Skill Name>

One-paragraph description: what this flow does, when it's used.

## Steps

Each step lists the action, the primary selector, fallback selectors, and the assertion to verify the step succeeded.

### Step 1 — <short imperative description>
- **Action:** navigate / type / click / wait / etc.
- **Target (primary):** `selector` — _why this one is stable_
- **Target (fallbacks):**
  - `fallback selector 1`
  - `fallback selector 2`
- **Value (if applicable):** `{input_param}` or literal
- **Assertion:** what must be true after this step
  - Type: existence | text_equals | numeric | etc.
  - Source: `selector` or URL or API endpoint
  - Expected: <value or pattern>

### Step 2 — ...

## Failure signatures

Patterns the classifier should recognize, with their interpretation:

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `[role="alert"]` with text "Invalid credentials" + creds were valid | BUG | report |
| Primary selector missing, fallback works | STALE SKILL | auto-promote fallback |
| Primary + fallbacks all missing, similar element nearby | STALE CANDIDATE | flag for human |
| Page returns 5xx or blank | BUG | report |
| Visual difference, all functional assertions pass | NOT A BUG | log to known-quirks |

## Network expectations

API calls expected during this skill's execution. A missing or failing call is a bug, not a skill issue.

| Endpoint | Method | Expected status | Notes |
|----------|--------|-----------------|-------|
| `/api/...` | POST | 200 | _what it does_ |

## Changelog

- **v1** (YYYY-MM-DD): initial draft from exploration run
