# QA-114840 — Settings > Users - Export Functionality (External User) — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (safety, carry-forward)

## Rationale
- Spec preconditions require an **External User** login/password to exercise the Users export from that role. Per safety policy I do not enter credentials / authenticate as another user. Consistent with 2026-06-05 BLOCKED.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Users export as External User | Export works for external-user role | NOT REACHED — external-user login required (safety) | 🚫 BLOCKED |

## Bugs filed
_None._ (LFIQA to run while logged in as the external user.)
