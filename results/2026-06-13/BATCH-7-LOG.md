# QA-22296 Re-run — Batch 7/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-109749, QA-109919, QA-112583, QA-113594, QA-113723 (order 31–35)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-109749 | Brand Audience > Threads - Hovering | 🚫 BLOCKED | Threads-audience no-data + Audience renderer-hang family |
| QA-109919 | Brand Content - Sentiment Comments limit - CSV | ✅ PASS | Sentiment Export CSV: 1,392 comment rows, 25 cols (Classified/Emotion/Topics/Comment Date/Channel) |
| QA-112583 | Follower Demographics vs Threads Audience - Export | 🚫 BLOCKED | Sibling of QA-109749 — no Threads-audience data |
| QA-113594 | Settings > Audit - External User View | 🚫 BLOCKED | External-user login required (safety) |
| QA-113723 | Admin - Brand Set Creation + Audit | 🚫 BLOCKED | Admin/Cognito-gated (safety) |

## Headline
- 1 PASS (QA-109919), 4 BLOCKED (all environment/safety: Threads-audience test-data gap ×2, Admin/external-user gating ×2). No new product bugs. All blocks consistent with 2026-06-05.

## Cleanup
- Sentiment export queued (harmless). No mutations.
