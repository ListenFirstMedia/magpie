# QA-22296 Re-run — Batch 8/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-114840, QA-116140, QA-116173, QA-121158, QA-121217 (order 36–40)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-114840 | Settings > Users - Export (External User) | 🚫 BLOCKED | External-user login required (safety) |
| QA-116140 | Brand Sentiment - Sentiment Export CTA | ✅ PASS | CTA opens export modal; export queued (verified via QA-109919) |
| QA-116173 | Sentiment Export Email/Notification/Auto Download | ✅ PASS | Notification "Download file" + email-to-lfiqa statement; CSV 200 OK |
| QA-121158 | IG Collaborated Total Filter | ✅ PASS | **Upgrade** — filter + Or/And + values 1–5 + URL serialize + Apply→Posts(29); LFMP-31862 not reproduced |
| QA-121217 | IG Collaborator count - Export | ✅ PASS | **Upgrade** — export has Instagram Collaborator Count + Name; 29/29 rows populated |

## Headline
- 4 PASS (2 upgrades: QA-121158, QA-121217 — MTV has collaborated IG posts where prior Hulu had none), 1 BLOCKED (external-user safety). No new product bugs.

## Cleanup
- Exports queued (harmless). No mutations.
