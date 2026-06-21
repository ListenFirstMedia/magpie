# QA-96045 — Settings > Data Identities - Instagram Threads — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (test-data gap, Rule 1 — no substitute) — consistent with 2026-06-05

## Findings
- Data Identities loaded (52 identity rows). Channels present: **Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn (6)**. **Threads is absent.**
- QA-96045 requires an Instagram **Threads** data identity, which doesn't exist on the Adam Orfei account → cannot exercise the Threads-specific assertions. Per Rule 1, no substitute.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Threads identity present + verifiable | Threads in Data Identities | Threads channel absent (6 non-Threads channels only) | 🚫 BLOCKED |

## Bugs filed
_None._ (Recommend a Threads-enabled account/identity for this case, or descope.)
