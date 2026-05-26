# Bugs — YYYY-MM-DD

Detailed evidence package per failing case. Each section is self-contained so a developer can act on it without re-running.

---

## TC-XXX — <title>

- **Severity:** P1 | P2 | P3
- **Case file:** [`testcases/english/TC-XXX.md`](../testcases/english/TC-XXX.md)
- **Status:** 🐛 BUG (classifier confidence: high/medium)
- **First seen:** YYYY-MM-DD (this run, or earlier date if recurring)
- **Recurrence:** N runs in last 7 days
- **Affected area:** _e.g. Dashboard / account header rendering_

### What failed

One-paragraph plain-English summary of the symptom. What the user would notice.

### Reproduction (deterministic)

1. Log in as `<email>` (creds in `config/credentials.md`)
2. From dashboard, click user menu → "Switch account"
3. Type "Acme Corp" in the search field
4. Click the "Acme Corp" result
5. Observe the dashboard header

### Expected vs Actual

```
Assertion:  text_equals on [data-testid="account-header"]
Expected:   "Acme Corp"
Actual:     "Acme  Corp"
Diff:       index 4 — expected ' ' (U+0020), got '  ' (two U+0020)
Source:     DOM textContent
Normalize:  trim=true, collapse_whitespace=false, case_sensitive=true
```

For numeric / table / cross-source assertions, render the appropriate diff block (number delta, cell-level table diff, UI-vs-API delta).

### Evidence

- **Full-page screenshot:** [`evidence/TC-XXX/screenshot-full.png`](../runs/YYYY-MM-DD/evidence/TC-XXX/screenshot-full.png)
- **Element crop:** [`evidence/TC-XXX/screenshot-header-crop.png`](../runs/YYYY-MM-DD/evidence/TC-XXX/screenshot-header-crop.png)
- **DOM snippet:** [`evidence/TC-XXX/dom-snippet.html`](../runs/YYYY-MM-DD/evidence/TC-XXX/dom-snippet.html)

  ```html
  <h1 data-testid="account-header" class="acct-name">Acme  Corp</h1>
  ```

### Console output (during this case)

```
[WARN]  Possible duplicate space in account name (acct-renderer.js:142)
[ERROR] Failed prop type: invalid prop `displayName` ...
```

### Network activity

| Status | Method | URL | Duration | Notes |
|-------:|--------|-----|---------:|-------|
| 200 | POST | `/api/auth/login` | 312ms | ok |
| 200 | GET | `/api/accounts/search?q=Acme%20Corp` | 188ms | ok |
| **500** | GET | `/api/accounts/0001/dashboard-summary` | 4.2s | **error response below** |

```json
// 500 response body
{
  "error": "InternalServerError",
  "request_id": "req_abc123",
  "trace": "AccountRenderer.formatDisplayName: extra whitespace in raw value"
}
```

### Timing

| Step | Duration |
|------|---------:|
| Navigate to /login | 0.6s |
| Submit credentials | 0.9s |
| Open user menu | 0.2s |
| Search "Acme Corp" | 0.4s |
| Click result | 0.8s |
| **Dashboard load (assertion failed here)** | **4.2s** ⚠ |

### Skill state at time of failure

| Skill | Version | Trust | Notes |
|-------|---------|-------|-------|
| login | v4 | stable | succeeded |
| switch-account | v2 | stable | succeeded up to header assertion |

### Suggested next steps

- Backend: investigate the 500 from `/api/accounts/0001/dashboard-summary`
- Frontend: confirm whether the double-space is server-provided or introduced client-side (`AccountRenderer.formatDisplayName`)
- QA: re-run `TC-014` after the fix; add a normalization-stripping regression case to ensure raw values are sanitized at the API boundary

---

_(repeat the section above per bug)_
